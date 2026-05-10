<?php include './init.php'; ?>

<!DOCTYPE html>
<html lang="en">

<head>
    <?php include './partials/header.php'; ?>
</head>
<style>
    /* =========================================================
   GENERAL UI IMPROVEMENTS
========================================================= */

    body {
        background: #f5f7fb !important;
    }

    /* Card hover */
    .card.shadow {
        border-radius: 14px;
        transition: 0.25s ease;
        border: none;
    }

    .card.shadow:hover {
        transform: translateY(-4px);
        box-shadow: 0 18px 32px rgba(0, 0, 0, 0.12) !important;
    }

    /* Inputs */
    .form-control {
        border-radius: 10px;
        padding: 10px 14px;
        transition: 0.2s;
    }

    .form-control:focus {
        border-color: #4e73df;
        box-shadow: 0 0 8px rgba(78, 115, 223, 0.25);
    }

    /* Headings */
    .card-header {
        border-radius: 14px 14px 0 0 !important;
    }

    /* Smooth fade in */
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(12px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* =========================================================
   MAP CONTAINER
========================================================= */

    #vietmap-container {
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 6px 26px rgba(0, 0, 0, 0.15);
        animation: fadeIn 0.5s ease;
    }

    #vm-map {
        width: 100%;
        height: 600px;
    }

    /* Floating locate button */
    .btn-locate {
        position: absolute;
        top: 15px !important;
        left: 90px !important;
        z-index: 10;
        background: #28a745;
        color: #fff;
        padding: 10px 16px;
        border-radius: 40px;
        border: none;
        font-weight: 600;
        transition: 0.25s ease;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
    }

    .btn-locate:hover {
        transform: translateY(-3px);
        background: #218838;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
    }

    /* =========================================================
   CONTEXT MENU
========================================================= */

    .map-context-menu {
        position: absolute;
        display: none;
        z-index: 9999;
        background: #fff;
        border-radius: 12px;
        min-width: 170px;
        overflow: hidden;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.18);
        animation: fadeIn 0.15s ease;
    }

    .map-context-menu button {
        width: 100%;
        padding: 12px 16px;
        border: none;
        background: #fff;
        text-align: left;
        transition: 0.25s;
        font-size: 15px;
    }

    .map-context-menu button:hover {
        background: #f2f4f9;
    }

    /* =========================================================
   MODAL UI
========================================================= */

    .modal-content {
        border-radius: 14px !important;
        animation: fadeIn .25s ease;
    }

    .modal-header {
        border-radius: 14px 14px 0 0 !important;
    }

    .modal.fade .modal-dialog {
        transform: translateY(-20px);
        transition: transform .3s ease-out;
    }

    .modal.show .modal-dialog {
        transform: translateY(0);
    }

    /* Recruitment / Delivery cards */
    .custom-info-card {
        border-radius: 12px;
        border: none !important;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08) !important;
        transition: 0.2s ease;
    }

    .custom-info-card:hover {
        transform: translateY(-3px);
    }

    /* Titles */
    .section-title {
        font-weight: 700;
        font-size: 20px;
        color: #4e73df;
    }

    /* Empty state */
    .empty-state {
        padding: 16px;
        background: #fafbff;
        border-radius: 10px;
        color: #777;
        text-align: center;
    }

    /* Buttons inside card */
    .custom-info-card .btn {
        border-radius: 8px;
        padding: 6px 10px;
    }
