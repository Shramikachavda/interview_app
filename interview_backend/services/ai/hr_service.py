from typing import List, Dict
from langchain_core.messages import SystemMessage, HumanMessage
from langchain_core.prompts import PromptTemplate
from services.ai.base import LLMBase
from models.interview_feedback import InterviewFeedback

class HRInterviewService(LLMBase):

  

    def llm_generate_hr_question(self, experience: str, previous: List[str]) -> str:
        template = PromptTemplate(
            input_variables=["experience", "previous_questions"],
            template="""
            You are an expert HR interviewer. Generate one behavioral or situational question.

            Experience Level: {experience}
            Already Asked: {previous_questions}
            Avoid repeating or rephrasing earlier questions like: {previous_questions}.
            Return a **new**, unique question only.

            Focus on teamwork, conflict resolution, problem-solving, or leadership.
            Avoid duplicates. Just return the question text.
            """
        )

        prompt = template.format(
            experience=experience,
            previous_questions=", ".join(previous) if previous else "None"
        )

   

        
        response = self.ask(HumanMessage(content=prompt))

        return response.content.strip() if hasattr(response, 'content') else "Tell me about a time you handled a difficult team situation."



