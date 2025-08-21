from sqlalchemy import Column, Integer, String, Enum, DateTime, ForeignKey, JSON, Boolean , func
from sqlalchemy.orm import relationship
import enum
from datetime import datetime, timezone
from database import Base

# Enums
class DifficultyLevel(str, enum.Enum):
    easy = "easy"
    medium = "medium"
    hard = "hard"

class SessionType(str, enum.Enum):
    hr = "hr"
    technical = "technical"

class QuestionType(str, enum.Enum): 
    coding = "coding"
    sql = "sql"
    conceptual = "conceptual"
    hr = "hr"

# User Table
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    password_hash = Column(String, nullable=False)
    level = Column(Enum(DifficultyLevel), nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    interviews = relationship("InterviewSession", back_populates="user")

    def verify_password(self, plain_password):
        from core.security import pwd_context
        return pwd_context.verify(plain_password, self.password_hash)

# Question Bank Table
class QuestionBank(Base):
    __tablename__ = "question_bank"
    id = Column(Integer, primary_key=True, index=True)
    type = Column(Enum(QuestionType), nullable=False)  
    difficulty = Column(Enum(DifficultyLevel), nullable=False)
    question_data = Column(JSON, nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

# Interview Session Table
class InterviewSession(Base):
    __tablename__ = "interview_sessions"

    id = Column(Integer, primary_key=True, index=True)
    session_id = Column(String, unique=True, index=True, nullable=False)   # UUID string
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    session_type = Column(Enum(SessionType), nullable=False)
    level = Column(Enum(DifficultyLevel), nullable=False)
    total_questions = Column(Integer, nullable=False, default=0)
    state = Column(JSON, nullable=True)   # stores InterviewModel.dict()
    started_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="interviews")
    attempts = relationship("QuestionAttempt", back_populates="session")

# Question Attempt Table
class QuestionAttempt(Base):
    __tablename__ = "question_attempts"
    id = Column(Integer, primary_key=True)
    session_id = Column(Integer, ForeignKey("interview_sessions.id"), nullable=False)
    question_id = Column(Integer, ForeignKey("question_bank.id"), nullable=True)  # Allow null for LLM questions
    user_answer = Column(String)
    is_correct = Column(Boolean)
    feedback = Column(String)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    session = relationship("InterviewSession", back_populates="attempts")
    question = relationship("QuestionBank")