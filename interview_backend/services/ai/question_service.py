# services/ai/hr.py (unchanged behavior, but uses ask_text)
from typing import List
from langchain_core.messages import HumanMessage
from langchain_core.prompts import PromptTemplate
from services.ai.base import LLMBase

class HRInterviewService(LLMBase):

    async def llm_generate_hr_question(self, experience: str, previous: List[str]) -> str:
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

   
        text = await self.ask_text(HumanMessage(content=prompt))

        if isinstance(text, str) and text.strip():
            q = text.strip()
      
       
            return q


        return "Tell me about a time you handled a difficult team situation."
    

    
class TechInterviewService(LLMBase):

    async def llm_generate_technical_question(self, level: str, previous: List[str]) -> str:
        """
        Generate one unique technical interview question.
        """
        template = PromptTemplate(
            input_variables=["level", "previous_questions"],
            template="""
            You are an expert technical interviewer. Generate one coding, problem-solving, or system design question.

            Candidate Level: {level}
            Already Asked: {previous_questions}
            Avoid repeating or rephrasing earlier questions like: {previous_questions}.
            Return a **new**, unique question only.

            Focus on algorithms, coding challenges, debugging, optimization, or system design.
            Avoid duplicates. Just return the question text.
            """
        )

        prompt = template.format(
            level=level,
            previous_questions=", ".join(previous) if previous else "None"
        )

        text = await self.ask_text(HumanMessage(content=prompt))

        print(repr(text))

        if isinstance(text, str):
            cleaned = text.strip()
            if cleaned:

                print(cleaned)

                return cleaned

    
        return "Explain how you would design a scalable URL shortener service."
