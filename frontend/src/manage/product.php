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

                    <h1 class="h3 mb-4 text-gray-800">Chi tiết sản phẩm</h1>

                    <div id="product-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-warning" id="btn-edit">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </button>
                        <button class="btn btn-sm btn-danger" id="btn-delete">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                    </div>
                    <div id="product-edit-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-success" id="btn-save">
                            <i class="fas fa-save"></i> Lưu
                        </button>
                        <button class="btn btn-sm btn-secondary" id="btn-cancel">
                            Hủy
                        </button>
                    </div>

                    <!-- Thông tin sản phẩm -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Thông tin sản phẩm</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p>
                                        <strong>Tên sản phẩm:</strong>
                                        <span class="view-mode" id="p-name"></span>
                                        <input class="form-control form-control-sm edit-mode d-none" id="i-name" data-field="name">
                                    </p>
                                    <p>
                                        <strong>Mô tả:</strong>
                                        <span class="view-mode" id="p-description"></span>
                                        <textarea class="form-control form-control-sm edit-mode d-none" id="i-description" data-field="description"></textarea>
                                    </p>
                                    <p>
                                        <strong>Giá:</strong>
                                        <span class="view-mode" id="p-price"></span>
                                        <input type="number" class="form-control form-control-sm edit-mode d-none" id="i-price" data-field="price">
                                    </p>
                                    <p>
                                        <strong>Tồn kho:</strong>
                                        <span class="view-mode" id="p-stock"></span>
                                        <input type="number" class="form-control form-control-sm edit-mode d-none" id="i-stock" data-field="stock">
                                    </p>
                                    <p>
                                        <strong>Đơn vị:</strong>
                                        <span class="view-mode" id="p-unit"></span>
                                        <input class="form-control form-control-sm edit-mode d-none" id="i-unit_type" data-field="unit_type">
                                    </p>
                                </div>

                                <div class="col-md-6">
                                    <p>
                                        <strong>Danh mục:</strong><br>

                                        <!-- VIEW MODE -->
                                        <span class="view-mode" id="p-category"></span>

                                        <!-- EDIT MODE -->
                                        <select class="form-select form-select-sm edit-mode d-none"
                                            id="i-category"
                                            data-field="category_id">
                                        </select>
                                    </p>
                                    <p>
                                        <strong>Địa điểm:</strong>
                                        <span class="view-mode" id="p-place"></span>
                                    </p>
                                    <p>
                                        <strong>Hình ảnh:</strong>
                                    <div id="product-images" class="d-flex flex-wrap gap-2"></div>
                                    <input type="file" id="i-images" class="form-control-file mt-2 edit-mode d-none" multiple>
                                    </p>
                                    <p>
                                        <strong>Ngày tạo:</strong> <span id="p-created"></span>
                                    </p>
                                    <p>
                                        <strong>Cập nhật:</strong> <span id="p-updated"></span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <?php include './partials/footer.php'; ?>
        </div>
    </div>

</body>

</html>

