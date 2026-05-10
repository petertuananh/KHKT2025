<ul class="navbar-nav bg-secondary sidebar sidebar-dark accordion " id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/">
        <img src="/assets/TRASHELOGO(1).png" alt="..." class="mx-auto" style="height: 3vw !important">
    </a>

    <!-- Divider -->
    <hr class="sidebar-divider my-0">

    <!-- Nav Item - Dashboard -->
    <li class="nav-item active">
        <a class="nav-link" href="/manage">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Trang chủ</span></a>
    </li>

    <!-- Divider -->

    <li class="nav-item active">
        <a class="nav-link" href="/manage/map.php">
            <i class="fa-solid fa-map"></i>
            <span>Bản đồ số</span></a>
    </li>

    <li class="nav-item active">
        <a class="nav-link" href="/manage/cart.php">
            <i class="fa-solid fa-cart-shopping"></i>
            <span>Giỏ hàng</span></a>
    </li>

    <li class="nav-item active">
        <a class="nav-link" href="/manage/orders.php">
            <i class="fa-solid fa-box"></i>
            <span>Đơn hàng</span></a>
    </li>

    <li class="nav-item active">
        <a class="nav-link" href="/manage/user.php">
            <i class="fa-solid fa-user"></i>
            <span>Trang cá nhân</span></a>
    </li>

    <li class="nav-item active">
        <a class="nav-link" href="/manage/wallet.php">
            <i class="fa-solid fa-wallet"></i>
            <span>Ví</span></a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider">

    <!-- Heading -->
    <div class="sidebar-heading">
        Quản lý
    </div>
    <!-- Nav Item - Tables -->
    <li class="nav-item">
        <a class="nav-link" href="/manage/companies.php">
            <i class="fa-solid fa-building"></i>
            <span>Doanh nghiệp của tôi</span></a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="/manage/places.php">
            <i class="fa-solid fa-location-pin"></i>
            <span>Địa điểm của tôi</span></a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="/manage/products.php">
            <i class="fa-solid fa-shop"></i>
            <span>Mặt hàng của tôi</span></a>
    </li>


    <!-- ADMIN SIDEBAR -->
    <div id="admin-sidebar" class="d-none">

        <!-- Divider -->
        <hr class="sidebar-divider">

        <!-- Heading -->
        <div class="sidebar-heading">
            Quản trị
        </div>

        <!-- Users -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminUsers">
                <i class="fa-solid fa-user"></i>
                <span>Người dùng</span>
            </a>
            <div id="collapseAdminUsers" class="collapse">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Quản lý người dùng</h6>
                    <a class="collapse-item" href="/manage/admin/users.php">Danh sách người dùng</a>
                    <a class="collapse-item" href="/manage/admin/user-campaigns.php">Quét hàng loạt</a>
                </div>
            </div>
        </li>

        <!-- Companies -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminCompanies">
                <i class="fa-solid fa-building"></i>
                <span>Doanh nghiệp</span>
            </a>
            <div id="collapseAdminCompanies" class="collapse">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Quản lý doanh nghiệp</h6>
                    <a class="collapse-item" href="/manage/admin/companies.php">Danh sách</a>
                    <a class="collapse-item" href="/manage/admin/companies-verify.php">Xác minh</a>
                </div>
            </div>
        </li>

        <!-- Places -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminPlaces">
                <i class="fa-solid fa-location-dot"></i>
                <span>Địa điểm</span>
            </a>
            <div id="collapseAdminPlaces" class="collapse">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Quản lý địa điểm</h6>
                    <a class="collapse-item" href="/manage/admin/places.php">Danh sách</a>
                </div>
            </div>
        </li>

        <!-- Categories -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminProductList">
                <i class="fa-solid fa-list"></i>
                <span>Danh mục sản phẩm</span>
            </a>
            <div id="collapseAdminProductList" class="collapse">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Quản lý danh mục</h6>
                    <a class="collapse-item" href="/manage/admin/categories.php">Danh sách</a>
                </div>
            </div>
        </li>

        <!-- Products -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminProducts">
                <i class="fa-solid fa-shop"></i>
                <span>Sản phẩm</span>
            </a>
            <div id="collapseAdminProducts" class="collapse">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Quản lý sản phẩm</h6>
                    <a class="collapse-item" href="/manage/admin/products.php">Danh sách</a>
                </div>
            </div>
        </li>

        <!-- Orders -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminOrders">
                <i class="fa-solid fa-box"></i>
                <span>Đơn hàng</span>
            </a>
            <div id="collapseAdminOrders" class="collapse">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Quản lý đơn hàng</h6>
                    <a class="collapse-item" href="/manage/admin/orders.php">Danh sách</a>
                </div>
            </div>
        </li>

    </div>
    <!-- END ADMIN SIDEBAR -->


    <!-- Divider -->
    <!-- <hr class="sidebar-divider"> -->

    <!-- Heading -->
    <!-- <div class="sidebar-heading">
        Interface
    </div> -->

    <!-- Nav Item - Pages Collapse Menu -->
    <!-- <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUser"
            aria-expanded="true" aria-controls="collapseUser">
            <i class="fas fa-fw fa-cog"></i>
            <span>Components</span>
        </a>
        <div id="collapseUser" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded">
                <h6 class="collapse-header">Custom Components:</h6>
                <a class="collapse-item" href="buttons.html">Buttons</a>
                <a class="collapse-item" href="cards.html">Cards</a>
            </div>
        </div>
    </li> -->

    <!-- Nav Item - Utilities Collapse Menu -->
    <!-- <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities"
            aria-expanded="true" aria-controls="collapseUtilities">
            <i class="fas fa-fw fa-wrench"></i>
            <span>Utilities</span>
        </a>
        <div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities"
            data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded">
                <h6 class="collapse-header">Custom Utilities:</h6>
                <a class="collapse-item" href="utilities-color.html">Colors</a>
                <a class="collapse-item" href="utilities-border.html">Borders</a>
                <a class="collapse-item" href="utilities-animation.html">Animations</a>
                <a class="collapse-item" href="utilities-other.html">Other</a>
            </div>
        </div>
    </li> -->

    <!-- Divider -->
    <!-- <hr class="sidebar-divider"> -->

    <!-- Heading -->
    <!-- <div class="sidebar-heading">
        Addons
    </div> -->

    <!-- Nav Item - Pages Collapse Menu -->
    <!-- <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapsePages"
            aria-expanded="true" aria-controls="collapsePages">
            <i class="fas fa-fw fa-folder"></i>
            <span>Pages</span>
        </a>
        <div id="collapsePages" class="collapse" aria-labelledby="headingPages" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded">
                <h6 class="collapse-header">Login Screens:</h6>
                <a class="collapse-item" href="login.html">Login</a>
                <a class="collapse-item" href="register.html">Register</a>
                <a class="collapse-item" href="forgot-password.html">Forgot Password</a>
                <div class="collapse-divider"></div>
                <h6 class="collapse-header">Other Pages:</h6>
                <a class="collapse-item" href="404.html">404 Page</a>
                <a class="collapse-item" href="blank.html">Blank Page</a>
            </div>
        </div>
    </li> -->

    <!-- Nav Item - Charts -->
    <!-- <li class="nav-item">
        <a class="nav-link" href="charts.html">
            <i class="fas fa-fw fa-chart-area"></i>
            <span>Charts</span></a>
    </li> -->

    <!-- Nav Item - Tables -->
    <!-- <li class="nav-item">
        <a class="nav-link" href="tables.html">
            <i class="fas fa-fw fa-table"></i>
            <span>Tables</span></a>
    </li> -->

    <!-- Divider -->
    <!-- <hr class="sidebar-divider d-none d-md-block"> -->

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

    <!-- Sidebar Message -->
    <!-- <div class="sidebar-card d-none d-lg-flex">
        <img class="sidebar-card-illustration mb-2" src="img/undraw_rocket.svg" alt="...">
        <p class="text-center mb-2"><strong>SB Admin Pro</strong> is packed with premium features, components, and more!</p>
        <a class="btn btn-success btn-sm" href="https://startbootstrap.com/theme/sb-admin-pro">Upgrade to Pro!</a>
    </div> -->

</ul>