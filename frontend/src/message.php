<?php include './init.php';
include './middlewares/auth.php';
?>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Chat</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: #eef1f5;
        }

        /* ================================
       SIDEBAR
    ==================================*/
        .chat-list {
            border-right: 1px solid #ddd;
            height: 100vh;
            overflow-y: auto;
            background: #fff;
            padding: 0;
        }

        .chat-item {
            padding: 14px;
            display: flex;
            gap: 12px;
            cursor: pointer;
            align-items: center;
            transition: 0.2s;
            border-bottom: 1px solid #f0f0f0;
        }

        .chat-item:hover {
            background: #f7f9fc;
        }

        .chat-item.active {
            background: #e8edff;
            border-left: 4px solid #4e73df;
        }

        .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            object-fit: cover;
        }

        .online-dot {
            position: absolute;
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: #28a745;
            bottom: 2px;
            right: 2px;
            border: 2px solid white;
        }

        .idle-dot {
            background: #f4c542 !important;
        }

        .offline-dot {
            background: #ccc !important;
        }

        /* ================================
       MESSAGES BOX
    ==================================*/
        .messages-box {
            padding: 20px;
            overflow-y: auto;
            height: calc(100vh - 150px);
            background: #f7f7f9;
        }

        /* MESSAGE ROW */
        .message-row {
            display: flex;
            margin-bottom: 18px;
        }

        .message-row.me {
            justify-content: flex-end;
        }

        .message-row.me .message-bubble {
            background: #4e73df;
            color: #fff;
            border-radius: 16px 16px 4px 16px;
        }

        .message-row.other .message-bubble {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 16px 16px 16px 4px;
        }

        .message-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }

        .message-content {
            max-width: 70%;
        }

        .message-name {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 3px;
            color: #344767;
        }

        .message-bubble {
            padding: 10px 15px;
            line-height: 1.45;
            font-size: 15px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
            word-wrap: break-word;
            /* white-space: pre-wrap; */
        }

        .message-time {
            font-size: 11px;
            margin-top: 4px;
            color: #999;
        }

        /* ================================
       HEADER
    ==================================*/
        .chat-header {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            background: #fff;
        }

        /* ================================
       INPUT
    ==================================*/
        .input-group {
            background: #fff;
            border-top: 1px solid #ddd;
        }

        /* ================================
       TYPING INDICATOR
    ==================================*/
        #typingIndicator {
            height: 20px;
            font-size: 13px;
            margin-left: 20px;
            color: #666;
            display: none;
        }

        .chat-item.new-message {
            animation: flash 1s ease 0s 2;
        }

        @keyframes flash {
            0% {
                background-color: #fff;
            }

            50% {
                background-color: #fff3cd;
            }

            /* màu vàng nhạt */
            100% {
                background-color: #fff;
            }
        }
    </style>

</head>