<script>
    let currentProduct = null;
    let isEditing = false;
    let allCategories = [];


    $(document).ready(async function() {

        await waitForUser();

        await reloadProduct();
        await loadCategories();

        renderProduct(currentProduct);
        // Check quyền chỉnh sửa
        if ((currentProduct.creator_id === window.user.id) || window.user.flags?.includes('ADMIN')) {
            $('#product-actions').removeClass('d-none');
        }
    });



    async function loadCategories() {
        const res = await fetch('/api/categories', {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });
        const json = await res.json();
        if (json.code === 200) {
            allCategories = json.data;
            renderCategorySelect();
        }
    }


    function renderCategorySelect() {
        const $select = $('#i-category');
        $select.empty();
        $select.append(`<option value="">— Chọn danh mục —</option>`);

        allCategories.forEach(c => {
            $select.append(`<option value="${c.id}">${c.name}</option>`);
        });
    }


    function renderCategories(product) {
        const $view = $('#p-categories');

        if (!product.categories?.length) {
            $view.html('<span class="text-muted">—</span>');
            return;
        }

        $view.html(
            product.categories.map(pc =>
                `<span class="badge bg-primary me-1">${pc.category.name}</span>`
            ).join('')
        );

        // set selected cho edit
        $('#i-categories').val(
            product.categories.map(pc => pc.category_id)
        );
    }



    async function reloadProduct() {
        const productId = getQuery('id');
        if (!productId) return;
        try {
            const res = await fetch(`/api/products/${productId}`, {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });
            const json = await res.json();
            if (json.code !== 200) return;

            currentProduct = json.data;
            renderImages(currentProduct.files);


        } catch (e) {
            console.error(e);
        }
    }

    function renderProduct(p) {
        $('#p-name').text(p.name || '—');
        $('#i-name').val(p.name || '');

        $('#p-description').text(p.description || '—');
        $('#i-description').val(p.description || '');

        $('#p-price').text(p.price?.toLocaleString() + ' ₫' || '—');
        $('#i-price').val(p.price || '');

        $('#p-stock').text(p.stock || '—');
        $('#i-stock').val(p.stock || '');

        $('#p-unit').text(p.unit_type || '—');
        $('#i-unit_type').val(p.unit_type || '');

        // VIEW
        $('#p-category').text(p.category?.name || '—');

        // EDIT
        $('#i-category').val(p.category_id || '');


        if (p.place) {
            $('#p-place').html(`
        <span>${p.place.name}</span>
        <a href="/manage/place.php?id=${p.place.id}"
           class="btn btn-sm btn-outline-primary ms-2"
           target="_blank">
            <i class="fas fa-map-marker-alt"></i> Xem địa điểm
        </a>
    `);
        } else {
            $('#p-place').text('—');
        }


        $('#p-created').text(p.created_at ? new Date(p.created_at).toLocaleString() : '—');
        $('#p-updated').text(p.modified_at ? new Date(p.modified_at).toLocaleString() : '—');

        renderImages(p.files || []);
        renderCategories(p);

    }

    function renderImages(images) {
        const $container = $('#product-images');
        $container.empty();

        if (!images?.length) {
            $container.append('<p class="text-muted">Chưa có hình ảnh</p>');
            return;
        }

        images
            .sort((a, b) => a.order - b.order)
            .forEach(img => {
                $container.append(`
        <div class="position-relative image-item"
             data-id="${img.id}">
            <img src="/api/media-proxy/product_images/${currentProduct.id}/${img.id}"
                 class="img-thumbnail"
                 style="width:90px;height:90px;object-fit:cover;cursor:grab;">
            ${isEditing ? `
            <button class="btn btn-sm btn-danger position-absolute top-0 end-0"
                    onclick="deleteImage('${img.id}')">&times;</button>
            ` : ''}
        </div>
        `);
            });

        if (isEditing) enableSortImages();
    }


    // Chỉnh sửa
    $('#btn-edit').on('click', function() {
        isEditing = true;
        enterEditMode();
    });

    function enterEditMode() {
        isEditing = true;

        $('#product-actions').addClass('d-none');
        $('#product-edit-actions').removeClass('d-none');

        $('.view-mode').addClass('d-none');
        $('.edit-mode').removeClass('d-none');

        // ⭐ RENDER LẠI ẢNH ĐỂ HIỆN NÚT XOÁ + SORT
        renderImages(currentProduct.files || []);
    }


    // Hủy
    $('#btn-cancel').on('click', function() {
        isEditing = false;
        exitEditMode();
        renderProduct(currentProduct);
    });

    function exitEditMode() {
        isEditing = false;
        $('#product-edit-actions').addClass('d-none');
        $('#product-actions').removeClass('d-none');

        $('.edit-mode').addClass('d-none');
        $('.view-mode').removeClass('d-none');
    }

    // Lưu
    $('#btn-save').on('click', async function() {
        const updateData = {};
        $('.edit-mode[data-field]').each(function() {
            const field = $(this).data('field');
            const val = $(this).val().trim();
            if (val !== (currentProduct[field] || '')) {
                updateData[field] = val;
            }
        });

        const categoryIds = $('#i-categories').val() || [];


        try {
            const res = await fetch(`/api/products/${currentProduct.id}`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: 'Bearer ' + getCookie('auth_token')
                },
                body: JSON.stringify(updateData)
            });

            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Cập nhật thất bại');
                return;
            }

            currentProduct = json.data;

            exitEditMode();
            await reloadProduct();
            renderProduct(currentProduct);
            renderImages(currentProduct.files || []);
            alert('Đã cập nhật sản phẩm');
        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });

    // Xóa sản phẩm
    $('#btn-delete').on('click', async function() {
        if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) return;

        try {
            const res = await fetch(`/api/products/${currentProduct.id}`, {
                method: 'DELETE',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });
            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Xóa thất bại');
                return;
            }
            alert('Đã xóa sản phẩm');
            window.location.href = '/manage/places.php?id=' + currentProduct.place_id;
        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });

    // Upload ảnh
    $('#i-images').on('change', async function() {
        const files = this.files;
        if (!files?.length) return;

        const formData = new FormData();
        formData.append('product_id', currentProduct.id);
        formData.append('type', 'product_image');
        for (const f of files) {
            formData.append('files', f);
            formData.append("filenames[]", f.name);
        }

        try {
            const res = await fetch(`/api/files/`, {
                method: 'PUT',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                },
                body: formData
            });
            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Upload thất bại');
                return;
            }
            await reloadProduct();
            $('#i-images').val('');

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });

    // Xóa ảnh
    async function deleteImage(imageId) {
        if (!confirm('Xóa hình ảnh này?')) return;
        try {
            const res = await fetch(`/api/products/${currentProduct.id}/images/${imageId}`, {
                method: 'DELETE',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });
            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Xóa thất bại');
                return;
            }
            await reloadProduct();
        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    }

    function enableSortImages() {
        const el = document.getElementById('product-images');

        Sortable.create(el, {
            animation: 150,
            onEnd: async () => {
                const order = [];
                $('#product-images .image-item').each((i, el) => {
                    order.push({
                        id: $(el).data('id'),
                        order: i
                    });
                });

                await saveImageOrder(order);
            }
        });
    }
    async function saveImageOrder(order) {
        try {
            const res = await fetch(
                `/api/products/${currentProduct.id}/images/order`, {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                        Authorization: 'Bearer ' + getCookie('auth_token')
                    },
                    body: JSON.stringify({
                        order
                    })
                }
            );

            const json = await res.json();
            if (json.code !== 200) {
                alert('Không lưu được thứ tự ảnh');
            }
            // await reloadProduct();

        } catch (e) {
            console.error(e);
        }
    }
</script>