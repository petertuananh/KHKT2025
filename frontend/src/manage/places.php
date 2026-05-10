<!DOCTYPE html>
<html lang="en">

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

                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Địa điểm của tôi</h1>

                        <button class="btn btn-sm btn-primary shadow-sm"
                            data-toggle="modal"
                            data-target="#addPlaceModal">
                            <i class="fas fa-plus fa-sm text-white-50"></i> Thêm địa điểm
                        </button>
                    </div>

                    <!-- Places Table -->
                    <table class="table table-bordered" id="placesTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Tên địa điểm</th>
                                <th>Địa chỉ</th>
                                <th>Điện thoại</th>
                                <th>Tọa độ</th>
                                <th>Ngày tạo</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>

                </div>
            </div>

            <?php include './partials/footer.php'; ?>
        </div>

    </div>

    <!-- Add Place Modal (UI trước) -->
    <div class="modal fade" id="addPlaceModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Thêm địa điểm mới</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <form id="addPlaceForm">
                        <div class="form-row">

                            <div class="form-group col-md-6">
                                <label>Tên địa điểm *</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>

                            <div class="form-group col-md-6">
                                <label>Điện thoại</label>
                                <input type="text" class="form-control" name="phone">
                            </div>

                            <div class="form-group col-12">
                                <label>Địa chỉ</label>
                                <input type="text" class="form-control" name="address">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Latitude</label>
                                <input type="number" step="any" class="form-control" name="latitude">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Longitude</label>
                                <input type="number" step="any" class="form-control" name="longitude">
                            </div>

                            <div class="form-group col-12">
                                <label>Mô tả</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>
                            </div>

                        </div>
                    </form>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-dismiss="modal">Huỷ</button>
                    <button class="btn btn-primary" id="submitAddPlace">
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

            renderPlaces(json.data.places || []);
        } catch (e) {
            console.error(e);
        }
    });
</script>


<script>
    function renderPlaces(places) {
        const $tbody = $('#placesTable tbody');
        $tbody.empty();

        if (!places.length) {
            $tbody.append(`
            <tr>
                <td colspan="5" class="text-center text-muted">
                    Bạn chưa có địa điểm nào
                </td>
            </tr>
        `);
            return;
        }

        places.forEach(p => {
            $tbody.append(`
            <tr class="place-row" data-id="${p.id}" style="cursor:pointer">
                <td>${escapeHtml(p.name)}</td>
                <td>${escapeHtml(p.address || '')}</td>
                <td>${escapeHtml(p.phone || '')}</td>
                <td class="text-muted">
                    ${p.latitude && p.longitude ? `${p.latitude}, ${p.longitude}` : ''}
                </td>
                <td>
                    ${new Date(p.created_at).toLocaleDateString()}
                </td>
            </tr>
        `);
        });
    }
</script>

<script>
    $(document).on('click', '.place-row', function() {
        const id = $(this).data('id');
        window.location.href = `/manage/place.php?id=${id}`;
    });
</script>

<script>
    $('#submitAddPlace').on('click', async function() {
        const form = document.getElementById('addPlaceForm');
        const formData = new FormData(form);

        const payload = {};
        formData.forEach((v, k) => {
            if (v !== '') payload[k] = v;
        });

        if (!payload.name) {
            alert('Tên địa điểm là bắt buộc');
            return;
        }

        try {
            const res = await fetch('/api/places', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + getCookie('auth_token')
                },
                body: JSON.stringify(payload)
            });

            const json = await res.json();

            if (json.code !== 200) {
                alert(json.msg || 'Tạo địa điểm thất bại');
                return;
            }

            // Đóng modal + reset form
            $('#addPlaceModal').modal('hide');
            form.reset();

            // Reload danh sách places
            const meRes = await fetch('/api/users/@me', {
                headers: {
                    Authorization: 'Bearer ' + getCookie('auth_token')
                }
            });
            const meJson = await meRes.json();

            renderPlaces(meJson.data.places || []);

        } catch (e) {
            console.error(e);
            alert('Có lỗi xảy ra');
        }
    });
</script>