
from pydantic import BaseModel
from typing import List

class QuestionFeedback(BaseModel):
    question: str
    answer: str
    evaluation: str
    score: float

class InterviewPDFFeedback(BaseModel):
    overall_score: float
    summary: str
    strengths: List[str]
    improvements: List[str]
    detailed_feedback: List[QuestionFeedback]