</style>
<style>
    .form-control {
        transition: 0.2s;
    }

    .form-control:focus {
        border-color: #4e73df;
        box-shadow: 0 0 6px rgba(78, 115, 223, 0.25);
    }

    .card-body h5 {
        font-size: 16px;
        font-weight: 600;
    }

    .card-body .small {
        font-size: 13px;
        color: #666;
    }

    /* 1. Bao phủ toàn bộ màn hình */
    #preloader {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: #ffffff;
        /* Nền trắng sạch sẽ */
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        z-index: 999999;
        /* Đảm bảo nằm trên mọi thành phần khác */
        transition: opacity 0.8s ease;
        /* Hiệu ứng mờ dần khi biến mất */
    }

    /* 2. Logo với hiệu ứng nhịp thở (Pulse) */
    .loading-logo {
        width: 150px;
        /* Chỉnh kích thước logo tùy ý */
        height: auto;
        animation: pulse 2s infinite ease-in-out;
    }

    @keyframes pulse {
        0% {
            transform: scale(0.95);
            opacity: 0.8;
        }

        50% {
            transform: scale(1.05);
            opacity: 1;
        }

        100% {
            transform: scale(0.95);
            opacity: 0.8;
        }
    }

    /* 3. Thanh chạy ngang bên dưới logo */
    .loader-line {
        width: 200px;
        height: 3px;
        background: #f0f0f0;
        margin-top: 20px;
        position: relative;
        overflow: hidden;
        border-radius: 5px;
    }

    .loader-line::after {
        content: "";
        position: absolute;
        left: -100%;
        width: 100%;
        height: 100%;
        background: #007bff;
        /* Màu xanh chủ đạo */
        animation: lineRun 1.5s infinite;
    }

    @keyframes lineRun {
        0% {
            left: -100%;
        }

        100% {
            left: 100%;
        }
    }

    /* 4. Chữ hiển thị phía dưới */
    .loading-text {
        margin-top: 15px;
        color: #666;
        font-size: 14px;
        font-family: sans-serif;
    }

    /* 5. Class dùng để ẩn loading */
    .fade-out {
        opacity: 0;
        pointer-events: none;
        /* Tránh việc click nhầm vào màn hình đang ẩn */
    }

    /* ================================
   DARK MODE
================================ */
    /* =========================================================
   FULL DARK MODE OVERRIDES – SB ADMIN 2
========================================================= */

    body.dark,
    body.dark #content-wrapper,
    body.dark #wrapper,
    body.dark #content {
        background-color: #1e1e1e !important;
        color: #eaeaea !important;
    }

    /* ===== Sidebar ===== */
    body.dark .sidebar {
        background: #181818 !important;
    }

    body.dark .sidebar .nav-item .nav-link {
        color: #cfcfcf !important;
    }

    body.dark .sidebar .nav-item .nav-link:hover,
    body.dark .sidebar .nav-item.active .nav-link {
        background: #2b2b2b !important;
        color: #fff !important;
    }

    body.dark .sidebar-heading {
        color: #aaa !important;
    }

    /* ===== Topbar ===== */
    body.dark .topbar,
    body.dark .navbar,
    body.dark .navbar-light,
    body.dark .bg-white,
    body.dark .shadow {
        background: #222 !important;
        color: #fff !important;
        border-color: #333 !important;
    }

    /* ===== Card ===== */
    body.dark .card,
    body.dark .card-body {
        background: #2a2d32 !important;
        color: #f0f0f0 !important;
    }

    body.dark .card-header {
        background: #2f3339 !important;
        color: #fff !important;
    }

    /* ===== Modal ===== */
    body.dark .modal-content {
        background: #2c2f34 !important;
        color: #fff !important;
    }

    body.dark .modal-header {
        background: #3a3f45 !important;
        border-bottom: none !important;
    }

    /* ===== Form controls ===== */
    body.dark .form-control {
        background: #2e2e2e !important;
        color: #fff !important;
        border-color: #555 !important;
    }

    body.dark .form-control:focus {
        border-color: #4e73df !important;
        box-shadow: 0 0 6px rgba(78, 115, 223, 0.35) !important;
    }

    /* ===== Buttons ===== */
    body.dark .btn {
        color: #fff !important;
    }

    body.dark .btn-primary {
        background: #3759c1 !important;
    }

    /* ===== Table ===== */
    body.dark table {
        color: #eaeaea !important;
    }

    body.dark .table thead th {
        background: #323232 !important;
        border-color: #444 !important;
    }

    body.dark .table tbody td {
        background: #2a2a2a !important;
        border-color: #444 !important;
    }

    /* ===== Context menu ===== */
    body.dark .map-context-menu {
        background: #2f2f2f !important;
        color: #fff !important;
    }

    body.dark .map-context-menu button:hover {
        background: #3a3a3a !important;
    }

    /* ===== Preloader ===== */
    body.dark #preloader {
        background-color: #111 !important;
    }

    body.dark .loading-text {
        color: #ccc !important;
    }

    /* ===== SB-Admin override for bg/text utilities ===== */
    body.dark .bg-light,
    body.dark .bg-white {
        background: #1f1f1f !important;
    }

    body.dark .text-gray-800,
    body.dark .text-dark {
        color: #f1f1f1 !important;
    }

    body.dark .text-gray-600 {
        color: #cfcfcf !important;
    }

    /* Dark Mode Toggle Icon Align */
    #toggle-darkmode {
        cursor: pointer;
    }

    body.dark #toggle-darkmode i {
        color: #f1c40f !important;
        /* icon vàng khi darkmode */
    }

    body.dark-mode .modal-content {
        background-color: #2b2b2b !important;
        color: #ffffff !important;
        border-color: #444;
    }

    body.dark-mode .modal-header,
    body.dark-mode .modal-footer {
        border-color: #444;
    }

    body.dark-mode .btn-close {
        filter: invert(1);
    }

    body.dark-mode .company-item {
        background: #333;
        border-color: #555 !important;
    }

    body.dark-mode .company-item .text-muted {
        color: #ccc !important;
    }

    body.dark-mode .btn-outline-primary {
        color: #9cc3ff;
        border-color: #9cc3ff;
    }

    body.dark-mode .btn-outline-primary:hover {
        background: #9cc3ff;
        color: #000;
    }

    body.dark-mode .btn-info {
        background: #0dcaf0;
    }
</style>



<body id="page-top">
    <button id="btn-locate-user" class="btn-locate" onclick="locateUser()">
        <i class="fas fa-location-arrow"></i> Vị trí của tôi
    </button>
    <div id="preloader">
        <div class="logo-container">
            <img src="https://i.ibb.co/rGFn3z3m/download-removebg-preview.png" alt="Logo" class="loading-logo">
        </div>
        <div class="loader-line"></div>
        <p class="loading-text">Đang tải dữ liệu...</p>
    </div>
    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <?php include './partials/headerbar.php'; ?>
                <!-- End of Topbar -->

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <!-- <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                                class="fas fa-download fa-sm text-white-50"></i> Generate Report</a>
                    </div> -->
                    <!-- Content Row -->
                    <!-- bản đồ việt map -->
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Bản đồ VietMap</h6>
                                </div>
                                <div class="card-body">
                                    <!-- Map layout -->
                                    <div id="vietmap-container">
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

    <!-- Scroll to Top Button-->

    <div id="map-context-menu" class="map-context-menu">
        <button onclick="openAddCompanyModal()">➕ Thêm công ty</button>
        <button onclick="openGoogleMaps()">📍 Xem trên Google Maps</button>
    </div>

</body>

</html>

<!-- Company Info Modal -->
<div class="modal fade" id="companyInfoModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Thông tin công ty</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>


            <div class="modal-body" id="company-info-container">
                <!-- <div class="text-center p-5">
                    <div class="spinner-border"></div>
                    <div>Đang tải thông tin...</div>
                </div> -->
                <div class="text-center p-5">
                    <div class="spinner-border text-primary" style="width:3rem; height:3rem;"></div>
                    <div class="mt-2 text-muted">Đang tải dữ liệu...</div>
                </div>

            </div>

        </div>
    </div>
</div>
<!-- VietMap dependencies (Leaflet demo) -->
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<script src="https://cdn.socket.io/4.7.5/socket.io.min.js"></script>


