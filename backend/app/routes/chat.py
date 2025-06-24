from fastapi import APIRouter, Body
from app.services.openai_service import generate_response

router = APIRouter()

@router.post('/', response_model=str)
def chat(prompt: str  = Body(..., embed=True)):
    response = generate_response(prompt)
    return response