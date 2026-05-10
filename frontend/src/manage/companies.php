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

                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Doanh nghiệp</h1>
                        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                                class="fas fa-download fa-sm text-white-50"></i> Generate Report</a>
                        <button class="btn btn-sm btn-primary shadow-sm"
                            data-toggle="modal"
                            data-target="#addCompanyModal">

                            <i class="fas fa-plus fa-sm text-white-50"></i> Thêm doanh nghiệp
                        </button>
                    </div>


                    <!-- Content Row -->
                    <table class="table table-bordered" id="companiesTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Tên công ty</th>
                                <th>Địa chỉ</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Website</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>


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
    <div class="modal fade" id="addCompanyModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Thêm doanh nghiệp mới</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <form id="addCompanyForm">
                        <div class="form-row">

                            <div class="form-group col-md-6">
                                <label>Tên công ty *</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>

                            <div class="form-group col-md-6">
                                <label>Tên rút gọn</label>
                                <input type="text" class="form-control" name="short_name">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Mã số thuế</label>
                                <input type="text" class="form-control" name="tax_id">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Email</label>
                                <input type="email" class="form-control" name="email">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Điện thoại</label>
                                <input type="text" class="form-control" name="phone">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Website</label>
                                <input type="url" class="form-control" name="website">
                            </div>

                            <div class="form-group col-12">
                                <label>Địa chỉ</label>
                                <input type="text" class="form-control" name="address">
                            </div>

                            <div class="form-group col-12">
                                <label>Mô tả</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>
                            </div>

                        </div>
                    </form>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Huỷ</button>
                    <button type="button" class="btn btn-primary" id="submitAddCompany">
                        <i class="fas fa-save"></i> Lưu
                    </button>
                </div>

            </div>
        </div>
    </div>


</body>

</html>
<script>
    $(document).ready(async function() {
        try {
            const res = await fetch('/api/users/@me', {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });

            const json = await res.json();
            if (json.code !== 200) return;

            renderCompanies(json.data.companies || []);
        } catch (e) {
            console.error(e);
        }
    });
</script>

<script>
    function renderCompanies(companies) {
        const $tbody = $('#companiesTable tbody');
        $tbody.empty();

        if (!companies.length) {
            $tbody.append(`
            <tr>
                <td colspan="6" class="text-center text-muted">
                    Bạn chưa có doanh nghiệp nào
                </td>
            </tr>
        `);
            return;
        }

        companies.forEach(c => {
            $tbody.append(`
            <tr class="company-row" data-id="${c.id}" style="cursor:pointer">
                <td>${escapeHtml(c.name)}</td>
                <td>${escapeHtml(c.address || '')}</td>
                <td>${escapeHtml(c.email || '')}</td>
                <td>${escapeHtml(c.phone || '')}</td>
                <td>
                    ${c.website ? `<a href="${c.website}" target="_blank">${c.website}</a>` : ''}
                </td>
                <td>
                    ${c.is_active 
                        ? '<span class="badge badge-success">Hoạt động</span>'
                        : '<span class="badge badge-secondary">Tạm dừng</span>'
                    }
                </td>
            </tr>
        `);
        });
    }
</script>

<script>
    $(document).on('click', '.company-row', function() {
        const id = $(this).data('id');
        window.location.href = `/manage/company.php?id=${id}`;
    });
</script>
<script>
    $('#submitAddCompany').on('click', async function() {
        const form = document.getElementById('addCompanyForm');
        const formData = new FormData(form);

        const payload = {};
        formData.forEach((v, k) => {
            if (v !== '') payload[k] = v;
        });

        if (!payload.name) {
            alert('Tên công ty là bắt buộc');
            return;
        }

        try {
            const res = await fetch('/api/companies', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + getCookie('auth_token')
                },
                body: JSON.stringify(payload)
            });

            const json = await res.json();

            if (json.code !== 201) {
                alert(json.msg || 'Tạo doanh nghiệp thất bại');
                return;
            }

            // Đóng modal
            $('#addCompanyModal').modal('hide');
            form.reset();

            // Reload danh sách
            const meRes = await fetch('/api/users/@me', {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });
            const meJson = await meRes.json();
            renderCompanies(meJson.data.companies || []);

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });
</script>