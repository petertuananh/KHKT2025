<!DOCTYPE html>
<html lang="vi">
<head>
    <?php include '../partials/init.php'; ?>
</head>

<body id="page-top">
<div id="wrapper">

    <?php include '../partials/sidebar.php'; ?>

    <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">

            <?php include '../partials/header.php'; ?>

            <div class="container-fluid">

                <!-- TITLE -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">📦 Quản lý đơn hàng</h1>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-body">

                        <!-- SEARCH -->
                        <div class="row mb-3 align-items-center">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <input type="text"
                                           id="orderSearch"
                                           class="form-control"
                                           placeholder="Tìm đơn hàng (ID, tên người dùng...)">
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="fas fa-search"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6 text-right">
                                <small class="text-muted">
                                    Hiển thị <span id="countShown">0</span> /
                                    <span id="countTotal">0</span>
                                </small>
                            </div>
                        </div>

                        <!-- TABLE -->
                        <table class="table table-bordered table-hover">
                            <thead class="thead-light">
                            <tr>
                                <th>ID đơn</th>
                                <th>Người đặt</th>
                                <th>Sản phẩm</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thời gian</th>
                                <th width="220">Hành động</th>
                            </tr>
                            </thead>
                            <tbody id="ordersTable"></tbody>
                        </table>

                    </div>
                </div>

            </div>
        </div>

        <?php include '../partials/footer.php'; ?>
    </div>
</div>

<script>
let orders = []

/* ================= LOAD ORDERS ================= */
async function loadOrders() {
    const res = await fetch('/api/orders', {
        headers: {
            'Authorization': 'Bearer ' + getCookie('auth_token')
        }
    })

    const json = await res.json()
    if (json.code !== 200) return alert('Không tải được đơn hàng')

    orders = json.data
    document.getElementById('countTotal').innerText = orders.length
    renderOrders(orders)
}

/* ================= RENDER ================= */
function renderOrders(list) {
    const tbody = document.getElementById('ordersTable')
    tbody.innerHTML = ''

    list.forEach(o => {
        const total = calcTotal(o)
        tbody.innerHTML += `
        <tr>
            <td class="text-monospace small">${o.id}</td>

            <td>
                👤 ${o.user.display_name}<br>
                <small class="text-muted">${o.user.email}</small>
            </td>

            <td>
                ${o.products.map(p =>
                    `• ${p.product.name} × ${p.amount} ${p.product.unit_type}`
                ).join('<br>')}
            </td>

            <td class="font-weight-bold text-success">
                ${total.toLocaleString()} ₫
            </td>

            <td>${renderStatus(o.status)}</td>

            <td>
                ${new Date(o.created_at).toLocaleString()}
            </td>

            <td>
                <a href="/manage/order.php?id=${o.id}"
                   class="btn btn-sm btn-outline-primary mb-1">
                    🔍 Xem chi tiết
                </a>

                ${renderCancelButton(o)}
            </td>
        </tr>
        `
    })

    document.getElementById('countShown').innerText = list.length
}

/* ================= HELPERS ================= */
function calcTotal(order) {
    return order.products.reduce((sum, p) => {
        return sum + p.amount * p.product.price
    }, 0)
}

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

function renderCancelButton(order) {
    if (order.status !== 'pending') return ''

    return `
    <button class="btn btn-sm btn-danger"
            onclick="cancelOrder('${order.id}')">
        ❌ Hủy đơn
    </button>`
}

/* ================= CANCEL ================= */
async function cancelOrder(id) {
    if (!confirm('ADMIN xác nhận hủy đơn hàng này?')) return

    const res = await fetch(`/api/orders/${id}`, {
        method: 'DELETE',
        headers: {
            'Authorization': 'Bearer ' + getCookie('auth_token')
        }
    })

    const json = await res.json()
    if (json.code !== 200) {
        return alert(json.msg || 'Không thể hủy đơn')
    }

    alert('✅ Đã hủy đơn hàng')
    loadOrders()
}

/* ================= SEARCH ================= */
document.getElementById('orderSearch').addEventListener('input', e => {
    const q = e.target.value.toLowerCase()

    const filtered = orders.filter(o =>
        o.id.toLowerCase().includes(q) ||
        o.user.display_name.toLowerCase().includes(q) ||
        o.user.email.toLowerCase().includes(q)
    )

    renderOrders(filtered)
})

/* ================= INIT ================= */
loadOrders()
</script>

</body>
</html>
