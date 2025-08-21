
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.interviews import start_interview_api
from api.auth import auth


app = FastAPI(
    title="Interview Coach API",
    description="AI-powered Interview Coaching Platform",
    version="1.0.0"
)

# CORS (optional)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include the interview router
app.include_router(start_interview_api.router, prefix="/api/interview", tags=["Interview"])
app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])

# Health check endpoint
@app.get("/api/test")
async def test_endpoint():
    import time
    return {
        "message": "Backend is working!", 
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "status": "healthy",
        "version": "1.0.0"
    }

# Health check with more details
@app.get("/api/health")
async def health_check():
    import time
    import psutil
    
    return {
        "status": "healthy",
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "version": "1.0.0",
        "uptime": time.time(),
        "memory_usage": psutil.virtual_memory().percent if hasattr(psutil, 'virtual_memory') else "N/A",
        "active_sessions": 0  # Stateless approach - no active sessions stored
    }
