function callAI(payload) {
    return fetch(process.env.AI_SERVICE_URL, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
    })
    .then(function (res) {
        if (!res || !res.ok) {
            throw new Error("AI service error");
        }
        return res.json();
    }).catch(e => console.log(e))
}

module.exports = {
    callAI
}