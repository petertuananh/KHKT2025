const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');
const crypto = require('crypto');
/* ======================================================
   GET DANH SÁCH CHAT CỦA USER
====================================================== */
router.get('/', async (req, res) => {
    const chats = await prisma.chats.findMany({
        where: {
            users: {
                some: { id: req.user.id }
            }
        },
        include: { users: true, messages: { orderBy: { created_at: 'desc' }, take: 1 } },
    });
    return res.json({ code: 200, data: chats });
});

/* ======================================================
   TẠO CHAT MỚI HOẶC LẤY CHAT ĐÃ TỒN TẠI
====================================================== */
router.put('/', async (req, res) => {
    const io = req.app.get("io");

    if (!req.body.user_chat_to_id)
        return res.status(400).json({ code: 400, msg: 'Missing user_chat_to_id' });

    const findExistingChats = await prisma.chats.findMany({
        where: {
            AND: [
                { users: { some: { id: req.user.id } } },
                { users: { some: { id: req.body.user_chat_to_id } } }
            ]
        },
        include: { users: true }
    });

    if (findExistingChats.length > 0) {
        return res.json({ code: 200, data: findExistingChats[0] });
    }

    const targetUser = await prisma.users.findUnique({
        where: { id: req.body.user_chat_to_id }
    });

    if (!targetUser) {
        return res.status(404).json({ code: 404, msg: 'User to chat not found' });
    }

    const newChat = await prisma.chats.create({
        data: {
            id: utils.createSnowflakeId(),
            users: {
                connect: [
                    { id: req.user.id },
                    { id: req.body.user_chat_to_id }
                ]
            }
        },
        include: { users: true }
    });

    // 🔥 emit cho 2 user cập nhật danh sách chat mới
    newChat.users.forEach(u => {
        io.to(`user_${u.id}`).emit("chat:new", newChat);
    });

    return res.json({ code: 200, data: newChat });
});

/* ======================================================
   LẤY TIN NHẮN
====================================================== */
router.get('/:chat_id/messages', async (req, res) => {
    const findChat = await prisma.chats.findUnique({
        where: { id: req.params.chat_id },
        include: { users: true },
    });

    if (!findChat)
        return res.status(404).json({ code: 404, msg: 'Chat not found' });

    if (!findChat.users.some(u => u.id === req.user.id))
        return res.status(403).json({ code: 403, msg: 'Forbidden' });

    const messages = await prisma.messages.findMany({
        where: { chat_id: req.params.chat_id },
        orderBy: { created_at: 'asc' },
        include: { sender: true, seens: true, reactions: true },
    });

    return res.json({ code: 200, data: messages });
});

/* ======================================================
   GỬI TIN NHẮN + SOCKET.IO
====================================================== */
/* ======================================================
   GỬI TIN NHẮN + SOCKET.IO
====================================================== */
router.put('/:chat_id/messages', async (req, res) => {
    const io = req.app.get("io");

    const findChat = await prisma.chats.findUnique({
        where: { id: req.params.chat_id },
        include: { users: true },
    });

    if (!findChat)
        return res.status(404).json({ code: 404, msg: 'Chat not found' });

    if (!findChat.users.some(user => user.id === req.user.id))
        return res.status(403).json({ code: 403, msg: 'Forbidden' });

    if (!req.body.content)
        return res.status(400).json({ code: 400, msg: 'Missing content' });

    const newMsg = await prisma.messages.create({
        data: {
            id: utils.createSnowflakeId(),
            chat_id: req.params.chat_id,
            sender_id: req.user.id,
            content: req.body.content,
        },
        include: { sender: true }
    });

    // 🔥 client đang nghe event "message"
    io.to(`chat_${req.params.chat_id}`).emit("message", newMsg);
    return res.json({ code: 200, data: newMsg });
});

/* ======================================================
   ĐÁNH DẤU TIN NHẮN ĐÃ XEM
====================================================== */
router.put('/:chat_id/messages/:message_id/seen', async (req, res) => {
    const io = req.app.get("io");

    // Tìm chat
    const chat = await prisma.chats.findUnique({
        where: { id: req.params.chat_id },
        include: { users: true }
    });
    if (!chat) return res.status(404).json({ code: 404, msg: 'Chat not found' });

    if (!chat.users.some(u => u.id === req.user.id))
        return res.status(403).json({ code: 403, msg: 'Forbidden' });

    // Kiểm tra tin nhắn
    const message = await prisma.messages.findUnique({
        where: { id: req.params.message_id }
    });
    if (!message) return res.status(404).json({ code: 404, msg: 'Message not found' });

    // Nếu đã seen rồi thì không tạo duplicate
    const existing = await prisma.message_seens.findFirst({
        where: {
            message_id: req.params.message_id,
            seen_by_id: req.user.id
        }
    });

    if (!existing) {
        const seen = await prisma.message_seens.create({
            data: {
                id: crypto.randomUUID(),
                message_id: req.params.message_id,
                seen_by_id: req.user.id
            }
        });

        // Emit event để client cập nhật UI
        io.to(`chat_${req.params.chat_id}`).emit("message:seen", {
            message_id: req.params.message_id,
            seen_by_id: req.user.id,
            seen_at: seen.seen_at
        });
    }

    return res.json({ code: 200, msg: "Message marked as seen" });
});

/* ======================================================
   REACT TIN NHẮN
   body: { icon: "❤️" }
====================================================== */
router.put('/:chat_id/messages/:message_id/react', async (req, res) => {
    const io = req.app.get("io");
    const { icon } = req.body;

    if (!icon) return res.status(400).json({ code: 400, msg: 'Missing icon' });

    // Tìm chat
    const chat = await prisma.chats.findUnique({
        where: { id: req.params.chat_id },
        include: { users: true }
    });
    if (!chat) return res.status(404).json({ code: 404, msg: 'Chat not found' });

    if (!chat.users.some(u => u.id === req.user.id))
        return res.status(403).json({ code: 403, msg: 'Forbidden' });

    // Kiểm tra tin nhắn
    const message = await prisma.messages.findUnique({
        where: { id: req.params.message_id }
    });
    if (!message) return res.status(404).json({ code: 404, msg: 'Message not found' });

    // Kiểm tra nếu user đã react rồi → update, nếu chưa → create
    const existing = await prisma.message_reactions.findFirst({
        where: {
            message_id: req.params.message_id,
            seen_by_id: req.user.id
        }
    });

    let reaction;
    if (existing) {
        reaction = await prisma.message_reactions.update({
            where: { id: existing.id },
            data: { icon, seen_at: new Date() }
        });
    } else {
        reaction = await prisma.message_reactions.create({
            data: {
                id: utils.createSnowflakeId(),
                message_id: req.params.message_id,
                seen_by_id: req.user.id,
                icon
            }
        });
    }

    // Emit event để client cập nhật UI
    io.to(`chat_${req.params.chat_id}`).emit("message:react", reaction);

    return res.json({ code: 200, data: reaction });
});




module.exports = router;