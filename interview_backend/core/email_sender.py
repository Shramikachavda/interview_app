import smtplib
from email.message import EmailMessage
from pathlib import Path
from core.config import settings  
from core.logger import logger

def send_email_with_pdf(
    to_email: str,
    pdf_path: str,
    subject: str = "Interview Feedback Report",
    body_text: str = None
) -> bool:
    """
    Sends an email with a PDF attachment.
    """
    if not to_email or "@" not in to_email:
        logger.warning(f"Invalid recipient email: {to_email}")
        return False

    if not Path(pdf_path).exists():
        logger.error(f"PDF file not found: {pdf_path}")
        return False

    if not body_text:
        body_text = (
            "Dear candidate,\n\n"
            "Please find attached your detailed interview feedback report.\n\n"
            "Best regards,\nInterview Team"
        )

    try:
        logger.info(f"📧 Preparing email to {to_email} with attachment {pdf_path}")

        msg = EmailMessage()
        msg["Subject"] = subject
        msg["From"] = settings.SMTP_USER
        msg["To"] = to_email
        msg.set_content(body_text)

        with open(pdf_path, "rb") as f:
            pdf_data = f.read()
            logger.debug(f"Read {len(pdf_data)} bytes from PDF file")

        msg.add_attachment(
            pdf_data,
            maintype="application",
            subtype="pdf",
            filename="Interview_Feedback.pdf"
        )
        logger.debug("PDF attached to email")

        with smtplib.SMTP(settings.SMTP_SERVER, settings.SMTP_PORT) as smtp:
            logger.info(f"Connecting to SMTP server {settings.SMTP_SERVER}:{settings.SMTP_PORT}")
            smtp.starttls()
            logger.debug("Started TLS encryption for SMTP connection")
            smtp.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
            logger.info("SMTP login successful")
            smtp.send_message(msg)

        logger.info(f"✅ Email sent successfully to {to_email}")
        return True

    except smtplib.SMTPException as e:
        logger.error(f"❌ SMTP error while sending email to {to_email}: {e}")
        return False
    except Exception as e:
        logger.exception(f"⚠️ Unexpected error while sending email to {to_email}: {e}")
        return False
