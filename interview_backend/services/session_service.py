# services/session_service.py
from sqlalchemy.orm import Session
from models.models import InterviewSession
from models.models import QuestionAttempt
from models.interview import InterviewModel
from datetime import datetime, timezone
from typing import Optional, Any

class SessionService:
    def __init__(self, db: Session):
        self.db = db

    def get_session_by_id(self, session_id: str) -> Optional[InterviewSession]:
        return self.db.query(InterviewSession).filter(InterviewSession.session_id == session_id).first()        

    # def create_session(
    #     self,
    #     session_id: str,
    #     user_id: int,
    #     session_type,
    #     level,
    #     total_questions: int = 0,
    #     state: Optional[dict] = None
    # ) -> InterviewSession:
    #     session = InterviewSession(
    #         session_id=session_id,
    #         user_id=user_id,
    #         session_type=session_type,
    #         level=level,
    #         total_questions=total_questions,
    #         state=state or {}
    #     )
    #     self.db.add(session)
    #     self.db.commit()
    #     self.db.refresh(session)
    #     return session



    # def update_session_state(self, session_id: str, state: InterviewModel) -> InterviewSession:
    #     obj = self.get_session_by_id(session_id)
    #     if obj:
    #         obj.state = state.dict()
    #         self.db.commit()
    #         self.db.refresh(obj)
    #         return obj
    #     raise ValueError("Session not found")

    # def store_question_attempt(
    #     self,
    #     session_id: int,
    #     question_id: Optional[int],
    #     question_text: str,
    #     answer: str,
    #     is_llm_question: bool = False
    # ) -> QuestionAttempt:
    #     attempt = QuestionAttempt(
    #         session_id=session_id,
    #         question_id=question_id,
    #         question_text=question_text,
    #         user_answer=answer,
    #         is_llm_question=is_llm_question,
    #         created_at=datetime.now(timezone.utc)
    #     )
    #     self.db.add(attempt)
    #     self.db.commit()
    #     self.db.refresh(attempt)
    #     return attempt

    # def update_session_status(self, session_id: int, status: str = "completed") -> bool:
    #     obj = self.get_session_by_id(session_id)
    #     if obj:
    #         obj.status = status
    #         self.db.commit()
    #         return True
    #     return False

    # def get_session_attempts(self, session_id: int):
    #     return self.db.query(QuestionAttempt).filter(QuestionAttempt.session_id == session_id).all()