<body>
    <audio id="newMessageSound" src="https://tiengdong.com/wp-content/uploads/Am-thanh-messenger-www_tiengdong_com.mp3" preload="auto"></audio>
    <div class="container-fluid">
        <div class="row">

            <!-- SIDEBAR -->
            <div class="col-md-3 chat-list" id="chatList"></div>

            <!-- CHAT AREA -->
            <div class="col-md-9 d-flex flex-column p-0">

                <!-- Chat Header -->
                <div class="chat-header d-flex align-items-center justify-content-between">

                    <div class="d-flex align-items-center gap-3">
                        <a href="/" class="btn btn-outline-primary btn-sm">
                            <i class="fa-solid fa-house"></i> Trang chủ
                        </a>

                        <div>
                            <h5 id="chatTitle" class="mb-0">Chọn người để nhắn</h5>
                            <span id="chatStatus" class="ms-1"></span>
                        </div>
                    </div>

                </div>


                <!-- Messages -->
                <div class="messages-box" id="messagesBox"></div>

                <!-- Typing indicator -->
                <div id="typingIndicator">Đang nhập…</div>

                <!-- Input -->
                <div class="input-group p-3">
                    <input type="text" id="messageInput" class="form-control" placeholder="Nhập tin nhắn...">
                    <div class="input-group-append">
                        <button class="btn btn-primary" onclick="sendMessage()">
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </div>
                </div>

            </div>

        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.socket.io/4.7.5/socket.io.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


    <script>
        let socket;
        let CURRENT_CHAT = null;
        let typingTimer;

        /* ================================================================
           1) SOCKET.IO
        ================================================================ */
        function initWS() {
            socket = io("https://khkt.itlhbs.io.vn", {
                path: "/api/ws",
                transports: ["websocket"],
                auth: {
                    token: getCookie("auth_token")
                }
            });

            socket.on("connect", () => {
                console.log("WS Connected");
                if (CURRENT_CHAT) joinRoom(CURRENT_CHAT);
            });

            socket.on("message", msg => {
                if (msg.chat_id === CURRENT_CHAT) {
                    appendMessage(msg);
                } else {
                    // Chat khác -> highlight và thông báo
                    highlightChatItem(msg.chat_id);

                    // Play sound
                    document.getElementById("newMessageSound").play();

                    // Thông báo trình duyệt
                    notifyNewMessage(msg);
                }
            });


            socket.on("typing", data => {
                if (data.chat_id !== CURRENT_CHAT) return;
                showTyping();
            });

            // Server trả về status + last_active_at mới
            socket.on("status_change", data => {
                const {
                    user_id,
                    status,
                    last_active_at
                } = data;

                const item = $(`.chat-item[data-uid="${user_id}"]`);
                if (item.length) {
                    const obj = item.data("userObj");
                    obj.status = status;
                    obj.last_active_at = last_active_at;
                    item.data("userObj", obj);
                    item.attr("data-status", status);
                }

                refreshChatOnlineStatus();
                updateHeaderStatus();
            });

            // ====================
            // WS nhận seen
            // ====================
            socket.on("message:seen", data => {
                const {
                    message_id,
                    seen_by_id
                } = data;

                const bubble = $(`.message-row[data-msg-id="${message_id}"] .message-bubble`);
                if (bubble.length && bubble.closest(".me").length) {
                    const statusSpan = bubble.find("span.text-muted");
                    if (statusSpan.length) {
                        statusSpan.text("✓✓").attr("title", "Đã xem");
                    } else {
                        bubble.append('<span class="text-muted ms-1" title="Đã xem">✓✓</span>');
                    }
                }
            });


            socket.on("message:react", reaction => {
                const msgRow = $(`.message-row[data-msg-id="${reaction.message_id}"] .message-reactions`);
                if (msgRow.length) {
                    // Append hoặc update số lượng
                    let existing = msgRow.find(`span[data-icon="${reaction.icon}"]`);
                    if (existing.length) {
                        existing.text(reaction.icon + (reaction.count > 1 ? reaction.count : ""));
                    } else {
                        msgRow.append(`<span class="reaction" data-message-id="${reaction.message_id}" data-icon="${reaction.icon}">${reaction.icon}</span>`);
                    }
                } else {
                    $(`.message-row[data-msg-id="${reaction.message_id}"] .message-content`).append(
                        `<div class="message-reactions mt-1"><span class="reaction" data-message-id="${reaction.message_id}" data-icon="${reaction.icon}">${reaction.icon}</span></div>`
                    );
                }
            });

            // Idle/Active
            let idleTimer;

            // Đánh dấu idle sau 5 giây không focus
            function setIdle() {
                socket.emit("user_idle");
            }

            function setActive() {
                socket.emit("user_active");
                clearTimeout(idleTimer);
                idleTimer = setTimeout(setIdle, 5000);
            }

            // Khi tab bị ẩn
            document.addEventListener("visibilitychange", () => {
                if (document.hidden) setIdle();
                else setActive();
            });

            // Khi chuyển sang cửa sổ khác
            window.addEventListener("blur", () => {
                setIdle();
            });

            // Khi quay lại cửa sổ
            window.addEventListener("focus", () => {
                setActive();
            });

        }

        /* ================================================================
           2) Render trạng thái online trong danh sách
        ================================================================ */
        function refreshChatOnlineStatus() {
            $(".chat-item").each(function() {
                const status = $(this).attr("data-status");
                const dot = $(this).find(".online-dot");

                dot.removeClass("idle-dot offline-dot").css("background", "#28a745");

                if (status === "idle") {
                    dot.addClass("idle-dot");
                } else if (status === "offline") {
                    dot.addClass("offline-dot");
                }
            });
        }

        /* ================================================================
           3) Typing
        ================================================================ */
        function showTyping() {
            $("#typingIndicator").show();
            clearTimeout(typingTimer);
            typingTimer = setTimeout(() => $("#typingIndicator").hide(), 1200);
        }
        $("#messageInput").on("input", () => {
            if (!CURRENT_CHAT) return;

            socket.emit("typing", {
                chat_id: CURRENT_CHAT
            });


        });


        /* ================================================================
           4) Load messages
        ================================================================ */
        function loadMessages(chatId) {
            $.ajax({
                url: `/api/chats/${chatId}/messages`,
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                },
                success: res => {
                    $("#messagesBox").html("");
                    res.data.forEach(appendMessage);

                    let box = document.getElementById("messagesBox");
                    box.scrollTop = box.scrollHeight;
                }
            });
        }

        $("#messageInput").on("keypress", function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
                sendMessage();
            }
        });


        /* ================================================================
           5) Open chat
        ================================================================ */
        function openChat(chatId, user) {
            CURRENT_CHAT = chatId;

            $("#chatTitle").text(user.username);

            $(".chat-item").removeClass("active");
            $(`.chat-item[data-id="${chatId}"]`).addClass("active");

            $("#messagesBox").html("");

            joinRoom(chatId);
            loadMessages(chatId);

            updateCurrentChatStatus(user.id, user.last_active_at, user.status);
        }

        function joinRoom(id) {
            socket.emit("join", {
                chat_id: id
            });
        }

        /* ================================================================
           6) Header status
        ================================================================ */
        function updateHeaderStatus() {
            if (!CURRENT_CHAT) return;

            const item = $(`.chat-item[data-id="${CURRENT_CHAT}"]`);
            const userObj = item.data("userObj");
            if (!userObj) return;

            updateCurrentChatStatus(userObj.id, userObj.last_active_at, userObj.status);
        }

        function updateCurrentChatStatus(userId, lastActiveAt, status) {
            if (status === "online") {
                $("#chatStatus").text("● 🟢 Trực tuyến").css("color", "green");
                return;
            }
            if (status === "idle") {
                $("#chatStatus").text("● 🌙 Chờ").css("color", "#f4c542");
                return;
            }
            $("#chatStatus").text(`● ⚫ Ngoại tuyến · ${timeAgo(lastActiveAt)}`).css("color", "gray");
        }

        /* ================================================================
           7) Send message
        ================================================================ */
        function sendMessage() {
            let text = $("#messageInput").val().trim();
            if (!text || !CURRENT_CHAT) return;

            $.ajax({
                url: `/api/chats/${CURRENT_CHAT}/messages`,
                method: "PUT",
                contentType: "application/json",
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                },
                data: JSON.stringify({
                    content: text
                }),
                success: () => {
                    $("#messageInput").val("");
                    // appendMessage({
                    //     sender_id: window.USER_ID,
                    //     content: text
                    // });

                    let box = document.getElementById("messagesBox");
                    box.scrollTop = box.scrollHeight;
                }
            });
        }

        /* ================================================================
           8) Load chat list
        ================================================================ */
        function loadChatList() {
            function getAvatarSource(u) {
                let src = ''

                if (u.avatar_file_id) {
                    src = `/api/media-proxy/avatars/${u.id}?size=120x120`

                } else {
                    // fallback ui-avatars
                    const name = encodeURIComponent(u.display_name || u.username || 'User');
                    src = `https://ui-avatars.com/api/?name=${name}&size=120&background=4e73df&color=fff`
                }
                return src

            }


            $.ajax({
                url: "/api/chats",
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                },
                success: res => {
                    $("#chatList").html("");

                    res.data.forEach(chat => {
                        const u = chat.users.find(x => x.id !== window.USER_ID);
                        const lastMsg = chat.messages?.[chat.messages.length - 1];

                        const unread = chat.unread_count && chat.unread_count > 0;

                        const lastMsgText = lastMsg?.content || lastMsg?.text || 'Chưa có tin nhắn';
                        const html = $(`
                        <div class="chat-item ${unread ? 'new-message' : ''}"
                            data-id="${chat.id}"
                            data-uid="${u.id}"
                            data-status="${u.status}">
                            <div class="position-relative">
                                <img class="avatar" src="${getAvatarSource(u)}">
                                <div class="online-dot"></div>
                            </div>
                            <div>
                                <strong>${u.username}</strong><br>
                                <small class="text-muted">${lastMsgText}</small>
                            </div>
                        </div>
                        `);

                        html.data("userObj", u);
                        html.on("click", () => openChat(chat.id, u));
                        $("#chatList").append(html);
                    });


                    refreshChatOnlineStatus();
                }
            });
        }

        /* ================================================================
           9) Utils
        ================================================================ */
        $(document).ready(() => {
            window.USER_ID = "<?php echo $user->id; ?>";
            initWS();
            loadChatList();
        });

        function getCookie(name) {
            const n = name + "=";
            return document.cookie.split(';').map(c => c.trim()).find(c => c.startsWith(n))?.substring(n.length) || "";
        }

        function timeAgo(date) {
            if (!date) return "Chưa từng hoạt động";
            let t = new Date(date);
            let diff = (new Date() - t) / 1000;

            if (diff < 60) return "Vừa hoạt động";
            if (diff < 3600) return Math.floor(diff / 60) + " phút trước";
            if (diff < 86400) return Math.floor(diff / 3600) + " giờ trước";
            if (diff < 172800) return "Hôm qua";
            return Math.floor(diff / 86400) + " ngày trước";
        }

        function formatTime(t) {
            if (!t) return "";
            let d = new Date(t);
            return d.toLocaleTimeString("vi-VN", {
                hour: "2-digit",
                minute: "2-digit"
            });
        }
        /* ================================================================
           10) Tạo chat mới + search user
        =============================================================== */
        let searchTimer;
        $(document).on("input", "#userSearchInput", function() {
            clearTimeout(searchTimer);
            const q = $(this).val().trim();
            if (!q) {
                $("#searchResults").empty();
                return;
            }

            searchTimer = setTimeout(() => {
                $.ajax({
                    url: `/api/users?search=${encodeURIComponent(q)}`,
                    headers: {
                        Authorization: "Bearer " + getCookie("auth_token")
                    },
                    success: res => {
                        $("#searchResults").empty();
                        if (!res.data || res.data.length === 0) {
                            $("#searchResults").append(`<li class="list-group-item">Không tìm thấy người dùng</li>`);
                            return;
                        }
                        res.data.forEach(user => {
                            const li = $(`
                        <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                            ${user.display_name || user.username} (${user.username})
                            <button class="btn btn-sm btn-primary">Chat</button>
                        </li>
                    `);
                            li.find("button").on("click", () => createChat(user.id));
                            $("#searchResults").append(li);
                        });
                    }
                });
            }, 300);
        });


        function createChat(userId) {
            $.ajax({
                url: `/api/chats`,
                method: "PUT",
                contentType: "application/json",
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                },
                data: JSON.stringify({
                    user_chat_to_id: userId
                }),
                success: res => {
                    // Đóng modal
                    const modal = bootstrap.Modal.getInstance(document.getElementById('newChatModal'));
                    modal.hide();

                    // Reload chat list và mở chat mới
                    loadChatList();
                    setTimeout(() => {
                        openChat(res.data.id, {
                            id: userId,
                            username: "Người dùng",
                            status: "online"
                        });
                    }, 500);
                }
            });
        }
    </script>
    <script>
        function highlightChatItem(chatId) {
            const item = $(`.chat-item[data-id="${chatId}"]`);
            if (!item.hasClass("active")) {
                item.addClass("new-message");
                setTimeout(() => item.removeClass("new-message"), 2000);
            }
        }

        function notifyNewMessage(msg) {
            if (document.hidden) { // chỉ hiển thị khi tab đang không active
                if (Notification.permission === "granted") {
                    new Notification(`Tin nhắn từ ${msg.sender?.username || 'Người dùng'}`, {
                        body: msg.content,
                        icon: "https://taphoammo.net/images/avatars/user.svg"
                    });
                } else if (Notification.permission !== "denied") {
                    Notification.requestPermission();
                }
            }
        }

        // ==================== 1) Đánh dấu seen khi load message / append ====================
        function markMessageSeen(messageId) {
            if (!CURRENT_CHAT) return;

            $.ajax({
                url: `/api/chats/${CURRENT_CHAT}/messages/${messageId}/seen`,
                method: "PUT",
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                }
            });
        }

        // ==================== 2) Append message với seen và reactions ====================
        // ==================== Append message với seen & reactions ====================
        let seenMessages = new Set();

        function appendMessage(msg) {
            const item = $(`.chat-item[data-id="${msg.chat_id}"]`);
            item.find("small").text(msg.content || 'Chưa có tin nhắn');

            const isMe = msg.sender_id == window.USER_ID;

            // ====================
            // Trạng thái seen
            // ====================
            let statusHtml = "";

            if (isMe) {
                // Nếu là tin nhắn của mình, hiển thị trạng thái
                if (msg.seens && msg.seens.length > 0) {
                    statusHtml = `<span class="text-muted ms-1" title="Đã xem">✓✓</span>`;
                } else {
                    statusHtml = `<span class="text-muted ms-1" title="Đã gửi">✓</span>`;
                }
            } else {
                // Tin nhắn người khác, không hiển thị ✓
                statusHtml = "";
            }

            // Tạo container reactions
            let reactionsHtml = "";
            if (msg.reactions && msg.reactions.length > 0) {
                reactionsHtml = `<div class="message-reactions mt-1">` +
                    msg.reactions.map(r => {
                        return `<span class="reaction" data-icon="${r.icon}" data-message-id="${msg.id}" title="${r.users?.map(u=>u.username).join(',') || ''}">${r.icon}${r.count > 1 ? r.count : ''}</span>`;
                    }).join(" ") +
                    `</div>`;
            }

            const html = `
    <div class="message-row ${isMe ? "me" : "other"}" data-msg-id="${msg.id}">
        ${!isMe ? `<img src="https://taphoammo.net/images/avatars/user.svg" class="message-avatar">` : ""}
        <div class="message-content">
            ${!isMe ? `<div class="message-name">${msg.sender?.username || msg.sender_name || "Người dùng"}</div>` : ""}
            <div class="message-bubble">
                ${msg.content} ${statusHtml}
            </div>
            <div class="message-time">${formatTime(msg.created_at)}</div>
            ${reactionsHtml}
        </div>
    </div>`;

            $("#messagesBox").append(html);

            // Auto scroll
            let box = document.getElementById("messagesBox");
            box.scrollTop = box.scrollHeight;

            // Chỉ gửi seen nếu tin nhắn là của người khác và chưa seen
            if (!isMe && !seenMessages.has(msg.id)) {
                markMessageSeen(msg.id);
                seenMessages.add(msg.id);
            }
            // Highlight chat sidebar nếu chat khác
            if (msg.chat_id !== CURRENT_CHAT) {
                const item = $(`.chat-item[data-id="${msg.chat_id}"]`);
                item.addClass("new-message");

                // Tự động cập nhật tin nhắn gần nhất
                item.find("small").text(msg.content);
            } else {
                // Đã mở chat -> đánh dấu đọc
                // markMessageSeen(msg.id);
                const item = $(`.chat-item[data-id="${msg.chat_id}"]`);
                item.removeClass("new-message");
            }

        }




        // ==================== Gửi reaction ====================
        $(document).on("click", ".reaction", function() {
            const messageId = $(this).data("message-id");
            const icon = $(this).data("icon");
            sendReaction(messageId, icon);
        });

        function sendReaction(messageId, icon) {
            if (!CURRENT_CHAT) return;
            $.ajax({
                url: `/api/chats/${CURRENT_CHAT}/messages/${messageId}/react`,
                method: "PUT",
                contentType: "application/json",
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                },
                data: JSON.stringify({
                    icon
                }),
            });
        }
        // Hiển thị picker khi click vào message-bubble
        $(document).on("click", ".message-bubble", function(e) {
            const bubble = $(this);
            const picker = $("#reactionPicker");

            // Lưu message id
            picker.data("message-id", bubble.closest(".message-row").data("msg-id"));

            // Vị trí picker ngay dưới bubble
            const offset = bubble.offset();
            picker.css({
                top: offset.top + bubble.outerHeight(),
                left: offset.left
            }).removeClass("d-none");
        });

        // Khi click vào icon reaction
        $(document).on("click", ".reaction-icon", function() {
            const icon = $(this).data("icon");
            const messageId = $("#reactionPicker").data("message-id");

            sendReaction(messageId, icon);

            $("#reactionPicker").addClass("d-none");
        });

        // Click ra ngoài để ẩn picker
        $(document).on("click", function(e) {
            if (!$(e.target).closest(".message-bubble, #reactionPicker").length) {
                $("#reactionPicker").addClass("d-none");
            }
        });

        // =============================
        //  XỬ LÝ TẠO CHAT TỰ ĐỘNG TỪ URL
        // =============================
        const url = new URL(window.location.href);
        const chatTo = url.searchParams.get("chat_to");
        const autoContent = url.searchParams.get("content");

        if (chatTo) {
            // 1) Kiểm tra xem đã có đoạn chat hay chưa
            $.ajax({
                url: "/api/chats",
                headers: {
                    Authorization: "Bearer " + getCookie("auth_token")
                },
                success: async res => {
                    let targetChat = res.data.find(c => c.users.some(u => u.id == chatTo));

                    if (!targetChat) {
                        // 2) Nếu chưa có -> tạo đoạn chat mới
                        const createRes = await $.ajax({
                            url: "/api/chats",
                            method: "POST",
                            contentType: "application/json",
                            headers: {
                                Authorization: "Bearer " + getCookie("auth_token")
                            },
                            data: JSON.stringify({
                                user_id: chatTo
                            })
                        });
                        targetChat = createRes.data;
                    }

                    // 3) Nếu có content -> gửi tin nhắn đầu tiên
                    if (autoContent) {
                        await $.ajax({
                            url: `/api/chats/${targetChat.id}/messages`,
                            method: "PUT",
                            contentType: "application/json",
                            headers: {
                                Authorization: "Bearer " + getCookie("auth_token")
                            },
                            data: JSON.stringify({
                                content: decodeURIComponent(autoContent)
                            })
                        });
                    }

                    // 4) Mở đoạn chat
                    loadChatList(); // refresh sidebar
                    setTimeout(() => {
                        const partner = targetChat.users.find(x => x.id != window.USER_ID);
                        openChat(targetChat.id, partner);
                    }, 300);
                }
            });
        }
    </script>


    <!-- Modal tạo chat mới -->
    <div class="modal fade" id="newChatModal" tabindex="-1" aria-labelledby="newChatModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="newChatModalLabel">Tạo cuộc hội thoại mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="text" id="userSearchInput" class="form-control" placeholder="Tìm kiếm người dùng...">
                    <ul class="list-group mt-2" id="searchResults"></ul>
                </div>
            </div>
        </div>
    </div>
    <!-- Reaction picker -->
    <div class="reaction-picker position-absolute bg-white border rounded shadow p-2 d-none" id="reactionPicker">
        <span class="reaction-icon" data-icon="👍">👍</span>
        <span class="reaction-icon" data-icon="❤️">❤️</span>
        <span class="reaction-icon" data-icon="😂">😂</span>
        <span class="reaction-icon" data-icon="😮">😮</span>
        <span class="reaction-icon" data-icon="😢">😢</span>
        <span class="reaction-icon" data-icon="👏">👏</span>
    </div>


    <!-- Nút mở modal -->
    <button class="btn btn-success position-fixed" style="bottom:20px; left:20px;" data-bs-toggle="modal" data-bs-target="#newChatModal">
        <i class="fa-solid fa-plus"></i> Chat mới
    </button>

</body>

</html>