<!DOCTYPE html>
<html lang="en">

<head>
    <?php include './partials/init.php'; ?>
</head>

<body id="page-top">

    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <?php include './partials/sidebar.php'; ?>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <?php include './partials/header.php'; ?>

                <!-- End of Topbar -->

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <div class="row">

                        <!-- WALLET INFO -->
                        <div class="col-lg-5 mb-4">
                            <div class="card shadow h-100">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        💼 Ví của tôi
                                    </h6>
                                </div>
                                <div class="card-body text-center">
                                    <div class="text-muted mb-2">Số dư hiện tại</div>

                                    <h2 class="font-weight-bold text-success" id="wallet-balance">
                                        -- ₫
                                    </h2>

                                    <hr>

                                    <small class="text-muted">
                                        Số dư dùng để thanh toán dịch vụ trong hệ thống
                                    </small>
                                </div>
                            </div>
                        </div>

                        <!-- TOPUP -->
                        <div class="col-lg-7 mb-4">
                            <div class="card shadow h-100">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        💳 Nạp tiền vào ví
                                    </h6>
                                </div>
                                <div class="card-body">

                                    <!-- QUICK AMOUNT -->
                                    <div class="mb-3">
                                        <label class="font-weight-bold mb-2">Chọn nhanh</label>
                                        <div class="d-flex flex-wrap gap-2">
                                            <button class="btn btn-outline-secondary quick-amount mr-2 mb-2" data-amount="10000">10.000₫</button>
                                            <button class="btn btn-outline-secondary quick-amount mr-2 mb-2" data-amount="50000">50.000₫</button>
                                            <button class="btn btn-outline-secondary quick-amount mr-2 mb-2" data-amount="100000">100.000₫</button>
                                            <button class="btn btn-outline-secondary quick-amount mr-2 mb-2" data-amount="200000">200.000₫</button>
                                            <button class="btn btn-outline-secondary quick-amount mr-2 mb-2" data-amount="500000">500.000₫</button>
                                            <button class="btn btn-outline-secondary quick-amount mr-2 mb-2" data-amount="1000000">1.000.000₫</button>
                                        </div>
                                    </div>

                                    <!-- INPUT -->
                                    <div class="mb-3">
                                        <label class="font-weight-bold">Số tiền muốn nạp</label>
                                        <input type="number"
                                            class="form-control form-control-lg"
                                            id="topup-amount"
                                            min="10000"
                                            placeholder="Nhập số tiền (tối thiểu 10.000₫)">
                                    </div>

                                    <div class="text-muted small mb-3">
                                        Thanh toán qua PayOS (QR / ngân hàng / ví)
                                    </div>

                                    <button class="btn btn-success btn-lg btn-block" onclick="topup()">
                                        🚀 Tiến hành thanh toán
                                    </button>

                                </div>
                            </div>

                        </div>
                        <div class="col-lg-5 mb-4">
                            <!-- WITHDRAW -->
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-danger">
                                        🏧 Rút tiền từ ví
                                    </h6>
                                </div>
                                <div class="card-body">

                                    <div class="mb-3">
                                        <label class="font-weight-bold">Số tiền muốn rút</label>
                                        <input type="number"
                                            class="form-control form-control-lg"
                                            id="withdraw-amount"
                                            min="10000"
                                            placeholder="Nhập số tiền">
                                    </div>

                                    <div class="mb-3">
                                        <label>Ghi chú (tuỳ chọn)</label>
                                        <input type="text"
                                            class="form-control"
                                            id="withdraw-note"
                                            placeholder="VD: Rút về ngân hàng">
                                    </div>

                                    <button class="btn btn-danger btn-lg btn-block" onclick="withdraw()">
                                        💸 Rút tiền
                                    </button>
                                </div>
                            </div>

                        </div>
                        <div class="col-lg-7 mb-4">
                            <div class="card shadow h-100">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-info">
                                        👤 Chuyển tiền cho người khác
                                    </h6>
                                </div>
                                <div class="card-body">

                                    <div class="mb-3">
                                        <label class="font-weight-bold">User ID người nhận</label>
                                        <input type="text"
                                            class="form-control"
                                            id="transfer-user-id"
                                            placeholder="Nhập ID người nhận">
                                    </div>

                                    <div class="mb-3">
                                        <label class="font-weight-bold">Số tiền</label>
                                        <input type="number"
                                            class="form-control form-control-lg"
                                            id="transfer-user-amount"
                                            placeholder="Nhập số tiền">
                                    </div>

                                    <div class="mb-3">
                                        <label>Ghi chú</label>
                                        <input type="text"
                                            class="form-control"
                                            id="transfer-user-note"
                                            placeholder="VD: Trả tiền, hỗ trợ…">
                                    </div>

                                    <button class="btn btn-info btn-lg btn-block" onclick="transferToUser()">
                                        🔁 Chuyển tiền
                                    </button>

                                </div>
                            </div>
                        </div>
                        <!-- <div class="col-lg-7 mb-4">
                            <div class="card shadow h-100">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        🏢 Chuyển tiền cho công ty
                                    </h6>
                                </div>
                                <div class="card-body">

                                    <div class="mb-3">
                                        <label class="font-weight-bold">Company ID</label>
                                        <input type="text"
                                            class="form-control"
                                            id="pay-company-id"
                                            placeholder="Nhập ID công ty">
                                    </div>

                                    <div class="mb-3">
                                        <label class="font-weight-bold">Order ID</label>
                                        <input type="text"
                                            class="form-control"
                                            id="pay-company-order-id"
                                            placeholder="ID đơn hàng">
                                    </div>

                                    <div class="mb-3">
                                        <label class="font-weight-bold">Số tiền</label>
                                        <input type="number"
                                            class="form-control form-control-lg"
                                            id="pay-company-amount"
                                            placeholder="Nhập số tiền">
                                    </div>

                                    <button class="btn btn-primary btn-lg btn-block" onclick="payCompany()">
                                        💼 Thanh toán công ty
                                    </button>

                                </div>
                            </div>
                        </div> -->


                    </div>
                    <!-- TRANSACTION HISTORY -->
                    <div class="row">
                        <div class="col-lg-12 mb-4">
                            <div class="card shadow">
                                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        📜 Lịch sử giao dịch
                                    </h6>
                                    <button class="btn btn-sm btn-outline-secondary" onclick="loadTransactions()">
                                        🔄 Tải lại
                                    </button>
                                </div>

                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th>Thời gian</th>
                                                    <th>Loại</th>
                                                    <th>Số tiền</th>
                                                    <th>Đối tượng</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ghi chú</th>
                                                    <th>Hành động</th>
                                                </tr>
                                            </thead>

                                            <tbody id="transaction-list">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted py-4">
                                                        Đang tải dữ liệu...
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <div class="p-3 d-flex justify-content-center">
                                            <nav>
                                                <ul class="pagination mb-0" id="tx-pagination"></ul>
                                            </nav>
                                        </div>

                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>



                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->

            <!-- Footer -->
            <?php include './partials/footer.php'; ?>
            <!-- End of Footer -->

        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->
