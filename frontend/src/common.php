<script>
    let user = null;
    let socket;



    /* ================================================================
       1) SOCKET.IO
    ================================================================ */
    function initWS() {
        socket = io(`https://${window.location.host}`, {
            path: "/api/ws",
            transports: ["websocket"],
            auth: {
                token: getCookie("auth_token")
            }
        });

        socket.on("connect", () => {
            console.log("WS Connected");
        });
        socket.on("disconnect", () => {
            console.log("WS Disconnected");
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

    function getCookie(cname) {
        const name = cname + "=";
        const decodedCookie = decodeURIComponent(document.cookie);
        const ca = decodedCookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) === ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) === 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }

    function setCookie(name, value, days) {
        var expires = "";
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "") + expires + "; path=/";
    }



    async function initUser() {
        return new Promise((resolve) => {
            $.ajax({
                url: '/api/users/@me',
                method: 'GET',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                },
                success: function(res) {
                    if (res.code === 200) {
                        window.user = res.data;
                        user = res.data;
                        resolve(res.data);
                    } else {
                        resolve(null);
                    }
                },
                error: function() {
                    resolve(null);
                }
            });
        });
    }

    function waitForUser(timeout = 5000) {
        return new Promise((resolve, reject) => {
            const start = Date.now();

            const check = () => {
                if (window.user && window.user.id) {
                    resolve(window.user);
                } else if (Date.now() - start > timeout) {
                    reject(new Error('User not loaded'));
                } else {
                    setTimeout(check, 50);
                }
            };

            check();
        });
    }

    function getQuery(name) {
        return new URLSearchParams(window.location.search).get(name);
    }

    function escapeHtml(text) {
        if (!text) return '';
        return text.replace(/[&<>"']/g, m => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        } [m]));
    }

    function renderUserBadges(flags) {
        if (!flags) return '';

        const list = Array.isArray(flags) ? flags : [flags];

        const map = {
            ADMIN: '/img/70776-admin.png',
            VERIFIED: '/img/191911-verified.png',
            BOT: '/img/876414-bot.png',
            BANNED: '/579518-ban.png'
        };

        return list
            .filter(f => map[f])
            .map(f => `
            <img src="${map[f]}"
                 title="${f}"
                 class="ms-1"
                 style="width:18px;height:18px">
        `)
            .join('');
    }

    function debounce(fn, delay = 600) {
        let t;
        return (...args) => {
            clearTimeout(t);
            t = setTimeout(() => fn(...args), delay);
        };
    }
    async function addProductToCart(productId, amount = 1) {
        const res = await fetch('/api/users/@me/cart', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                product_id: productId,
                amount
            })
        });

        const json = await res.json();
        if (json.code !== 200) {
            alert(json.msg || 'Không thể thêm vào giỏ hàng');
            return false;
        }

        // reload user + cart
        await initUser();
        return true;
    }

    async function loadCart() {
        await initUser();
        if (!window.user) return [];

        return window.user.carts || [];
    }

    async function removeProductFromCart(cartItemId) {
        const res = await fetch(`/api/users/@me/cart/${cartItemId}`, {
            method: 'DELETE',
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) {
            alert(json.msg || 'Không thể xóa sản phẩm');
            return false;
        }

        await initUser();
        return true;
    }

    async function editCartItemQuantity(cartItemId, amount) {
        if (amount <= 0) {
            alert('Số lượng không hợp lệ');
            return false;
        }

        const res = await fetch(`/api/users/@me/cart/${cartItemId}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                amount
            })
        });

        const json = await res.json();
        if (json.code !== 200) {
            alert(json.msg || 'Không thể cập nhật số lượng');
            return false;
        }

        await initUser();
        return true;
    }

    function formatType(type) {
        const map = {
            topup: 'Nạp tiền',
            withdraw: 'Rút tiền',
            transfer: 'Chuyển/nhận tiền',
            payment: 'Thanh toán đơn hàng',
            income: 'Thanh toán đơn hàng'
        }
        return map[type] || type
    }

    function formatStatus(status) {
        const map = {
            finished: '<span class="badge badge-success">Thành công</span>',
            pending: '<span class="badge badge-warning">Đang xử lý</span>',
            cancelled: '<span class="badge badge-danger">Đã hủy</span>',
        }
        return map[status] || status
    }
    document.querySelectorAll('[data-require-login]').forEach(btn => {
        btn.addEventListener('click', e => {
            if (!window.user) {
                e.preventDefault();
                renderGuest();
            }
        });
    });

    function openLoginPopup(isRedirectAfterLogin, isCloseAfterLogin) {
        const width = 420;
        const height = 520;

        const left = (screen.width - width) / 2;
        const top = (screen.height - height) / 2;

        const loginWindow = window.open(
            `/login.php?next=${encodeURIComponent(
            window.location.pathname + window.location.search
        )}&isRedirectAfterLogin=${isRedirectAfterLogin}&isCloseAfterLogin=${isCloseAfterLogin}`,
            'Đăng nhập vào hệ thống',
            `width=${width},height=${height},top=${top},left=${left},resizable=no`
        );

        // Lắng nghe popup gửi tín hiệu
        window.addEventListener('message', async (event) => {
            const overlay = document.getElementById('login-required-overlay');
            // Chỉ nhận từ cùng origin
            if (event.origin !== window.location.origin) return;



            if (event.data?.type === 'LOGIN_SUCCESS') {
                setCookie("auth_token", event.data.token, 7);
                if (event.data.next && event.data.isRedirectAfterLogin) {
                    window.location.href = event.data.next;
                } else {
                    await initUser();
                    if (overlay) overlay.classList.add('d-none');
                    window.location.reload();

                }
            }
        });
    }
</script>
<!-- LOGIN REQUIRED OVERLAY -->
<div id="login-required-overlay" class="login-overlay d-none">
    <div class="login-box text-center">
        <div class="spinner-border text-primary mb-3" role="status"></div>

        <h5 class="mb-2">Bạn chưa đăng nhập</h5>
        <p class="text-muted mb-4">
            Vui lòng đăng nhập để tiếp tục sử dụng chức năng này
        </p>

        <a id="login-btn" onclick="openLoginPopup(false, true)" href="#" class="btn btn-primary px-4">
            🔐 Đăng nhập
        </a>
    </div>
</div>

<style>
    .login-overlay {
        position: fixed;
        inset: 0;
        background: rgba(255, 255, 255, 0.9);
        z-index: 9999;

        display: flex;
        align-items: center;
        justify-content: center;
    }

    .login-box {
        background: #fff;
        border-radius: 12px;
        padding: 32px 36px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, .1);
        max-width: 360px;
        width: 100%;
    }
</style>