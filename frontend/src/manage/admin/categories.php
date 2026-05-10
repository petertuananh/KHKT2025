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
                    <h1 class="h3 mb-0 text-gray-800">Danh mục sản phẩm</h1>

                    <button class="btn btn-primary btn-sm"
                            onclick="openCreateCategory()">
                        <i class="fas fa-plus"></i> Thêm danh mục
                    </button>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-body">

                        <div class="row mb-3 align-items-center">
                            <div class="col-md-6">
                                <input type="text"
                                       id="categorySearch"
                                       class="form-control"
                                       placeholder="Tìm danh mục...">
                            </div>

                            <div class="col-md-6 text-right">
                                <small class="text-muted">
                                    Hiển thị <span id="countShown">0</span> /
                                    <span id="countTotal">0</span>
                                </small>
                            </div>
                        </div>

                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Tên danh mục</th>
                                <th>Mô tả</th>
                                <th>Sản phẩm</th>
                                <th width="160">Hành động</th>
                            </tr>
                            </thead>
                            <tbody id="categoriesTable"></tbody>
                        </table>

                    </div>
                </div>

            </div>
        </div>

        <?php include '../partials/footer.php'; ?>
    </div>
</div>

<!-- MODAL CREATE / EDIT -->
<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="cm-title"></h5>
                <button class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="c-id">

                <div class="form-group">
                    <label>Tên danh mục</label>
                    <input class="form-control" id="c-name">
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea class="form-control" id="c-description"></textarea>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-danger d-none"
                        id="btn-delete-category">
                    Xóa
                </button>
                <button class="btn btn-primary"
                        id="btn-save-category">
                    Lưu
                </button>
            </div>

        </div>
    </div>
</div>

</body>
</html>
<script>
let categories = [];
let filtered = [];

$(document).ready(() => {
    loadCategories();

    $('#categorySearch').on('input', function () {
        const q = $(this).val().toLowerCase().trim();
        filtered = categories.filter(c =>
            (c.name || '').toLowerCase().includes(q) ||
            (c.description || '').toLowerCase().includes(q)
        );
        renderCategories();
    });
});

async function loadCategories() {
    const res = await fetch('/api/categories', {
        headers: {
            Authorization: 'Bearer ' + getCookie('auth_token')
        }
    });

    const json = await res.json();
    if (json.code !== 200) {
        alert('Không tải được danh mục');
        return;
    }

    categories = json.data;
    filtered = categories;

    $('#countTotal').text(categories.length);
    renderCategories();
}

function renderCategories() {
    const $tb = $('#categoriesTable');
    $tb.empty();

    filtered.forEach(c => {
        $tb.append(`
            <tr>
                <td><strong>${escapeHtml(c.name)}</strong></td>
                <td>${escapeHtml(c.description || '—')}</td>
                <td>
                    <span class="badge badge-info">
                        ${c.products?.length || 0} sản phẩm
                    </span>
                </td>
                <td>
                    <button class="btn btn-sm btn-warning"
                            onclick="openEditCategory('${c.id}')">
                        <i class="fas fa-edit"></i>
                    </button>
                </td>
            </tr>
        `);
    });

    $('#countShown').text(filtered.length);
}
</script>
<script>
function openCreateCategory() {
    $('#cm-title').text('Thêm danh mục');
    $('#c-id').val('');
    $('#c-name').val('');
    $('#c-description').val('');
    $('#btn-delete-category').addClass('d-none');
    $('#categoryModal').modal('show');
}

function openEditCategory(id) {
    const c = categories.find(x => x.id === id);
    if (!c) return;

    $('#cm-title').text('Chỉnh sửa danh mục');
    $('#c-id').val(c.id);
    $('#c-name').val(c.name);
    $('#c-description').val(c.description || '');
    $('#btn-delete-category').removeClass('d-none');

    $('#categoryModal').modal('show');
}

$('#btn-save-category').click(async () => {
    const id = $('#c-id').val();
    const payload = {
        name: $('#c-name').val(),
        description: $('#c-description').val()
    };

    let url = '/api/categories';
    let method = 'PUT';

    if (id) {
        url += '/' + id;
        method = 'PATCH';
    }

    const res = await fetch(url, {
        method,
        headers: {
            'Content-Type': 'application/json',
            Authorization: 'Bearer ' + getCookie('auth_token')
        },
        body: JSON.stringify(payload)
    });

    const json = await res.json();
    if (json.code !== 200) {
        alert(json.msg || 'Lỗi');
        return;
    }

    $('#categoryModal').modal('hide');
    loadCategories();
});

$('#btn-delete-category').click(async () => {
    if (!confirm('Xóa danh mục này?')) return;

    const id = $('#c-id').val();
    const res = await fetch(`/api/categories/${id}`, {
        method: 'DELETE',
        headers: {
            Authorization: 'Bearer ' + getCookie('auth_token')
        }
    });

    const json = await res.json();
    if (json.code !== 200) {
        alert(json.msg);
        return;
    }

    $('#categoryModal').modal('hide');
    loadCategories();
});
</script>
