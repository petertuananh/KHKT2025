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

                    <h1 class="h3 mb-4 text-gray-800">Hồ sơ người dùng</h1>

                    <!-- ACTIONS -->
                    <div id="user-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-warning" id="btn-edit">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </button>
                    </div>

                    <div id="user-edit-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-success" id="btn-save">
                            <i class="fas fa-save"></i> Lưu
                        </button>
                        <button class="btn btn-sm btn-secondary" id="btn-cancel">
                            Hủy
                        </button>
                    </div>

                    <!-- USER INFO -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Thông tin cá nhân</h6>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-3 text-center">

                                    <img id="u-avatar"
                                        src=""
                                        class="img-profile rounded-circle mb-2"
                                        style="width:120px;height:120px;object-fit:cover">

                                    <!-- VIEW -->
                                    <div class="view-mode">
                                        <small class="text-muted">Ảnh đại diện</small>
                                    </div>

                                    <!-- EDIT -->
                                    <div class="edit-mode d-none">
                                        <input type="file"
                                            id="i-avatar"
                                            class="form-control form-control-sm mt-2"
                                            accept="image/*">
                                        <button class="btn btn-sm btn-outline-danger mt-2"
                                            id="btn-remove-avatar">
                                            Xóa avatar
                                        </button>
                                    </div>

                                </div>
                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <p>
                                        <strong>Username:</strong>
                                        <span id="u-username"></span>
                                    </p>

                                    <p>
                                        <strong>Tên hiển thị:</strong>
                                        <span class="view-mode" id="u-display_name"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-display_name"
                                            data-field="display_name">
                                    </p>

                                    <p>
                                        <strong>Email:</strong>
                                        <span class="view-mode" id="u-email"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-email"
                                            data-field="email">
                                    </p>

                                    <p>
                                        <strong>Số điện thoại:</strong>
                                        <span class="view-mode" id="u-phone"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-phone"
                                            data-field="phone_number">
                                    </p>
                                </div>

                                <div class="col-md-6">
                                    <p>
                                        <strong>Trạng thái:</strong>
                                        <span id="u-status"></span>
                                    </p>

                                    <p>
                                        <strong>Hoạt động lần cuối:</strong>
                                        <span id="u-last-active"></span>
                                    </p>

                                    <p>
                                        <strong>Ngày tạo:</strong>
                                        <span id="u-created"></span>
                                    </p>

                                    <p>
                                        <strong>Cập nhật:</strong>
                                        <span id="u-updated"></span>
                                    </p>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- COMPANIES -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Doanh nghiệp sở hữu</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Tên</th>
                                            <th>MST</th>
                                            <th>Trạng thái</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody id="companiesTable"></tbody>
                                </table>
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
    let currentUserProfile = null;
    let isOwner = false;
    let isEditing = false;

    $(document).ready(async function() {
        await waitForUser();
        const userId = getQuery('id') || window.user.id;
        if (!userId) return;


        const res = await fetch(`/api/users/${userId}`, {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return;

        currentUserProfile = json.data;
        isOwner = (window.user && window.user.id === currentUserProfile.id) || (window.user.flags?.includes('ADMIN'));

        renderUserInfo(currentUserProfile);

        if (isOwner) {
            $('#user-actions').removeClass('d-none');
        }
    });

    /* ================= RENDER ================= */

    function renderUserInfo(u) {
        renderAvatar(u);
        $('#u-username').text(u.username);
        $('#u-display_name').text(u.display_name || '—');
        $('#u-email').text(u.email || '—');
        $('#u-phone').text(u.phone_number || '—');

        $('#i-display_name').val(u.display_name || '');
        $('#i-email').val(u.email || '');
        $('#i-phone').val(u.phone_number || '');

        $('#u-status').html(
            u.status === 'offline' ?
            '<span class="badge badge-secondary">Offline</span>' :
            '<span class="badge badge-success">Online</span>'
        );

        $('#u-last-active').text(
            u.last_active_at ? new Date(u.last_active_at).toLocaleString() : '—'
        );
        $('#u-created').text(new Date(u.created_at).toLocaleString());
        $('#u-updated').text(new Date(u.modified_at).toLocaleString());

        if (u.companies) renderCompanies(u.companies || []);
    }

    function renderCompanies(companies) {
        const $tbody = $('#companiesTable');
        $tbody.empty();

        if (!companies.length) {
            $tbody.append(`
            <tr>
                <td colspan="4" class="text-center text-muted">Không có dữ liệu</td>
            </tr>
        `);
            return;
        }

        companies.forEach(c => {
            $tbody.append(`
            <tr>
                <td>${escapeHtml(c.name)}</td>
                <td>${c.tax_id || '—'}</td>
                <td>
                    ${c.is_active
                        ? '<span class="badge badge-success">Hoạt động</span>'
                        : '<span class="badge badge-secondary">Tạm dừng</span>'}
                </td>
                <td>
                    <a href="/manage/company.php?id=${c.id}" class="btn btn-sm btn-outline-primary">
                        Xem
                    </a>
                </td>
            </tr>
        `);
        });
    }
</script>
<script>
    $('#btn-edit').on('click', function() {
        isEditing = true;
        $('.view-mode').addClass('d-none');
        $('.edit-mode').removeClass('d-none');
        $('#user-actions').addClass('d-none');
        $('#user-edit-actions').removeClass('d-none');
    });

    $('#btn-cancel').on('click', function() {
        isEditing = false;
        renderUserInfo(currentUserProfile);
        exitEditMode();
    });

    $('#btn-save').on('click', async function() {
        const payload = {};

        $('.edit-mode[data-field]').each(function() {
            const field = $(this).data('field');
            const val = $(this).val().trim();
            if (val !== (currentUserProfile[field] || '')) {
                payload[field] = val;
            }
        });

        if (!Object.keys(payload).length) {
            alert('Không có thay đổi');
            return;
        }

        const res = await fetch(`/api/users/${currentUserProfile.id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify(payload)
        });

        const json = await res.json();
        if (json.code !== 200) {
            alert(json.msg || 'Cập nhật thất bại');
            return;
        }

        currentUserProfile = json.data;
        renderUserInfo(currentUserProfile);
        exitEditMode();
    });

    function exitEditMode() {
        $('.edit-mode').addClass('d-none');
        $('.view-mode').removeClass('d-none');
        $('#user-edit-actions').addClass('d-none');
        $('#user-actions').removeClass('d-none');
    }

    function renderAvatar(u) {
        const $img = $('#u-avatar');

        if (u.avatar_file_id) {
            $img.attr(
                'src',
                `/api/media-proxy/avatars/${u.id}?size=120x120`
            );
        } else {
            // fallback ui-avatars
            const name = encodeURIComponent(u.display_name || u.username || 'User');
            $img.attr(
                'src',
                `https://ui-avatars.com/api/?name=${name}&size=120&background=4e73df&color=fff`
            );
        }

    }
    $('#i-avatar').on('change', async function() {
        const file = this.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append('type', 'user_avatar');
        formData.append('user_id', currentUserProfile.id);
        formData.append('files', file);
        formData.append('filenames[]', file.name);

        try {
            const res = await fetch('/api/files', {
                method: 'PUT',
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                },
                body: formData
            });

            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Upload avatar thất bại');
                return;
            }

            // reload user
            currentUserProfile.avatar_file_id = json.data[0]?.id;
            renderAvatar(currentUserProfile);
            $('#i-avatar').val('');

        } catch (e) {
            console.error(e);
            alert('Có lỗi khi upload avatar');
        }
    });
    $('#btn-remove-avatar').on('click', async function() {
        if (!currentUserProfile.avatar_file_id) return;
        if (!confirm('Xóa ảnh đại diện?')) return;

        try {
            const res = await fetch(
                `/api/files/${currentUserProfile.avatar_file_id}`, {
                    method: 'DELETE',
                    headers: {
                        Authorization: 'Bearer ' + getCookie('auth_token')
                    }
                }
            );

            const json = await res.json();
            if (json.code !== 200) {
                alert(json.msg || 'Xóa avatar thất bại');
                return;
            }

            currentUserProfile.avatar_file_id = null;
            renderAvatar(currentUserProfile);

        } catch (e) {
            console.error(e);
            alert('Có lỗi khi xóa avatar');
        }
    });
</script>