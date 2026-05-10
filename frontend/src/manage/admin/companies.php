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

                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Quản lý doanh nghiệp</h1>
                    </div>

                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <div class="row mb-3 align-items-center">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <input type="text"
                                            id="companySearch"
                                            class="form-control"
                                            placeholder="Tìm doanh nghiệp (tên, MST, email, SĐT...)">
                                        <div class="input-group-append">
                                            <span class="input-group-text">
                                                <i class="fas fa-search"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6 text-right">
                                    <small class="text-muted">
                                        Hiển thị <span id="countShown">0</span> / <span id="countTotal">0</span>
                                    </small>
                                </div>
                            </div>

                            <table class="table table-bordered" id="companiesTable">
                                <thead>
                                    <tr>
                                        <th>Doanh nghiệp</th>
                                        <th>Liên hệ</th>
                                        <th>Trạng thái</th>
                                        <th>Thời gian</th>
                                        <th width="220">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>

            <?php include '../partials/footer.php'; ?>
        </div>
    </div>

    <!-- MODAL -->
    <div class="modal fade" id="editCompanyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa doanh nghiệp</h5>
                    <button class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <input type="hidden" id="c-id">

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label>Tên doanh nghiệp</label>
                            <input id="c-name" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Tên viết tắt</label>
                            <input id="c-short" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Tên quốc tế</label>
                            <input id="c-international" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Mã số thuế</label>
                            <input id="c-tax" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Email</label>
                            <input id="c-email" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Điện thoại</label>
                            <input id="c-phone" class="form-control">
                        </div>

                        <div class="col-12 form-group">
                            <label>Website</label>
                            <input id="c-website" class="form-control">
                        </div>

                        <div class="col-12 form-group">
                            <label>Địa chỉ</label>
                            <input id="c-address" class="form-control">
                        </div>

                        <div class="col-12 form-group">
                            <label>Mô tả</label>
                            <textarea id="c-description" class="form-control"></textarea>
                        </div>

                        <div class="col-12 form-group">
                            <label>
                                <input type="checkbox" id="c-active"> Hoạt động
                            </label>
                            <label class="ml-3">
                                <input type="checkbox" id="c-verified"> Đã xác minh
                            </label>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-danger" id="btn-delete-company">Xóa</button>
                    <button class="btn btn-primary" id="btn-save-company">Lưu</button>
                </div>

            </div>
        </div>
    </div>

</body>

</html>

<script>
    let companies = [];
    let filteredCompanies = [];

    $(document).ready(() => {
        loadCompanies();

        $('#companySearch').on('input', function() {
            const q = $(this).val().toLowerCase().trim();

            filteredCompanies = companies.filter(c =>
                (c.name || '').toLowerCase().includes(q) ||
                (c.short_name || '').toLowerCase().includes(q) ||
                (c.tax_id || '').toLowerCase().includes(q) ||
                (c.email || '').toLowerCase().includes(q) ||
                (c.phone || '').toLowerCase().includes(q) ||
                (c.address || '').toLowerCase().includes(q)
            );

            renderCompanies();
        });
    });

    async function loadCompanies() {
        const res = await fetch('/api/companies', {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return alert('Không tải được doanh nghiệp');

        companies = json.data;
        filteredCompanies = companies;

        $('#countTotal').text(companies.length);
        renderCompanies();
    }

    function renderCompanies() {
        const $tb = $('#companiesTable tbody');
        $tb.empty();

        filteredCompanies.forEach(c => {
            $tb.append(`
        <tr>
            <td>
                <strong>${escapeHtml(c.name)}</strong><br>
                <small class="text-muted">${escapeHtml(c.short_name || '')}</small>
            </td>

            <td>
                ${c.email ? `<div><i class="fas fa-envelope"></i> ${escapeHtml(c.email)}</div>` : ''}
                ${c.phone ? `<div><i class="fas fa-phone"></i> ${escapeHtml(c.phone)}</div>` : ''}
            </td>

            <td>
                <span class="badge badge-${c.is_active ? 'success' : 'secondary'}">
                    ${c.is_active ? 'Hoạt động' : 'Tạm dừng'}
                </span>
                ${c.is_verified
                    ? '<span class="badge badge-info ml-1">Verified</span>'
                    : '<span class="badge badge-warning ml-1">Chưa xác minh</span>'}
            </td>

            <td>
                <div><small>Tạo: ${formatDate(c.created_at)}</small></div>
                <div><small>Cập nhật: ${formatDate(c.modified_at)}</small></div>
            </td>

            <td>
                <button class="btn btn-sm btn-info mb-1"
                    onclick="window.open('/manage/company.php?id=${c.id}', '_blank')">
                    <i class="fas fa-eye"></i> Xem
                </button>

                <button class="btn btn-sm btn-warning mb-1"
                    onclick="openEditCompany('${c.id}')">
                    <i class="fas fa-edit"></i> Edit
                </button>
            </td>
        </tr>
        `);
        });

        // 👇 cập nhật bộ đếm
        $('#countShown').text(filteredCompanies.length);
    }


    function formatDate(d) {
        return new Date(d).toLocaleString('vi-VN');
    }
</script>
<script>
    function openEditCompany(id) {
        const c = companies.find(x => x.id === id);
        if (!c) return;

        $('#c-id').val(c.id);
        $('#c-name').val(c.name);
        $('#c-short').val(c.short_name || '');
        $('#c-international').val(c.international_name || '');
        $('#c-tax').val(c.tax_id || '');
        $('#c-email').val(c.email || '');
        $('#c-phone').val(c.phone || '');
        $('#c-website').val(c.website || '');
        $('#c-address').val(c.address || '');
        $('#c-description').val(c.description || '');

        $('#c-active').prop('checked', c.is_active);
        $('#c-verified').prop('checked', c.is_verified);

        $('#editCompanyModal').modal('show');
    }

    $('#btn-save-company').click(async () => {
        const id = $('#c-id').val();

        const res = await fetch(`/api/companies/${id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                name: $('#c-name').val(),
                short_name: $('#c-short').val(),
                international_name: $('#c-international').val(),
                tax_id: $('#c-tax').val(),
                email: $('#c-email').val(),
                phone: $('#c-phone').val(),
                website: $('#c-website').val(),
                address: $('#c-address').val(),
                description: $('#c-description').val(),
                is_active: $('#c-active').is(':checked'),
                is_verified: $('#c-verified').is(':checked')
            })
        });

        const json = await res.json();
        if (json.code !== 200) return alert(json.msg || 'Lỗi');

        $('#editCompanyModal').modal('hide');
        loadCompanies();
    });

    $('#btn-delete-company').click(async () => {
        if (!confirm('Xóa doanh nghiệp này?')) return;

        const id = $('#c-id').val();
        const res = await fetch(`/api/companies/${id}`, {
            method: 'DELETE',
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return alert(json.msg);

        $('#editCompanyModal').modal('hide');
        loadCompanies();
    });
</script>