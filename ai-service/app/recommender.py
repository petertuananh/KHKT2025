from app.schemas import UserRequest
from app.intent import extract_category, analyze_intent

def recommend(req: UserRequest):
    category_id = extract_category(req.query)
    intent = analyze_intent(req.query)

    filters = {
        "category_id": category_id,
        "stock_min": req.min_stock or 0,
        "price_max": req.max_price,
        "place_id": req.place_id
    }

    ranking = ["place", "price", "stock"]

    explain_parts = []

    if category_id:
        explain_parts.append("đúng loại vật liệu")
    if req.min_stock:
        explain_parts.append("đủ số lượng")
    if req.max_price:
        explain_parts.append("giá trong ngân sách")
    if req.place_id:
        explain_parts.append("ưu tiên khu vực")

    explain = "AI ưu tiên " + ", ".join(explain_parts) if explain_parts else \
        "AI gợi ý dựa trên nhu cầu tìm kiếm của bạn"

    return {
        "filters": filters,
        "ranking": ranking,
        "explain": explain
    }