</body>

</html>
<script>
    async function loadWallet() {
        const res = await fetch('/api/users/@me', {
            headers: {
                'Authorization': 'Bearer ' + getCookie('auth_token')
            }
        })
        const json = await res.json()
        if (json.code !== 200) return

        document.getElementById('wallet-balance').innerText =
            Number(json.data.balance).toLocaleString() + ' ₫'
    }


    async function topup() {
        const amount = Number(document.getElementById('topup-amount').value)

        if (!amount || amount < 10000) {
            return alert('Số tiền tối thiểu là 10.000₫')
        }

        const btn = event.target
        btn.disabled = true
        btn.innerText = 'Đang xử lý...'

        const res = await fetch('/api/users/@me/financials', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                action: 'topup',
                amount,
                note: 'Nạp qua PayOS'
            })
        })

        const json = await res.json()

        btn.disabled = false
        btn.innerText = '🚀 Tiến hành thanh toán'

        if (json.code !== 200) {
            return alert(json.msg || 'Nạp tiền thất bại')
        }

        openTopupPopup(json.data.checkout_url, `NẠP TIỀN ${json.data.transaction_id}`, true);

        // alert('🎉 Nạp tiền thành công')
        loadWallet()
    }

    async function withdraw() {
        const amount = Number(document.getElementById('withdraw-amount').value)
        const note = document.getElementById('withdraw-note').value

        if (!amount || amount <= 0) {
            return alert('Số tiền không hợp lệ')
        }

        if (!confirm(`Bạn chắc chắn muốn rút ${amount.toLocaleString()} ₫ ?`)) {
            return
        }

        const btn = event.target
        btn.disabled = true
        btn.innerText = 'Đang xử lý...'

        const res = await fetch('/api/users/@me/financials', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                action: 'withdraw',
                amount,
                note
            })
        })

        const json = await res.json()

        btn.disabled = false
        btn.innerText = '💸 Rút tiền'

        if (json.code !== 200) {
            return alert(json.msg || 'Không thể rút tiền')
        }

        alert('✅ Yêu cầu rút tiền thành công')
        loadWallet()
    }


    // Quick amount buttons
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('quick-amount')) {
            document.getElementById('topup-amount').value =
                e.target.dataset.amount;
        }
    });

    document.addEventListener('DOMContentLoaded', () => {
        loadWallet();

        const params = new URLSearchParams(window.location.search);
        if (params.get('success')) {
            alert('🎉 Thanh toán thành công! Số dư sẽ được cập nhật.');
        }
        if (params.get('cancel')) {
            alert('❌ Thanh toán đã bị huỷ.');
        }
    });
