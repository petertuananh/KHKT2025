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



                    <h1 class="h3 mb-4 text-gray-800">Chi tiết doanh nghiệp</h1>

                    <div id="company-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-warning" id="btn-edit">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </button>
                        <button class="btn btn-sm btn-danger" id="btn-delete">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                    </div>
                    <div id="company-edit-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-success" id="btn-save">
                            <i class="fas fa-save"></i> Lưu
                        </button>
                        <button class="btn btn-sm btn-secondary" id="btn-cancel">
                            Hủy
                        </button>
                    </div>



                    <!-- Thông tin công ty -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Thông tin chung</h6>
                        </div>

                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p>
                                        <strong>Tên công ty:</strong>
                                        <span class="view-mode" id="c-name"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-name"
                                            data-field="name">
                                    </p>

                                    <p>
                                        <strong>Mã số thuế:</strong>
                                        <span class="view-mode" id="c-tax_id"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-tax_id"
                                            data-field="tax_id">
                                    </p>

                                    <p>
                                        <strong>Địa chỉ:</strong>
                                        <span class="view-mode" id="c-address"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-address"
                                            data-field="address">
                                    </p>

                                    <p>
                                        <strong>Email:</strong>
                                        <span class="view-mode" id="c-email"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-email"
                                            data-field="email">
                                    </p>

                                    <p>
                                        <strong>Điện thoại:</strong>
                                        <span class="view-mode" id="c-phone"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-phone"
                                            data-field="phone">
                                    </p>

                                    <p>
                                        <strong>Website:</strong>
                                        <span class="view-mode" id="c-website"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-website"
                                            data-field="website">
                                    </p>
                                </div>

                                <div class="col-md-6">
                                    <p>
                                        <strong>Tên nước ngoài:</strong>
                                        <span class="view-mode" id="c-international"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-international"
                                            data-field="international_name">
                                    </p>

                                    <p>
                                        <strong>Tên viết tắt:</strong>
                                        <span class="view-mode" id="c-short"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-short"
                                            data-field="short_name">
                                    </p>

                                    <p>
                                        <strong>Trạng thái:</strong>
                                        <span id="c-active"></span>
                                    </p>

                                    <p>
                                        <strong>Xác minh:</strong>
                                        <span id="c-verified"></span>
                                    </p>

                                    <p>
                                        <strong>Ngày tạo:</strong>
                                        <span id="c-created"></span>
                                    </p>

                                    <p>
                                        <strong>Cập nhật:</strong>
                                        <span id="c-updated"></span>
                                    </p>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Owner -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Chủ sở hữu doanh nghiệp</h6>
                        </div>
                        <div class="card-body" id="owner-info">
                            <!-- render bằng JS -->
                        </div>
                    </div>

                    <!-- COMPANY WALLET -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-success">
                                💼 Ví doanh nghiệp
                            </h6>
                        </div>
                        <div class="card-body text-center">
                            <div class="text-muted mb-2">Số dư hiện tại</div>

                            <h2 class="font-weight-bold text-success" id="company-balance">
                                -- ₫
                            </h2>

                            <hr>

                            <small class="text-muted">
                                Số dư dùng để nhận thanh toán & giao dịch trong hệ thống
                            </small>
                        </div>
                    </div>

                    <!-- Places -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">Địa điểm của công ty</h6>

                            <button id="btn-add-place"
                                class="btn btn-sm btn-primary d-none">
                                <i class="fas fa-plus"></i> Thêm địa điểm
                            </button>
                        </div>

                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Tên</th>
                                            <th>Địa chỉ</th>
                                            <th>Điện thoại</th>
                                            <th width="120">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="placesTable"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>


                    <!-- COMPANY TRANSACTIONS -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">
                                📜 Lịch sử giao dịch của công ty
                            </h6>

                            <button class="btn btn-sm btn-outline-secondary"
                                onclick="loadCompanyTransactions()">
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

                                    <tbody id="company-tx-list">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">
                                                Đang tải dữ liệu...
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="p-3 d-flex justify-content-center">
                                    <nav>
                                        <ul class="pagination mb-0" id="company-tx-pagination"></ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>

            </div>

            <?php include './partials/footer.php'; ?>
        </div>
    </div>
    <div class="modal fade" id="addPlaceModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Thêm địa điểm</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="form-group">
                        <label>Tên địa điểm</label>
                        <input id="p-name" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input id="p-address" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Điện thoại</label>
                        <input id="p-phone" class="form-control">
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button class="btn btn-primary" id="btn-save-place">
                        <i class="fas fa-save"></i> Lưu
                    </button>
                </div>

            </div>
        </div>
    </div>

