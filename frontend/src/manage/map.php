<!DOCTYPE html>
<html lang="en">

<head>
    <?php include './partials/init.php'; ?>
</head>
<style>
    #vm-map {
        width: 100%;
        height: 600px;
        border-radius: 8px;
    }
</style>

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

                    <div class="row">
                        <div class="col-lg-12">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Bản đồ VietMap</h6>
                                </div>
                                <div class="card-body">
                                    <!-- Map layout -->
                                    <div id="vietmap-container">
                                        <button id="btn-locate"
                                            class="btn btn-sm btn-primary position-absolute"
                                            style="top:10px; right:10px; z-index:1000">
                                            <i class="fas fa-crosshairs"></i> Định vị tôi
                                        </button>

                                        <div id="vm-map"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

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
    <div class="modal fade" id="placeModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="placeModalTitle"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <p id="placeAddress"></p>
                    <p id="placeOwner"></p>

                    <hr>
                    <h6>Sản phẩm</h6>
                    <ul id="placeProducts" class="list-group"></ul>
                </div>

                <div class="modal-footer">
                    <a id="btnPlaceDetail" class="btn btn-primary" target="_blank">
                        Xem chi tiết
                    </a>
                    <a id="btnGoogleMaps" class="btn btn-outline-success" target="_blank">
                        Google Maps
                    </a>
                </div>
            </div>
        </div>
    </div>

</body>

</html>

<script>
    const VIETMAP_ACCESS_TOKEN = "YOUR_VIETMAP_ACCESS_TOKEN";

    const map = L.map('vm-map').setView([10.776530, 106.700981], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19
    }).addTo(map);

    const markers = L.layerGroup().addTo(map);
    setTimeout(() => {
        map.invalidateSize();
    }, 300);

    // lightLayer.addTo(map);


    const darkLayer = L.tileLayer(
        "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png?api_key=8ca17792-2dc1-4eee-9169-6e56a2fa470b", {
            maxZoom: 20,
            attribution: '&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, ' +
                '&copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> ' +
                '&copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors'
        }
    );

    function highlightMarker(marker) {
        marker._icon.style.filter = "drop-shadow(0 0 6px #4e73df)";
    }

    function unhighlightMarker(marker) {
        marker._icon.style.filter = "none";
    }
    // marker.on("mouseover", () => highlightMarker(marker));
    // marker.on("mouseout", () => unhighlightMarker(marker));
    async function loadPlaces() {
        const res = await fetch('/api/places');
        const json = await res.json();
        if (json.code !== 200) return;

        json.data.forEach(place => {
            const lat = Number(place.latitude);
            const lng = Number(place.longitude);

            if (isNaN(lat) || isNaN(lng)) return;

            const marker = L.marker([lat, lng])
                .addTo(markers)
                .on('click', () => {
                    console.log('Clicked place:', place.name);
                    openPlaceModal(place);
                });
        });
    }


    loadPlaces();

    function openPlaceModal(place) {
        document.getElementById('placeModalTitle').innerText = place.name;
        document.getElementById('placeAddress').innerText =
            '📍 ' + (place.address || 'Chưa cập nhật');

        // Chủ sở hữu
        if (place.company) {
            document.getElementById('placeOwner').innerText =
                `🏢 Công ty: ${place.company.name}`;
        } else if (place.user) {
            document.getElementById('placeOwner').innerText =
                `👤 Cá nhân: ${place.user.display_name || place.user.username}`;
        } else {
            document.getElementById('placeOwner').innerText = '—';
        }

        // Sản phẩm
        const $products = document.getElementById('placeProducts');
        $products.innerHTML = '';

        if (!place.products || place.products.length === 0) {
            $products.innerHTML =
                `<li class="list-group-item text-muted">Không có sản phẩm</li>`;
        } else {
            place.products.forEach(p => {
                $products.innerHTML += `
        <li class="list-group-item d-flex justify-content-between align-items-center">
            <div>
                <div class="fw-semibold">${p.name}</div>
                <small class="text-muted">${p.price.toLocaleString()} ₫</small>
            </div>

            <a href="/manage/product.php?id=${p.id}"
               target="_blank"
               class="btn btn-sm btn-outline-primary">
                <i class="fas fa-eye"></i>
                Xem
            </a>
        </li>
    `;
            });

        }

        // Buttons
        document.getElementById('btnPlaceDetail').href =
            `/manage/place.php?id=${place.id}`;

        document.getElementById('btnGoogleMaps').href =
            `https://www.google.com/maps?q=${place.latitude},${place.longitude}`;

        // ✅ FIX LỖI Ở ĐÂY
        const modalEl = document.getElementById('placeModal');
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
    }

    document.getElementById('btn-locate').onclick = () => {
        if (!navigator.geolocation) {
            alert('Trình duyệt không hỗ trợ định vị');
            return;
        }

        navigator.geolocation.getCurrentPosition(pos => {
            const lat = pos.coords.latitude;
            const lng = pos.coords.longitude;

            map.setView([lat, lng], 16);

            L.circleMarker([lat, lng], {
                radius: 8,
                color: '#4e73df',
                fillColor: '#4e73df',
                fillOpacity: 0.8
            }).addTo(map).bindPopup('Vị trí của bạn').openPopup();
        });
    };
</script>