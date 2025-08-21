from fastapi.responses import JSONResponse
from typing import Any, Optional
from pydantic import BaseModel


def standardize_response(
    success: bool,
    message: str,
    data: Optional[Any] = None,
    status_code: int = 200
) -> JSONResponse:
    """
    Returns a standardized JSON API response.

    Args:
        success (bool): Indicates if the request was successful.
        message (str): A message describing the result.
        data (Any, optional): Payload data. Defaults to None.
        status_code (int, optional): HTTP status code. Defaults to 200.

    Returns:
        JSONResponse: Standardized response.
    """

    if isinstance(data, BaseModel): 
        data = data.model_dump()

    return JSONResponse(
        status_code=status_code,
        content={
            "success": success,
            "message": message,
            "data": data
        }
    )
