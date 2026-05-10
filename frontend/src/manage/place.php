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

                    <h1 class="h3 mb-4 text-gray-800">Chi tiết địa điểm</h1>

                    <!-- Actions -->
                    <div id="place-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-warning" id="btn-edit">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </button>
                        <button class="btn btn-sm btn-danger" id="btn-delete">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                    </div>

                    <div id="place-edit-actions" class="mb-3 d-none">
                        <button class="btn btn-sm btn-success" id="btn-save">
                            <i class="fas fa-save"></i> Lưu
                        </button>
                        <button class="btn btn-sm btn-secondary" id="btn-cancel">Hủy</button>
                    </div>

                    <!-- Thông tin địa điểm -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Thông tin chung</h6>
                        </div>


                        <div class="card-body">
                            <div class="row">

                                <div class="col-md-6">
                                    <p>
                                        <strong>Tên địa điểm:</strong>
                                        <span class="view-mode" id="p-name"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-name" data-field="name">
                                    </p>

                                    <p>
                                        <strong>Địa chỉ:</strong>
                                        <span class="view-mode" id="p-address"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-address" data-field="address">
                                    </p>

                                    <p>
                                        <strong>Điện thoại:</strong>
                                        <span class="view-mode" id="p-phone"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-phone" data-field="phone">
                                    </p>
                                </div>

                                <div class="col-md-6">
                                    <p>
                                        <strong>Latitude:</strong>
                                        <span class="view-mode" id="p-lat"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-latitude" data-field="latitude">
                                    </p>

                                    <p>
                                        <strong>Longitude:</strong>
                                        <span class="view-mode" id="p-lng"></span>
                                        <input class="form-control form-control-sm edit-mode d-none"
                                            id="i-longitude" data-field="longitude">
                                    </p>

                                    <p>
                                        <strong>Ngày tạo:</strong>
                                        <span id="p-created"></span>
                                    </p>

                                    <p>
                                        <strong>Cập nhật:</strong>
                                        <span id="p-updated"></span>
                                    </p>
                                </div>

                                <div class="col-12">
                                    <p>
                                        <strong>Mô tả:</strong>
                                        <span class="view-mode" id="p-description"></span>
                                        <textarea class="form-control form-control-sm edit-mode d-none"
                                            id="i-description" data-field="description"></textarea>
                                    </p>
                                </div>

                            </div>
                        </div>

                    </div>

                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">Vị trí trên bản đồ</h6>

                            <a id="btn-open-google-maps"
                                href="#"
                                target="_blank"
                                class="btn btn-sm btn-outline-success d-none">
                                <i class="fas fa-map-marked-alt"></i> Xem trên Google Maps
                            </a>
                        </div>

                        <div class="card-body">
                            <div id="map" style="height: 400px; border-radius: 8px;"></div>
                        </div>
                    </div>


                    <!-- Owner -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Chủ sở hữu địa điểm</h6>
                        </div>
                        <div class="card-body" id="owner-info"></div>
                    </div>

                    <!-- Products -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Sản phẩm tại địa điểm</h6>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Tên</th>
                                        <th>Số lượng</th>
                                        <th>Đơn vị</th>
                                        <th>Giá</th>
                                        <th style="width:120px">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="productsTable"></tbody>
                            </table>
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
    let currentPlace = null;
    let isEditing = false;
    let editMarker = null;
    let map;

    function initMap(lat = 21.028511, lng = 105.804817) {
        map = L.map('map').setView([lat, lng], 13);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; OpenStreetMap'
        }).addTo(map);
        map.on('click', e => {
            if (!isEditing) return;
            moveMarkerTo(e.latlng.lat, e.latlng.lng);
        });
    }

    $(document).ready(async function() {
        const placeId = getQuery('id');
        if (!placeId) return;



        await waitForUser();

        const res = await fetch(`/api/places/${placeId}`, {
            headers: {
                Authorization: 'Bearer ' + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return;

        currentPlace = json.data;
        initMap(
            currentPlace.latitude || 21.028511,
            currentPlace.longitude || 105.804817
        );
        renderPlace(currentPlace);

        // Quyền sửa
        if (
            (currentPlace.user_id && currentPlace.user_id === window.user.id) ||
            (currentPlace.company && currentPlace.company.owned_by === window.user.id ||
                (window.user.flags?.includes('ADMIN'))
            )
        ) {
            $('#place-actions').removeClass('d-none');
        }
    });
</script>

<script>
    $('#btn-edit').click(() => enterEditMode());
    $('#btn-cancel').click(() => {
        exitEditMode();
        renderPlace(currentPlace);
    });

    function enterEditMode() {
        isEditing = true;

        $('#place-actions').addClass('d-none');
        $('#place-edit-actions').removeClass('d-none');

        $('.view-mode').addClass('d-none');
        $('.edit-mode').removeClass('d-none');

        if (currentPlace.latitude && currentPlace.longitude) {
            // xoá marker xem
            if (editMarker) {
                map.removeLayer(editMarker);
                editMarker = null;
            }

            // tạo marker draggable
            editMarker = L.marker(
                [currentPlace.latitude, currentPlace.longitude], {
                    draggable: true
                }
            ).addTo(map);

            editMarker.on('dragend', () => {
                const pos = editMarker.getLatLng();
                updateLatLngInputs(pos.lat, pos.lng);
            });
        }
    }



    function exitEditMode() {
        isEditing = false;

        $('#place-edit-actions').addClass('d-none');
        $('#place-actions').removeClass('d-none');

        $('.edit-mode').addClass('d-none');
        $('.view-mode').removeClass('d-none');

        if (editMarker) {
            map.removeLayer(editMarker);
            editMarker = null;
        }
    }
</script>

<script>
    function renderPlace(p) {
        $('#p-name').text(p.name || '—');
        $('#i-name').val(p.name || '');

        $('#p-address').text(p.address || '—');
        $('#i-address').val(p.address || '');

        $('#p-phone').text(p.phone || '—');
        $('#i-phone').val(p.phone || '');

        $('#p-lat').text(p.latitude ?? '—');
        $('#i-latitude').val(p.latitude ?? '');

        $('#p-lng').text(p.longitude ?? '—');
        $('#i-longitude').val(p.longitude ?? '');

        $('#p-description').text(p.description || '—');
        $('#i-description').val(p.description || '');

        $('#p-created').text(new Date(p.created_at).toLocaleString());
        $('#p-updated').text(new Date(p.modified_at).toLocaleString());

        renderOwner(p);
        renderProducts(p.products || []);

        // ⭐ locate map + ghim marker NGAY KHI LOAD
        locatePlaceOnMap(p);
        updateGoogleMapsButton(p.latitude, p.longitude);

    }

    function locatePlaceOnMap(p) {
        const lat = parseFloat(p.latitude);
        const lng = parseFloat(p.longitude);

        if (!lat || !lng) return;

        map.flyTo([lat, lng], 16, {
            duration: 1
        });

        // marker xem (KHÔNG draggable)
        if (!editMarker) {
            editMarker = L.marker([lat, lng]).addTo(map);
        } else {
            editMarker.setLatLng([lat, lng]);
        }
    }
</script>

<script>
    function renderOwner(p) {
        if (p.company) {
            $('#owner-info').html(`
            <p><strong>Doanh nghiệp:</strong> ${escapeHtml(p.company.name)}</p>
            <a class="btn btn-sm btn-outline-primary"
               href="/manage/company.php?id=${p.company.id}">
               <i class="fas fa-building"></i> Xem doanh nghiệp
            </a>
        `);
            return;
        }

        if (p.user) {
            $('#owner-info').html(`
            <p><strong>Cá nhân:</strong> ${escapeHtml(p.user.display_name || p.user.username)}</p>
            <p>Email: ${p.user.email || '—'}</p>
            <a class="btn btn-sm btn-outline-primary"
               href="/manage/user.php?id=${p.user.id}">
               <i class="fas fa-user"></i> Xem tài khoản
            </a>
        `);
        }
    }
</script>

<script>
    function renderProducts(products) {
        const $tbody = $('#productsTable');
        $tbody.empty();

        if (!products.length) {
            $tbody.append(`
            <tr>
                <td colspan="4" class="text-center text-muted">Chưa có sản phẩm</td>
            </tr>
        `);
            return;
        }

        products.forEach(p => {
            $tbody.append(`
        <tr>
            <td>${escapeHtml(p.name)}</td>
            <td>${p.stock}</td>
            <td>${escapeHtml(p.unit_type)}</td>
            <td>${p.price.toLocaleString()} ₫</td>
            <td class="text-center">
                <a href="/manage/product.php?id=${p.id}"
                   class="btn btn-sm btn-outline-primary"
                   title="Xem chi tiết sản phẩm">
                    <i class="fas fa-eye"></i>
                </a>
            </td>
        </tr>
    `);
        });

    }
    $('#btn-save').click(async () => {
        if (!currentPlace || !isEditing) return;

        const payload = {
            name: $('#i-name').val().trim(),
            address: $('#i-address').val().trim(),
            phone: $('#i-phone').val().trim(),
            latitude: $('#i-latitude').val() || null,
            longitude: $('#i-longitude').val() || null,
            description: $('#i-description').val().trim()
        };

        const res = await fetch(`/api/places/${currentPlace.id}`, {
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

        currentPlace = json.data;
        exitEditMode();
        renderPlace(currentPlace);
    });
    $('#btn-delete').click(async () => {
        if (!currentPlace) return;

        if (!confirm('Bạn có chắc chắn muốn xóa địa điểm này?')) return;

        const res = await fetch(`/api/places/${currentPlace.id}`, {
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

        alert('Đã xóa địa điểm');
        window.location.href = '/manage/places.php';
    });
    async function geocodeAddress(address) {
        if (!address || address.length < 5) return;

        const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`;

        const res = await fetch(url, {
            headers: {
                "Accept-Language": "vi"
            }
        });

        const data = await res.json();
        if (!data.length) return;

        const lat = parseFloat(data[0].lat);
        const lng = parseFloat(data[0].lon);

        moveMarkerTo(lat, lng);
    }


    function moveMarkerTo(lat, lng) {
        map.flyTo([lat, lng], 17, {
            duration: 1
        });

        if (!editMarker) {
            editMarker = L.marker([lat, lng], {
                draggable: true
            }).addTo(map);

            editMarker.on('dragend', () => {
                const pos = editMarker.getLatLng();
                updateLatLngInputs(pos.lat, pos.lng);
            });
        } else {
            editMarker.setLatLng([lat, lng]);
        }

        updateLatLngInputs(lat, lng);

    }

    function updateLatLngInputs(lat, lng) {
        $('#i-latitude').val(lat.toFixed(6));
        $('#i-longitude').val(lng.toFixed(6));

        updateGoogleMapsButton(lat, lng);
    }

    const onAddressChange = debounce((val) => {
        if (!isEditing) return;
        geocodeAddress(val);
    });

    $('#i-address').on('change', function() {
        onAddressChange(this.value);
    });

    function updateGoogleMapsButton(lat, lng) {
        if (!lat || !lng) {
            $('#btn-open-google-maps').addClass('d-none');
            return;
        }

        const url = `https://www.google.com/maps?q=${lat},${lng}`;

        $('#btn-open-google-maps')
            .attr('href', url)
            .removeClass('d-none');
    }
</script>