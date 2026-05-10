<!DOCTYPE html>
<html lang="en">

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
                        <h1 class="h3 mb-0 text-gray-800">Quản lý người dùng</h1>
                    </div>

                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <input type="text"
                                        id="userSearch"
                                        class="form-control"
                                        placeholder="Tìm user (username, email, phone, flag...)">
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <small class="text-muted">
                                        Hiển thị <span id="countShown">0</span> / <span id="countTotal">0</span>
                                    </small>
                                </div>
                            </div>

                            <table class="table table-bordered" id="usersTable">
                                <thead>
                                    <tr>
                                        <th>Avatar</th>
                                        <th>User</th>
                                        <th>Liên hệ</th>
                                        <th>Trạng thái</th>
                                        <th>Hoạt động</th>
                                        <th>Flags</th>
                                        <th width="200">Hành động</th>
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
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa người dùng</h5>
                    <button class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <input type="hidden" id="u-id">

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label>User ID</label>
                            <input id="u-id-view" class="form-control" disabled>
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Username</label>
                            <input id="u-username" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Email</label>
                            <input id="u-email" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Số điện thoại</label>
                            <input id="u-phone" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Display name</label>
                            <input id="u-display" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Google ID</label>
                            <input id="u-google" class="form-control" disabled>
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Trạng thái</label>
                            <input id="u-status" class="form-control" disabled>
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Last active</label>
                            <input id="u-last-active" class="form-control" disabled>
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Created at</label>
                            <input id="u-created" class="form-control" disabled>
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Modified at</label>
                            <input id="u-modified" class="form-control" disabled>
                        </div>

                        <div class="col-12 form-group">
                            <label>Flags</label><br>
                            <label><input type="checkbox" value="ADMIN" class="u-flag"> ADMIN</label>
                            <label class="ml-3"><input type="checkbox" value="BOT" class="u-flag"> BOT</label>
                            <label class="ml-3"><input type="checkbox" value="VERIFIED" class="u-flag"> VERIFIED</label>
                            <label class="ml-3"><input type="checkbox" value="BANNED" class="u-flag"> BANNED</label>
                        </div>
                    </div>
                </div>


                <div class="modal-footer">
                    <button class="btn btn-danger" id="btn-delete-user">Xóa</button>
                    <button class="btn btn-primary" id="btn-save-user">Lưu</button>
                </div>

            </div>
        </div>
    </div>

</body>

</html>

