function getUserLocation() {
  return new Promise((resolve, reject) => {
    if (!navigator.geolocation) {
      resolve({ userLat: 10.959792, userLon: 106.789791 }); // default location for LHBS
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (pos) => {
        resolve({
          userLat: pos.coords.latitude,
          userLon: pos.coords.longitude,
        });
      },
      (err) => {
        resolve({ userLat: 10.959792, userLon: 106.789791 });console.error(err); // default location for LHBS
      },
    );
  });
}

async function searchAI() {
  // search
  const query = document.getElementById("query").value;
  const min_stock = Number(document.getElementById("min_stock").value || 1);
  const max_price = Number(document.getElementById("max_price").value || null);
  const location = await getUserLocation();
  const res = await fetch("/api/search", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      query,
      min_stock,
      max_price: max_price || null,
      userLat: location.userLat || 10.959792,
      userLon: location.userLon || 106.789791,
    }),
  });
  if (!res.ok) {
    const text = await res.text();
    console.error("Server error:", text);
    return;
  }
  const data = await res.json();
  renderExplain(data.explain);
  renderProductsEle(data.results);
}

function renderExplain(text) {
  const box = document.getElementById("ai-explain");
  box.innerHTML = "🤖 <b>AI:</b> " + text;
  box.classList.remove("d-none");
}

function renderProductsEle(products) {
  const container = document.querySelector("#results");
  container.innerHTML = "";
  if (!products || products.length === 0) {
    container.innerHTML = `
      <div class="col-12">
        <div class="alert alert-warning">
          Không tìm thấy sản phẩm phù hợp
        </div>
      </div>
    `;
    return;
  }

  products.forEach((p) => {

    container.innerHTML += `
      <div class="col-md-4">
        <div class="card h-100 shadow-sm">
          <div class="card-body d-flex flex-column">
            <img src="/api/media-proxy/product_images/${p.id}/${p.files[0]?.id}"
              class="card-img-top mb-3"
              alt="${p.name}"
              style="height: 200px; object-fit: cover;"
            />
            <h5 class="card-title">${p.name}</h5>

            <p class="card-text small text-muted">
              ${p.description || "Không có mô tả"}
            </p>

            <ul class="list-unstyled mb-2">
              <li>💰 <b>${formatPrice(p.price)}</b> / ${p.unit_type}</li>
              <li>📦 Kho: ${p.stock} ${p.unit_type}</li>
              <li>📍 ${p.place?.name || "Không xác định"}</li>
            </ul>

            <div class="mt-auto">
              <span class="badge bg-success">
                Phù hợp ${(p.score.ai_score * 100).toFixed(2)}%
              </span>

              <ul class="mt-2 small text-muted">
                ${p.score.ai_reason.map((r) => `<li>${r}</li>`).join("")}
                <li>Khoảng cách: ${p.score.distance.toFixed(2)} km</li>
              </ul>
            </div>
            <div class="mt-3 mx-auto d-flex flex-row gap-2 align-items-center">
              <button data-require-login class="btn btn-sm btn-primary"
                        onclick="openAddToCart('${p.id}')">
                        🛒 Mua
                    </button>
                    <button class="btn btn-sm btn-outline-dark"
                        onclick="openProduct('${p.id}')">
                        Xem
                    </button>
            </div>
          </div>
        </div>
      </div>
    `;
  });
}
function formatPrice(price) {
  return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " VND";
}
