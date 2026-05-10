<?php
require '../config.php';
require 'jwt.php';


function res($code, $msg) {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'code' => $code,
        'msg'  => $msg
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

$token = $_GET['key'] ?? '';
if (!$token) {
    res(400, 'Thiếu token download');
}

$data = jwt_decode($token, JWT_SECRET);
if (!$data || ($data['exp'] ?? 0) < time()) {
    res(403, 'Link tải đã hết hạn hoặc không hợp lệ');
}

$file = basename($data['file'] ?? '');
if (!$file) {
    res(400, 'Tên file không hợp lệ');
}

$path = STORAGE_PATH . $file;
if (!file_exists($path)) {
    res(404, 'File không tồn tại');
}

/**
 * ====== DETECT MIME TYPE ======
 */
$mime = mime_content_type($path);

/**
 * ====== MIME CÓ THỂ SHOW TRONG BROWSER ======
 */
$inlineMimes = [
    'image/',
    'video/',
    'audio/',
    'text/',
    'application/pdf'
];

$inline = false;
foreach ($inlineMimes as $type) {
    if (str_starts_with($mime, $type)) {
        $inline = true;
        break;
    }
}

/**
 * ====== STREAM FILE ======
 */
header('Content-Type: ' . $mime);
header('Content-Length: ' . filesize($path));
header('Cache-Control: public, max-age=3600');

if ($inline) {
    // 👉 xem trực tiếp
    header('Content-Disposition: inline; filename="' . $file . '"');
} else {
    // 👉 tải về
    header('Content-Disposition: attachment; filename="' . $file . '"');
}

readfile($path);
exit;