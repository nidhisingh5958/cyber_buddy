from fastapi import APIRouter, File, UploadFile
from app.services.log_parser import analyze_log

router = APIRouter()

@router.post("/")
async def analyze_uploaded_log(file: UploadFile = File(...)):
    content = await file.read()
    result = analyze_log(content.decode())
    return {"analysis": result}


    

