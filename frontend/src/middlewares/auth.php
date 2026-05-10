<?php
if (!$user) {
    // Lấy URL hiện tại (bao gồm query string)
    $currentUrl = $_SERVER['REQUEST_URI'];

    // Encode để tránh lỗi ký tự đặc biệt
    $next = urlencode($currentUrl);

    header("Location: /login.php?next={$next}&timestamp=" . time() . "#login-frompopup;loginwithgoogle");
    exit;
}