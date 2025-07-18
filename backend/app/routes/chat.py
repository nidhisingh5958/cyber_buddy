from fastapi import APIRouter
from app.services.openai_service import generate_response
from app.utils import setup_logging
from app.models.cyber_models import ChatRequest

logger = setup_logging()
chat_route = APIRouter()

@chat_route.post('/')
def chat(prompt: ChatRequest):
    logger.info(f"Received prompt: {prompt}")
    logger.info(f"Response type: {type(prompt)}") 
    response = generate_response(prompt.prompt)
    logger.info(f"Generated response: {response}")
    return {"response":response}