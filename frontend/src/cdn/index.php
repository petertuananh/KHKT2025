<?php
require '../config.php';
require 'jwt.php';
$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? "https://" : "http://";
$host = $_SERVER['HTTP_HOST'];

$server_url = 'https://' . $host;
header('Content-Type: application/json; charset=utf-8');
mb_internal_encoding("UTF-8");

// helper response
function res($code, $msg, $data = null)
{
    http_response_code($code);
    echo json_encode([
        'code' => $code,
        'msg'  => $msg,
        'data' => $data
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

// auth
$headers = getallheaders();
if (($headers['Authorization'] ?? '') !== CDN_PASSWORD) {
    res(401, 'Unauthorized – Sai mật khẩu');
}

$action = $_GET['action'] ?? '';

if (!is_dir(STORAGE_PATH)) {
    res(500, 'Thư mục lưu trữ không tồn tại');
}

switch ($action) {

    // 📤 UPLOAD
    case 'upload':
        if (!isset($_FILES['file'])) {
            res(400, 'Không tìm thấy file upload');
        }

        // Giữ nguyên tên tiếng Việt, không bị lỗi encoding
        $rawName = $_FILES['file']['name'];

        // Làm sạch name (không dùng basename)
        $name = pathinfo($rawName, PATHINFO_BASENAME);

        // Hoặc nếu muốn lọc ký tự lạ:
        // $name = preg_replace('/[^\p{L}\p{N}\._ -]/u', '', $rawName);

        if (!move_uploaded_file($_FILES['file']['tmp_name'], STORAGE_PATH . $name)) {
            res(500, 'Upload file thất bại');
        }

        res(200, 'Upload thành công', [
            'filename' => $name
        ]);
        break;

    // 📥 LẤY LINK DOWNLOAD
    case 'download':
        $file = basename($_GET['filename'] ?? '');
        if (!$file || !file_exists(STORAGE_PATH . $file)) {
            res(404, 'File không tồn tại');
        }

        $payload = [
            'file' => $file,
            'exp'  => time() + 3600
        ];

        $token = jwt_encode($payload, JWT_SECRET);

        res(200, 'Tạo link download thành công', [
            'url' => "$server_url/cdn/download.php?key=$token",
            'expires_in' => '1 giờ'
        ]);
        break;

    // 🗑️ XOÁ FILE
    case 'remove':
        $file = basename($_POST['filename'] ?? '');
        if (!$file || !file_exists(STORAGE_PATH . $file)) {
            res(404, 'File không tồn tại');
        }

        unlink(STORAGE_PATH . $file);
        res(200, 'Xoá file thành công', [
            'filename' => $file
        ]);
        break;

    // ✏️ ĐỔI TÊN FILE
    case 'rename':
        $body = json_decode(file_get_contents("php://input"), true);

        $old = $body['old'] ?? null;
        $new = $body['new'] ?? null;

        if (!$old || !$new) {
            res(400, 'Thiếu tên file');
        }

        if (!file_exists(STORAGE_PATH . $old)) {
            res(404, 'File gốc không tồn tại');
        }

        rename(STORAGE_PATH . $old, STORAGE_PATH . $new);
        res(200, 'Đổi tên file thành công', [
            'old' => $old,
            'new' => $new
        ]);
        break;

    // 📂 DANH SÁCH FILE
    case 'list':
        $files = array_values(array_filter(scandir(STORAGE_PATH), function ($f) {
            return !in_array($f, ['.', '..']) && is_file(STORAGE_PATH . $f);
        }));

        res(200, 'Lấy danh sách file thành công', [
            'total' => count($files),
            'files' => $files
        ]);
        break;

    default:
        res(400, 'Action không hợp lệ');
}
