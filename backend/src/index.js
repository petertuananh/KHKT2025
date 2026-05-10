const express = require("express");
const app = express();
const cors = require("cors");
const config = require("../config");
const routers = require("./routers");
const http = require("http");
const socketio = require("socket.io");
const server = http.createServer(app);
const jsonWebToken = require('jsonwebtoken');
const prisma = require('./utils/prisma');


const io = socketio(server, {
    cors: { origin: "*" },
    transports: ["websocket"],
    path: "/api/ws"
});
app.use(cors({
    origin: "*", // chỉ định domain
    methods: "*",
    allowedHeaders: "*"
}));

// let onlineUsers = new Set();


io.on("connection", async (socket) => {
    // console.log("WS connected:", socket.id);

    const token = socket.handshake.auth?.token;
    if (!token) {
        socket.disconnect();
        return;
    }

    let user = null;

    const findBotToken = await prisma.users.findFirst({
        where: { bot_token: token }
    });
    // console.log("Bot token check:", token);
    if (findBotToken) {
        user = findBotToken;
    }
    else {
        const decoded = jsonWebToken.verify(token, config.JWT_SECRET);
        const findUser = await prisma.users.findUnique({ where: { id: decoded.id } });
        user = findUser;
        if (!findUser) {
            socket.disconnect();
            return;
        }
    }

    // console.log(`WS User connected: ${user.id} (${socket.id})`);

    const userId = user.id;

    io.emit("status_change", {
        user_id: userId,
        status: "online",
    });

    await prisma.users.update({
        where: { id: userId },
        data: {
            last_active_at: null,
            status: 'online'
        }
    });


    socket.on("user_idle", async () => {
        io.emit("status_change", {
            user_id: userId,
            status: "idle"
        });
        await prisma.users.update({
            where: { id: userId },
            data: {
                status: 'idle'
            }
        });
    });

    socket.on("user_active", async () => {
        io.emit("status_change", {
            user_id: userId,
            status: "online"
        });
        await prisma.users.update({
            where: { id: userId },
            data: {
                status: 'idle',
                last_active_at: user.last_active_at,
            }
        });
    });


    // Tham gia room theo user
    socket.join(`user_${userId}`);
    // onlineUsers.add(userId);

    // Gửi danh sách online cho tất cả user
    // io.emit("online_users", Array.from(onlineUsers));

    /* ============================================
       JOIN CHAT ROOM
    ============================================ */
    socket.on("join", data => {
        socket.join(`chat_${data.chat_id}`);
    });

    /* ============================================
       USER TYPING
    ============================================ */
    socket.on("typing", data => {
        socket.to(`chat_${data.chat_id}`).emit("typing", {
            chat_id: data.chat_id,
            user_id: userId
        });
    });

    /* ============================================
       SEND MESSAGE (client chỉ emit WS thông báo)
    ============================================ */
    socket.on("send", async data => {
        // server KHÔNG lưu vào DB (client dùng API PUT)
        // chỉ emit thông báo sang room
        io.to(`chat_${data.chat_id}`).emit("message", {
            chat_id: data.chat_id,
            sender_id: userId,
            content: data.content,
            temp: true
        });
    });

    /* ============================================
       DISCONNECT
    ============================================ */
    socket.on("disconnect", async () => {
        await prisma.users.update({
            where: { id: userId },
            data: {
                last_active_at: new Date(),
                status: 'offline'
            }
        });
        io.emit("status_change", {
            user_id: userId,
            status: "offline",
            last_active_at: new Date(),
        });
    });

});

app.set("io", io);


app.use(async function (req, res, next) {
    if (req.originalUrl.includes("/api/ws/") || req.originalUrl === "/api/ws") {
        console.log("WebSocket request detected, skipping URL modification.");
        return next(); // Không đụng vào URL cho websocket
    }
    req.url = req.url.replace('/_/', '/').replace('/api/', '/');
    req.originalUrl = req.url.replace('/_/', '/').replace('/api/', '/');
    if (!req.url) req.url = '/';
    res.header('Content-Type', 'application/json; charset=utf-8');
    res.header('X-Powered-By', `SOFTLAB .,LTD`);
    res.header('Project', `KHKT 2025`);
    return next();
});

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.raw());
app.use(routers);

