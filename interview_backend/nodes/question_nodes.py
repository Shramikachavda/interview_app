from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from sqlalchemy import cast, String
from models.models import QuestionBank, QuestionType, SessionType
from models.interview import InterviewModel
from services import ai_factory
import random
import time
import traceback
import inspect


async def ask_question(state: InterviewModel, config: dict = None):
    """
    Decide and fetch the next question (HR or Technical).
    Guarantees ~40% LLM questions across total.
    """
    start_ts = time.time()
    try:
        print(f"\n[AskQuestion] ❓ === ASK_QUESTION START ===")
        print(f"[AskQuestion] session_type={state.session_type}, level={state.level}, index={state.current_question_index}/{state.total_questions}")

        db: Session = config.get("configurable", {}).get("db") if config else None
        if not db:
            raise ValueError("❌ Database session not provided in config")

        if state.session_type == SessionType.hr:
            state = await get_hr_question_from_state(state, db)
        else:
            state = await get_technical_question_from_state(state, db)

        preview = (state.current_question or "None")[:120]
        print(f"[AskQuestion] ✅ Selected question: {preview} (took {time.time() - start_ts:.2f}s)")
        print(f"[AskQuestion] ❓ === ASK_QUESTION END ===\n")
        return state

    except Exception as e:
        print(f"[AskQuestion] ❌ Fatal error while fetching question: {e}")
        traceback.print_exc()
        # Always fallback safely
        state.current_question = "Unexpected error. Please try again."
        return state


async def _should_use_llm(state: InterviewModel, llm_probability: float) -> bool:
    """Strict quota check + probability check."""
    total_llm_allowed = int(state.total_questions * llm_probability) if state.total_questions else 0
    used_llm = len(state.asked_llm_questions or [])
    remaining_llm = total_llm_allowed - used_llm

    # force LLM if quota not reached and DB quota nearly filled
    if remaining_llm > 0 and (len(state.q_a_pair) + remaining_llm >= state.total_questions):
        return True
    # otherwise probabilistic
    return remaining_llm > 0 and random.random() < llm_probability


async def get_hr_question_from_state(state: InterviewModel, db: Session, llm_probability: float = 0.4):
    fallback = "Tell me about a time you overcame a workplace challenge."
    asked_texts = {qa["question"] for qa in (state.q_a_pair or [])}
    asked_ids = set(state.asked_question_ids or [])

    try:
        use_llm = await _should_use_llm(state, llm_probability)
        print(f"[AskQuestion][HR] 🔀 Decision: use_llm={use_llm}")

        if use_llm:
            try:
                llm_fn = ai_factory.hr_ai.llm_generate_hr_question
                question = await llm_fn(state.level, list(asked_texts)) if inspect.iscoroutinefunction(llm_fn) else llm_fn(state.level, list(asked_texts))
                if inspect.isawaitable(question):
                    question = await question
                if question and question not in asked_texts:
                    state.asked_llm_questions.append(question)
                    state.current_question = question
                    return state
            except Exception as e:
                print(f"[AskQuestion][HR] ⚠️ LLM failed: {e}")
                traceback.print_exc()

        # fallback to DB
        db_question = (
            db.query(QuestionBank)
            .filter(
                QuestionBank.type == QuestionType.hr,
                QuestionBank.difficulty == state.level,
                ~QuestionBank.id.in_(asked_ids) if asked_ids else True
            )
            .order_by(func.random())
            .first()
        )
        if db_question:
            q_text = db_question.question_data.get("question_text") or db_question.question_data.get("question")
            state.current_question_id = db_question.id
            state.asked_question_ids.append(db_question.id)
            state.current_question = q_text
            return state

    except Exception as e:
        print(f"[AskQuestion][HR] ❌ Unexpected error: {e}")
        traceback.print_exc()

    # final fallback
    state.current_question = fallback
    return state


