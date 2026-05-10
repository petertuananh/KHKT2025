from fastapi import FastAPI
from app.schemas import UserRequest, AIResponse
from app.recommender import recommend
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="AI Recommendation Service",
    description="AI phân tích nhu cầu mua bán phế liệu",
    version="1.0.0",
    root_path="/ai-service"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/ai/recommend", response_model=AIResponse)
def ai_recommend(req: UserRequest):
    return recommend(req)
