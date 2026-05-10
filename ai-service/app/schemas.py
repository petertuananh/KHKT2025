from pydantic import BaseModel
from typing import Optional, List, Dict

class UserRequest(BaseModel):
    query: str
    min_stock: Optional[int] = 0
    max_price: Optional[int] = None
    place_id: Optional[str] = None

class AIResponse(BaseModel):
    filters: Dict
    ranking: List[str]
    explain: str
