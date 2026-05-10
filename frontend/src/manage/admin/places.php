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
                        <h1 class="h3 mb-0 text-gray-800">Quản lý địa điểm</h1>
                    </div>

                    <div class="card shadow mb-4">
                        <div class="card-body">

                            <!-- SEARCH -->
                            <div class="row mb-3 align-items-center">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <input type="text"
                                            id="placeSearch"
                                            class="form-control"
                                            placeholder="Tìm địa điểm (tên, địa chỉ, SĐT...)">
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

                            <!-- TABLE -->
                            <table class="table table-bordered" id="placesTable">
                                <thead>
                                    <tr>
                                        <th>Địa điểm</th>
                                        <th>Liên hệ</th>
                                        <th>Vị trí</th>
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
    <div class="modal fade" id="editPlaceModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa địa điểm</h5>
                    <button class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <input type="hidden" id="p-id">

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label>Tên địa điểm</label>
                            <input id="p-name" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Số điện thoại</label>
                            <input id="p-phone" class="form-control">
                        </div>

                        <div class="col-12 form-group">
                            <label>Địa chỉ</label>
                            <input id="p-address" class="form-control">
                        </div>

                        <div class="col-12 form-group">
                            <label>Mô tả</label>
                            <textarea id="p-description" class="form-control"></textarea>
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Latitude</label>
                            <input id="p-lat" class="form-control">
                        </div>

                        <div class="col-md-6 form-group">
                            <label>Longitude</label>
                            <input id="p-lng" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-danger" id="btn-delete-place">Xóa</button>
                    <button class="btn btn-primary" id="btn-save-place">Lưu</button>
                </div>

            </div>
        </div>
    </div>


</body>

</html>
<script>
let places = [];
let filteredPlaces = [];

$(document).ready(() => {
    loadPlaces();

    $('#placeSearch').on('input', function () {
        const q = $(this).val().toLowerCase().trim();

        filteredPlaces = places.filter(p =>
            (p.name || '').toLowerCase().includes(q) ||
            (p.address || '').toLowerCase().includes(q) ||
            (p.phone || '').toLowerCase().includes(q)
        );

        renderPlaces();
    });
});

async function loadPlaces() {
    const res = await fetch('/api/places', {
        headers: {
            Authorization: 'Bearer ' + getCookie('auth_token')
        }
    });

    const json = await res.json();
    if (json.code !== 200) return alert('Không tải được địa điểm');

    places = json.data;
    filteredPlaces = places;

    $('#countTotal').text(places.length);
    renderPlaces();
}

function renderPlaces() {
    const $tb = $('#placesTable tbody');
    $tb.empty();

    filteredPlaces.forEach(p => {
        $tb.append(`
        <tr>
            <td>
                <strong>${escapeHtml(p.name)}</strong><br>
                <small class="text-muted">${escapeHtml(p.description || '')}</small>
            </td>

            <td>
                ${p.phone ? `<div><i class="fas fa-phone"></i> ${escapeHtml(p.phone)}</div>` : ''}
            </td>

            <td>
                ${p.address ? escapeHtml(p.address) : ''}
                ${p.latitude && p.longitude
                    ? `<br><a target="_blank"
                        href="https://www.google.com/maps?q=${p.latitude},${p.longitude}">
                        <small>Xem bản đồ</small>
                       </a>`
                    : ''}
            </td>

            <td>
                <div><small>Tạo: ${formatDate(p.created_at)}</small></div>
                <div><small>Cập nhật: ${formatDate(p.modified_at)}</small></div>
            </td>

            <td>
                <button class="btn btn-sm btn-info mb-1"
                    onclick="window.open('/manage/place.php?id=${p.id}', '_blank')">
                    <i class="fas fa-eye"></i> Xem
                </button>

                <button class="btn btn-sm btn-warning mb-1"
                    onclick="openEditPlace('${p.id}')">
                    <i class="fas fa-edit"></i> Edit
                </button>
            </td>
        </tr>
        `);
    });

    $('#countShown').text(filteredPlaces.length);
}

function formatDate(d) {
    return new Date(d).toLocaleString('vi-VN');
}
</script>
<script>
function openEditPlace(id) {
    const p = places.find(x => x.id === id);
    if (!p) return;

    $('#p-id').val(p.id);
    $('#p-name').val(p.name);
    $('#p-phone').val(p.phone || '');
    $('#p-address').val(p.address || '');
    $('#p-description').val(p.description || '');
    $('#p-lat').val(p.latitude || '');
    $('#p-lng').val(p.longitude || '');

    $('#editPlaceModal').modal('show');
}

$('#btn-save-place').click(async () => {
    const id = $('#p-id').val();

    const res = await fetch(`/api/places/${id}`, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            Authorization: 'Bearer ' + getCookie('auth_token')
        },
        body: JSON.stringify({
            name: $('#p-name').val(),
            phone: $('#p-phone').val(),
            address: $('#p-address').val(),
            description: $('#p-description').val(),
            latitude: $('#p-lat').val(),
            longitude: $('#p-lng').val()
        })
    });

    const json = await res.json();
    if (json.code !== 200) return alert(json.msg || 'Lỗi');

    $('#editPlaceModal').modal('hide');
    loadPlaces();
});

$('#btn-delete-place').click(async () => {
    if (!confirm('Xóa địa điểm này?')) return;

    const id = $('#p-id').val();
    const res = await fetch(`/api/places/${id}`, {
        method: 'DELETE',
        headers: {
            Authorization: 'Bearer ' + getCookie('auth_token')
        }
    });

    const json = await res.json();
    if (json.code !== 200) return alert(json.msg);

    $('#editPlaceModal').modal('hide');
    loadPlaces();
});
</script>
