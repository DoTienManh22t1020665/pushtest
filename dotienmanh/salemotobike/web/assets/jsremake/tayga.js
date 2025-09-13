// tayga.js: Toggle "yêu thích" lưu tạm vào localStorage (UI demo).
(function () {
  const KEY = "listfavIds";

  const readFavs = () => {
    try { return JSON.parse(localStorage.getItem(KEY) || "[]"); }
    catch { return []; }
  };
  const writeFavs = (arr) => localStorage.setItem(KEY, JSON.stringify(arr));

  const setPressed = (btn, active) => {
    btn.classList.toggle("active", active);
    btn.setAttribute("aria-pressed", String(active));
  };

  const favs = new Set(readFavs());

  // Khởi tạo trạng thái nút theo localStorage
  document.querySelectorAll(".fav-btn").forEach(btn => {
    const id = btn.getAttribute("data-id");
    const active = favs.has(id);
    setPressed(btn, active);

    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const nowActive = !btn.classList.contains("active");
      setPressed(btn, nowActive);

      if (nowActive) {
        favs.add(id);
      } else {
        favs.delete(id);
      }
      writeFavs(Array.from(favs));
      // TODO: nếu có API backend, gửi AJAX tới /listfav/add|remove ở đây
      // fetch(`/listfav/${nowActive ? 'add' : 'remove'}?id=` + encodeURIComponent(id), { method: 'POST' });
    });
  });
})();
