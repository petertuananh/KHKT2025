<!DOCTYPE html>
<html lang="vi">

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

                    <!-- PAGE HEADING -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">
                            📦 Chi tiết đơn hàng
                        </h1>

                        <div>
                            <button id="cancelOrderBtn"
                                class="btn btn-sm btn-danger d-none">
                                ❌ Hủy đơn hàng
                            </button>
                            <button class="btn btn-sm btn-success d-none" id="checkoutOrderBtn">
                                💳 Thanh toán
                            </button>
                        </div>

                        <button id="exportPdfBtn"
                            class="btn btn-sm btn-outline-success">
                            📄 Xuất hóa đơn PDF
                        </button>

                    </div>

                    <!-- ORDER INFO -->
                    <div class="card shadow mb-4">
                        <div class="card-body">

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <strong>Mã đơn:</strong>
                                    <span id="orderId" class="text-monospace"></span>
                                </div>
                                <div class="col-md-6 text-right">
                                    <span id="orderStatus"></span>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <strong>Người đặt:</strong>
                                    <div id="orderUser"></div>
                                </div>
                                <div class="col-md-6">
                                    <strong>Thời gian tạo:</strong>
                                    <div id="orderCreated"></div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- PRODUCTS -->
                    <div class="card shadow mb-4">
                        <div class="card-header">
                            <h6 class="m-0 font-weight-bold text-primary">
                                🧾 Danh sách sản phẩm
                            </h6>
                        </div>
                        <div class="card-body">

                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody id="productsTable"></tbody>
                            </table>

                            <div class="text-right mt-3">
                                <h5>
                                    Tổng tiền:
                                    <span class="text-success font-weight-bold"
                                        id="orderTotal">0 ₫</span>
                                </h5>
                            </div>

                        </div>
                    </div>

                    <!-- TRANSACTIONS -->
                    <div class="card shadow mb-4">
                        <div class="card-header">
                            <h6 class="m-0 font-weight-bold text-primary">
                                💸 Giao dịch thanh toán
                            </h6>
                        </div>
                        <div class="card-body">

                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Đối tượng nhận</th>
                                        <th>Số tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thời gian</th>
                                    </tr>
                                </thead>
                                <tbody id="transactionsTable"></tbody>
                            </table>

                        </div>
                    </div>

                </div>
            </div>

            <?php include './partials/footer.php'; ?>
        </div>
    </div>

    <script>
        const params = new URLSearchParams(window.location.search)
        const orderId = params.get('id')

        if (!orderId) {
            alert('Thiếu ID đơn hàng')
        }

        /* ================= LOAD ORDER ================= */
        async function loadOrder() {
            const res = await fetch(`/api/orders/${orderId}`, {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            })

            const json = await res.json()
            if (json.code !== 200) {
                alert(json.msg || 'Không tải được đơn hàng')
                return
            }

            renderOrder(json.data)
        }

        /* ================= RENDER ================= */
        function renderOrder(order) {
            document.getElementById('orderId').innerText = order.id
            document.getElementById('orderCreated').innerText =
                new Date(order.created_at).toLocaleString()

            document.getElementById('orderUser').innerHTML = `
    👤 <strong>${escapeHtml(order.user.display_name)}</strong><br>
    <small>${order.user.email}</small><br>
    <a href="/manage/user.php?id=${order.user.id}"
       class="btn btn-sm btn-outline-primary mt-1">
        Xem profile
    </a>
`


            document.getElementById('orderStatus').innerHTML = renderStatus(order.status)

            /* PRODUCTS */
            let total = 0
            const pBody = document.getElementById('productsTable')
            pBody.innerHTML = ''

            order.products.forEach(i => {
                const price = i.product.price * i.amount
                total += price

                pBody.innerHTML += `
        <tr>
            <td>${escapeHtml(i.product.name)}</td>
            <td>${i.product.price.toLocaleString()} ₫</td>
            <td>${i.amount} ${i.product.unit_type}</td>
            <td class="font-weight-bold">
                ${price.toLocaleString()} ₫
            </td>
        </tr>
        `
            })

            document.getElementById('orderTotal').innerText =
                total.toLocaleString() + ' ₫'

            /* TRANSACTIONS */
            const tBody = document.getElementById('transactionsTable')
            tBody.innerHTML = ''

            order.user_transactions.forEach(t => {

                let receiverHtml = ''
                if (t.to_company_id) {
                    receiverHtml = `
            🏢 Công ty ${t.to_company.name}<br>
            <a href="/manage/company.php?id=${t.to_company_id}"
               class="btn btn-sm btn-outline-info mt-1">
                Xem công ty
            </a>
        `
                } else if (t.to_user_id) {
                    receiverHtml = `
            👤 Người dùng ${t.to_user.display_name || t.to_user.username}<br>
            <a href="/manage/user.php?id=${t.to_user_id}"
               class="btn btn-sm btn-outline-primary mt-1">
                Xem profile
            </a>
        `
                }

                tBody.innerHTML += `
    <tr>
        <td class="text-monospace small">${t.id}</td>
        <td>${receiverHtml}</td>
        <td>${Number(t.amount).toLocaleString()} ₫</td>
        <td>
            <span class="badge badge-success">
                ${t.status}
            </span>
        </td>
        <td>${new Date(t.created_at).toLocaleString()}</td>
    </tr>
    `
            })


            /* CANCEL BUTTON */
            if (order.status === 'pending') {
                document.getElementById('cancelOrderBtn').classList.remove('d-none')
                document.getElementById('checkoutOrderBtn').classList.remove('d-none')

            }
        }

        /* ================= CANCEL ================= */
        document.getElementById('cancelOrderBtn').onclick = async () => {
            if (!confirm('Bạn chắc chắn muốn hủy đơn hàng này?')) return

            const res = await fetch(`/api/orders/${orderId}`, {
                method: 'DELETE',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            })

            const json = await res.json()
            if (json.code !== 200) {
                alert(json.msg || 'Không thể hủy đơn')
                return
            }

            alert('✅ Đã hủy đơn hàng')
            loadOrder()
        }

        /* ================= STATUS ================= */
        function renderStatus(status) {
            const map = {
                pending: 'warning',
                paid: 'success',
                cancelled: 'secondary'
            }
            return `<span class="badge badge-${map[status] || 'dark'}">
        ${status.toUpperCase()}
    </span>`
        }

        loadOrder()
        document.getElementById('exportPdfBtn').onclick = () => {
            window.open(
                `/api/orders/${orderId}/invoice.pdf?token=${getCookie('auth_token')}`,
                '_blank'
            )
        }
        $('#checkoutOrderBtn').on('click', async function() {

            if (!confirm('Bạn muốn thanh toán đơn hàng này?')) return;

            try {
                const res = await fetch(`/api/orders/${orderId}/checkout`, {
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
                loadOrder()
                document.getElementById('cancelOrderBtn').classList.add('d-none')
                document.getElementById('checkoutOrderBtn').classList.add('d-none')
            } catch (err) {
                console.error(err);
                alert('Có lỗi xảy ra khi thanh toán');
            }
        });
    </script>

</body>

</html>