</body>

</html>
<script>
    let currentCompany = null;
    let currentUser = null;
    let isEditing = false;
    let companyTxPage = 1
    const companyTxLimit = 20




    $(document).ready(async function() {
        const companyId = getQuery('id');
        if (!companyId) return;

        try {
            await waitForUser();
            // 2. Lấy công ty

            const res = await fetch(`/api/companies/${companyId}`, {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });
            const json = await res.json();
            if (json.code !== 200) return;

            currentCompany = json.data;
            renderCompany(currentCompany);

            // 3. Check owner
            if ((currentCompany.owned_by === window.user.id) || (window.user.flags?.includes('ADMIN'))) {
                $('#company-actions').removeClass('d-none');
                $('#btn-add-place').removeClass('d-none');
            }


        } catch (e) {
            console.error(e);
        }
    });
    $('#btn-edit').on('click', function() {
        if (!currentCompany) return;

        isEditing = true;
        enterEditMode();
    });

    function enterEditMode() {
        isEditing = true;

        $('#company-actions').addClass('d-none');
        $('#company-edit-actions').removeClass('d-none');

        $('.view-mode').addClass('d-none');
        $('.edit-mode').removeClass('d-none');
    }



    function replaceWithInput(selector, field) {
        const value = currentCompany[field] || '';
        const $el = $(selector);

        $el.replaceWith(`
        <input 
            class="form-control form-control-sm mb-2"
            id="${selector.substring(1)}"
            data-field="${field}"
            value="${escapeHtml(value)}"
        >
    `);
    }

    $('#btn-save').on('click', async function() {
        const updateData = {};

        $('.edit-mode[data-field]').each(function() {
            const field = $(this).data('field');
            const val = $(this).val().trim();

            if (val !== (currentCompany[field] || '')) {
                updateData[field] = val;
            }
        });

        if (!Object.keys(updateData).length) {
            alert('Không có thay đổi');
            return;
        }

        try {
            const res = await fetch(`/api/companies/${currentCompany.id}`, {
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

            currentCompany = json.data;
            exitEditMode();
            renderCompany(currentCompany);

            alert('Đã cập nhật doanh nghiệp');

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });


    $('#btn-cancel').on('click', function() {
        exitEditMode();
        renderCompany(currentCompany);
    });

    function exitEditMode() {
        isEditing = false;

        $('#company-edit-actions').addClass('d-none');
        $('#company-actions').removeClass('d-none');

        $('.edit-mode').addClass('d-none');
        $('.view-mode').removeClass('d-none');
    }




    $('#btn-delete').on('click', async function() {
        if (!confirm('Bạn có chắc chắn muốn xóa doanh nghiệp này?')) return;

        try {
            const res = await fetch(`/api/companies/${currentCompany.id}`, {
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

            alert('Đã xóa doanh nghiệp');
            window.location.href = '/manage/companies.php';

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });

    async function reloadCompany() {
        const res = await fetch(`/api/companies/${currentCompany.id}`, {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) {
            alert('Không thể tải lại dữ liệu công ty');
            return;
        }

        currentCompany = json.data;
        renderCompany(currentCompany);
    }



    function renderCompany(c) {
        /* ========= LEFT ========= */

        $('#c-name').text(c.name || '—');
        $('#i-name').val(c.name || '');

        $('#c-tax_id').text(c.tax_id || '—');
        $('#i-tax_id').val(c.tax_id || '');


        $('#c-address').text(c.address || '—');
        $('#i-address').val(c.address || '');

        $('#c-email').text(c.email || '—');
        $('#i-email').val(c.email || '');

        $('#c-phone').text(c.phone || '—');
        $('#i-phone').val(c.phone || '');

        if (c.website) {
            $('#c-website').html(
                `<a href="${escapeHtml(c.website)}" target="_blank">${escapeHtml(c.website)}</a>`
            );
        } else {
            $('#c-website').text('—');
        }
        $('#i-website').val(c.website || '');

        /* ========= RIGHT ========= */

        $('#c-international').text(c.international_name || '—');
        $('#i-international').val(c.international_name || '');

        $('#c-short').text(c.short_name || '—');
        $('#i-short').val(c.short_name || '');

        $('#c-active').html(
            c.is_active ?
            '<span class="badge badge-success">Hoạt động</span>' :
            '<span class="badge badge-secondary">Tạm dừng</span>'
        );

        $('#c-verified').html(
            c.is_verified ?
            '<span class="badge badge-info">Đã xác minh</span>' :
            '<span class="badge badge-warning">Chưa xác minh</span>'
        );

        $('#c-created').text(
            c.created_at ? new Date(c.created_at).toLocaleString() : '—'
        );

        $('#c-updated').text(
            c.modified_at ? new Date(c.modified_at).toLocaleString() : '—'
        );
        renderOwner(c.owner);
        renderPlaces(c.places || []);
        loadCompanyWallet();
        loadCompanyTransactions();
    }
    async function loadCompanyWallet() {
        if (!currentCompany) return

        const res = await fetch(`/api/companies/${currentCompany.id}`, {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        })

        const json = await res.json()
        if (json.code !== 200) return

        document.getElementById('company-balance').innerText =
            Number(json.data.balance || 0).toLocaleString() + ' ₫'
    }



    function renderOwner(owner) {
        if (!owner) {
            $('#owner-info').html(
                `<p class="text-muted mb-0">Không có thông tin chủ sở hữu</p>`
            );
            return;
        }

        $('#owner-info').html(`
        <div class="row align-items-center">
            <div class="col-md-8">
                <p class="mb-1">
                    <strong>ID:</strong>
                    ${escapeHtml(owner.id)}
                </p>
                <p class="mb-1">
                    <strong>Tên hiển thị:</strong>
                    ${escapeHtml(owner.display_name || owner.username)}
                </p>

                <p class="mb-1">
                    <strong>Tên đăng nhập:</strong>
                    ${escapeHtml(owner.username)}
                </p>

                <p class="mb-1">
                    <strong>Email:</strong>
                    ${owner.email || '—'}
                </p>

                <p class="mb-1">
                    <strong>Điện thoại:</strong>
                    ${owner.phone_number || '—'}
                </p>

                <p class="mb-0">
                    <strong>Trạng thái:</strong>
                    ${
                        owner.status === 'online'
                            ? '<span class="badge badge-success">Online</span>'
                            : '<span class="badge badge-secondary">Offline</span>'
                    }
                </p>

                <p class="small text-muted mt-2 mb-0">
                    Hoạt động lần cuối:
                    ${owner.last_active_at
                        ? new Date(owner.last_active_at).toLocaleString()
                        : '—'}
                </p>
            </div>

            <div class="col-md-4 text-right">
                <a href="/manage/user.php?id=${owner.id}"
                   class="btn btn-sm btn-outline-primary">
                    <i class="fas fa-user"></i> Xem profile
                </a>
            </div>
        </div>
    `);
    }

    function renderPlaces(places) {
        const $tbody = $('#placesTable');
        $tbody.empty();

        if (!places.length) {
            $tbody.append(`
            <tr>
                <td colspan="4" class="text-center text-muted">
                    Chưa có địa điểm
                </td>
            </tr>
        `);
            return;
        }

        places.forEach(p => {
            const hasLocation = p.latitude && p.longitude;

            $tbody.append(`
        <tr>
            <td>
                <a href="/manage/place.php?id=${p.id}">
                    ${escapeHtml(p.name)}
                </a>
            </td>
            <td>${escapeHtml(p.address || '—')}</td>
            <td>${escapeHtml(p.phone || '—')}</td>
            <td class="text-center">
                ${hasLocation ? `
                    <button class="btn btn-sm btn-outline-success me-1"
                        onclick="openGoogleMaps('${p.latitude}', '${p.longitude}')">
                        <i class="fas fa-map-marked-alt"></i>
                    </button>
                ` : ''}

                <button class="btn btn-sm btn-danger"
                    onclick="deletePlace('${p.id}')">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `);
        });

    }

    function openGoogleMaps(lat, lng) {
        window.open(`https://www.google.com/maps?q=${lat},${lng}`, '_blank');
    }

    $('#btn-add-place').on('click', () => {
        $('#p-name, #p-address, #p-phone').val('');
        $('#addPlaceModal').modal('show');
    });

    $('#btn-save-place').on('click', async function() {
        const name = $('#p-name').val().trim();
        if (!name) {
            alert('Tên địa điểm là bắt buộc');
            return;
        }

        try {
            const res = await fetch('/api/places', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: 'Bearer ' + getCookie('auth_token')
                },
                body: JSON.stringify({
                    name,
                    address: $('#p-address').val().trim(),
                    phone: $('#p-phone').val().trim(),
                    company_id: currentCompany.id
                })
            });

            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Thêm địa điểm thất bại');
                return;
            }

            // ✅ đóng modal
            $('#addPlaceModal').modal('hide');

            // ✅ clear form
            $('#p-name, #p-address, #p-phone').val('');

            // ✅ reload lại company + places
            await reloadCompany();

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });

    async function deletePlace(placeId) {
        if (!confirm('Xóa địa điểm này?')) return;

        try {
            const res = await fetch(`/api/places/${placeId}`, {
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

            // ✅ reload lại company + places
            await reloadCompany();

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    }
    async function loadCompanyTransactions(page = 1) {
        if (!currentCompany) return

        const tbody = document.getElementById('company-tx-list')
        tbody.innerHTML = `
        <tr>
            <td colspan="7" class="text-center text-muted py-4">
                Đang tải dữ liệu...
            </td>
        </tr>
    `

        const res = await fetch(
            `/api/companies/${currentCompany.id}/transactions?page=${page}&limit=${companyTxLimit}`, {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            }
        )

        const json = await res.json()
        console.log(json)

        if (json.code !== 200 || !json.data.length) {
            tbody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center text-muted py-4">
                    Chưa có giao dịch nào
                </td>
            </tr>
        `
            return
        }

        tbody.innerHTML = ''

        json.data.forEach(tx => {
            const amount = Number(tx.amount)
            const isMinus = ['withdraw', 'payment'].includes(tx.type)

            tbody.innerHTML += `
        <tr>
            <td>${new Date(tx.created_at).toLocaleString()}</td>
            <td>${formatType(tx.type)}</td>
            <td class="font-weight-bold ${tx.status === 'finished'
                ? (isMinus ? 'text-danger' : 'text-success')
                : ''}">
                ${tx.status === 'finished'
                    ? (isMinus ? '-' : '+')
                    : ''}${amount.toLocaleString()} ₫
            </td>
            <td>${renderCompanyTarget(tx)}</td>
            <td>${formatStatus(tx.status)}</td>
            <td class="text-muted">${tx.note || '-'}</td>
            <td>${renderCompanyActions(tx)}</td>
        </tr>
        `
        })

        renderCompanyPagination(json.data.pagination)
    }

    function renderCompanyTarget(tx) {
        if (tx.from_user) {
            return `
            👤 ${tx.from_user.display_name}
            <br>
            <a href="/manage/user.php?id=${tx.from_user.id}"
               class="btn btn-sm btn-outline-primary mt-1">
                Xem người gửi
            </a>
        `
        }

        if (tx.to_user) {
            return `
            👤 ${tx.to_user.display_name}
            <br>
            <a href="/manage/user.php?id=${tx.to_user.id}"
               class="btn btn-sm btn-outline-info mt-1">
                Xem người nhận
            </a>
        `
        }

        return `<span class="text-muted">-</span>`
    }

    function renderCompanyActions(tx) {
        let html = ''

        if (tx.order) {
            html += `
            <a href="/manage/order.php?id=${tx.order.id}"
               class="btn btn-sm btn-outline-secondary mb-1">
                📦 Xem đơn
            </a><br>
        `
        }

        return html || '<span class="text-muted">-</span>'
    }

    function renderCompanyPagination(pagination) {
        const ul = document.getElementById('company-tx-pagination')
        ul.innerHTML = ''

        const {
            page,
            total_pages
        } = pagination
        if (total_pages <= 1) return

        for (let i = 1; i <= total_pages; i++) {
            ul.innerHTML += `
            <li class="page-item ${i === page ? 'active' : ''}">
                <a class="page-link"
                   href="javascript:void(0)"
                   onclick="loadCompanyTransactions(${i})">
                    ${i}
                </a>
            </li>
        `
        }
    }
</script>