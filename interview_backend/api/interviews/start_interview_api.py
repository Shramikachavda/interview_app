import asyncio
import traceback
from datetime import datetime
from typing import List, Dict
from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session

from models.interview import UnifiedInterviewRequest, InterviewResponse, InterviewModel
from models.pdf_feedback import InterviewPDFFeedback
from models.models import User

from graph import InterviewEngine
from database import get_db
from core.security import get_current_user
from core.pdf_render import render_feedback_html
from core.email_sender import send_email_with_pdf
from core.pdf_gen import html_to_pdf
from nodes.feedback_nodes import generate_unified_pdf_feedback
from services.ai.base import LLMBase


router = APIRouter()
interview_engine = InterviewEngine()


@router.post("/interview", response_model=InterviewResponse)
async def unified_interview(
    request: UnifiedInterviewRequest,
    db: Session = Depends(get_db),
):
    try:
        print("\n🌐 === UNIFIED INTERVIEW API START ===")

        # Convert dict to InterviewModel if needed
        state = InterviewModel(**request.state) if isinstance(request.state, dict) else request.state
        print(f"🔍 Received state: {state}  ")
        print(type(state))

        if not state.session_id:
            print("🆕 Starting new interview…")

            if not state.user_id or not state.session_type or not state.level:
                raise HTTPException(400, "Missing user_id, session_type, or level")

            user_exists = await asyncio.to_thread(
                lambda: db.query(User).filter(User.id == state.user_id).first()
            )
            if not user_exists:
                raise HTTPException(404, "User not found")

            initial_state = InterviewModel(
                session_id=str(uuid4()),
                user_id=state.user_id,
                session_type=state.session_type,
                level=state.level,
                current_question_index=0,
                total_questions=0,
                session_status="not_done",
                q_a_pair=[],
                asked_question_ids=[],
                asked_llm_questions=[],
                current_question=None,
                feedback=None,
                latest_answer=None
            )

            print(f"🟢 Initialized session_id: {initial_state.session_id}")
            print("⚙️ Running init step…")

            # Await async run_step directly
            new_state = await interview_engine.run_step(initial_state, db=db, first_call=True)

            return InterviewResponse(
                message=new_state.current_question or "Interview started",
                done=False,
                state=new_state
            )

        print(f"🔁 Continuing interview with session_id: {state.session_id}")

        new_state = await interview_engine.run_step(state, db=db, first_call=False)

        if new_state.session_status == "done":
            feedback_dict = new_state.feedback if isinstance(new_state.feedback, dict) else {}
            msg = feedback_dict.get("summary", "Interview completed")
            return InterviewResponse(message=msg, done=True, state=new_state)

        return InterviewResponse(
            message=new_state.current_question or "Next question",
            done=False,
            state=new_state
        )

    except Exception as e:
        print(f"❌ Error: {e}")
        raise HTTPException(500, "Internal error during interview step.")
    
@router.post("/send_feedback_email")
async def send_feedback_email(
    state: InterviewModel,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    try:
        print("📥 Received state:", state.dict() if hasattr(state, "dict") else state)

        # 1️⃣ Ensure q_a_pair is safe
        safe_qa_list = [
            {"question": qa.get("question", "N/A"), "answer": qa.get("answer", "N/A")}
            for qa in state.q_a_pair
        ]
        print("✅ Safe QA List prepared:", safe_qa_list)

        # 2️⃣ Get current user info
        interviewer_name = current_user.name
        user_email = current_user.email
        print(f"👤 Sending feedback to: {user_email} (Interviewer: {interviewer_name})")

        # 3️⃣ Current date & time
        current_date = datetime.now().strftime("%d-%m-%Y")
        current_time = datetime.now().strftime("%H:%M:%S")
        print(f"📅 Date: {current_date}, 🕒 Time: {current_time}")

        # 4️⃣ Initialize LLM
        llm_base = LLMBase()
        print("⚙️ LLM initialization status:", llm_base.is_ready())
        if not llm_base.is_ready():
            raise HTTPException(status_code=503, detail="AI service not available")

        # 5️⃣ Generate structured feedback
        print("🤖 Generating feedback...")
        feedback: InterviewPDFFeedback = await generate_unified_pdf_feedback(
            experience=state.level or "N/A",
            qa_list=safe_qa_list,
            llm=llm_base.llm
        )
        print("✅ Feedback generated:", feedback)

        # 6️⃣ Render HTML -> PDF
        print("📝 Rendering HTML for PDF...")
        html_content = render_feedback_html(
            feedback=feedback,          # now defined
            qa_list=safe_qa_list,       # actual Q&A
            interviewer_name=interviewer_name,
            current_date=current_date,
            current_time=current_time
        )

        pdf_file = f"/tmp/feedback_{uuid4()}.pdf"
        print("📄 PDF will be saved to:", pdf_file)
        if not html_to_pdf(html_content, pdf_file):
            raise HTTPException(status_code=500, detail="PDF generation failed")
        print("✅ PDF generated successfully.")

        # 7️⃣ Send email in background
        print("📧 Scheduling email send...")
        background_tasks.add_task(send_email_with_pdf, user_email, pdf_file)
        print("✅ Email task added to background queue.")

        return {"message": "Feedback report is being generated and will be emailed shortly."}

    except Exception as e:
        traceback.print_exc()
        print("❌ ERROR:", str(e))
        raise HTTPException(status_code=500, detail=f"Error generating or sending feedback: {str(e)}")
