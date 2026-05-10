<?php
require_once './init.php';

/**
 * ====================================================
 * 1. LẤY & VALIDATE INPUT
 * ====================================================
 */
$token = $_GET['token'] ?? null;
$next  = $_GET['next']  ?? '/';
$isRedirectAfterLogin = isset($_GET['isRedirectAfterLogin']) ? $_GET['isRedirectAfterLogin'] : null;
$isCloseAfterLogin = isset($_GET['isCloseAfterLogin']) ? $_GET['isCloseAfterLogin'] : null;
// chống open redirect
if (!str_starts_with($next, '/')) {
    $next = '/';
}

if (!$token) {
    showError('Không tìm thấy mã token đăng nhập!');
    exit;
}

/**
 * ====================================================
 * 2. GỌI API LẤY USER
 * ====================================================
 */
$response = fetchUser($API_BASE . '/users/@me', $token);

if (!$response || !isset($response['data']['id'])) {
    showError('Token không hợp lệ hoặc phiên đăng nhập đã hết hạn.');
    exit;
}

$user = $response['data'];

/**
 * ====================================================
 * 3. LOGIN THÀNH CÔNG → LƯU SESSION + COOKIE
 * ====================================================
 */
$_SESSION['user'] = $user;

setcookie('auth_token', $token, [
    'expires'  => time() + 86400,
    'path'     => '/',
    'secure'   => true,
    'httponly' => false, // JS cần đọc
    'samesite' => 'Lax'
]);
?>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Đăng nhập thành công</title>
</head>

<body>
    <script>
        (function() {
            // Báo cho trang cha
            if (window.opener) {
                window.opener.postMessage({
                    type: 'LOGIN_SUCCESS',
                    next: <?= json_encode($next) ?>,
                    token: <?= json_encode($token) ?>,
                    isRedirectAfterLogin: <?= json_encode($isRedirectAfterLogin) ?>,
                    isCloseAfterLogin: <?= json_encode($isCloseAfterLogin) ?>
                }, window.location.origin);
            }

            // Đóng popup
            window.close();

            // Fallback nếu bị chặn
            setTimeout(() => {
                window.location.href = <?= json_encode($next) ?>;
            }, 500);
        })();
    </script>
</body>

</html>

<?php
/**
 * ====================================================
 * HÀM CALL API
 * ====================================================
 */
function fetchUser(string $url, string $token): ?array
{
    $ch = curl_init($url);

    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => [
            "Authorization: Bearer {$token}",
            "Accept: application/json"
        ]
    ]);

    $response = curl_exec($ch);
    $status   = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    curl_close($ch);

    if ($status !== 200 || !$response) {
        return null;
    }

    return json_decode($response, true);
}

/**
 * ====================================================
 * HÀM HIỂN THỊ LỖI
 * ====================================================
 */
function showError(string $msg): void
{
    global $API_BASE;
?>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Lỗi đăng nhập</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow-sm border-0">
                        <div class="card-body text-center">
                            <h4 class="text-danger mb-3">Đăng nhập thất bại</h4>
                            <p class="text-muted"><?= htmlspecialchars($msg) ?></p>
                            <a href="<?= $API_BASE ?>/auth/login" class="btn btn-primary">
                                Đăng nhập lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>
<?php
}
