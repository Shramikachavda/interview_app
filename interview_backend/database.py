from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# Database file name
DATABASE_URL = "sqlite:///interview.db"

# Create the engine
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})

# Base class for models
Base = declarative_base()

# Create session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
