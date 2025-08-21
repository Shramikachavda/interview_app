from pydantic import BaseModel , Field
from typing import Optional, Any, Dict, List
from models.models import SessionType, DifficultyLevel, QuestionType
from typing_extensions import Literal

class InterviewModel(BaseModel):
    """Main interview state model that gets passed between frontend and backend"""
    session_id: Optional[str] = None
    user_id: Optional[int] = None
    session_type: Optional[SessionType] = None
    level: Optional[DifficultyLevel] = None
    current_question_index: int = 0
    total_questions: int = 0
    current_question_type: Optional[QuestionType] = None
    q_a_pair: List[Dict[str, str]] = Field(default_factory=list)
    current_question_id: Optional[int] = None
    asked_question_ids: List[int] = Field(default_factory=list)
    asked_llm_questions: List[str] = Field(default_factory=list)
    session_status: Literal["not_done", "done"] = "not_done"
    current_question: Optional[str] = None
    feedback: Optional[Dict[str, Any]] = None
    latest_answer: Optional[str] = None

    class Config:
        use_enum_values = True

class UnifiedInterviewRequest(BaseModel):
    """
    Unified request model for the /interview endpoint.
    Handles both starting new interviews and continuing existing ones.
    """
    # For starting: just send user_id, session_type, level in state
    # For continuing: send the full state with latest_answer
    state: InterviewModel

class InterviewResponse(BaseModel):
    message: str  # <next question> or <final feedback>
    done: bool    # true if session is complete
    state: InterviewModel  # updated InterviewModel
