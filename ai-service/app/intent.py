from app.category_map import CATEGORY_MAP

def extract_category(query: str):
    q = query.lower()
    for keyword, category_id in CATEGORY_MAP.items():
        if keyword in q:
            return category_id
    return None
def analyze_intent(query: str):
    intent = "search"

    if any(word in query.lower() for word in ["bán", "thanh lý"]):
        intent = "sell"
    elif any(word in query.lower() for word in ["mua", "cần"]):
        intent = "buy"

    return intent
