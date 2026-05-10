/*!
* Start Bootstrap - Shop Homepage v5.0.6 (https://startbootstrap.com/template/shop-homepage)
* Copyright 2013-2023 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-shop-homepage/blob/master/LICENSE)
*/

// This file is intentionally blank
// Use this file to add JavaScript to your project


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
$(document).ready(async function () {
    initWS();
    const user = await initUser();

    if (user) {
        renderUser(user);
    } else {
        renderGuest();
    }
});

function renderUser(user) {
    $('#auth-area').html(`
        <div class="dropdown">
            <button class="btn btn-outline-dark dropdown-toggle" type="button"
                data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle me-1"></i>
                ${user.name || user.username || 'User'}
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li>
                    <a class="dropdown-item" href="/manage/user.php">
                        <i class="bi bi-person me-1"></i> Profile
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="/manage">
                        <i class="bi bi-gear me-1"></i> Quản lý
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="/manage/orders.php">
                        <i class="bi bi-bag me-1"></i> Orders
                    </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <button class="dropdown-item text-danger" onclick="logout()">
                        <i class="bi bi-box-arrow-right me-1"></i> Logout
                    </button>
                </li>
            </ul>
        </div>
    `);
}
function renderGuest() {
    $('#auth-area').html(`
        <a href="#" onclick="openLoginPopup(true, true)" class="btn btn-outline-primary me-2">Đăng nhập</a>
    `);
}
function logout() {
    document.cookie = "auth_token=; path=/; max-age=0";
    location.reload();
}