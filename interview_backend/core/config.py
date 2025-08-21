import os
from typing import Optional
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Settings:
    # API Settings
    API_V1_STR: str = "/api"
    PROJECT_NAME: str = os.getenv("PROJECT_NAME", "Interview Coach API")
    
    # Database Settings
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./interview.db")
    
    # CORS Settings
    BACKEND_CORS_ORIGINS: list = os.getenv("BACKEND_CORS_ORIGINS", "*").split(",")
    
    # Security Settings
    SECRET_KEY: str = os.getenv("SECRET_KEY", "change-this-secret-in-prod")
    ALGORITHM: str = os.getenv("ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 60 * 24))
    
    # AI Settings
    GOOGLE_API_KEY: Optional[str] = os.getenv("GOOGLE_API_KEY")
    
    # Interview Settings
    MIN_QUESTIONS_PER_SESSION: int = int(os.getenv("MIN_QUESTIONS_PER_SESSION", 5))
    MAX_QUESTIONS_PER_SESSION: int = int(os.getenv("MAX_QUESTIONS_PER_SESSION", 10))
    DB_QUESTION_RATIO: float = float(os.getenv("DB_QUESTION_RATIO", 0.6))
    LLM_QUESTION_RATIO: float = float(os.getenv("LLM_QUESTION_RATIO", 0.4))
    
    # Session Settings
    SESSION_TIMEOUT_MINUTES: int = int(os.getenv("SESSION_TIMEOUT_MINUTES", 30))
    
    # SMTP Settings
    SMTP_SERVER: str = os.getenv("SMTP_SERVER", "")
    SMTP_PORT: int = int(os.getenv("SMTP_PORT", 587))
    SMTP_USER: str = os.getenv("SMTP_USER", "")
    SMTP_PASSWORD: str = os.getenv("SMTP_PASSWORD", "")
    
    # Logging
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    
    # Environment
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "development")
    DEBUG: bool = ENVIRONMENT.lower() == "development"

settings = Settings()
