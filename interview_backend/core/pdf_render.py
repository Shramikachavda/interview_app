from pathlib import Path
from jinja2 import Environment, FileSystemLoader
from models.pdf_feedback import InterviewPDFFeedback
from typing import List , Dict

# Load templates from the correct folder
env = Environment(loader=FileSystemLoader("templete"))  # folder name exactly
def render_feedback_html(
    feedback: InterviewPDFFeedback, 
    qa_list: List[Dict[str, str]],  # <-- add this
    interviewer_name: str, 
    current_date: str, 
    current_time: str
) -> str:
    """
    Render InterviewPDFFeedback into HTML using Jinja2 template,
    including interviewer name, current date, current time, and Q&A.
    """
    template_path = Path("templete/pdf_templete.html")
    if not template_path.exists():
        raise FileNotFoundError(f"PDF template not found at {template_path}")
    
    template = env.get_template("pdf_templete.html")
    
    return template.render(
        feedback=feedback.dict(),
        qa_list=qa_list,  # <-- pass Q&A list to template
        interviewer_name=interviewer_name,
        current_date=current_date,
        current_time=current_time
    )
