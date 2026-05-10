<!DOCTYPE html>
<html lang="en">

<head>
    <?php include './partials/init.php'; ?>
</head>

<body id="page-top">

    <div id="wrapper">

        <?php include './partials/sidebar.php'; ?>

        <div id="content-wrapper" class="d-flex flex-column">
            <div id="content">

                <?php include './partials/header.php'; ?>

                <div class="container-fluid">

                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">📦 Đơn hàng</h1>
                    </div>

                    <!-- Orders Table -->
                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <table class="table table-bordered" id="ordersTable">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Số sản phẩm</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                            <div id="ordersEmpty" class="text-center text-muted d-none py-4">
                                Bạn chưa có đơn hàng nào
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <?php include './partials/footer.php'; ?>
        </div>

    </div>

    <!-- Order Detail Modal -->
    <div class="modal fade" id="orderDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết đơn hàng</h5>
                    <button class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>

                <div class="modal-body">
                    <div id="orderProducts"></div>
                    <hr>
                    <div class="text-right">
                        <strong>Tổng tiền: </strong>
                        <span id="orderTotalPrice">0 ₫</span>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-success" id="checkoutOrderBtn">
                        💳 Thanh toán
                    </button>

                    <button class="btn btn-danger d-none" id="cancelOrderBtn">
                        ❌ Hủy đơn hàng
                    </button>

                    <button class="btn btn-secondary" data-dismiss="modal">
                        Đóng
                    </button>
                </div>


            </div>
        </div>
    </div>

</body>

</html>
<script>
    $(document).on('click', '.order-row', function() {
        const orderId = $(this).data('id');
        showOrderDetail(orderId);
    });

    async function showOrderDetail(orderId) {
        const res = await fetch('/api/users/@me/orders', {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });
        const json = await res.json();
        if (json.code !== 200) return;

        const order = json.data.find(o => o.id === orderId);
        if (!order) return;
        if (order.status == 'pending') {
            $('#cancelOrderBtn').removeClass('d-none');
            // document.getElementById('checkoutOrderBtn').classList.remove('d-none')
        } else {
            $('#cancelOrderBtn').addClass('d-none');
            // document.getElementById('checkoutOrderBtn').classList.add('d-none')
        }


        const $list = $('#orderProducts');
        $list.empty();

        let total = 0;

        order.products.forEach(item => {
            console.log(item)
            const p = item.product;
            const price = p.price * item.amount;
            total += price;

            $list.append(`
            <div class="d-flex align-items-center mb-3">
                <div class="flex-grow-1">
                    <div class="fw-bold">${escapeHtml(p.name)}</div>
                    <div class="text-muted small">
                        ${p.price.toLocaleString()} ₫ × ${item.amount}
                    </div>
                </div>
                <strong>${price.toLocaleString()} ₫</strong>
            </div>
        `);
        });

        $('#orderTotalPrice').text(total.toLocaleString() + ' ₫');
        $('#orderDetailModal').modal('show');
    }
</script>

<script>
    let ordersCache = [];

    let currentOrderId = null;
    async function loadOrders() {
        const res = await fetch('/api/users/@me/orders', {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return;

        ordersCache = json.data;

        const $tbody = $('#ordersTable tbody');
        $tbody.empty();

        if (ordersCache.length === 0) {
            $('#ordersEmpty').removeClass('d-none');
            return;
        }

        $('#ordersEmpty').addClass('d-none');

        ordersCache.forEach(o => {
            console.log(o)
            $tbody.append(`
            <tr class="order-row" data-id="${o.id}" style="cursor:pointer">
                <td>${o.id}</td>
                <td>${o.products.length}</td>
                <td>${o.products.reduce((partialSum, a) => partialSum + parseInt(a.product.price) * parseInt(a.amount), 0).toLocaleString()} ₫</td>
                <td>
                    <span class="badge badge-${o.status === 'pending' ? 'warning' : o.status === 'cancelled' ? 'secondary' : 'success'}">
                        ${o.status}
                    </span>
                </td>
                <td>${new Date(o.created_at).toLocaleString()}</td>
                <td>
                <button class="btn btn-success" onclick="window.location.href = '/manage/order.php?id=${o.id}'">
                        Xem đơn
                    </button>
                </td>
            </tr>
        `);
        });
    }
    $(document).ready(loadOrders);

    function showOrderDetail(orderId) {
        currentOrderId = orderId;

        const order = ordersCache.find(o => o.id === orderId);
        if (!order) return;

        const $list = $('#orderProducts');
        $list.empty();

        let total = 0;

        order.products.forEach(item => {
            const p = item.product;
            const price = p.price * item.amount;
            total += price;

            $list.append(`
            <div class="d-flex justify-content-between mb-2">
                <div>
                    <strong>${escapeHtml(p.name)}</strong><br>
                    <small class="text-muted">
                        ${p.price.toLocaleString()} ₫ × ${item.amount}
                    </small>
                </div>
                <strong>${price.toLocaleString()} ₫</strong>
            </div>
        `);
        });

        $('#orderTotalPrice').text(total.toLocaleString() + ' ₫');

        // Hiện nút hủy nếu pending
        if (order.status === 'pending') {
            $('#cancelOrderBtn').removeClass('d-none');
        } else {
            $('#cancelOrderBtn').addClass('d-none');
        }

        $('#orderDetailModal').modal('show');
    }
</script>
<script>
    $('#cancelOrderBtn').on('click', async function() {
        if (!currentOrderId) return;

        if (!confirm('Bạn chắc chắn muốn hủy đơn hàng này?')) return;

        try {
            const res = await fetch(`/api/orders/${currentOrderId}`, {
                method: 'DELETE',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });

            const json = await res.json();

            if (json.code !== 200) {
                alert(json.msg || 'Hủy đơn thất bại');
                return;
            }

            alert('Đã hủy đơn hàng');

            $('#orderDetailModal').modal('hide');
            await loadOrders();

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });
</script>
<script>
    $('#checkoutOrderBtn').on('click', async function() {
        if (!currentOrderId) return;

        if (!confirm('Bạn muốn thanh toán đơn hàng này?')) return;

        try {
            const res = await fetch(`/api/orders/${currentOrderId}/checkout`, {
                method: 'POST',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token'),
                    'Content-Type': 'application/json'
                }
            });

            const json = await res.json();

            if (json.code !== 200) {
                alert(json.msg || 'Không thể thanh toán');
                return;
            }
            $('#orderDetailModal').modal('hide');

            await loadOrders();

        } catch (err) {
            console.error(err);
            alert('Có lỗi xảy ra khi thanh toán');
        }
    });
</script>