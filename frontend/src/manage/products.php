<!DOCTYPE html>
<html lang="en">

<head>
    <?php include './partials/init.php'; ?>
    <title>Quản lý sản phẩm - Places</title>
</head>

<body id="page-top">

    <div id="wrapper">

        <!-- Sidebar -->
        <?php include './partials/sidebar.php'; ?>

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <?php include './partials/header.php'; ?>

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Quản lý sản phẩm theo địa điểm</h1>
                    </div>

                    <!-- PLACES & PRODUCTS -->
                    <div id="placesContainer"></div>

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->

            <!-- Footer -->
            <?php include './partials/footer.php'; ?>

        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->

    <!-- MODAL THÊM / SỬA SẢN PHẨM -->
    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="productModalTitle"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <form id="productForm">
                        <input type="hidden" name="id" id="productId">
                        <input type="hidden" name="place_id" id="productPlaceId">

                        <div class="mb-3">
                            <label class="form-label">Tên sản phẩm *</label>
                            <input type="text" class="form-control" name="name" id="productName" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" id="productDescription" rows="3"></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Giá *</label>
                                <input type="number" class="form-control" name="price" id="productPrice" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Tồn kho *</label>
                                <input type="number" class="form-control" name="stock" id="productStock" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Đơn vị</label>
                                <input type="text" class="form-control" name="unit_type" id="productUnit">
                            </div>
                        </div>

                    </form>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="button" class="btn btn-primary" id="saveProductBtn">
                        <i class="fas fa-save"></i> Lưu sản phẩm
                    </button>
                </div>

            </div>
        </div>
    </div>

</body>

</html>

<script>
    let placesData = [];

    $(document).ready(async function() {
        await initUser();
        await loadPlaces();
    });

    async function loadPlaces() {
        try {
            const res = await fetch('/api/places', {
                headers: {
                    'Authorization': 'Bearer ' + getCookie('auth_token')
                }
            });
            const json = await res.json();
            if (json.code !== 200) return;

            // Lọc chỉ những places user sở hữu
            const userId = window.user.id; // giả sử API trả current_user_id
            placesData = json.data.filter(p => p.user_id === userId || (p.company?.owned_by === userId) || window.user.flags.includes('ADMIN'));

            renderPlaces();
        } catch (e) {
            console.error(e);
        }
    }

    function renderPlaces() {
        const container = $('#placesContainer');
        container.empty();

        if (!placesData.length) {
            container.append(`<div class="text-muted text-center py-4">Bạn chưa có địa điểm nào</div>`);
            return;
        }

        placesData.forEach(p => {
            const ownerBtn = p.user ?
                `<button class="btn btn-sm btn-warning" onclick="window.location.href='/manage/user.php?id=${p.user.id}'">
                <i class="fas fa-user"></i> Xem cá nhân
           </button>` :
                p.company ?
                `<button class="btn btn-sm btn-warning" onclick="window.location.href='/manage/company.php?id=${p.company.id}'">
                <i class="fas fa-building"></i> Xem công ty
           </button>` :
                '';

            const productsHtml = p.products.length ?
                p.products.map(pr => `
            <tr>
                <td>${pr.name}</td>
                <td>${pr.description || '-'}</td>
                <td>${pr.price.toLocaleString()} ₫</td>
                <td>${pr.stock}</td>
                <td>${pr.unit_type || '-'}</td>
                <td>
                    <button class="btn btn-sm btn-warning" onclick="window.location.href = '/manage/product.php?id=${pr.id}'">Xem chi tiết</button>
                    <button class="btn btn-sm btn-primary" onclick="editProduct('${p.id}', '${pr.id}')">Sửa</button>
                    <button class="btn btn-sm btn-danger" onclick="deleteProduct('${pr.id}')">Xoá</button>
                </td>
            </tr>
        `).join('') :
                `<tr><td colspan="6" class="text-center text-muted">Chưa có sản phẩm</td></tr>`;

            container.append(`
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <strong>${p.name}</strong> (${p.user ? 'Cá nhân' : p.company ? 'Công ty' : ''})
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-info" onclick="window.location.href='/manage/place.php?id=${p.id}'">
                        <i class="fas fa-map-marker-alt"></i> Xem địa điểm
                    </button>
                    ${ownerBtn}
                    <button class="btn btn-sm btn-success" onclick="addProduct('${p.id}')">
                        <i class="fas fa-plus"></i> Thêm sản phẩm
                    </button>
                </div>
            </div>
            <div class="card-body p-0">
                <table class="table table-bordered mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Tên</th>
                            <th>Mô tả</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Đơn vị</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>${productsHtml}</tbody>
                </table>
            </div>
        </div>
    `);
        });


    }

    function addProduct(placeId) {
        $('#productModalTitle').text('Thêm sản phẩm');
        $('#productForm')[0].reset();
        $('#productId').val('');
        $('#productPlaceId').val(placeId);
        new bootstrap.Modal(document.getElementById('productModal')).show();
    }

    function editProduct(placeId, productId) {
        const place = placesData.find(p => p.id === placeId);
        if (!place) return;
        const product = place.products.find(pr => pr.id === productId);
        if (!product) return;

        $('#productModalTitle').text('Sửa sản phẩm');
        $('#productId').val(product.id);
        $('#productPlaceId').val(placeId);
        $('#productName').val(product.name);
        $('#productDescription').val(product.description);
        $('#productPrice').val(product.price);
        $('#productStock').val(product.stock);
        $('#productUnit').val(product.unit_type);

        new bootstrap.Modal(document.getElementById('productModal')).show();
    }

    $('#saveProductBtn').on('click', async function() {
        const form = $('#productForm');
        const data = Object.fromEntries(new FormData(form[0]).entries());

        // Kiểm tra bắt buộc
        if (!data.name || !data.price || !data.stock) {
            alert('Vui lòng nhập đầy đủ thông tin bắt buộc');
            return;
        }

        const isEdit = !!data.id;
        const method = isEdit ? 'PATCH' : 'PUT';
        const url = isEdit ? `/api/products/${data.id}` : `/api/places/${data.place_id}/products`;

        try {
            const res = await fetch(url, {
                method,
                headers: {
                    'Authorization': 'Bearer ' + getCookie('auth_token'),
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Lỗi lưu sản phẩm');
                return;
            }
            $('#productForm').modal('hide');
            form.reset();
            await loadPlaces();
        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });

    async function deleteProduct(productId) {
        if (!confirm('Bạn có chắc muốn xoá sản phẩm này?')) return;

        try {
            const res = await fetch(`/api/products/${productId}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': 'Bearer ' + getCookie('auth_token')
                }
            });
            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Xoá thất bại');
                return;
            }
            await loadPlaces();
        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    }
</script>