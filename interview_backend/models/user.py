from pydantic import BaseModel, EmailStr , field_validator
from typing import Optional
from models.models import DifficultyLevel
import re

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    level: DifficultyLevel

    @field_validator("password")
    def strong_password(cls, value):
        if len(value) < 6:
            raise ValueError("Password must be at least 6 characters long")
        if not re.search(r"[A-Z]", value):
            raise ValueError("Password must contain at least one uppercase letter")
        if not re.search(r"[a-z]", value):
            raise ValueError("Password must contain at least one lowercase letter")
        if not re.search(r"[0-9]", value):
            raise ValueError("Password must contain at least one number")
        if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", value):
            raise ValueError("Password must contain at least one special character")
        return value

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class UserResponse(BaseModel):
    id: int
    name: str
    email: EmailStr
    level: DifficultyLevel

    class Config:
        from_attributes = True
