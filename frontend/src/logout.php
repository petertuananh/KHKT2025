<?php
// Khởi động session
session_start();

// Xóa toàn bộ session
$_SESSION = [];
session_unset();
session_destroy();

// Xóa token trong cookie nếu có
if (isset($_COOKIE['token'])) {
    setcookie('token', '', time() - 3600, '/');
}

// Xóa token trong local storage (nếu bạn dùng JS ở front-end)
// Không thể xóa bằng PHP nhưng có thể redirect qua trang trung gian

// Redirect về login
header("Location: /login.php");
exit;