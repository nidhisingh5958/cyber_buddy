from fastapi import FastAPI
import os
import sys
sys.path.append(os.path.abspath)
from app.routes.chat import chat_route
from app.routes.info import info_route
from app.routes.logs import logs_route
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware

app = FastAPI(title='Cyber Buddy Backend API',
              description='API for Cyber Buddy, a cybersecurity assistant',)

app.include_router(chat_route, prefix='/chat', tags=['Chat'])
app.include_router(info_route, prefix='/info', tags=['Info'])
app.include_router(logs_route, prefix='/logs', tags=['Logs'])

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)
app.add_middleware(SessionMiddleware, secret_key=os.getenv("SESSION_SECRET_KEY"))

@app.get('/')
def root():
    return {'message': 'Welcome to the Cyber Buddy Backend!'}