async def get_technical_question_from_state(state: InterviewModel, db: Session, llm_probability: float = 0.4):
    fallback = "Explain the difference between a stack and a queue."
    asked_texts = {qa["question"] for qa in (state.q_a_pair or [])}
    asked_ids = set(state.asked_question_ids or [])

    try:
        use_llm = await _should_use_llm(state, llm_probability)
        print(f"[AskQuestion][Tech] 🔀 Decision: use_llm={use_llm}")

        if use_llm:
            try:
                llm_fn = ai_factory.tech_ai.llm_generate_technical_question
                question = await llm_fn(state.level, list(asked_texts)) if inspect.iscoroutinefunction(llm_fn) else llm_fn(state.level, list(asked_texts))
                if inspect.isawaitable(question):
                    question = await question
                if question and question not in asked_texts:
                    state.asked_llm_questions.append(question)
                    state.current_question = question
                    return state
            except Exception as e:
                print(f"[AskQuestion][Tech] ⚠️ LLM failed: {e}")
                traceback.print_exc()

        # fallback to DB
        db_question = (
            db.query(QuestionBank)
            .filter(
                QuestionBank.type.in_([QuestionType.coding, QuestionType.sql, QuestionType.conceptual]),
                QuestionBank.difficulty == state.level,
                ~QuestionBank.id.in_(asked_ids) if asked_ids else True
            )
            .order_by(func.random())
            .first()
        )
        if db_question:
            q_text = db_question.question_data.get("question_text") or db_question.question_data.get("question")
            state.current_question_id = db_question.id
            state.asked_question_ids.append(db_question.id)
            state.current_question = q_text
            return state

    except Exception as e:
        print(f"[AskQuestion][Tech] ❌ Unexpected error: {e}")
        traceback.print_exc()

    # final fallback
    state.current_question = fallback
    return state


async def store_answer(state: InterviewModel, config: dict = None):
    """
    Store the user's answer to current question and prepare state for next.
    Ensures question_id is tracked in asked_question_ids.
    """
    start_ts = time.time()
    print(f"\n[AskQuestion] 💾 === STORE_ANSWER NODE START ===")
    print(f"[AskQuestion] 🔍 latest_answer: {state.latest_answer}")
    print(f"[AskQuestion] 🔍 current_question: {state.current_question}")
    print(f"[AskQuestion] 🔍 current_question_id: {state.current_question_id}")
    print(f"[AskQuestion] 🔍 current_question_index: {state.current_question_index}")
    print(f"[AskQuestion] 🔍 q_a_pair BEFORE store: {state.q_a_pair}")
    print(f"[AskQuestion] 🔍 asked_question_ids BEFORE store: {state.asked_question_ids}")

    try:
        # Only store if there is an answer and question is not already stored
        if state.current_question and state.latest_answer is not None:
            if not any(qa["question"] == state.current_question for qa in (state.q_a_pair or [])):
                new_qa_pair = {
                    "question": state.current_question,
                    "answer": state.latest_answer
                }
                state.q_a_pair.append(new_qa_pair)
                print(f"[AskQuestion] ✅ Stored Q&A pair. Total so far: {len(state.q_a_pair)}")
            else:
                print(f"[AskQuestion] ⚠️ Question already stored, skipping duplicate storage.")
        else:
            print(f"[AskQuestion] ⚠️ Skipping store - missing current_question or latest_answer.")

        # IMPORTANT: track current_question_id in asked_question_ids if present
        if getattr(state, "current_question_id", None) is not None:
            if state.current_question_id not in (state.asked_question_ids or []):
                state.asked_question_ids.append(state.current_question_id)
                print(f"[AskQuestion] 🔁 Added current_question_id to asked_question_ids: {state.current_question_id}")
            else:
                print(f"[AskQuestion] 🔁 current_question_id already present in asked_question_ids: {state.current_question_id}")

        state.current_question_index += 1
        elapsed = time.time() - start_ts
        print(f"[AskQuestion] 🔄 Incremented index to: {state.current_question_index} (took {elapsed:.3f}s)")
        print(f"[AskQuestion] 💾 === STORE_ANSWER NODE END ===")
        print(f"[AskQuestion] 🔍 q_a_pair AFTER store: {state.q_a_pair}")
        print(f"[AskQuestion] 🔍 asked_question_ids AFTER store: {state.asked_question_ids}")

    except Exception as e:
        print(f"[AskQuestion] ❌ [Store Answer Error]: {e}")
        traceback.print_exc()

    return state
