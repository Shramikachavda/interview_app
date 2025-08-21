import sys
import os

# Add root directory to PYTHONPATH
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from database import Base, engine
from models.models import User, QuestionBank

def initialize_database():
    print("Dropping all tables...")
    Base.metadata.drop_all(bind=engine)
    print("Creating all tables...")
    print("Creating all tables...")
    Base.metadata.create_all(bind=engine)
    print("✅ Database initialized successfully.")

if __name__ == "__main__":
    initialize_database()
