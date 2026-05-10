$(document).ready(async function () {
    initWS();
    const user = await initUser();


    if (user) {
        renderUser(user);
    } else {
        renderGuest();
    }
    loadUserAvatar(window.user, '40x40');
    handleAdminSidebar();

    socket.on("status_change", data => {
        const {
            user_id,
            status,
            last_active_at
        } = data;

        // Cập nhật list bên sidebar
        const item = $(`.chat-item[data-uid="${user_id}"]`);
        if (item.length) {
            const obj = item.data("userObj");
            obj.status = status;
            obj.last_active_at = last_active_at;
            item.data("userObj", obj);
            item.attr("data-status", status);
        }

        // Cập nhật trạng thái phần header chat
        // refreshChatOnlineStatus();
        // updateHeaderStatus();

        // ⭐ Cập nhật Message Center luôn
        updateMessageCenterStatus(user_id, status);
    });

    socket.on("message", msg => {
        if (msg.chat_id === CURRENT_CHAT) {
            appendMessage(msg); // chat đang mở
        } else {
            highlightChatItem(msg.chat_id);
            document.getElementById("newMessageSound").play();
            notifyNewMessage(msg);
        }

        // 🔥⚡ Cập nhật Message Center
        updateMessageCenterNewMessage(msg);
    });
    // Gọi khi mở dropdown
    document.getElementById("messagesDropdown").addEventListener("click", loadMessageCenter);
});

async function handleAdminSidebar() {
    try {
        if (Array.isArray(window.user.flags) && window.user.flags.includes('ADMIN')) {
            $('#admin-sidebar').removeClass('d-none');
        } else {
            $('#admin-sidebar').remove(); // xóa hẳn khỏi DOM
        }

    } catch (e) {
        console.error(e);
        $('#admin-sidebar').remove();
    }
}

function renderUser(user) {
    $('#user-name').text(user.name || user.username || 'User');

    if (user.avatar) {
        $('#user-avatar').attr('src', user.avatar);
    }

    $('#user-dropdown').show();
}
function renderGuest() {
    const overlay = document.getElementById('login-required-overlay');
    if (overlay) overlay.classList.remove('d-none');
}

function logout() {
    document.cookie = "auth_token=; path=/; max-age=0";
    window.location.href = '/login.php';
}

const SEARCH_ROUTE_MAP = {
    users: item => `/manage/user.php?id=${item.id}`,
    companies: item => `/manage/company.php?id=${item.id}`,
    places: item => `/manage/place.php?id=${item.id}`,
    products: item => `/manage/product.php?id=${item.id}`,
};

function debounce(fn, delay = 300) {
    let t;
    return (...args) => {
        clearTimeout(t);
        t = setTimeout(() => fn(...args), delay);
    };
}