<script>
    $(document).ready(() => {
        initWS();
    });
    let socket;

    /* ================================================================
       1) SOCKET.IO
    ================================================================ */
    function initWS() {
        socket = io("https://khkt.itlhbs.io.vn", {
            path: "/api/ws",
            transports: ["websocket"],
            auth: {
                token: getCookie("auth_token")
            }
        });

        socket.on("connect", () => {
            console.log("WS Connected");
        });

        // Server trả về status + last_active_at mới


        socket.on("status_change", data => {
            const {
                user_id,
                status,
                last_active_at
            } = data;

            // Cập nhật list bên sidebar
            const item = $(`.chat-item[data-uid="${user_id}"]`);
            if (item.length) {
                const obj = item.data("userObj");
                obj.status = status;
                obj.last_active_at = last_active_at;
                item.data("userObj", obj);
                item.attr("data-status", status);
            }

            // Cập nhật trạng thái phần header chat
            // refreshChatOnlineStatus();
            // updateHeaderStatus();

            // ⭐ Cập nhật Message Center luôn
            updateMessageCenterStatus(user_id, status);
        });

        socket.on("message", msg => {
            if (msg.chat_id === CURRENT_CHAT) {
                appendMessage(msg); // chat đang mở
            } else {
                highlightChatItem(msg.chat_id);
                document.getElementById("newMessageSound").play();
                notifyNewMessage(msg);
            }

            // 🔥⚡ Cập nhật Message Center
            updateMessageCenterNewMessage(msg);
        });



        // Idle/Active
        let idleTimer;

        // Đánh dấu idle sau 5 giây không focus
        function setIdle() {
            socket.emit("user_idle");
        }

        function setActive() {
            socket.emit("user_active");
            clearTimeout(idleTimer);
            idleTimer = setTimeout(setIdle, 5000);
        }

        // Khi tab bị ẩn
        document.addEventListener("visibilitychange", () => {
            if (document.hidden) setIdle();
            else setActive();
        });

        // Khi chuyển sang cửa sổ khác
        window.addEventListener("blur", () => {
            setIdle();
        });

        // Khi quay lại cửa sổ
        window.addEventListener("focus", () => {
            setActive();
        });

    }

    const VIETMAP_ACCESS_TOKEN = "YOUR_VIETMAP_ACCESS_TOKEN";

    const map = L.map('vm-map').setView([10.776530, 106.700981], 13);
    // const lightLayer = L.tileLayer(
    //     "https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png?api_key=8ca17792-2dc1-4eee-9169-6e56a2fa470b", {
    //         maxZoom: 20,
    //         attribution: '&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, ' +
    //             '&copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> ' +
    //             '&copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors'
    //     }
    // ).addTo(map);
    const lightLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
    }).addTo(map);
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




    const markers = L.layerGroup().addTo(map);

    let allCompanies = [];
    let companyMarkers = {}; // Lưu marker theo companyId

    // ----- LOAD ALL COMPANIES -----
    async function loadCompanies() {
        try {
            const res = await fetch("https://khkt.itlhbs.io.vn/api/companies");
            const json = await res.json();

            if (json.code !== 200 || !json.data) return;

            allCompanies = json.data;

            json.data.filter(x => x.is_active === true && x.is_deleted === false).forEach(c => {
                if (c.lat && c.lng) {

                    const popupHtml = `
<div style="width: 240px; padding: 4px;">
    <h5 style="margin:0; font-size:16px; font-weight:600;">${c.name}</h5>
    <div style="font-size:13px; color:#666;">${c.address ?? ''}</div>

    <div style="margin-top:10px; display:flex; gap:6px;">
        <button class="btn btn-primary btn-sm w-50"
            onclick="showCompanyModalAndInfo('${c.id}')">
            Chi tiết
        </button>

        <a class="btn btn-success btn-sm w-50"
            href="https://www.google.com/maps?q=${c.lat},${c.lng}" 
            target="_blank">
            Google Maps
        </a>
    </div>
</div>
`;


                    const marker = L.marker([c.lat, c.lng]).addTo(markers);
                    marker.bindPopup(popupHtml);

                    companyMarkers[c.id] = marker;
                }
            });


            const group = new L.featureGroup(markers.getLayers());
            map.fitBounds(group.getBounds().pad(0.2));

        } catch (err) {
            console.error("Lỗi khi load companies:", err);
        }
    }

    // ----- LOCATE USER -----
    function locateUser() {
        if (!navigator.geolocation) {
            alert("Trình duyệt không hỗ trợ Geolocation!");
            return;
        }

        navigator.geolocation.getCurrentPosition(pos => {
            const lat = pos.coords.latitude;
            const lng = pos.coords.longitude;

            L.marker([lat, lng], {
                icon: L.icon({
                    iconUrl: 'https://cdn-icons-png.flaticon.com/512/64/64113.png',
                    iconSize: [32, 32],
                    iconAnchor: [16, 32]
                })
            }).addTo(map).bindPopup("Bạn đang ở đây").openPopup();

            map.setView([lat, lng], 15);
        }, err => {
            console.error("Không lấy được vị trí:", err);
        });
    }

    // document.getElementById("vm-loc-btn").onclick = locateUser;


    // ----- AUTO LOCATE COMPANY WHEN ?companyLocate=ID -----
    function autoLocateCompany() {
        const params = new URLSearchParams(window.location.search);
        const id = params.get("companyLocate");
        if (!id) return;

        const marker = companyMarkers[id];
        const company = allCompanies.find(c => c.id == id);

        if (!marker || !company) {
            console.warn("companyLocate id không hợp lệ!");
            return;
        }

        map.setView([company.lat, company.lng], 17);
        marker.openPopup();
    }


    // ----- RUN -----
    loadCompanies().then(() => {
        // locateUser();
        autoLocateCompany();

        setTimeout(() => {
            map.invalidateSize();
        }, 300);
    });
    document.addEventListener("DOMContentLoaded", function() {
        if (document.body.classList.contains("dark")) {
            map.removeLayer(lightLayer);
            map.addLayer(darkLayer);
        }
        let mFilter = "all";
        let mDebounce;

        // Khi mở modal => reset UI
        $('#companySearchModal').on('shown.bs.modal', function() {
            document.getElementById("m-search-input").focus();
            doModalSearch();
        });

        // FILTER
        document.querySelectorAll("#m-filters button").forEach(btn => {
            btn.addEventListener("click", () => {
                document.querySelector("#m-filters .active").classList.remove("active");
                btn.classList.add("active");
                mFilter = btn.dataset.type;
                doModalSearch();
            });
        });

        // Clear button
        document.getElementById("m-search-clear").addEventListener("click", () => {
            document.getElementById("m-search-input").value = "";
            document.getElementById("m-search-clear").style.display = "none";
            doModalSearch();
        });

        // Input debounce
        document.getElementById("m-search-input").addEventListener("input", () => {
            const v = document.getElementById("m-search-input").value.trim();
            document.getElementById("m-search-clear").style.display = v ? "block" : "none";

            clearTimeout(mDebounce);
            mDebounce = setTimeout(doModalSearch, 300);
        });

        // MAIN SEARCH
        async function doModalSearch() {
            const keyword = document.getElementById("m-search-input").value.trim();
            const loading = document.getElementById("m-loading");
            const result = document.getElementById("m-results");

            loading.style.display = "block";
            result.innerHTML = "";

            try {
                const res = await fetch(`/api/companies/search?keyword=${encodeURIComponent(keyword)}&type=${mFilter}`);
                const data = await res.json();

                loading.style.display = "none";

                if (!data.data || data.data.length === 0) {
                    result.innerHTML = `
                <div class="alert alert-light text-center border">
                    Không tìm thấy kết quả
                </div>
            `;
                    return;
                }

                result.innerHTML = data.data.filter(x => x.is_active === true && x.is_deleted === false).map(item => `
            <div class="p-3 border rounded mb-2 company-item">
                <div class="font-weight-bold">${item.name}</div>
                <div class="text-muted small mb-2">${item.address ?? "Không có địa chỉ"}</div>
                <div class="d-flex gap-2 mt-2">
                    <button class="btn btn-sm btn-outline-primary flex-fill" 
                        onclick="showCompanyModalAndInfo('${item.id}');closeModalById('companySearchModal')">
                        <i class="fas fa-info-circle"></i> Chi tiết
                    </button>
                    <button class="btn btn-sm btn-info flex-fill text-white" 
                        onclick="locateCompanyOnMap('${item.id}')">
                        <i class="fas fa-map-marker-alt"></i> Bản đồ
                    </button>
                </div>
            </div>
        `).join('');

            } catch (err) {
                loading.style.display = "none";
                result.innerHTML = `
            <div class="alert alert-danger">Lỗi kết nối tới server</div>
        `;
            }
        }
    });


    let rightClickLatLng = null;
    const contextMenu = document.getElementById("map-context-menu");

    // Chuột phải trên map
    map.on("contextmenu", function(e) {
        rightClickLatLng = e.latlng;

        contextMenu.style.left = e.containerPoint.x + "px";
        contextMenu.style.top = e.containerPoint.y + "px";
        contextMenu.style.display = "block";
    });

    // Click bất kỳ đâu → ẩn menu
    map.on("click", () => {
        contextMenu.style.display = "none";
    });

    function openAddCompanyModal() {
        contextMenu.style.display = "none";

        document.getElementById("add_lat").value = rightClickLatLng.lat;
        document.getElementById("add_lng").value = rightClickLatLng.lng;

        $("#addCompanyModal").modal("show");
    }

    function openGoogleMaps() {
        contextMenu.style.display = "none";

        const lat = rightClickLatLng.lat;
        const lng = rightClickLatLng.lng;

        window.open(`https://www.google.com/maps?q=${lat},${lng}`, "_blank");
    }
    async function submitAddCompany() {
        const payload = {
            name: document.getElementById("add_name").value,
            address: document.getElementById("add_address").value,
            lat: parseFloat(document.getElementById("add_lat").value),
            lng: parseFloat(document.getElementById("add_lng").value),
        };
        console.log("Submitting new company:", payload);

        try {
            const res = await fetch("https://khkt.itlhbs.io.vn/api/companies", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${getCookie("auth_token")}`
                },
                body: JSON.stringify(payload)
            });

            const json = await res.json();

            if (json.code !== 200) {
                alert("Không thể thêm công ty!");
                return;
            }

            const c = json.data;

            const marker = L.marker([c.lat, c.lng]).addTo(markers);
            marker.bindPopup(`<b>${c.name}</b><br>${c.address ?? ""}`);

            companyMarkers[c.id] = marker;
            allCompanies.push(c);

            $("#addCompanyModal").modal("hide");
            alert("Đã thêm công ty!");

        } catch (e) {
            alert("Lỗi kết nối máy chủ!");
        }
    }
    async function reloadCompanyInfo() {

        await showCompanyModalAndInfo(CURRENT_COMPANY_ID);
    }

    function openRecruitmentModal(data = null) {
        $("#recruitmentModal").modal("show");

        document.getElementById("rec_id").value = data?.id ?? "";
        document.getElementById("rec_title").value = data?.title ?? "";
        document.getElementById("rec_description").value = data?.description ?? "";
        document.getElementById("rec_requirements").value = data?.requirements ?? "";
        document.getElementById("rec_location").value = data?.location ?? "";
        document.getElementById("rec_salary_from").value = data?.salary_range_from ?? "";
        document.getElementById("rec_salary_to").value = data?.salary_range_to ?? "";
        document.getElementById("rec_type").value = data?.employment_type ?? "";
    }

    async function saveRecruitment() {
        const id = rec_id.value;

        const payload = {
            title: rec_title.value,
            description: rec_description.value,
            requirements: rec_requirements.value,
            location: rec_location.value,
            salary_range_from: rec_salary_from.value,
            salary_range_to: rec_salary_to.value,
            employment_type: rec_type.value,
            company_id: CURRENT_COMPANY_ID
        };

        await fetch(`/api/companies/${CURRENT_COMPANY_ID}/recruitments${id ? "/" + id : ""}`, {
            method: id ? "PUT" : "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${getCookie("auth_token")}`
            },
            body: JSON.stringify(payload)
        });

        $("#recruitmentModal").modal("hide");
        reloadCompanyInfo();
    }

    async function deleteRecruitment(id) {
        if (!confirm("Xóa tin tuyển dụng này?")) return;

        await fetch(`/api/companies/${CURRENT_COMPANY_ID}/recruitments/${id}`, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${getCookie("auth_token")}`
            },
        });
        reloadCompanyInfo();
    }

    function openDeliveryModal(data = null) {
        $("#deliveryModal").modal("show");

        del_id.value = data?.id ?? "";
        del_title.value = data?.title ?? "";
        del_weight.value = data?.weight ?? "";
        del_length.value = data?.length ?? "";
        del_width.value = data?.width ?? "";
        del_height.value = data?.height ?? "";
        del_budget.value = data?.budget ?? "";
    }

    async function saveDelivery() {
        const id = del_id.value;

        const payload = {
            title: del_title.value,
            weight: Number(del_weight.value),
            length: Number(del_length.value),
            width: Number(del_width.value),
            height: Number(del_height.value),
            budget: Number(del_budget.value),
            company_id: CURRENT_COMPANY_ID
        };

        await fetch(`/api/companies/${CURRENT_COMPANY_ID}/deliveries${id ? "/" + id : ""}`, {
            method: id ? "PUT" : "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${getCookie("auth_token")}`
            },
            body: JSON.stringify(payload)
        });

        $("#deliveryModal").modal("hide");
        reloadCompanyInfo();
    }

    async function deleteDelivery(id) {
        if (!confirm("Xóa đơn giao hàng này?")) return;

        await fetch(`/api/companies/${CURRENT_COMPANY_ID}/deliveries/${id}`, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${getCookie("auth_token")}`
            },
        });
        reloadCompanyInfo();
    }

    function openScrapeModal(data = null) {
        $("#scrapeModal").modal("show");

        scr_id.value = data?.id ?? "";
        scr_name.value = data?.name ?? "";
        scr_quantity.value = data?.quantity ?? "";
        scr_unit.value = data?.unit_type ?? "";
        scr_price.value = data?.unit_price ?? "";
    }

    async function saveScrape() {
        const id = scr_id.value;

        const payload = {
            name: scr_name.value,
            quantity: Number(scr_quantity.value),
            unit_type: scr_unit.value,
            unit_price: Number(scr_price.value),
            company_id: CURRENT_COMPANY_ID
        };

        await fetch(`/api/companies/${CURRENT_COMPANY_ID}/scrapes${id ? "/" + id : ""}`, {
            method: id ? "PUT" : "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${getCookie("auth_token")}`
            },
            body: JSON.stringify(payload)
        });

        $("#scrapeModal").modal("hide");
        reloadCompanyInfo();
    }

    async function deleteScrape(id) {
        if (!confirm("Xóa dữ liệu thu gom này?")) return;

        await fetch(`/api/companies/${CURRENT_COMPANY_ID}/scrapes/${id}`, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${getCookie("auth_token")}`
            },
        });
        reloadCompanyInfo();
    }

    function encodeData(obj) {
        return JSON.stringify(obj).replace(/"/g, '&quot;');
    }
    document.addEventListener("DOMContentLoaded", function() {
        // 1. Ngay khi vào trang, bắt đầu định vị ngầm
        if (typeof locateUser === "function") {
            // locateUser(); 
        }

        // 2. Thiết lập thời gian chờ 3 giây cho màn hình Loading
        window.addEventListener("load", function() {
            setTimeout(() => {
                const preloader = document.getElementById("preloader");
                if (preloader) {
                    // Thêm class để kích hoạt hiệu ứng mờ dần từ CSS
                    preloader.classList.add("fade-out");

                    // Đợi hiệu ứng mờ kết thúc (0.8s) rồi xóa hẳn khỏi giao diện
                    setTimeout(() => {
                        preloader.style.display = "none";
                    }, 800);
                }
            }, 1000);
        });
    });
    const toggleBtn = document.getElementById("toggle-darkmode");

    // Tải trạng thái Dark Mode từ localStorage
    if (localStorage.getItem("darkmode") === "enabled") {
        document.body.classList.add("dark");
    }

    toggleBtn.addEventListener("click", () => {
        document.body.classList.toggle("dark");

        if (document.body.classList.contains("dark")) {
            localStorage.setItem("darkmode", "enabled");
            toggleBtn.innerHTML = "☀️";
            map.removeLayer(lightLayer);
            map.addLayer(darkLayer);
        } else {
            localStorage.setItem("darkmode", "disabled");
            toggleBtn.innerHTML = "🌙";
            map.removeLayer(darkLayer);
            map.addLayer(lightLayer);
        }
    });

    // Đổi icon nút ngay khi load
    toggleBtn.innerHTML = document.body.classList.contains("dark") ? "☀️" : "🌙";

    function applyMapDarkMode(isDark) {
        if (!window.vmMap) return;

        window.vmMap.setStyle(isDark ? "vm2019night" : "vm2019");
    }

    function confirmDeleteCompany(companyId, companyName) {
        const ok = confirm(
            `Bạn có chắc chắn muốn XÓA công ty:\n\n"${companyName}"\n\nHành động này KHÔNG thể hoàn tác!`
        );

        if (!ok) return;

        deleteCompany(companyId);
    }
    async function deleteCompany(companyId) {
        try {
            const res = await fetch(
                `https://khkt.itlhbs.io.vn/api/companies/${companyId}`, {
                    method: "DELETE",
                    headers: {
                        Authorization: `Bearer ${getCookie("auth_token")}`
                    }
                }
            );

            const json = await res.json();

            if (json.code !== 200) {
                alert("Không thể xóa công ty!");
                return;
            }

            /* ===== XÓA MARKER TRÊN MAP ===== */
            if (companyMarkers[companyId]) {
                markers.removeLayer(companyMarkers[companyId]);
                delete companyMarkers[companyId];
            }

            /* ===== XÓA KHỎI LIST ===== */
            allCompanies = allCompanies.filter(c => c.id !== companyId);

            $("#companyInfoModal").modal("hide");

            alert("Đã xóa công ty thành công!");

        } catch (err) {
            console.error(err);
            alert("Lỗi kết nối máy chủ!");
        }
    }

    function updateMessageCenterNewMessage(msg) {
        const list = document.getElementById("messageCenterList");
        const meId = window.ME_ID;

        // Xác định người gửi (other user)
        const otherUser = msg.sender;
        const time = timeAgo(msg.created_at);

        const avatar = otherUser.avatar || "https://ui-avatars.com/api/?name=" + encodeURIComponent(otherUser.display_name);

        const statusColor =
            otherUser.status === "online" ? "bg-success" :
            otherUser.status === "idle" ? "bg-warning" :
            "bg-secondary";

        // Gỡ item cũ nếu có
        const oldItem = list.querySelector(`[data-chat-id="${msg.chat_id}"]`);
        if (oldItem) oldItem.remove();

        const html = `
        <a class="dropdown-item d-flex align-items-center new-msg" 
           href="/message.php?chat_to=${otherUser.id}"
           data-chat-id="${msg.chat_id}">
            
            <div class="dropdown-list-image me-3 position-relative">
                <img class="rounded-circle" src="${avatar}" width="60" height="60">
                <div class="status-indicator ${statusColor}"></div>
            </div>

            <div class="flex-grow-1">
                <div class="text-truncate fw-bold">${msg.content}</div>
                <div class="small text-gray-500">${otherUser.display_name} · ${time}</div>
            </div>
        </a>
    `;

        // Đặt lên đầu danh sách
        list.insertAdjacentHTML("afterbegin", html);

        // Update counter
        const messageCounter = document.getElementById("messageCounter");
        messageCounter.innerHTML = list.children.length;
    }


    async function loadMessageCenter() {
        const res = await fetch("/api/users/@me", {
            headers: {
                "Authorization": "Bearer " + getCookie('auth_token')
            }
        });

        const json = await res.json();
        if (json.code !== 200) return;

        const me = json.data;
        const chats = me.chats;

        const list = document.getElementById("messageCenterList");
        const messageCounter = document.getElementById("messageCounter");
        messageCounter.innerHTML = chats.length;
        list.innerHTML = "";

        chats.forEach(chat => {
            const otherUser = chat.users.find(u => u.id !== me.id);

            const lastMsg = chat.messages?.[0];
            const time = lastMsg ? timeAgo(lastMsg.created_at) : "Chưa có tin nhắn";

            const statusColor =
                otherUser.status === "online" ? "bg-success" :
                otherUser.status === "idle" ? "bg-warning" :
                "bg-secondary";

            const avatar = otherUser.avatar || "https://ui-avatars.com/api/?name=" + encodeURIComponent(otherUser.display_name);

            const html = `
    <a class="dropdown-item d-flex align-items-center user-status-item"
       data-uid="${otherUser.id}"
       href="/message.php?chat_to=${otherUser.id}">

        <div class="dropdown-list-image me-3 position-relative">
            <img class="rounded-circle" src="${avatar}" width="60" height="60">
            <div class="status-indicator ${statusColor}"></div>
        </div>

        <div class="flex-grow-1">
            <div class="text-truncate">${lastMsg ? lastMsg.content : "Chưa có tin nhắn"}</div>
            <div class="small text-gray-500">
                ${otherUser.display_name} · ${time}
            </div>
        </div>
    </a>
`;


            list.insertAdjacentHTML("beforeend", html);
        });
    }

    function updateMessageCenterStatus(user_id, status) {
        const items = document.querySelectorAll(`.user-status-item[data-uid="${user_id}"]`);

        items.forEach(el => {
            const indicator = el.querySelector(".status-indicator");

            indicator.classList.remove("bg-success", "bg-warning", "bg-secondary");

            if (status === "online") indicator.classList.add("bg-success");
            else if (status === "idle") indicator.classList.add("bg-warning");
            else indicator.classList.add("bg-secondary");
        });
    }

    function timeAgo(dateStr) {
        const seconds = (new Date() - new Date(dateStr)) / 1000;

        if (seconds < 60) return "vừa xong";
        if (seconds < 3600) return Math.floor(seconds / 60) + " phút";
        if (seconds < 86400) return Math.floor(seconds / 3600) + " giờ";
        return Math.floor(seconds / 86400) + " ngày";
    }


    // Gọi khi mở dropdown
    document.getElementById("messagesDropdown").addEventListener("click", loadMessageCenter);

    function closeModalById(modalId) {
        $(`#${modalId}`).modal("hide");
    }
    let CURRENT_COMPANY_ID = null;


    async function showCompanyModalAndInfo(companyId) {
        CURRENT_COMPANY_ID = companyId;
        $("#companyInfoModal").modal("show");

        const container = document.getElementById("company-info-container");
        container.innerHTML = `
        <div class="text-center p-5">
            <div class="spinner-border"></div>
            <div>Đang tải thông tin...</div>
        </div>
    `;

        try {
            const res = await fetch(`https://khkt.itlhbs.io.vn/api/companies/${companyId}`);
            const data = await res.json();

            if (!data.data) {
                container.innerHTML = `<div class="alert alert-danger">Không tìm thấy công ty!</div>`;
                return;
            }

            const c = data.data;

            container.innerHTML = `
<div class="form-group">
    <label>Tên Công ty</label>
    <input type="text" id="info_name" class="form-control" value="${c.name ?? ""}">
</div>

<div class="form-group">
    <label>Địa chỉ</label>
    <input type="text" id="info_address" class="form-control" value="${c.address ?? ""}">
</div>

<div class="form-group">
    <label>Điện thoại</label>
    <input type="text" id="info_phone" class="form-control" value="${c.phone ?? ""}">
</div>

<div class="form-group">
    <label>Email</label>
    <input type="text" id="info_email" class="form-control" value="${c.email ?? ""}">
</div>

<div class="form-group">
    <label>Website</label>
    <input type="text" id="info_website" class="form-control" value="${c.website ?? ""}">
</div>

<div class="form-row">
    <div class="form-group col-6">
        <label>Lat</label>
        <input type="text" id="info_lat" class="form-control" value="${c.lat ?? ""}">
    </div>

    <div class="form-group col-6">
        <label>Lng</label>
        <input type="text" id="info_lng" class="form-control" value="${c.lng ?? ""}">
    </div>
</div>
<button class="btn btn-warning btn-lg btn-block mt-3 shadow-sm"
        onclick="saveCompanyInfo('${c.id}')">
    Lưu thay đổi
</button>

<button class="btn btn-danger btn-lg btn-block mt-2 shadow-sm"
        onclick="confirmDeleteCompany('${c.id}', '${c.name ?? ""}')">
    ❌ Xóa công ty
</button>

<button onclick="locateCompanyOnMap('${c.id}')" 
        class="btn btn-sm btn-info mt-2">
    Xem trên bản đồ
</button>

<button onclick="window.location.href='/message.php?chat_to=${c.owned_by}&content=Xin chào ${encodeURIComponent(c.name)}! Tôi muốn liên hệ với công ty của bạn.'" 
        class="btn btn-sm btn-success mt-2">
    Nhắn tin cho người đại diện công ty
</button>
            <hr>

            <!-- ===================== TUYỂN DỤNG ===================== -->
<div class="mt-4">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <h4 class="mb-0">📌 Tuyển dụng</h4>
        <button class="btn btn-sm btn-success"
            onclick="openRecruitmentModal()">
            ➕ Thêm
        </button>
    </div>

    <div class="bg-light rounded p-3">
        ${renderRecruitments(c.recruitments)}
    </div>
</div>

<!-- ===================== GIAO HÀNG ===================== -->
<div class="mt-4">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <h4 class="mb-0">🚚 Giao hàng</h4>
        <button class="btn btn-sm btn-success"
            onclick="openDeliveryModal()">
            ➕ Thêm
        </button>
    </div>

    <div class="bg-light rounded p-3">
        ${renderDeliveries(c.deliveries)}
    </div>
</div>

<!-- ===================== THU GOM PHẾ LIỆU ===================== -->
<div class="mt-4">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <h4 class="mb-0">♻️ Thu gom phế liệu</h4>
        <button class="btn btn-sm btn-success"
            onclick="openScrapeModal()">
            ➕ Thêm
        </button>
    </div>

    <div class="bg-light rounded p-3">
        ${renderScrapes(c.scrapes)}
    </div>
</div>

        `;
        } catch (err) {
            console.error(err);
            container.innerHTML = `<div class="alert alert-danger">Lỗi kết nối đến máy chủ!</div>`;
        }
    }


    /* ==========================
       RENDER RECRUITMENTS
       ========================== */
    function renderRecruitments(list = []) {
        if (!list.length) {
            return `<div class="alert alert-light">Chưa có tin tuyển dụng</div>`;
        }

        return list.map(r => `
        <div class="card mb-3 shadow-sm">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h5 class="mb-1">${r.title}</h5>
                    <div>
                        <button class="btn btn-sm btn-outline-warning"
                            onclick="openRecruitmentModal('edit', '${r.id}')">✏️</button>
                        <button class="btn btn-sm btn-outline-danger"
                            onclick="deleteRecruitment('${r.id}')">❌</button>
                    </div>
                </div>

                <p class="text-muted mb-2">${r.description}</p>

                <div class="row small">
                    <div class="col-md-6"><b>Yêu cầu:</b> ${r.requirements}</div>
                    <div class="col-md-6"><b>Địa điểm:</b> ${r.location ?? "Không có"}</div>
                    <div class="col-md-6">
                        <b>Lương:</b> ${r.salary_range_from ?? "?"} - ${r.salary_range_to ?? "?"}
                    </div>
                    <div class="col-md-6">
                        <b>Hình thức:</b> ${r.employment_type ?? "Không có"}
                    </div>
                </div>
            </div>
        </div>
    `).join("");
    }



    /* ==========================
       RENDER DELIVERIES
       ========================== */
    function renderDeliveries(list = []) {
        if (!list.length)
            return `<div class="alert alert-light">Chưa có đơn giao hàng</div>`;

        return list.map(d => `
        <div class="card mb-3 shadow-sm">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h5>${d.title}</h5>
                    <div>
                        <button class="btn btn-sm btn-outline-warning"
                            onclick="openDeliveryModal('edit','${d.id}')">✏️</button>
                        <button class="btn btn-sm btn-outline-danger"
                            onclick="deleteDelivery('${d.id}')">❌</button>
                    </div>
                </div>

                <div class="row small mt-2">
                    <div class="col-6"><b>Khối lượng:</b> ${d.weight} kg</div>
                    <div class="col-6"><b>Ngân sách:</b> ${d.budget} đ</div>
                    <div class="col-12">
                        <b>Kích thước:</b>
                        ${d.length} × ${d.width} × ${d.height} cm
                    </div>
                </div>
            </div>
        </div>
    `).join("");
    }



    /* ==========================
       RENDER SCRAPES
       ========================== */
    function renderScrapes(list = []) {
        if (!list.length)
            return `<div class="alert alert-light">Chưa có dữ liệu thu gom</div>`;

        return list.map(s => `
        <div class="card mb-3 shadow-sm">
            <div class="card-body d-flex justify-content-between">
                <div>
                    <h5>${s.name}</h5>
                    <div class="small">
                        <b>Số lượng:</b> ${s.quantity} ${s.unit_type}<br>
                        <b>Đơn giá:</b> ${s.unit_price} đ
                    </div>
                </div>
                <div>
                    <button class="btn btn-sm btn-outline-warning"
                        onclick="openScrapeModal('edit','${s.id}')">✏️</button>
                    <button class="btn btn-sm btn-outline-danger"
                        onclick="deleteScrape('${s.id}')">❌</button>
                </div>
            </div>
        </div>
    `).join("");
    }


    function locateCompanyOnMap(companyId) {
        window.location.href = "/?companyLocate=" + companyId;
    }
    async function saveCompanyInfo(id) {
        const payload = {
            name: document.getElementById("info_name").value,
            address: document.getElementById("info_address").value,
            phone: document.getElementById("info_phone").value,
            email: document.getElementById("info_email").value,
            website: document.getElementById("info_website").value,
            lat: parseFloat(document.getElementById("info_lat").value),
            lng: parseFloat(document.getElementById("info_lng").value)
        };

        try {
            const res = await fetch(`https://khkt.itlhbs.io.vn/api/companies/${id}`, {
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${getCookie("auth_token")}`
                },
                body: JSON.stringify(payload)
            });

            const json = await res.json();

            if (json.code !== 200) {
                alert("Lỗi khi cập nhật!");
                return;
            }

            alert("Cập nhật thành công!");

            // Cập nhật lại marker
            // updateCompanyMarker(id, payload);

        } catch (e) {
            alert("Không thể lưu thông tin!");
        }
    }
</script>


<!-- COMPANY SEARCH MODAL -->
<div class="modal fade" id="companySearchModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-search mr-2 text-primary"></i> Tìm kiếm công ty
                </h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>

            <div class="modal-body">

                <!-- FILTERS -->
                <div class="d-flex flex-wrap mb-3" id="m-filters">
                    <button class="btn btn-light border mr-2 mb-2 active" data-type="all">Tất cả</button>
                    <button class="btn btn-light border mr-2 mb-2" data-type="recruitments">Recruitments</button>
                    <button class="btn btn-light border mr-2 mb-2" data-type="deliveries">Deliveries</button>
                    <button class="btn btn-light border mb-2" data-type="scrapes">Scrapes</button>
                </div>

                <!-- SEARCH BOX -->
                <div class="position-relative mb-3" style="max-width: 540px;">
                    <input id="m-search-input" class="form-control pl-5 pr-5" placeholder="Nhập từ khóa...">

                    <i class="fas fa-search text-muted position-absolute"
                        style="left: 15px; top: 10px;"></i>

                    <button id="m-search-clear" class="btn btn-sm position-absolute"
                        style="right: 10px; top: 4px; display:none;">✕</button>
                </div>

                <!-- LOADING -->
                <div id="m-loading" class="mt-2" style="display:none;">
                    <div class="spinner-border spinner-border-sm text-primary"></div>
                    <span class="small text-primary ml-1">Đang tìm...</span>
                </div>

                <!-- RESULTS -->
                <div id="m-results" class="mt-3"></div>

            </div>
        </div>
    </div>
</div>



<div class="modal fade" id="addCompanyModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Thêm công ty mới</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>

            <div class="modal-body">
                <div class="form-group">
                    <label>Tên công ty</label>
                    <input type="text" id="add_name" class="form-control">
                </div>

                <div class="form-group">
                    <label>Địa chỉ</label>
                    <input type="text" id="add_address" class="form-control">
                </div>

                <div class="form-row">
                    <div class="form-group col-6">
                        <label>Lat</label>
                        <input type="text" id="add_lat" class="form-control" readonly>
                    </div>
                    <div class="form-group col-6">
                        <label>Lng</label>
                        <input type="text" id="add_lng" class="form-control" readonly>
                    </div>
                </div>

                <button class="btn btn-primary btn-block" onclick="submitAddCompany()">
                    Thêm công ty
                </button>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="recruitmentModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="recruitmentModalTitle"></h5>
                <button class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="rec_id">

                <input class="form-control mb-2" id="rec_title" placeholder="Tiêu đề">
                <textarea class="form-control mb-2" id="rec_description" placeholder="Mô tả"></textarea>
                <textarea class="form-control mb-2" id="rec_requirements" placeholder="Yêu cầu"></textarea>

                <div class="row">
                    <div class="col-6">
                        <input class="form-control" id="rec_salary_from" placeholder="Lương từ">
                    </div>
                    <div class="col-6">
                        <input class="form-control" id="rec_salary_to" placeholder="Lương đến">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" onclick="submitRecruitment()">Lưu</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="recruitmentModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Tin tuyển dụng</h5>
                <button class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="rec_id">

                <input class="form-control mb-2" id="rec_title" placeholder="Tiêu đề">
                <textarea class="form-control mb-2" id="rec_description" placeholder="Mô tả"></textarea>
                <textarea class="form-control mb-2" id="rec_requirements" placeholder="Yêu cầu"></textarea>
                <input class="form-control mb-2" id="rec_location" placeholder="Địa điểm">
                <input class="form-control mb-2" id="rec_salary_from" placeholder="Lương từ">
                <input class="form-control mb-2" id="rec_salary_to" placeholder="Lương đến">
                <input class="form-control mb-2" id="rec_type" placeholder="Hình thức">
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" onclick="saveRecruitment()">💾 Lưu</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="deliveryModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Đơn giao hàng</h5>
                <button class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="del_id">

                <input class="form-control mb-2" id="del_title" placeholder="Tiêu đề">
                <input class="form-control mb-2" id="del_weight" placeholder="Khối lượng (kg)" type="number">

                <div class="form-row">
                    <div class="col">
                        <input class="form-control mb-2" id="del_length" placeholder="Dài (cm)" type="number">
                    </div>
                    <div class="col">
                        <input class="form-control mb-2" id="del_width" placeholder="Rộng (cm)" type="number">
                    </div>
                    <div class="col">
                        <input class="form-control mb-2" id="del_height" placeholder="Cao (cm)" type="number">
                    </div>
                </div>

                <input class="form-control mb-2" id="del_budget" placeholder="Ngân sách (đ)" type="number">
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" onclick="saveDelivery()">💾 Lưu</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="scrapeModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thu gom phế liệu</h5>
                <button class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="scr_id">

                <input class="form-control mb-2" id="scr_name" placeholder="Tên phế liệu">
                <input class="form-control mb-2" id="scr_quantity" placeholder="Số lượng" type="number">
                <input class="form-control mb-2" id="scr_unit" placeholder="Đơn vị (kg, tấn...)">
                <input class="form-control mb-2" id="scr_price" placeholder="Đơn giá" type="number">
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" onclick="saveScrape()">💾 Lưu</button>
            </div>
        </div>
    </div>
</div>