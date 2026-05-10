const io = require("socket.io-client");
const prisma = require("./utils/prisma");
const socket = io("https://trashe.io.vn", {
    path: "/api/ws",
    transports: ["websocket"],
    auth: {
        token: '76325468364792489'
    }
});
const BOT_USER_ID = '9999999999999999999';

const BOT_TOKEN = '76325468364792489';

// Khi connect thành công
socket.on("connect", async () => {
    console.log("✅ WS Connected as bot");
    console.log("Socket ID:", socket.id);

    // Gửi event test
    socket.emit("bot_ready", { message: "Bot đã online!" });

    socket.emit("user_idle");

    const chats = await fetch("https://trashe.io.vn/api/chats", {
        headers: { "Authorization": "Bearer 76325468364792489" }
    }).then(res => res.json()).catch(e => console.log(e));

    for (const chat of chats.data) {
        // console.log("Bot joining", `chat_${chat.id}`);
        socket.emit("join", { chat_id: chat.id });
    }
});

// Khi disconnect
socket.on("disconnect", (reason) => {
    console.log("❌ WS Disconnected:", reason);
});

// Khi lỗi
socket.on("connect_error", (err) => {
    console.log("⚠️ Connect error:", err.message);
});

// Lắng nghe tin nhắn
socket.on("message", async (data) => {
    const message = data.content.toLowerCase();

    // Bỏ qua tin do bot gửi chính mình
    if (data.sender_id === BOT_USER_ID) return;


    let reply = null;


    axios({
        url: `https://trashe.io.vn/api/chats/${data.chat_id}/messages/${data.id}/seen`,
        method: 'put',
        headers: {
            'Authorization': `Bearer ${BOT_TOKEN}`
        }
    });

    axios({
        url: `https://trashe.io.vn/api/chats/${data.chat_id}/messages/${data.id}/react`,
        method: 'put',
        data: { icon: "❤️" },
        headers: {
            'Authorization': `Bearer ${BOT_TOKEN}`
        }
    });


    socket.emit("typing", {
        chat_id: data.chat_id
    });

    await new Promise(resolve => setTimeout(resolve, 1000));



    if (message.startsWith('/help') || message.includes('trợ giúp') || message.includes('help') || message.includes('hướng dẫn') || message.includes('giúp')) {
        reply = "Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty";
    } else if (message.startsWith('/company')) {
        const parts = message.split(' ');
        if (parts.length < 2) {
            reply = "❗ Vui lòng cung cấp thông tin để tìm công ty.\nVí dụ: `/company 123456` hoặc `/company công ty ABC`";
            await sendReplyByAPI(data.chat_id, reply);
            return;
        }

        // lấy toàn bộ phần sau /company
        const identifier = parts.slice(1).join(" ").trim();

        let companies = [];

        // Nếu chỉ 1 từ → ưu tiên tìm theo ID
        if (!identifier.includes(" ")) {
            companies = await prisma.companies.findMany({
                where: {
                    OR: [
                        { id: identifier },
                        // { tax_id: identifier }
                    ]
                },
                take: 5
            });
        }

        // Nếu không tìm thấy hoặc chuỗi chứa nhiều từ → tìm theo tên / mô tả / địa chỉ
        if (companies.length === 0) {
            companies = await prisma.companies.findMany({
                where: {
                    OR: [
                        { name: { contains: identifier, mode: 'insensitive' } },
                        { description: { contains: identifier, mode: 'insensitive' } },
                        { address: { contains: identifier, mode: 'insensitive' } },
                        { phone: { contains: identifier, mode: 'insensitive' } },
                        { email: { contains: identifier, mode: 'insensitive' } }
                    ]
                },
                take: 5
            });
        }

        // nếu không có kết quả
        if (companies.length === 0) {
            reply = `❌ Không tìm thấy công ty nào khớp với: "${identifier}"`;
            await sendReplyByAPI(data.chat_id, reply);
            return;
        }

        // Nếu có nhiều kết quả → liệt kê danh sách
        let replyText = `🔍 Tìm thấy **${companies.length}** công ty:\n\n`;

        companies.forEach((c, i) => {
            replyText += `**${i + 1}. ${c.name}**\n`;
            replyText += `• ID: ${c.id}\n`;
            replyText += `• MST: ${c.tax_id || "Chưa có"}\n`;
            replyText += `• Địa chỉ: ${c.address || "Chưa cập nhật"}\n`;
            replyText += `\n`;
        });

        await sendReplyByAPI(data.chat_id, replyText);
        return;
    }


    if (message.includes("hello") || message.includes("hi") || message.includes("chào") || message.includes("xin chào")) {
        reply = `Xin chào @${data.sender.username}! Bạn cần hỗ trợ gì không?`;
    }

    if (!reply) return; // không có câu trả lời

    await sendReplyByAPI(data.chat_id, reply);
});


// Ví dụ lắng nghe event custom từ server
// socket.on("server_event", (payload) => {
//     console.log("📢 Server event:", payload);
// });

// socket.onAny((event, data) => {
//     console.log("📡 EVENT:", event, data);
// });

const axios = require("axios");

async function sendReplyByAPI(chatId, content) {
    try {
        const res = await axios.put(
            `https://trashe.io.vn/api/chats/${chatId}/messages`,
            { content },
            {
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + BOT_TOKEN
                }
            }
        );

        // console.log("📤 Sent reply:", res.data);
        return res.data;
    } catch (err) {
        console.error("❌ Error sending reply:", err.response?.data || err.message);
    }
}
