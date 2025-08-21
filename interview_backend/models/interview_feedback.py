from pydantic import BaseModel, Field
from typing import List

class InterviewFeedback(BaseModel):
    score: int = Field(
        ...,
        ge=0,
        le=10,
        description="Numeric score given to the candidate's answer (0–10)"
    )
    feedback: str = Field(
        ...,
        description="Brief overall feedback or summary of the candidate's performance for this question"
    )
    areas_for_improvement: List[str] = Field(
        ...,
        description="List of 3–5 specific bullet points suggesting how the candidate can improve their answer"
    )


