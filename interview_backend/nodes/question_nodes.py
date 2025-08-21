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
    Ask the next question based on session type and level.
    """
    start_ts = time.time()
    try:
        print(f"\n[AskQuestion] ❓ === ASK_QUESTION NODE START ===")
        print(f"[AskQuestion] 🔍 Incoming state summary:")
        print(f"[AskQuestion]    session_id: {getattr(state, 'session_id', None)}")
        print(f"[AskQuestion]    session_type: {state.session_type}, level: {state.level}")
        print(f"[AskQuestion]    current_question_index: {state.current_question_index} / {state.total_questions}")
        print(f"[AskQuestion]    q_a_pair length: {len(state.q_a_pair)}")
        print(f"[AskQuestion]    asked_question_ids: {state.asked_question_ids}")
        print(f"[AskQuestion]    asked_llm_questions: {state.asked_llm_questions}")
        print(f"[AskQuestion]    current_question_id: {getattr(state, 'current_question_id', None)}")
        print(f"[AskQuestion]    latest_answer: {state.latest_answer}")

        # Correctly fetch db from nested structure
        db: Session = config.get("configurable", {}).get("db") if config else None
        if db is None:
            raise ValueError("Database session not found in config")

        print(f"[AskQuestion] 🔗 DB session found: {db}")

        if state.session_type == SessionType.hr:
            state = await get_hr_question_from_state(state, db)
        else:
            state = await get_technical_question_from_state(state, db)

        # safe slicing in case current_question is None
        current_q_preview = state.current_question[:200] if state.current_question else "None"
        elapsed = time.time() - start_ts
        print(f"[AskQuestion] ✅ Question selected (took {elapsed:.3f}s): {current_q_preview}...")
        print(f"[AskQuestion] ❓ === ASK_QUESTION NODE END ===\n")
        return state

    except Exception as e:
        print(f"[AskQuestion] ❌ [Ask Question Error]: {e}")
        traceback.print_exc()
        return state


async def get_hr_question_from_state(state: InterviewModel, db: Session, llm_probability: float = 0.4):
    start_ts = time.time()
    print(f"[AskQuestion][HR] ▶ Enter get_hr_question_from_state()")
    fallback_question = "Tell me about a time you overcame a workplace challenge."
    already_asked_questions = {qa["question"] for qa in (state.q_a_pair or [])}
    already_asked_ids = set(state.asked_question_ids or [])

    print(f"[AskQuestion][HR] 🔍 Already asked questions (texts): {already_asked_questions}")
    print(f"[AskQuestion][HR] 🔍 Already asked question IDs: {already_asked_ids}")
    print(f"[AskQuestion][HR] 🔍 Asked LLM questions: {state.asked_llm_questions}")

    try:
        total_llm_allowed = int(state.total_questions * llm_probability) if state.total_questions else 0
        used_llm_questions = len(state.asked_llm_questions or [])
        remaining_llm = total_llm_allowed - used_llm_questions

        print(f"[AskQuestion][HR] 🔍 total_llm_allowed={total_llm_allowed}, used_llm_questions={used_llm_questions}, remaining_llm={remaining_llm}")

        use_llm = remaining_llm > 0 and random.random() < llm_probability
        print(f"[AskQuestion][HR] 🔀 LLM decision => use_llm={use_llm}")

        if use_llm:
            # Call LLM generator; support sync or async functions
            llm_fn = ai_factory.hr_ai.llm_generate_hr_question
            try:
                if inspect.iscoroutinefunction(llm_fn):
                    question = await llm_fn(experience=state.level, previous=list(already_asked_questions))
                else:
                    question = llm_fn(experience=state.level, previous=list(already_asked_questions))
                    # If returned coroutine by mistake, await it
                    if inspect.isawaitable(question):
                        question = await question
                print(f"[AskQuestion][HR] 🔍 LLM generated question (raw): {repr(question)}")
            except Exception as llm_err:
                print(f"[AskQuestion][HR] ⚠️ LLM generation error: {llm_err}")
                traceback.print_exc()
                question = None

            # log types and membership checks
            print(f"[AskQuestion][HR] 🔎 LLM question type: {type(question)}")
            if question and question not in already_asked_questions and question not in (state.asked_llm_questions or []):
                state.asked_llm_questions.append(question)
                state.current_question = question
                print(f"[AskQuestion][HR] ✅ HR: Using LLM generated question -> {question}")
                elapsed = time.time() - start_ts
                print(f"[AskQuestion][HR] ◀ Exit get_hr_question_from_state() (took {elapsed:.3f}s)")
                return state
            else:
                print(f"[AskQuestion][HR] ⚠️ HR: LLM question duplicate or empty (question={repr(question)})")

        # Exclude asked questions by ID AND question text (to avoid duplicates with same text but different IDs)
        print(f"[AskQuestion][HR] 🔁 Running DB query for candidate HR question (no JSON text filter in SQL)...")
        # Build filters: avoid inserting Python True into .filter()
        filters = [QuestionBank.type == QuestionType.hr, QuestionBank.difficulty == state.level]
        if already_asked_ids:
            filters.append(~QuestionBank.id.in_(already_asked_ids))

        # fetch random candidate (log also fallback)
        db_query_start = time.time()
        db_question = (
            db.query(QuestionBank)
            .filter(*filters)
            .order_by(func.random())
            .first()
        )
        db_query_time = time.time() - db_query_start
        print(f"[AskQuestion][HR] 🔍 DB query took {db_query_time:.3f}s, result: {db_question is not None}")

        question_text = None
        if db_question:
            # Prefer `question_text` key in your JSON
            question_text = db_question.question_data.get('question_text') or db_question.question_data.get('question')
            print(f"[AskQuestion][HR] 🔍 DB selected: id={db_question.id}, text={repr(question_text)}")
        else:
            print(f"[AskQuestion][HR] 🔍 DB returned no candidate (filters: already_asked_ids={already_asked_ids})")

        if db_question:
            state.current_question_id = db_question.id
            if db_question.id not in (state.asked_question_ids or []):
                state.asked_question_ids.append(db_question.id)
                print(f"[AskQuestion][HR] 🔁 Appended asked_question_id: {db_question.id}")
            state.current_question = question_text
            elapsed = time.time() - start_ts
            print(f"[AskQuestion][HR] ◀ Exit get_hr_question_from_state() (took {elapsed:.3f}s)")
            return state

    except Exception as e:
        print(f"[AskQuestion][HR] ❌ [HR Question Fetch Error]: {e}")
        traceback.print_exc()

    # Fallback question handling
    print(f"[AskQuestion][HR] 🔽 Fallback handling")
    if fallback_question not in already_asked_questions:
        state.current_question = fallback_question
        print(f"[AskQuestion][HR] ⚠️ HR: Using fallback question -> {fallback_question}")
    else:
        # If there are still slots to fill, optionally re-use fallback; otherwise mark no more unique
        if len(state.q_a_pair) < state.total_questions:
            state.current_question = fallback_question
            print("[AskQuestion][HR] ⚠️ HR: Re-using fallback to continue until total_questions reached")
        else:
            state.current_question = "No more unique HR questions available."
            print("[AskQuestion][HR] ⚠️ HR: No more unique HR questions available")

    elapsed = time.time() - start_ts
    print(f"[AskQuestion][HR] ◀ Exit get_hr_question_from_state() (took {elapsed:.3f}s)")
    return state


async def get_technical_question_from_state(state: InterviewModel, db: Session, llm_probability: float = 0.4):
    start_ts = time.time()
    print(f"[AskQuestion][Tech] ▶ Enter get_technical_question_from_state()")
    fallback_question = "Explain the difference between a stack and a queue."
    already_asked_questions = {qa["question"] for qa in (state.q_a_pair or [])}
    already_asked_ids = set(state.asked_question_ids or [])

    print(f"[AskQuestion][Tech] 🔍 Already asked questions (texts): {already_asked_questions}")
    print(f"[AskQuestion][Tech] 🔍 Already asked question IDs: {already_asked_ids}")
    print(f"[AskQuestion][Tech] 🔍 Asked LLM questions: {state.asked_llm_questions}")

    try:
        # Query a random technical DB question excluding asked IDs
        print(f"[AskQuestion][Tech] 🔁 Running DB query for technical candidate...")
        filters = [
            QuestionBank.type.in_([QuestionType.coding, QuestionType.sql, QuestionType.conceptual]),
            QuestionBank.difficulty == state.level,
        ]
        if already_asked_ids:
            filters.append(~QuestionBank.id.in_(already_asked_ids))

        db_query_start = time.time()
        db_question = (
            db.query(QuestionBank)
            .filter(*filters)
            .order_by(func.random())
            .first()
        )
        db_query_time = time.time() - db_query_start
        print(f"[AskQuestion][Tech] 🔍 DB query took {db_query_time:.3f}s, result: {db_question is not None}")

        question_text = None
        if db_question:
            question_text = db_question.question_data.get('question_text') or db_question.question_data.get('question')
            print(f"[AskQuestion][Tech] 🔍 DB selected: id={db_question.id}, text={repr(question_text)}")

        if db_question:
            state.current_question_id = db_question.id
            if db_question.id not in (state.asked_question_ids or []):
                state.asked_question_ids.append(db_question.id)
                print(f"[AskQuestion][Tech] 🔁 Appended asked_question_id: {db_question.id}")
            state.current_question = question_text
            elapsed = time.time() - start_ts
            print(f"[AskQuestion][Tech] ◀ Exit get_technical_question_from_state() (took {elapsed:.3f}s)")
            return state

        # No DB result -> potential LLM flow
        total_llm_allowed = int(state.total_questions * llm_probability) if state.total_questions else 0
        used_llm_questions = len(state.asked_llm_questions or [])
        remaining_llm = total_llm_allowed - used_llm_questions
        print(f"[AskQuestion][Tech] 🔍 total_llm_allowed={total_llm_allowed}, used_llm_questions={used_llm_questions}, remaining_llm={remaining_llm}")

        if remaining_llm > 0 and random.random() < llm_probability:
            question = f"Technical question for {state.level} level: Explain a key concept in software development."
            print(f"[AskQuestion][Tech] 🔍 LLM generated question (fallback): {question}")

            if question not in already_asked_questions and question not in (state.asked_llm_questions or []):
                state.asked_llm_questions.append(question)
                state.current_question = question
                print("[AskQuestion][Tech] ✅ Tech: Using LLM generated question")
                elapsed = time.time() - start_ts
                print(f"[AskQuestion][Tech] ◀ Exit get_technical_question_from_state() (took {elapsed:.3f}s)")
                return state
            else:
                print("[AskQuestion][Tech] ⚠️ Tech: LLM question duplicate")

    except Exception as e:
        print(f"[AskQuestion][Tech] ❌ [Technical Question Fetch Error]: {e}")
        traceback.print_exc()

    # Fallback question handling
    print("[AskQuestion][Tech] 🔽 Fallback handling")
    if fallback_question not in already_asked_questions:
        state.current_question = fallback_question
        print(f"[AskQuestion][Tech] ⚠️ Tech: Using fallback question -> {fallback_question}")
    else:
        if len(state.q_a_pair) < state.total_questions:
            state.current_question = fallback_question
            print("[AskQuestion][Tech] ⚠️ Tech: Re-using fallback to continue until total_questions reached")
        else:
            state.current_question = "No more unique technical questions available."
            print("[AskQuestion][Tech] ⚠️ Tech: No more unique technical questions available")

    elapsed = time.time() - start_ts
    print(f"[AskQuestion][Tech] ◀ Exit get_technical_question_from_state() (took {elapsed:.3f}s)")
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
