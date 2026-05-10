function calculateDistance(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in kilometers
    var dLat = ((lat2 - lat1) * Math.PI) / 180;
    var dLon = ((lon2 - lon1) * Math.PI) / 180;

    var a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var distance = R * c;

    return distance;
}

function calPriceScore(price, max_price, min_stock) {
    if (!max_price) return 0.2;
    return Math.min(0.2, 1 - price / (max_price/min_stock *1000));
}

function scoreProduct(product, userInput, userLat, userLon, min_stock) {
    var score = 0;
    var reasons = [];

    // đủ stock
    if (product.stock >= (userInput.min_stock || 0)) {
        score += 0.2;
        reasons.push("Đủ số lượng");
    }

    // giá phù hợp
    var price_score = calPriceScore(
        product.price,
        userInput.filters.price_max,
        min_stock
    );
    score += price_score;
    reasons.push("Giá phù hợp");

    // đúng loại
    if (
        userInput.filters.category_id &&
        product.category_id === userInput.filters.category_id
    ) {
        score += 0.2;
        reasons.push("Đúng loại vật liệu");
    }

    // gần vị trí
    var d = calculateDistance(
        userLat,
        userLon,
        product.place.latitude,
        product.place.longitude
    );

    score += Math.max(0, (100 - d) / 250);

    return {
        ai_score: Math.min(score, 1),
        ai_reason: reasons,
        distance: d,
        price_score: price_score
    };
}

module.exports = {
    scoreProduct: scoreProduct,
    calculateDistance: calculateDistance,
    calPriceScore: calPriceScore
};
