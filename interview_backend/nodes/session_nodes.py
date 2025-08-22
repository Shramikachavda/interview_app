from typing import Optional
from langchain_core.runnables import RunnableLambda
from models.models import SessionType, DifficultyLevel
from models.interview import InterviewModel
from core.config import settings
import random

async def initialize_session(state, config: dict = None):
    """
    Initialize the interview session with total questions and reset q_a_pair.
    """
    try:
        print(f"\n")
        print(f"🔍 Input state - session_type: {state.session_type}")
        print(f"🔍 Input state - level: {state.level}")
        print(f"🔍 Input state - q_a_pair length: {len(state.q_a_pair)}")
        
    
        total_questions = random.randint(settings.MIN_QUESTIONS_PER_SESSION, settings.MAX_QUESTIONS_PER_SESSION)
        
        print(f"🟢 Setting total_questions: {total_questions}")
        
        # Reset q_a_pair for new session
        state.q_a_pair = []
        state.asked_question_ids = []
        state.asked_llm_questions = []
        state.current_question_index = 0
        state.total_questions = total_questions
        state.session_status = "not_done"
        
        print(f"🟢 Reset q_a_pair length: {len(state.q_a_pair)}")
        print(f"🟢 === INITIALIZE_SESSION NODE END ===")
        
        return state
        
    except Exception as e:
        print(f"❌ [Initialize Session Error]: {e}")
        import traceback
        traceback.print_exc()
        return state


async def check_if_done(state, config: dict = None):
    """
    Check if the interview session is complete.
    """
    try:
        if isinstance(state, dict):
            current_index = state.get('current_question_index', 0)
            total_questions = state.get('total_questions', 0)
            session_status = "done" if current_index >= total_questions else "not_done"
            state['session_status'] = session_status
            print(f"🔍 Check if done: current={current_index}, total={total_questions}, status={session_status}")
            return state  
        else:
            session_status = "done" if state.current_question_index >= state.total_questions else "not_done"
            state.session_status = session_status
            print(f"🔍 Check if done: current={state.current_question_index}, total={state.total_questions}, status={session_status}")
            return state
    except Exception as e:
        print(f"[Check Done Error]: {e}")
        if isinstance(state, dict):
            state['session_status'] = "not_done"
            return state 
        else:
            state.session_status = "not_done"
            return state
