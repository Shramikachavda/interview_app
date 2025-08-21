from sqlalchemy.orm import Session
from models.models import User, DifficultyLevel
from core.security import pwd_context

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def create_user(db: Session, name: str, email: str, password: str, level: DifficultyLevel):
    hashed_password = pwd_context.hash(password)
    user = User(name=name, email=email, password_hash=hashed_password, level=level)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

def authenticate_user(db: Session, email: str, password: str):
    user = get_user_by_email(db, email)
    if user and user.verify_password(password):
        return user
    return None
