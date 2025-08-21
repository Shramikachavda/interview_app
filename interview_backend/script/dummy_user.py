import sys
import os

# ✅ Fix path first before importing anything
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# ✅ Now these imports will work
from models.models import User
from database import SessionLocal
from passlib.hash import bcrypt

hashed_password = bcrypt.hash("password123")  

def seed_user():
    db = SessionLocal()
    if not db.query(User).filter_by(id=1).first():
        
        dummy = User(
    id=1,
    name="Test User",
    email="test@example.com",
    password_hash=hashed_password,
    level="easy"
)
        db.add(dummy)
        db.commit()
        print("Dummy user created.")
    else:
        print("User already exists.")

if __name__ == "__main__":
    seed_user()