app.get("/routes", (req, res) => {
    res.json(getRoutesTree(app));
});

// Tạo routes tree 1 lần khi khởi động server
const routesTree = getRoutesTree(app);

app.use((req, res, next) => {
    const method = req.method.toLowerCase();
    const url = req.path.replace(/\/+/g, "/");

    let matchedGroup = null;
    let matchedRoute = null;
    let matchedAllowedMethods = [];

    // 1. Tìm group (prefix)
    for (const group in routesTree) {
        if (url === group || url.startsWith(group + "/")) {
            matchedGroup = group;
            break;
        }
    }

    // Không có group → để middleware 404 xử lý
    if (!matchedGroup) return next();

    // 2. Tìm route trong group
    for (const sub in routesTree[matchedGroup]) {
        const routePattern = combineRoute(matchedGroup, sub);

        if (matchRoutePattern(routePattern, url)) {
            matchedRoute = sub;
            matchedAllowedMethods = routesTree[matchedGroup][sub].methods;
            break;
        }
    }

    // Không tìm thấy route phù hợp → 404
    if (!matchedRoute) return next();

    // 3. Có route nhưng method không hợp lệ → 405
    if (!matchedAllowedMethods.includes(method)) {
        return res.status(405).json({
            code: 405,
            msg: "Method Not Allowed",
            // allowed: matchedAllowedMethods
        });
    }

    return next();
});



app.use(async function (req, res, next) {
    return res.status(404).json({ code: 404, msg: `The requested url can not be found on this server.`, path: req.url });
});

server.listen(3000, () => console.log("Backend running on port 3000"));

function getRoutesTree(app) {
    const tree = {};

    function ensurePath(obj, segments) {
        let curr = obj;
        for (const seg of segments) {
            if (!curr[seg]) curr[seg] = {};
            curr = curr[seg];
        }
        return curr;
    }

    function parseStack(prefix, stack) {
        for (const layer of stack) {
            // Route trực tiếp
            if (layer.route) {
                const full = (prefix + layer.route.path).replace(/\/+/g, "/");
                const segments = full.split("/").filter(Boolean);

                const node = ensurePath(tree, segments);

                node.methods = node.methods || [];
                node.methods.push(...Object.keys(layer.route.methods));

                continue;
            }

            // Router lồng
            if (layer.name === "router" && layer.handle.stack) {
                const mount = getPathFromRegexp(layer.regexp); // lấy "/companies", "/auth", ...
                const newPrefix = (prefix + mount).replace(/\/+/g, "/");
                parseStack(newPrefix, layer.handle.stack);
            }
        }
    }

    parseStack("/", app._router.stack);
    return tree;
}

// Helper: tách path từ regexp
function getPathFromRegexp(regexp) {
    // Ví dụ: /^\/companies\/?(?=\/|$)/ → "/companies"
    const match = regexp
        .toString()
        .replace("/^", "")
        .replace("\\/?(?=\\/|$)/i", "")
        .replace("\\/?(?=\\/|$)/", "")
        .replace("$/i", "")
        .replace("$/", "")
        .replace("/i", "")
        .replace("/", "");
    return match.startsWith("/") ? match : "/" + match;
}



function combineRoute(group, sub) {
    return (group + "/" + sub).replace(/\/+/g, "/");
}

// match URL với pattern có :id, :company_id, ...
function matchRoutePattern(pattern, url) {
    const p = pattern.split("/").filter(Boolean);
    const u = url.split("/").filter(Boolean);

    if (p.length !== u.length) return false;

    for (let i = 0; i < p.length; i++) {
        if (p[i].startsWith(":")) continue;
        if (p[i] !== u[i]) return false;
    }
    return true;
}

setTimeout(() => {
    require('./bot');
}, 2000);

process.on('uncaughtException', (err) => {
    console.error('🔥 Có lỗi chưa bắt được:', err.message);
    // Khuyến nghị: Log lỗi và thoát process vì trạng thái ứng dụng lúc này không còn an toàn
    //   process.exit(1); 
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('🚨 Promise bị từ chối nhưng không được xử lý:', reason);
    // Có thể log vào hệ thống giám sát như Sentry hoặc Winston
});
