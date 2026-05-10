<!DOCTYPE html>
<html lang="en">

<head>
    <?php include './partials/init.php'; ?>
</head>

<body class=" position-relative h-auto">
    <!-- Navigation-->
    <?php include './partials/header.php'; ?>
    <!-- Header-->
    <header class="bg-primary py-5">
        <div class="container px-4 px-lg-5 my-5">
            <div class="text-center text-white">
                <h1 class="display-4 fw-bolder">Sàn Giao Dịch Nguyên Liệu Tái Chế TRASHÉ</h1>
                <p class="lead fw-normal text-white-50 mb-0 fs-3">Biến phế thải thành kinh tế</p>
            </div>
        </div>
    </header>
    <!-- Section-->
    <!-- AI TOGGLE BTN -->
    <button
        class="btn btn-primary rounded-circle position-fixed end-0 bottom-0 m-4"
        style="z-index: 1000;"
        title="Tìm kiếm với AI"
        onclick="
                                document.querySelector('#search-container').classList.toggle('d-none');
                                document.getElementById('counter-section').classList.toggle('d-none');
                                document.getElementById('display-product').classList.toggle('d-none');
                                document.getElementById('productsGrid').classList.toggle('d-none');
                                document.getElementById('search-filter-box').classList.toggle('d-none');
                                searchAI();
                            ">
        <i class="bi bi-robot"></i>
    </button>

    <section class="py-5">
        <div class="container px-4 px-lg-5 mt-5">
            <div class="row">


                <!-- MAIN CONTENT -->
                <main class="col-lg-12">

                    <!-- SEARCH + FILTER -->
                    <div class="card mb-4 shadow-sm" id="search-filter-box">
                        <div class="card-body">
                            <input
                                type="text"
                                id="globalSearch"
                                class="form-control form-control-lg"
                                placeholder="🔍 Tìm sản phẩm, công ty, người bán, địa điểm...">
                            <div class="text-muted small mt-2">
                                Gợi ý: tên sản phẩm, công ty, người dùng, địa điểm
                            </div>
                        </div>
                    </div>
                    <!-- ai - search -->
                    <div class="container d-none py-5" id="search-container" style="height: auto !important">
                        <!-- SEARCH BOX -->
                        <div class="card shadow-sm my-3">
                            <div class="card-body">
                                <h5 class="mb-3">Tìm nguồn hàng bằng AI</h5>

                                <div class="row g-2">
                                    <div class="col-md-6">
                                        <input
                                            id="query"
                                            class="form-control"
                                            placeholder="Bạn cần gì? VD : Đồng, nhựa,..." />
                                    </div>
                                    <div class="col-md-3">
                                        <input
                                            id="min_stock"
                                            type="number"
                                            class="form-control"
                                            placeholder="Số lượng tối thiểu (kg)" />
                                    </div>
                                    <div class="col-md-3">
                                        <input
                                            id="max_price"
                                            type="number"
                                            class="form-control"
                                            placeholder="Giá tối đa (đ)" />
                                    </div>
                                </div>

                                <button class="btn btn-primary mt-3" onclick="searchAI()">
                                    🔍 Tìm bằng AI
                                </button>
                            </div>
                        </div>


                        <!-- AI EXPLAIN -->
                        <div id="ai-explain" class="alert alert-info d-none"></div>

                        <!-- RESULT -->
                        <div id="results" class="row g-3 mb-5"></div>
                    </div>


                    <!-- COUNT -->
                    <div class="mb-3 text-muted" id="counter-section">
                        <small>
                            Hiển thị <span id="countShown">0</span> /
                            <span id="countTotal">0</span> sản phẩm
                        </small>
                    </div>

                    <div class="card shadow-sm" id="display-product">
                        <div class="card-header bg-white">
                            <ul class="nav nav-tabs card-header-tabs" id="searchTabs">

                                <li class="nav-item">
                                    <button class="nav-link active"
                                        data-bs-toggle="tab"
                                        data-bs-target="#tab-products">
                                        🛒 Sản phẩm
                                        <span class="badge bg-secondary ms-1"
                                            id="countProducts">0</span>
                                    </button>
                                </li>

                                <li class="nav-item">
                                    <button class="nav-link"
                                        data-bs-toggle="tab"
                                        data-bs-target="#tab-companies">
                                        🏢 Công ty
                                        <span class="badge bg-secondary ms-1"
                                            id="countCompanies">0</span>
                                    </button>
                                </li>

                                <li class="nav-item">
                                    <button class="nav-link"
                                        data-bs-toggle="tab"
                                        data-bs-target="#tab-places">
                                        📍 Địa điểm
                                        <span class="badge bg-secondary ms-1"
                                            id="countPlaces">0</span>
                                    </button>
                                </li>

                                <li class="nav-item">
                                    <button class="nav-link"
                                        data-bs-toggle="tab"
                                        data-bs-target="#tab-users">
                                        👤 Người dùng
                                        <span class="badge bg-secondary ms-1"
                                            id="countUsers">0</span>
                                    </button>
                                </li>

                            </ul>
                        </div>

                        <div class="card-body tab-content">

                            <!-- PRODUCTS -->
                            <div class="tab-pane fade show active" id="tab-products">

                                <!-- CATEGORY FILTER -->
                                <div class="mb-3">
                                    <div class="d-flex flex-wrap gap-2" id="productCategoryFilter">
                                        <button class="btn btn-sm btn-primary active"
                                            data-id="">
                                            Tất cả
                                        </button>
                                    </div>
                                </div>

                                <!-- PRODUCTS GRID -->
                                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4"
                                    id="productsGrid"></div>
                            </div>


                            <!-- COMPANIES -->
                            <div class="tab-pane fade" id="tab-companies">
                                <div class="list-group" id="companiesList"></div>
                            </div>

                            <!-- PLACES -->
                            <div class="tab-pane fade" id="tab-places">
                                <div class="list-group" id="placesList"></div>
                            </div>

                            <!-- USERS -->
                            <div class="tab-pane fade" id="tab-users">
                                <div class="list-group" id="usersList"></div>
                            </div>

                        </div>
                    </div>



                    <!-- PRODUCTS GRID -->
                    <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 my-5"
                        id="productsGrid">
                    </div>

                </main>
            </div>
        </div>
    </section>

    <!-- Footer-->
    <footer class="py-2 bg-dark position-static w-100" style="z-index: 99 !important;">
        <?php include './partials/footer.php'; ?>
    </footer>
    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="pm-name"></h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-4">
                        <!-- Ảnh -->
                        <div class="col-md-5 text-center">
                            <div id="pm-carousel" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner" id="pm-images"></div>

                                <button class="carousel-control-prev" type="button"
                                    data-bs-target="#pm-carousel" data-bs-slide="prev">
                                    <span class="carousel-control-prev-icon"></span>
                                </button>

                                <button class="carousel-control-next" type="button"
                                    data-bs-target="#pm-carousel" data-bs-slide="next">
                                    <span class="carousel-control-next-icon"></span>
                                </button>
                            </div>

                        </div>

                        <!-- Thông tin -->
                        <div class="col-md-7">
                            <h5 class="fw-bold mb-2" id="pm-name"></h5>
                            <p class="text-muted mb-3" id="pm-description"></p>

                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item px-0">
                                    <strong>Giá:</strong> <span id="pm-price"></span>
                                </li>
                                <li class="list-group-item px-0">
                                    <strong>Tồn kho:</strong> <span id="pm-stock"></span>
                                </li>
                                <li class="list-group-item px-0">
                                    <strong>Đơn vị:</strong> <span id="pm-unit"></span>
                                </li>
                                <li class="list-group-item px-0">
                                    <strong>Ngày tạo:</strong> <span id="pm-created"></span>
                                </li>
                                <li class="list-group-item px-0">
                                    <strong>Cập nhật:</strong> <span id="pm-updated"></span>
                                </li>
                            </ul>

                            <hr>

                            <!-- Địa điểm -->
                            <h6 class="fw-bold">📍 Địa điểm bán</h6>
                            <p class="mb-1"><strong>Tên:</strong> <span id="pm-place"></span></p>
                            <p class="mb-1"><strong>Địa chỉ:</strong> <span id="pm-address"></span></p>
                            <p class="mb-1"><strong>SĐT:</strong> <span id="pm-place-phone"></span></p>

                            <hr>

                            <!-- Chủ sở hữu -->
                            <h6 class="fw-bold">👤 Chủ sở hữu</h6>
                            <div id="pm-owner"></div>
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </div>
    <div class="modal fade" id="addToCartModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">🛒 Thêm vào giỏ hàng</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" id="cart-product-id">

                    <div class="mb-2 fw-bold" id="cart-product-name"></div>
                    <div class="text-muted mb-3">
                        Giá: <span id="cart-product-price"></span>
                    </div>

                    <label class="form-label">Số lượng</label>
                    <div class="input-group">
                        <button class="btn btn-outline-secondary" id="qty-minus">−</button>
                        <input type="number"
                            class="form-control text-center"
                            id="cart-qty"
                            value="1"
                            min="1">
                        <button class="btn btn-outline-secondary" id="qty-plus">+</button>
                    </div>

                    <small class="text-muted">
                        Tồn kho: <span id="cart-product-stock"></span>
                    </small>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">
                        Hủy
                    </button>
                    <button class="btn btn-primary" onclick="confirmAddToCart()">
                        ➕ Thêm vào giỏ
                    </button>
                </div>

            </div>
        </div>
    </div>