<script>
    let users = [];
    let filteredUsers = [];


    $(document).ready(loadUsers);

    async function loadUsers() {
        const res = await fetch('/api/users', {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return alert('Không tải được user');

        users = json.data;
        filteredUsers = users;

        $('#countTotal').text(users.length);
        renderUsers();
    }



    function renderUsers() {
        const $tb = $('#usersTable tbody');
        $tb.empty();

        filteredUsers.forEach(u => {
            const avatarUrl = `/api/media-proxy/avatars/${u.id}?size=40x40`;

            $tb.append(`
        <tr>
            <!-- AVATAR -->
            <td class="text-center align-middle">
                <img src="${avatarUrl}"
                     class="rounded-circle border"
                     width="40"
                     height="40"
                     style="object-fit:cover"
                     onerror="this.src='https://ui-avatars.com/api/?name=${encodeURIComponent(u.display_name || u.username)}&size=40'">
            </td>

            <!-- USER -->
            <td>
                <strong>${escapeHtml(u.username)}</strong><br>
                <small class="text-muted">${escapeHtml(u.display_name || '')}</small>
            </td>

            <!-- CONTACT -->
            <td>
                ${u.email ? `<div><i class="fas fa-envelope"></i> ${escapeHtml(u.email)}</div>` : ''}
                ${u.phone_number ? `<div><i class="fas fa-phone"></i> ${escapeHtml(u.phone_number)}</div>` : ''}
            </td>

            <!-- STATUS -->
            <td>
                <span class="badge badge-${u.status === 'online' ? 'success' : 'secondary'}">
                    ${u.status}
                </span>
            </td>

            <!-- ACTIVITY -->
            <td>
                <div><small>Tạo: ${formatDate(u.created_at)}</small></div>
                <div><small>Active: ${u.last_active_at ? formatDate(u.last_active_at) : '—'}</small></div>
            </td>

            <!-- FLAGS -->
            <td>${renderFlags(u.flags)}</td>

            <!-- ACTIONS -->
            <td>
                <button class="btn btn-sm btn-info mb-1"
                    onclick="window.open('/manage/user.php?id=${u.id}', '_blank')">
                    <i class="fas fa-user"></i> Xem
                </button>
                <button class="btn btn-sm btn-warning mb-1"
                    onclick="openEdit('${u.id}')">
                    <i class="fas fa-edit"></i> Edit
                </button>
                <button class="btn btn-sm btn-danger"
                    onclick="toggleBan('${u.id}')">
                    ${u.flags.includes('BANNED') ? 'Unban' : 'Ban'}
                </button>
            </td>
        </tr>
        `);
        });

        $('#countShown').text(filteredUsers.length);
    }


    $('#userSearch').on('input', function() {
        const q = $(this).val().toLowerCase().trim();

        if (!q) {
            filteredUsers = users;
            return renderUsers();
        }

        filteredUsers = users.filter(u => {
            return (
                u.username?.toLowerCase().includes(q) ||
                u.display_name?.toLowerCase().includes(q) ||
                u.email?.toLowerCase().includes(q) ||
                u.phone_number?.toLowerCase().includes(q) ||
                (u.flags || []).some(f => f.toLowerCase().includes(q))
            );
        });

        renderUsers();
    });


    function formatDate(d) {
        return new Date(d).toLocaleString('vi-VN');
    }


    function renderFlags(flags = []) {
        return flags.map(f => `<span class="badge badge-secondary mr-1">${f}</span>`).join('');
    }

    function openEdit(id) {
        const u = users.find(x => x.id === id);
        if (!u) return;

        $('#u-id').val(u.id);
        $('#u-id-view').val(u.id);
        $('#u-username').val(u.username);
        $('#u-email').val(u.email || '');
        $('#u-phone').val(u.phone_number || '');
        $('#u-display').val(u.display_name || '');
        $('#u-google').val(u.google_id || '');
        $('#u-status').val(u.status);
        $('#u-last-active').val(u.last_active_at ? formatDate(u.last_active_at) : '');
        $('#u-created').val(formatDate(u.created_at));
        $('#u-modified').val(formatDate(u.modified_at));

        $('.u-flag').each(function() {
            $(this).prop('checked', u.flags.includes(this.value));
        });

        $('#editUserModal').modal('show');
    }
</script>

<script>
    $('#btn-save-user').click(async () => {
        const id = $('#u-id').val();
        const flags = $('.u-flag:checked').map((_, e) => e.value).get();

        const res = await fetch(`/api/users/${id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + getCookie('auth_token')
            },
            body: JSON.stringify({
                username: $('#u-username').val(),
                email: $('#u-email').val(),
                display_name: $('#u-display').val(),
                flags
            })
        });

        const json = await res.json();
        if (json.code !== 200) return alert(json.msg || 'Lỗi');

        $('#editUserModal').modal('hide');
        loadUsers();
    });

    $('#btn-delete-user').click(async () => {
        if (!confirm('Xóa user này?')) return;

        const id = $('#u-id').val();
        const res = await fetch(`/api/users/${id}`, {
            method: 'DELETE',
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return alert(json.msg);

        $('#editUserModal').modal('hide');
        loadUsers();
    });

    async function toggleBan(id) {
        await fetch(`/api/users/${id}/ban`, {
            method: 'POST',
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });
        loadUsers();
    }
</script>