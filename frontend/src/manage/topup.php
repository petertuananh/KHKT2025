<?php
$success    = $_GET['success']  ?? null;
$code       = $_GET['code']     ?? null;
$status     = $_GET['status']   ?? null;
$cancel     = $_GET['cancel']   ?? null;
$orderCode  = $_GET['orderCode'] ?? null;
$paymentId  = $_GET['id'] ?? null;

$isSuccess = (
    $success == '1' &&
    $code === '00' &&
    strtoupper($status) === 'PAID' &&
    $cancel === 'false'
);
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả nạp tiền</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
    >

    <style>
        body {
            background: #f8f9fc;
        }
        .result-box {
            max-width: 520px;
            margin: 80px auto;
        }
        .icon {
            font-size: 64px;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="card shadow result-box text-center">
        <div class="card-body p-4">

            <?php if ($isSuccess): ?>
                <div class="text-success icon mb-3">✅</div>
                <h4 class="text-success font-weight-bold mb-3">
                    Nạp tiền thành công
                </h4>
                <p class="text-muted">
                    Giao dịch của bạn đã được xử lý thành công.
                </p>
            <?php else: ?>
                <div class="text-danger icon mb-3">❌</div>
                <h4 class="text-danger font-weight-bold mb-3">
                    Thanh toán không thành công
                </h4>
                <p class="text-muted">
                    Giao dịch đã bị huỷ hoặc thất bại.
                </p>
            <?php endif; ?>

            <hr>

            <div class="text-left small">
                <p><strong>Mã đơn hàng:</strong> <?= htmlspecialchars($orderCode ?? '—') ?></p>
                <p><strong>Mã giao dịch:</strong> <?= htmlspecialchars($paymentId ?? '—') ?></p>
                <p><strong>Trạng thái:</strong>
                    <?php if ($isSuccess): ?>
                        <span class="text-success font-weight-bold">PAID</span>
                    <?php else: ?>
                        <span class="text-danger font-weight-bold">
                            <?= htmlspecialchars($status ?? 'FAILED') ?>
                        </span>
                    <?php endif; ?>
                </p>
                <p><strong>Mã phản hồi:</strong> <?= htmlspecialchars($code ?? '—') ?></p>
            </div>

            <hr>

            <button class="btn btn-primary btn-lg btn-block mt-3" onclick="closeWindow()">
                Đóng cửa sổ
            </button>

        </div>
    </div>
</div>

<script>
function closeWindow() {
    // Nếu là popup
    window.close();

    // fallback nếu browser không cho close
    setTimeout(() => {
        window.location.href = '/manage/wallet.php';
    }, 300);
}
</script>

</body>
</html>