</script>
<script>
    

    let txPage = 1
    const txLimit = 20

    async function loadTransactions(page = 1) {
        const tbody = document.getElementById('transaction-list')

        tbody.innerHTML = `
        <tr>
            <td colspan="5" class="text-center text-muted py-4">
                Đang tải dữ liệu...
            </td>
        </tr>
    `

        const res = await fetch(`/api/users/@me/transactions?page=${page}&limit=${txLimit}`, {
            headers: {
                'Authorization': 'Bearer ' + getCookie('auth_token')
            }
        })

        const json = await res.json()

        if (json.code !== 200 || !json.data.items.length) {
            tbody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center text-muted py-4">
                    Chưa có giao dịch nào
                </td>
            </tr>
        `
            return
        }

        tbody.innerHTML = ''

        json.data.items.forEach(tx => {
            const amount = Number(tx.amount)
            const isMinus = ['withdraw', 'transfer', 'payment'].includes(tx.type)

            tbody.innerHTML += `
    <tr>
        <td>${new Date(tx.created_at).toLocaleString()}</td>
        <td>${formatType(tx.type)}</td>
        <td class="${tx.status == 'finished' ? (isMinus ? 'text-danger' : 'text-success') : ''} font-weight-bold">
            ${tx.status == 'finished' ? (isMinus ? '-' : '+') : ''}${amount.toLocaleString()} ₫
        </td>
        <td>${renderTarget(tx)}</td>
        <td>${formatStatus(tx.status)}</td>
        <td class="text-muted">${tx.note || '-'}</td>
        <td>${renderActions(tx)}</td>
    </tr>`
        })


        renderPagination(json.data.pagination)
    }


    document.addEventListener('DOMContentLoaded', () => {
        loadWallet();
        loadTransactions();
    })



    function renderPagination(pagination) {
        const ul = document.getElementById('tx-pagination')
        ul.innerHTML = ''

        const {
            page,
            total_pages
        } = pagination

        if (total_pages <= 1) return

        for (let i = 1; i <= total_pages; i++) {
            ul.innerHTML += `
            <li class="page-item ${i === page ? 'active' : ''}">
                <a class="page-link" href="javascript:void(0)" onclick="loadTransactions(${i})">
                    ${i}
                </a>
            </li>
        `
        }
    }
</script>
<script>
    async function transferToUser() {
        const to_user_id = document.getElementById('transfer-user-id').value.trim()
        const amount = Number(document.getElementById('transfer-user-amount').value)
        const note = document.getElementById('transfer-user-note').value

        if (!to_user_id) {
            return alert('Vui lòng nhập User ID người nhận')
        }

        if (!amount || amount <= 0) {
            return alert('Số tiền không hợp lệ')
        }

        if (!confirm(`Chuyển ${amount.toLocaleString()} ₫ cho user ${to_user_id}?`)) {
            return
        }

        const res = await fetch('/api/users/@me/financials', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                action: 'transfer',
                to_user_id,
                amount,
                note
            })
        })

        const json = await res.json()

        if (json.code !== 200) {
            return alert(json.msg || 'Chuyển tiền thất bại')
        }

        alert('✅ Chuyển tiền thành công')
        loadWallet()
        loadTransactions()
    }
</script>
<script>
    async function payCompany() {
        const company_id = document.getElementById('pay-company-id').value.trim()
        const order_id = document.getElementById('pay-company-order-id').value.trim()
        const amount = Number(document.getElementById('pay-company-amount').value)

        if (!company_id || !order_id) {
            return alert('Thiếu Company ID hoặc Order ID')
        }

        if (!amount || amount <= 0) {
            return alert('Số tiền không hợp lệ')
        }

        if (!confirm(`Thanh toán ${amount.toLocaleString()} ₫ cho công ty?`)) {
            return
        }

        const res = await fetch('/api/users/@me/financials', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                action: 'pay_company',
                company_id,
                order_id,
                amount
            })
        })

        const json = await res.json()

        if (json.code !== 200) {
            return alert(json.msg || 'Thanh toán thất bại')
        }

        alert('✅ Thanh toán công ty thành công')
        loadWallet()
        loadTransactions()
    }

    function openTopupPopup(url, title, isReloadWallet) {
        const width = 420;
        const height = 520;

        const left = (screen.width - width) / 2;
        const top = (screen.height - height) / 2;

        loginWindow = window.open(
            `${url}`,
            title,
            `width=${width},height=${height},top=${top},left=${left},resizable=no`
        );

        // Theo dõi khi popup đóng
        const timer = setInterval(() => {
            if (loginWindow.closed) {
                clearInterval(timer);
                if (isReloadWallet) {
                    loadWallet();
                    loadTransactions();
                }
            }
        }, 500);
    }

    function renderTarget(tx) {
        if (tx.to_user) {
            return `
        👤 ${tx.to_user.display_name}
        <br>
        <a href="/manage/user.php?id=${tx.to_user.id}" class="btn btn-sm btn-outline-info mt-1">
            Xem người nhận
        </a>`
        }

        if (tx.to_company) {
            return `
        🏢 ${tx.to_company.name}
        <br>
        <a href="/manage/company.php?id=${tx.to_company.id}" class="btn btn-sm btn-outline-primary mt-1">
            Xem công ty
        </a>`
        }

        return `<span class="text-muted">-</span>`
    }

    function renderActions(tx) {
        let html = ''

        if (tx.order) {
            html += `
        <a href="/manage/order.php?id=${tx.order.id}"
           class="btn btn-sm btn-outline-secondary mb-1">
            📦 Xem đơn hàng
        </a><br>`
        }

        if (tx.status === 'pending') {
            html += `
        <button class="btn btn-sm btn-danger"
                onclick="cancelTransaction('${tx.id}')">
            ❌ Hủy giao dịch
        </button>`
        }

        return html || '<span class="text-muted">-</span>'
    }
    async function cancelTransaction(txId) {
        if (!confirm('Bạn chắc chắn muốn hủy giao dịch này?')) return

        const res = await fetch(`/api/users/@me/financials`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                action: 'topup_cancel',
                transaction_id: txId
            })
        });

        const json = await res.json()

        if (json.code !== 200) {
            return alert(json.msg || 'Không thể hủy giao dịch')
        }

        alert('✅ Đã hủy giao dịch')
        loadWallet()
        loadTransactions()
    }
</script>