import logging
from pathlib import Path
from weasyprint import HTML

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def html_to_pdf(html_content: str, output_path: str) -> bool:
    """
    Convert HTML content to a PDF file.

    Args:
        html_content (str): The HTML string to convert.
        output_path (str): The file path where the PDF should be saved.

    Returns:
        bool: True if PDF was generated successfully, False otherwise.
    """
    try:
        if not html_content or not html_content.strip():
            logger.error("Empty HTML content provided for PDF generation.")
            return False

        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)

        logger.info(f"Generating PDF at: {output_path}")
        HTML(string=html_content).write_pdf(str(output_file))
        logger.info("PDF generation successful.")
        return True

    except Exception as e:
        logger.error(f"Error generating PDF: {e}", exc_info=True)
        return False