async function superSearch(keyword) {
    if (!keyword) {
        $('#super-search-results').hide().empty();
        return;
    }

    try {
        const res = await fetch(`/api/search?q=${encodeURIComponent(keyword)}`, {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        if (res.status === 401) {
            renderGuest();
            return;
        }

        const json = await res.json();
        if (json.code !== 200) return;

        renderSearchResults(json.data);
    } catch (err) {
        console.error('Search error:', err);
    }
}

function renderSearchResults(data) {
    const $box = $('#super-search-results');
    $box.empty();

    const types = Object.keys(data).filter(t => data[t]?.length);
    if (!types.length) {
        $box.append(`
            <span class="dropdown-item text-muted small">
                No results found
            </span>
        `);
        $box.show();
        return;
    }

    types.forEach((type, idx) => {
        $box.append(`
            <h6 class="dropdown-header text-uppercase">
                ${type}
            </h6>
        `);

        data[type].forEach(item => {
            $box.append(`
                <a class="dropdown-item d-flex align-items-center search-item"
                   href="${SEARCH_ROUTE_MAP[type](item)}">
                    <div class="mr-3">
                        <i class="fas ${getSearchIcon(type)} text-gray-400"></i>
                    </div>
                    <div>
                        <div class="small text-gray-900">
                            ${getSearchTitle(type, item)}
                        </div>
                        <div class="small text-gray-500">
                            ${getSearchSub(type, item)}
                        </div>
                    </div>
                </a>
            `);
        });

        if (idx < types.length - 1) {
            $box.append(`<div class="dropdown-divider"></div>`);
        }
    });

    $box.show();
}


function getSearchTitle(type, item) {
    switch (type) {
        case 'users':
            return item.display_name || item.username || item.email;
        case 'companies':
            return item.name || item.short_name;
        case 'places':
            return item.name;
        case 'products':
            return item.name;
        default:
            return item.id;
    }
}

function getSearchSub(type, item) {
    switch (type) {
        case 'users':
            return item.email || item.id;
        case 'companies':
            return item.tax_id || item.address || item.id;
        case 'places':
            return item.address || item.id;
        case 'products':
            return item.description || item.id;
        default:
            return '';
    }
}


$(document).ready(function () {
    const onSearchInput = debounce(e => {
        superSearch(e.target.value.trim());
    }, 300);

    $('#super-search-input').on('input', onSearchInput);
});


$(document).on('click', function (e) {
    if (!$(e.target).closest('.navbar-search').length) {
        $('#super-search-results').hide();
    }
});


function showSearchLoading() {
    $('#super-search-results')
        .html(`<span class="dropdown-item text-muted small">Searching...</span>`)
        .show();
}

const onSearchInput = debounce(e => {
    const keyword = e.target.value.trim();
    if (keyword.length >= 2) {
        showSearchLoading();
    }
    superSearch(keyword);
}, 300);


function getSearchIcon(type) {
    switch (type) {
        case 'users': return 'fa-user';
        case 'companies': return 'fa-building';
        case 'places': return 'fa-map-marker-alt';
        case 'products': return 'fa-box';
        default: return 'fa-search';
    }
}
function updateMessageCenterNewMessage(msg) {
    const list = document.getElementById("messageCenterList");
    const meId = window.user.id;

    // Xác định người gửi (other user)
    const otherUser = msg.sender;
    const time = timeAgo(msg.created_at);

    const avatar = otherUser.avatar || "https://ui-avatars.com/api/?name=" + encodeURIComponent(otherUser.display_name);

    const statusColor =
        otherUser.status === "online" ? "bg-success" :
            otherUser.status === "idle" ? "bg-warning" :
                "bg-secondary";

    // Gỡ item cũ nếu có
    const oldItem = list.querySelector(`[data-chat-id="${msg.chat_id}"]`);
    if (oldItem) oldItem.remove();

    const html = `
        <a class="dropdown-item d-flex align-items-center new-msg" 
           href="/message.php?chat_to=${otherUser.id}"
           data-chat-id="${msg.chat_id}">
            
            <div class="dropdown-list-image me-3 position-relative">
                <img class="rounded-circle" src="${avatar}" width="60" height="60">
                <div class="status-indicator ${statusColor}"></div>
            </div>

            <div class="flex-grow-1">
                <div class="text-truncate fw-bold">${msg.content}</div>
                <div class="small text-gray-500">${otherUser.display_name} · ${time}</div>
            </div>
        </a>
    `;

    // Đặt lên đầu danh sách
    list.insertAdjacentHTML("afterbegin", html);

    // Update counter
    const messageCounter = document.getElementById("messageCounter");
    messageCounter.innerHTML = list.children.length;
}


async function loadMessageCenter() {
    const chats = window.user.chats;

    const list = document.getElementById("messageCenterList");
    const messageCounter = document.getElementById("messageCounter");
    messageCounter.innerHTML = chats.length;
    list.innerHTML = "";

    chats.forEach(chat => {
        const otherUser = chat.users.find(u => u.id !== window.user.id);

        const lastMsg = chat.messages?.[0];
        const time = lastMsg ? timeAgo(lastMsg.created_at) : "Chưa có tin nhắn";

        const statusColor =
            otherUser.status === "online" ? "bg-success" :
                otherUser.status === "idle" ? "bg-warning" :
                    "bg-secondary";

        const avatar = otherUser.avatar || "https://ui-avatars.com/api/?name=" + encodeURIComponent(otherUser.display_name);

        const html = `
    <a class="dropdown-item d-flex align-items-center user-status-item"
       data-uid="${otherUser.id}"
       href="/message.php?chat_to=${otherUser.id}">

        <div class="dropdown-list-image me-3 position-relative">
            <img class="rounded-circle" src="${avatar}" width="60" height="60">
            <div class="status-indicator ${statusColor}"></div>
        </div>

        <div class="flex-grow-1">
            <div class="text-truncate">${lastMsg ? lastMsg.content : "Chưa có tin nhắn"}</div>
            <div class="small text-gray-500">
                ${otherUser.display_name} · ${time}
            </div>
        </div>
    </a>
`;


        list.insertAdjacentHTML("beforeend", html);
    });
}

function updateMessageCenterStatus(user_id, status) {
    const items = document.querySelectorAll(`.user-status-item[data-uid="${user_id}"]`);

    items.forEach(el => {
        const indicator = el.querySelector(".status-indicator");

        indicator.classList.remove("bg-success", "bg-warning", "bg-secondary");

        if (status === "online") indicator.classList.add("bg-success");
        else if (status === "idle") indicator.classList.add("bg-warning");
        else indicator.classList.add("bg-secondary");
    });
}

function timeAgo(dateStr) {
    const seconds = (new Date() - new Date(dateStr)) / 1000;

    if (seconds < 60) return "vừa xong";
    if (seconds < 3600) return Math.floor(seconds / 60) + " phút";
    if (seconds < 86400) return Math.floor(seconds / 3600) + " giờ";
    return Math.floor(seconds / 86400) + " ngày";
}


function loadUserAvatar(user, size = '40x40') {
    const img = document.getElementById('user-avatar');
    if (!img || !user?.id) return;

    img.dataset.uid = user.id;
    img.src = `/api/media-proxy/avatars/${user.id}?size=${size}`;
}