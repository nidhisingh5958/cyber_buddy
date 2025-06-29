from fastapi import FastAPI
from app.routes import chat, info, logs
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title='Cyber Buddy Backend API',
              description='API for Cyber Buddy, a cybersecurity assistant',)

app.include_router(chat.router, prefix='/chat', tags=['Chat'])
app.include_router(info.router, prefix='/info', tags=['Info'])
app.include_router(logs.router, prefix='/logs', tags=['Logs'])

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # or your Flutter origin
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)

@app.get('/')
def root():
    return {'message': 'Welcome to the Cyber Buddy Backend!'}