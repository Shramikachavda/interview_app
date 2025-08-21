from langchain_google_genai import ChatGoogleGenerativeAI
from core.config import settings
from utils.response import standardize_response  


class LLMBase:
    def __init__(self):
        try:
            if settings.GOOGLE_API_KEY:
                self.llm = ChatGoogleGenerativeAI(
                    model="gemini-1.5-flash",
                    google_api_key=settings.GOOGLE_API_KEY,
                    temperature=0.7,
                    max_tokens=1000
                )
            else:
                self.llm = None
                self.init_error = "Missing Google API Key"
        except Exception as e:
            self.llm = None
            self.init_error = str(e)

    def is_ready(self) -> bool:
        return self.llm is not None

    async def ask(self, prompt):
        if not self.llm:
            return standardize_response(
                success=False,
                message="AI service is currently unavailable. Please try again later.",
                status_code=503
            )

        try:
            print("[⏳ Waiting for LLM response...]")
            response = await self.llm.ainvoke([prompt])
            print(response)
            print("[LLM response received]")

            return standardize_response(
                success=True,
                message="LLM response received.",
                data=response
            )
        except Exception as e:
            print(f"LLM Error: {e}")
            return standardize_response(
                success=False,
                message="Something went wrong while processing your request. Please try again later.",
                status_code=500
            )
