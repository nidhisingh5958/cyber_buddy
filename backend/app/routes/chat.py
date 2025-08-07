from fastapi import APIRouter, HTTPException, Request, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel, validator
from typing import Optional
import logging
from app.services.openai_service import generate_response
from app.utils import setup_logging
from app.models.cyber_models import ChatRequest

chat_route = APIRouter()
logger = setup_logging()

class ChatResponse(BaseModel):
    response: str
    status: str
    error_type: Optional[str] = None
    technical_details: Optional[str] = None

@chat_route.post("/")
async def chat(prompt: ChatRequest):
    try:
        logger.info(f"Received chat request: {prompt}")
        logger.info(f"Request type: {type(prompt)}")
        
        # Call the generate_response function (remove await since it's not async)
        result = generate_response(prompt.prompt)
        
        logger.info(f"Generated response: {result}")
        
        # Handle different response types from generate_response
        if isinstance(result, dict):
            # If generate_response returns a dict with status
            if result.get("status") == "error":
                logger.error(f"Service returned error: {result}")
                raise HTTPException(
                    status_code=500, 
                    detail=result.get("response", "Internal server error")
                )
            else:
                # Success response - return the response field
                return {"response": result.get("response", str(result))}
        else:
            # Legacy string response
            return {"response": str(result)}
            
    except HTTPException:
        # Re-raise HTTP exceptions
        raise
    except Exception as e:
        logger.error(f"Error in chat endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

# Health check endpoint
@chat_route.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "chat",
        "message": "Chat service is running"
    }

# from fastapi import APIRouter, HTTPException
# from app.services.openai_service import generate_response
# from app.utils import setup_logging
# from app.models.cyber_models import ChatRequest

# logger = setup_logging()
# chat_route = APIRouter()

# @chat_route.post('/')
# async def chat(prompt: ChatRequest):
#     try:
#         logger.info(f"Received chat request: {prompt}")
#         logger.info(f"Response type: {type(prompt)}")
#         response = await generate_response(prompt.prompt)
#         logger.info(f"Generated response: {response}")
#         return {"response": response}
#     except Exception as e:
#         logger.error(f"Error in chat endpoint: {str(e)}")
#         raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}") 