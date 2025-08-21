from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from datetime import timedelta
from core.security import verify_token  #
from models.user import UserCreate, UserLogin, Token, UserResponse
from crud.user import get_user_by_email, create_user, authenticate_user
from core.security import create_access_token , get_current_user
from core.config import settings
from utils.response import standardize_response
from database import get_db
from fastapi.security import OAuth2PasswordBearer
from models.models import User

router = APIRouter()


@router.post("/register")
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    # Check if user already exists
    existing_user = get_user_by_email(db, user_data.email)
    if existing_user:
        return standardize_response(
            success=False,
            message="Email already registered",
            status_code=status.HTTP_400_BAD_REQUEST
        )

    # Create new user
    user = create_user(
        db=db,
        name=user_data.name,
        email=user_data.email,
        password=user_data.password,
        level=user_data.level
    )

    # Generate access token
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    # Return standardized response with token and user info
    return standardize_response(
        success=True,
        message="Registration successful",
        data={
            "access_token": access_token,
            "token_type": "bearer",
            "user": UserResponse.model_validate(user).model_dump()
        },
        status_code=status.HTTP_201_CREATED
    )

@router.get("/me")
def get_me(current_user: User = Depends(get_current_user)):
    return {
        "name": current_user.name,
        "email": current_user.email
    }

@router.post("/login")
def login(user_data: UserLogin, db: Session = Depends(get_db)):
    # Authenticate user
    user = authenticate_user(db, user_data.email, user_data.password)
    if not user:
        return standardize_response(
            success=False,
            message="Invalid credentials",
            status_code=status.HTTP_401_UNAUTHORIZED
        )

    # Generate token
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return standardize_response(
        success=True,
        message="Login successful",
        data={
            "access_token": access_token,
            "token_type": "bearer",
            "user": UserResponse.model_validate(user).model_dump()
        },
        status_code=status.HTTP_200_OK
    )


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")


@router.post("/logout")
def logout(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    """
    Logout endpoint (stateless):
    - Client should delete the access token locally
    - Optionally track user logout
    """
    try:
        payload = verify_token(token)
        user_email = payload.get("sub")
        if not user_email:
            return standardize_response(
                success=False,
                message="Invalid token",
                status_code=status.HTTP_400_BAD_REQUEST
            )

        # Optional: log or track logout event here
        print(f"[Logout] User {user_email} has logged out")

        return standardize_response(
            success=True,
            message="Logout successful",
            status_code=status.HTTP_200_OK
        )

    except Exception:
        return standardize_response(
            success=False,
            message="Invalid or expired token",
            status_code=status.HTTP_401_UNAUTHORIZED
        )
