# services/ai/base.py
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.messages import HumanMessage
from core.config import settings
from utils.response import standardize_response

class LLMBase:
    def __init__(self):
        self.llm = None
        self.init_error = None
        try:
            if settings.GOOGLE_API_KEY:
                self.llm = ChatGoogleGenerativeAI(
                    model="gemini-1.5-flash",
                    google_api_key=settings.GOOGLE_API_KEY,
                    temperature=0.7,
                    max_tokens=1000
                )
            else:
                self.init_error = "Missing Google API Key"
        except Exception as e:
            self.init_error = str(e)

    def is_ready(self) -> bool:
        return self.llm is not None

    async def ask_text(self, prompt: HumanMessage) -> str | None:
        """
        INTERNAL helper: returns plain text (or None on error).
        """
        if not self.llm:
            print("[LLMBase.ask_text] LLM not ready:", self.init_error)
            return None
        try:
            print("[⏳ Waiting for LLM response in ask_text()]")
            resp = await self.llm.ainvoke([prompt])
            print("[LLM response received]")
            print("RAW:", resp)  # resp is usually an AIMessage with .content

            # Prefer .content if present
            if hasattr(resp, "content") and resp.content:
                out = str(resp.content).strip()
                print("[ask_text] Extracted content:", out)
                return out

            # Fallbacks for other shapes (rare)
            try:
                out = str(resp).strip()
                print("[ask_text] Fallback str(resp):", out)
                return out
            except Exception:
                return None

        except Exception as e:
            print(f"[ask_text] LLM Error: {e}")
            return None

    # Optional: keep API response wrapper for HTTP routes
    async def ask_api(self, prompt: HumanMessage):
        """
        API helper: returns standardized JSONResponse for HTTP handlers.
        """
        if not self.llm:
            return standardize_response(
                success=False,
                message="AI service is currently unavailable. Please try again later.",
                status_code=503
            )
        try:
            resp = await self.llm.ainvoke([prompt])
            return standardize_response(
                success=True,
                message="LLM response received.",
                data={"content": getattr(resp, "content", None)}
            )
        except Exception as e:
            print(f"[ask_api] LLM Error: {e}")
            return standardize_response(
                success=False,
                message="Something went wrong while processing your request. Please try again later.",
                status_code=500
            )
