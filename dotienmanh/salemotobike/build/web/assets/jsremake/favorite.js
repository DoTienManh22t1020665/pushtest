/* ===== LISTFAV v3 ===== */
(function () {
  const CPATH = document.documentElement.getAttribute("data-cpath") || window.CPATH || "";
  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
  const debounce = (fn, t = 220) => { let id; return (...a)=>{ clearTimeout(id); id=setTimeout(()=>fn(...a),t); }; };

  function toast(msg){
    let el = $(".fav-toast");
    if(!el){ el = document.createElement("div"); el.className="fav-toast"; document.body.appendChild(el); }
    el.textContent = msg; el.classList.add("show");
    setTimeout(()=> el.classList.remove("show"), 1600);
  }
  function updateCounters(total){
    const badge = document.querySelector("[data-fav-count]");
    if(badge){ badge.textContent = total; badge.hidden = !(+total>0); }
    const totalEl = document.querySelector("[data-fav-total]");
    if(totalEl) totalEl.textContent = total;
  }
  async function callToggle(id){
    const res = await fetch(`${CPATH}/fav/toggle`, {
      method:"POST",
      headers:{ "Content-Type":"application/x-www-form-urlencoded;charset=UTF-8" },
      body:`id=${encodeURIComponent(id)}`
    });
    if(res.status===401){ location.href = `${CPATH}/login`; return null; }
    return res.json();
  }

  /* XÓA trong trang listfav */
  document.addEventListener("click", async (e)=>{
    const btn = e.target.closest(".js-remove-fav");
    if(!btn) return;
    e.preventDefault();
    const id = btn.dataset.id;
    const card = btn.closest(".fav-card");
    if(!id || !card) return;

    btn.disabled = true;
    try{
      const data = await callToggle(id);
      if(!data) return;

      if(data.ok && data.state==="removed"){
        card.style.transition="transform .25s ease, opacity .25s ease";
        card.style.transform="scale(.98)"; card.style.opacity="0";
        setTimeout(()=> card.remove(), 220);
        updateCounters(data.count);
        toast("Đã xóa khỏi yêu thích");
        checkEmptyStates();
      }else if(data.ok && data.state==="added"){
        await callToggle(id); // hiếm khi lệch trạng thái
      }else{
        alert("Xóa thất bại, vui lòng thử lại.");
      }
    }catch(err){ console.error(err); alert("Không thể kết nối máy chủ."); }
    finally{ btn.disabled=false; }
  });

  /* Nút trái tim ở danh sách khác (giữ nguyên) */
  document.addEventListener("click", async (e)=>{
    const heart = e.target.closest(".fav-btn");
    if(!heart) return;
    e.preventDefault();
    const id = heart.dataset.id;
    if(!id) return;

    heart.disabled = true;
    try{
      const data = await callToggle(id);
      if(!data) return;
      if(data.ok){
        if(data.state==="added"){
          heart.classList.add("is-active");
          heart.setAttribute("aria-pressed","true");
          heart.setAttribute("title","Bỏ yêu thích");
          toast("Đã thêm vào yêu thích");
        }else{
          heart.classList.remove("is-active");
          heart.setAttribute("aria-pressed","false");
          heart.setAttribute("title","Yêu thích");
          toast("Đã xóa khỏi yêu thích");
        }
        updateCounters(data.count);
      }
    }catch(err){ console.error(err); }
    finally{ heart.disabled=false; }
  });

  /* Reveal + skeleton */
  const io = new IntersectionObserver((es)=>{
    es.forEach(en=>{ if(en.isIntersecting){ en.target.classList.add("is-inview"); io.unobserve(en.target);} });
  },{threshold:.08});
  $$(".fav-card").forEach(c=> io.observe(c));

  $$(".fav-thumb img").forEach(img=>{
    const box = img.closest(".fav-thumb");
    if(!box) return;
    box.classList.add("is-loading");
    const done=()=>box.classList.remove("is-loading");
    if(img.complete) done(); else img.addEventListener("load",done,{once:true});
  });

  /* Tìm kiếm + Sắp xếp */
  const searchInput = $("[data-fav-search]");
  const sortSelect  = $("[data-fav-sort]");
  const grid        = $(".fav-grid");
  const filterEmpty = $(".fav-empty-filter");

  function applySearchSort(){
    const q = (searchInput?.value || "").trim().toLowerCase();
    const sortVal = sortSelect?.value || "default";

    const cards = $$(".fav-card", grid);
    let visibleCount = 0;

    cards.forEach(card=>{
      const name = card.dataset.name || "";
      const match = !q || name.includes(q);
      card.style.display = match ? "" : "none";
      if(match) visibleCount++;
    });

    // sort DOM với các card đang hiển thị
    const visible = cards.filter(c=> c.style.display !== "none");
    visible.sort((a,b)=>{
      if(sortVal==="az") return a.dataset.name.localeCompare(b.dataset.name);
      if(sortVal==="price-asc")  return (+a.dataset.price)-(+b.dataset.price);
      if(sortVal==="price-desc") return (+b.dataset.price)-(+a.dataset.price);
      return 0;
    });
    visible.forEach(c=> grid.appendChild(c));

    if(filterEmpty){
      const hasAny = cards.length>0;
      filterEmpty.classList.toggle("is-show", hasAny && visibleCount===0);
    }
  }
  const run = debounce(applySearchSort, 140);
  searchInput?.addEventListener("input", run);
  sortSelect?.addEventListener("change", run);

  function checkEmptyStates(){
    const remain = $$(".fav-card").filter(c=> c.style.display!=="none").length;
    const anyAll = $$(".fav-card").length;
    const empty  = $(".fav-empty");
    if(empty) empty.classList.toggle("is-show", anyAll===0);

    if($(".fav-empty-filter")){
      $(".fav-empty-filter").classList.toggle("is-show", anyAll>0 && remain===0);
    }
  }
})();
(function () {
  const CPATH =
    document.documentElement.getAttribute("data-cpath") ||
    (window.__PD_CONTEXT__ && window.__PD_CONTEXT__.cpath) ||
    window.CPATH ||
    "";

  function updateCounters(total) {
    const badge = document.querySelector("[data-fav-count]");
    if (badge) {
      badge.textContent = total;
      if (+total > 0) badge.removeAttribute("hidden");
      else badge.setAttribute("hidden", "");
    }
    const totalEl = document.querySelector("[data-fav-total]");
    if (totalEl) totalEl.textContent = total;
  }

  async function callToggle(id) {
    const res = await fetch(`${CPATH}/fav/toggle`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
      body: `id=${encodeURIComponent(id)}`
    });
    if (res.status === 401) { location.href = `${CPATH}/login`; return null; }
    return res.json();
  }

  // Giữ nguyên xử lý xóa trong listfav:
  document.addEventListener("click", async (e) => {
    const btn = e.target.closest(".js-remove-fav");
    if (!btn) return;

    e.preventDefault();
    const id = btn.dataset.id;
    const card = btn.closest(".fav-card");
    if (!id) return;

    btn.disabled = true;
    try {
      const data = await callToggle(id);
      if (!data) return;

      if (data.ok && data.state === "removed") {
        if (card) card.remove();
        updateCounters(data.count);

        const grid = document.querySelector(".fav-grid");
        const empty = document.querySelector(".fav-empty");
        if (grid && grid.children.length === 0 && empty) {
          empty.style.display = "block";
        }
      } else if (data.ok && data.state === "added") {
        await callToggle(id); // trạng thái bất thường, toggle lần nữa
      } else {
        alert("Xóa thất bại, vui lòng thử lại.");
      }
    } catch (err) {
      console.error(err);
      alert("Không thể kết nối máy chủ.");
    } finally {
      btn.disabled = false;
    }
  });

  // NEW: bắt nút trái tim trên trang chi tiết `.pd-fav`
  document.addEventListener("click", async (e) => {
    const favBtn = e.target.closest(".pd-fav, .fav-btn");
    if (!favBtn) return;

    e.preventDefault();
    const id = favBtn.dataset.id;
    if (!id) return;

    favBtn.disabled = true;
    try {
      const data = await callToggle(id);
      if (!data) return;

      if (data.ok) {
        const added = data.state === "added";
        favBtn.classList.toggle("is-active", added);
        favBtn.setAttribute("aria-pressed", added ? "true" : "false");
        favBtn.setAttribute("title", added ? "Bỏ yêu thích" : "Yêu thích");

        const label = favBtn.querySelector(".pd-fav-text");
        if (label) label.textContent = added ? "Bỏ yêu thích" : "Yêu thích";

        updateCounters(data.count);
      }
    } catch (err) {
      console.error(err);
    } finally {
      favBtn.disabled = false;
    }
  });
})();
