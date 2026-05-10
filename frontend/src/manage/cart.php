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

                        <!-- Cart items -->
                        <div class="col-lg-8">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        🛒 Giỏ hàng của bạn
                                    </h6>
                                </div>

                                <div class="card-body">
                                    <div id="cartList" class="list-group">
                                        <!-- renderCart() -->
                                    </div>

                                    <div id="cartEmpty" class="text-center text-muted py-4 d-none">
                                        Giỏ hàng trống
                                    </div>
                                </div>



                            </div>
                        </div>

                        <!-- Cart summary -->
                        <div class="col-lg-4">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        💳 Tổng kết
                                    </h6>
                                </div>

                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Số sản phẩm</span>
                                        <strong id="cartTotalItems">0</strong>
                                    </div>

                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Tổng tiền</span>
                                        <strong id="cartTotalPrice">0 ₫</strong>
                                    </div>

                                    <div class="d-flex justify-content-between mb-3">
                                        <span>Số dư ví</span>
                                        <strong id="userBalance">0 ₫</strong>
                                    </div>

                                    <button id="btnCheckout"
                                        class="btn btn-success btn-block"
                                        disabled
                                        onclick="checkoutCart()">
                                        💳 Thanh toán
                                    </button>
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
    $(document).ready(async () => {
        await initUser();
        renderCart(await loadCart());
    });
    let currentTotalPrice = 0;

    $(document).ready(async () => {
        await initUser();
        $('#userBalance').text(window.user.balance.toLocaleString() + ' ₫');

        const cart = await loadCart();
        renderCart(cart);
    });


    function renderCart(cart) {
        const $list = $('#cartList');
        const $empty = $('#cartEmpty');

        $list.empty();

        if (!cart || cart.length === 0) {
            $empty.removeClass('d-none');
            $('#cartTotalItems').text(0);
            $('#cartTotalPrice').text('0 ₫');
            return;
        }

        $empty.addClass('d-none');

        let totalItems = 0;
        let totalPrice = 0;

        cart.forEach(item => {
            const p = item.product;
            const price = p.price * item.amount;

            totalItems += item.amount;
            totalPrice += price;

            $list.append(`
                <div class="list-group-item">
                    <div class="d-flex align-items-center">

                        <!-- Product image -->
                        <img src="/api/media-proxy/product_images/${p.id}/${p.files?.find(x=>x.order == 0)?.id}?size=60x60"
                             class="rounded mr-3"
                             style="width:60px;height:60px;object-fit:cover">

                        <!-- Info -->
                        <div class="flex-grow-1">
                            <div class="fw-bold">
                                <a href="/manage/product.php?id=${p.id}" target="_blank">
                                    ${escapeHtml(p.name)}
                                </a>
                            </div>
                            <div class="text-muted small">
                                ${p.price.toLocaleString()} ₫
                            </div>
                        </div>

                        <!-- Quantity -->
                        <div class="d-flex align-items-center mr-3">
                            <button class="btn btn-sm btn-outline-secondary"
                                onclick="changeQty('${item.id}', ${item.amount - 1})">−</button>

                            <span class="mx-2">${item.amount}</span>

                            <button class="btn btn-sm btn-outline-secondary"
                                onclick="changeQty('${item.id}', ${item.amount + 1})">+</button>
                        </div>

                        <!-- Price -->
                        <div class="fw-bold mr-3">
                            ${price.toLocaleString()} ₫
                        </div>

                        <!-- Remove -->
                        <button class="btn btn-sm btn-danger"
                            onclick="removeItem('${item.id}')">
                            <i class="fas fa-trash"></i>
                        </button>

                    </div>
                </div>
            `);
        });

        $('#cartTotalItems').text(totalItems);
        $('#cartTotalPrice').text(totalPrice.toLocaleString() + ' ₫');
        currentTotalPrice = totalPrice;

        const balance = window.user.balance || 0;
        const $btn = $('#btnCheckout');

        if (totalPrice > 0 && balance >= totalPrice) {
            $btn.prop('disabled', false)
                .removeClass('btn-secondary')
                .addClass('btn-success')
                .text('💳 Thanh toán');
        } else if (totalPrice > 0) {
            $btn.prop('disabled', true)
                .removeClass('btn-success')
                .addClass('btn-secondary')
                .text('Không đủ số dư');
        } else {
            $btn.prop('disabled', true);
        }

    }

    async function changeQty(cartItemId, amount) {
        if (amount <= 0) {
            await removeItem(cartItemId);
            return;
        }

        await editCartItemQuantity(cartItemId, amount);
        renderCart(await loadCart());

    }

    async function removeItem(cartItemId) {
        if (!confirm('Xóa sản phẩm này khỏi giỏ?')) return;
        await removeProductFromCart(cartItemId);
        renderCart(await loadCart());

    }
    async function checkoutCart() {
        // if (!confirm('Xác nhận thanh toán đơn hàng?')) return;

        const btn = $('#btnCheckout');
        btn.prop('disabled', true).text('Đang xử lý...');

        try {
            const res = await fetch('/api/users/@me/orders', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + getCookie('auth_token')
                }
            });

            const json = await res.json();

            if (json.code !== 200) {
                alert(json.msg || 'Tạo đơn hàng thất bại');
                return;
            }

            // Cập nhật balance local
            $('#userBalance').text(window.user.balance.toLocaleString() + ' ₫');

            alert('✅ Tạo đơn hàng thành công!');
            // Reload cart
            renderCart([]);
            window.location.href = `/manage/order.php?id=${json.data.id}`
        } catch (err) {
            console.error(err);
            alert('Lỗi hệ thống');
        } finally {
            btn.prop('disabled', false).text('Tạo đơn hàng');
        }
    }
</script>