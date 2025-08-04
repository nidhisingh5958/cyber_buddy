from fastapi import APIRouter, HTTPException
from app.services.openai_service import generate_response
from app.utils import setup_logging
from app.models.cyber_models import ChatRequest

logger = setup_logging()
chat_route = APIRouter()

@chat_route.post('/')
async def chat(prompt: ChatRequest):
    try:
        logger.info(f"Received chat request: {prompt}")
        logger.info(f"Response type: {type(prompt)}")
        response = await generate_response(prompt.prompt)
        logger.info(f"Generated response: {response}")
        return {"response": response}
    except Exception as e:
        logger.error(f"Error in chat endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}") 