</body>

</html>
<script>
    let searchResult = {
        users: [],
        companies: [],
        places: [],
        categories: [],
        products: []
    };
    let productFilter = {
        category_id: ''
    };

    let products = [];
    let categories = [];
    let filters = {
        q: '',
        category_id: '',
        company: ''
    };

    async function renderProductCategories() {
        const wrap = $('#productCategoryFilter');
        wrap.empty();

        // Tất cả
        wrap.append(`
        <button class="btn btn-sm btn-primary active"
                data-id="">
            Tất cả
        </button>
    `);

        const res = await fetch('/api/categories');
        const json = await res.json();
        if (json.code !== 200) return;

        categories = json.data || [];

        categories.forEach(c => {
            wrap.append(`
            <button class="btn btn-sm btn-outline-primary"
                    data-id="${c.id}">
                ${escapeHtml(c.name)}
            </button>
        `);
        });

        // Click handler
        wrap.off('click').on('click', 'button', function() {
            $('#productCategoryFilter button')
                .removeClass('active btn-primary')
                .addClass('btn-outline-primary');

            $(this)
                .addClass('active btn-primary')
                .removeClass('btn-outline-primary');

            productFilter.category_id = $(this).data('id') || '';
            renderProducts();
        });
    }


    async function searchAll() {
        const q = $('#globalSearch').val().trim();

        const res = await fetch(`/api/search?q=${encodeURIComponent(q)}`);
        const json = await res.json();
        if (json.code !== 200) return;

        searchResult = json.data;

        renderUsers();
        renderCompanies();
        renderPlaces();
        renderProductCategories(); // 👈 thêm dòng này
        renderProducts();
        updateTabCounts();
    }




    $(document).ready(() => {
        searchAll();

        $('#globalSearch').on('input', debounce(() => {
            searchAll();
        }, 400));
    });

    function renderUsers() {
        const list = $('#usersList');
        list.empty();

        const users = searchResult.users || [];

        if (!users.length) {
            list.append(`
        <div class="text-muted text-center py-4">
            Không có người dùng
        </div>`);
            return;
        }

        users.forEach(u => {
            const badges = renderUserBadges(u.flags);
            const avatarUrl = `/api/media-proxy/avatars/${u.id}?size=40x40`;

            list.append(`
    <div class="list-group-item">
        <div class="d-flex justify-content-between align-items-start">

            <!-- LEFT: Avatar + Info -->
            <div class="d-flex align-items-start gap-3">

                <!-- Avatar -->
                <a href="/manage/user.php?id=${u.id}" target="_blank">
                    <img src="${avatarUrl}"
                         class="rounded-circle border"
                         width="40"
                         height="40"
                         style="object-fit:cover"
                         onerror="this.src='https://ui-avatars.com/api/?name=${encodeURIComponent(u.display_name || u.username)}&size=40'">
                </a>

                <!-- Info -->
                <div>
                    <div class="fw-bold d-flex align-items-center gap-1">
                        ${escapeHtml(u.display_name)}
                        ${badges}
                    </div>
                    <div class="small text-muted">
                        ${escapeHtml(u.email)}
                    </div>
                </div>
            </div>

            <!-- RIGHT: Actions -->
            <div class="d-flex gap-2">
                <button class="btn btn-sm btn-outline-primary"
                    onclick="window.open('/message.php?chat_to=${u.id}', '_blank')">
                    💬 Nhắn tin
                </button>

                <a class="btn btn-sm btn-outline-secondary"
                   href="/manage/user.php?id=${u.id}"
                   target="_blank">
                    👤 Profile
                </a>
            </div>

        </div>
    </div>
    `);
        });

    }



    function renderCompanies() {
        const list = $('#companiesList');
        list.empty();

        const companies = searchResult.companies || [];

        if (!companies.length) {
            list.append(`<div class="text-muted text-center py-4">
            Không có công ty
        </div>`);
            return;
        }

        companies.forEach(c => {
            list.append(`
        <a class="list-group-item list-group-item-action"
           href="/manage/company.php?id=${c.id}">
            <div class="fw-bold">${escapeHtml(c.name)}</div>
            <div class="small text-muted">${escapeHtml(c.address || '')}</div>
        </a>
        `);
        });
    }


    function renderPlaces() {
        const list = $('#placesList');
        list.empty();

        const places = searchResult.places || [];

        if (!places.length) {
            list.append(`<div class="text-muted text-center py-4">
            Không có địa điểm
        </div>`);
            return;
        }

        places.forEach(p => {
            const gmapQuery = encodeURIComponent(p.address || p.name);

            list.append(`
    <div class="list-group-item">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <div class="fw-bold">${escapeHtml(p.name)}</div>
                <div class="small text-muted">
                    ${escapeHtml(p.address || '—')}
                </div>
            </div>
        </div>

        <div class="mt-2 d-flex gap-2 flex-wrap">
            <button class="btn btn-sm btn-outline-primary"
                onclick="window.location.href='/manage/place.php?id=${p.id}'">
                📄 Xem chi tiết
            </button>

            <a class="btn btn-sm btn-outline-success"
               href="/map.php?place_id=${p.id}"
               target="_blank">
                🗺️ Xem trên bản đồ
            </a>


            <a class="btn btn-sm btn-outline-secondary"
               href="https://www.google.com/maps?q=${p.latitude},${p.longitude}"
               target="_blank" rel="noopener">
                🌍 Google Maps
            </a>
        </div>
    </div>
    `);
        });

    }



    async function loadCategories() {
        const res = await fetch('/api/search?category=categories');
        const json = await res.json();
        if (json.code !== 200) return;

        categories = json.data.categories || [];

        const $list = $('#categoryList');

        categories.forEach(c => {
            $list.append(`
            <button
                class="list-group-item list-group-item-action"
                data-id="${c.id}">
                ${escapeHtml(c.name)}
            </button>
        `);
        });

        // click handler
        $('#categoryList').on('click', '.list-group-item', function() {
            $('#categoryList .list-group-item').removeClass('active');
            $(this).addClass('active');

            filters.category_id = $(this).data('id') || '';
            loadProducts();
        });
    }


    function renderProducts() {
        const grid = $('#productsGrid');
        grid.empty();

        let products = searchResult.products || [];

        // FILTER BY CATEGORY
        if (productFilter.category_id) {
            products = products.filter(p =>
                p.category_id === productFilter.category_id
            );
        }

        $('#countTotal').text(searchResult.products.length);
        $('#countShown').text(products.length);

        if (!products.length) {
            grid.append(`
            <div class="col-12 text-muted text-center">
                Không có sản phẩm phù hợp
            </div>
        `);
            return;
        }

        products.forEach(p => {
            grid.append(`
        <div class="col mb-4">
            <div class="card h-100">
                <img class="card-img-top"
                     src="${p.files[0]?.id ? `/api/media-proxy/product_images/${p.id}/${p.files?.find(x=>x.order == 0)?.id}` : `https://dummyimage.com/600x400/dee2e6/6c757d.jpg`}">
                <div class="card-body text-center">
                    <h6 class="fw-bold">${escapeHtml(p.name)}</h6>
                    <div class="text-muted">
                        ${p.price.toLocaleString()} ₫ / ${p.unit_type}
                    </div>
                </div>
                <div class="card-footer bg-transparent border-0 text-center">
                    <button data-require-login class="btn btn-sm btn-primary"
                        onclick="openAddToCart('${p.id}')">
                        🛒 Mua
                    </button>
                    <button class="btn btn-sm btn-outline-dark"
                        onclick="openProduct('${p.id}')">
                        Xem
                    </button>
                </div>
            </div>
        </div>
        `);
        });
    }



    async function openProduct(id) {
        const res = await fetch(`/api/products/${id}`);
        const json = await res.json();

        if (json.code !== 200) {
            alert('Không tải được sản phẩm');
            return;
        }

        const p = json.data;

        // === Sản phẩm ===
        $('#pm-name').text(p.name);
        $('#pm-description').text(p.description || '—');
        $('#pm-price').text(p.price.toLocaleString() + ' ₫');
        $('#pm-stock').text(p.stock);
        $('#pm-unit').text(p.unit_type);
        $('#pm-created').text(new Date(p.created_at).toLocaleString());
        $('#pm-updated').text(new Date(p.modified_at).toLocaleString());

        // === Ảnh ===
        // === Ảnh ===
        const imagesWrap = $('#pm-images');
        imagesWrap.empty();

        if (p.files && p.files.length) {
            p.files.forEach((f, i) => {
                imagesWrap.append(`
            <div class="carousel-item ${i === 0 ? 'active' : ''}">
                <img src="/api/media-proxy/product_images/${p.id}/${f.id}"
                     class="d-block w-100 rounded"
                     style="object-fit:contain;max-height:400px">
            </div>
        `);
            });
        } else {
            imagesWrap.append(`
        <div class="carousel-item active">
            <img src="https://dummyimage.com/600x400/dee2e6/6c757d.jpg"
                 class="d-block w-100 rounded">
        </div>
    `);
        }


        // === Địa điểm ===
        $('#pm-place').text(p.place?.name || '—');
        $('#pm-address').text(p.place?.address || '—');
        $('#pm-place-phone').text(p.place?.phone || '—');

        // === Chủ sở hữu ===
        let ownerHtml = '<span class="text-muted">Không xác định</span>';

        if (p.place?.company) {
            const c = p.place.company;
            ownerHtml = `
            <div class="border rounded p-2">
                <div><strong>Công ty:</strong> ${escapeHtml(c.name)}</div>
                <a class="btn btn-sm btn-outline-primary mt-2"
                   href="/manage/company.php?id=${c.id}" target="_blank">
                    Xem công ty
                </a>
            </div>
        `;
        } else if (p.place?.user) {
            const u = p.place.user;
            ownerHtml = `
            <div class="border rounded p-2">
                <div><strong>Cá nhân:</strong> ${escapeHtml(u.display_name)}</div>
                <div class="text-muted small">${escapeHtml(u.email)}</div>
                <a class="btn btn-sm btn-outline-primary mt-2"
                   href="/manage/user.php?id=${u.id}" target="_blank">
                    Xem người dùng
                </a>
            </div>
        `;
        }

        $('#pm-owner').html(ownerHtml);

        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('productModal'));
        modal.show();
    }

    function renderCategories() {
        const $list = $('#categoryList');
        $list.empty();

        $list.append(`
        <button class="list-group-item active">
            Tất cả danh mục
        </button>
    `);

        categories.forEach(c => {
            $list.append(`
            <button class="list-group-item">
                ${escapeHtml(c.name)}
            </button>
        `);
        });
    }

    function updateTabCounts() {
        $('#countProducts').text(searchResult.products?.length || 0);
        $('#countCompanies').text(searchResult.companies?.length || 0);
        $('#countPlaces').text(searchResult.places?.length || 0);
        $('#countUsers').text(searchResult.users?.length || 0);
    }
    let selectedProduct = null;

    async function openAddToCart(productId) {
        const res = await fetch(`/api/products/${productId}`);
        const json = await res.json();
        if (json.code !== 200) {
            alert('Không tải được sản phẩm');
            return;
        }

        selectedProduct = json.data;

        $('#cart-product-id').val(selectedProduct.id);
        $('#cart-product-name').text(selectedProduct.name);
        $('#cart-product-price').text(
            selectedProduct.price.toLocaleString() + ' ₫ / ' + selectedProduct.unit_type
        );
        $('#cart-product-stock').text(selectedProduct.stock);
        $('#cart-qty').val(1);

        new bootstrap.Modal('#addToCartModal').show();
    }

    /* +/- quantity */
    $('#qty-minus').click(() => {
        let v = parseInt($('#cart-qty').val());
        if (v > 1) $('#cart-qty').val(v - 1);
    });

    $('#qty-plus').click(() => {
        let v = parseInt($('#cart-qty').val());
        if (v < selectedProduct.stock) $('#cart-qty').val(v + 1);
    });

    /* Confirm add */
    async function confirmAddToCart() {
        const qty = parseInt($('#cart-qty').val());

        if (!qty || qty <= 0) {
            alert('Số lượng không hợp lệ');
            return;
        }

        if (qty > selectedProduct.stock) {
            alert('Vượt quá tồn kho');
            return;
        }

        await addProductToCart(selectedProduct.id, qty);

        bootstrap.Modal.getInstance(
            document.getElementById('addToCartModal')
        ).hide();

        // UX
        alert('✅ Đã thêm vào giỏ hàng');
    }
</script>