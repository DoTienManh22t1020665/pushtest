// ========== HEADER: sticky + burger + mega ==========
(() => {
  const header = document.querySelector('.hb-header');
  const burger = document.querySelector('.hb-burger');
  const nav = document.querySelector('#hb-nav');
  const overlay = document.querySelector('.hb-overlay');

  const onScroll = () => {
    if (window.scrollY > 2) header.classList.add('is-scrolled');
    else header.classList.remove('is-scrolled');
  };
  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });

  const openNav = () => {
    nav.classList.add('open');
    overlay.hidden = false;
    burger.setAttribute('aria-expanded', 'true');
    document.documentElement.style.overflow = 'hidden';
  };
  const closeNav = () => {
    nav.classList.remove('open');
    burger.setAttribute('aria-expanded', 'false');
    document.documentElement.style.overflow = '';

    // fade-out overlay rồi mới hidden
    const onFade = (e) => {
      if (e.propertyName !== 'opacity') return;
      overlay.hidden = true;
      overlay.removeEventListener('transitionend', onFade);
    };
    overlay.addEventListener('transitionend', onFade);
  };

  burger?.addEventListener('click', () => {
    nav.classList.contains('open') ? closeNav() : openNav();
  });
  overlay?.addEventListener('click', closeNav);
  window.addEventListener('keyup', e => { if (e.key === 'Escape') closeNav(); });

  // Mega menu trên mobile mở bằng click
  document.querySelectorAll('.has-mega > .hb-link').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const isDesktop = window.matchMedia('(min-width: 993px)').matches;
      if (isDesktop) return; // desktop dùng hover

      e.preventDefault();
      const li = btn.closest('.has-mega');
      const expanded = btn.getAttribute('aria-expanded') === 'true';
      document.querySelectorAll('.has-mega').forEach(x => {
        x.classList.remove('open');
        x.querySelector('.hb-link').setAttribute('aria-expanded', 'false');
      });
      if (!expanded) {
        li.classList.add('open');
        btn.setAttribute('aria-expanded', 'true');
      }
    });
  });
})();
window.setFavCount = function(n){
  const b = document.querySelector('[data-fav-count]');
  if(!b) return;
  b.textContent = n;
  b.hidden = !(n > 0);
};

// ========== HERO SLIDER (fade) ==========
(() => {
  const slider = document.querySelector('#hero-slider');
  if (!slider) return;

  const slides = Array.from(slider.querySelectorAll('.hb-slide'));
  const prevBtn = slider.querySelector('.hb-slider-prev');
  const nextBtn = slider.querySelector('.hb-slider-next');
  const dotsWrap = slider.querySelector('.hb-slider-dots');

  let index = 0;
  let timer = null, resumeT = null;
  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const autoplay = slider.dataset.autoplay !== 'false' && !prefersReduced;
  const delay = parseInt(slider.dataset.interval || '5000', 10);

  if (!dotsWrap.children.length) {
    slides.forEach((_, i) => {
      const b = document.createElement('button');
      b.type = 'button';
      b.setAttribute('role', 'tab');
      b.setAttribute('aria-label', `Chuyển tới banner ${i+1}`);
      b.dataset.index = i;
      dotsWrap.appendChild(b);
    });
  }
  const dots = Array.from(dotsWrap.querySelectorAll('button'));

  function setActive(i){
    slides.forEach((s, k) => s.classList.toggle('is-active', k === i));
    dots.forEach((d, k) => {
      const sel = k === i;
      d.setAttribute('aria-selected', sel ? 'true' : 'false');
      d.tabIndex = sel ? 0 : -1;
    });
    index = i;
  }
  const next = () => setActive((index + 1) % slides.length);
  const prev = () => setActive((index - 1 + slides.length) % slides.length);

  function play(){ if(!autoplay || timer) return; timer = setInterval(next, delay); }
  function pause(){ if(timer){ clearInterval(timer); timer = null; } }
  function resumeAfterUser(){ if(!autoplay) return; clearTimeout(resumeT); resumeT = setTimeout(play, 6000); }

  nextBtn.addEventListener('click', () => { pause(); next(); resumeAfterUser(); });
  prevBtn.addEventListener('click', () => { pause(); prev(); resumeAfterUser(); });
  dotsWrap.addEventListener('click', (e) => {
    const btn = e.target.closest('button'); if(!btn) return;
    pause(); setActive(parseInt(btn.dataset.index, 10)); resumeAfterUser();
  });

  slider.addEventListener('mouseenter', pause);
  slider.addEventListener('mouseleave', play);
  slider.addEventListener('focusin', pause);
  slider.addEventListener('focusout', play);

  slider.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight'){ e.preventDefault(); nextBtn.click(); }
    if (e.key === 'ArrowLeft'){ e.preventDefault(); prevBtn.click(); }
  });

  // Vuốt
  let startX = 0, dx = 0, touching = false, TH = 40;
  slider.addEventListener('touchstart', (e)=>{ touching=true; startX=e.touches[0].clientX; dx=0; pause(); }, {passive:true});
  slider.addEventListener('touchmove', (e)=>{ if(!touching) return; dx = e.touches[0].clientX - startX; }, {passive:true});
  slider.addEventListener('touchend', ()=>{ if(!touching) return; touching=false;
    if (Math.abs(dx) > TH) (dx < 0 ? next() : prev());
    resumeAfterUser();
  });

  setActive(0);
  play();
})();

// ========== Back-to-top ==========
(() => {
  const btn = document.querySelector('.hb-backtop');
  if (!btn) return;
  const toggle = () => { btn.hidden = window.scrollY < 500; };
  toggle();
  window.addEventListener('scroll', toggle, {passive:true});
  btn.addEventListener('click', () => window.scrollTo({top:0, behavior:'smooth'}));
})();

// ========== Reveal on scroll ==========
(() => {
  const reveals = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window)) {
    reveals.forEach(el => el.classList.add("is-visible"));
    return;
  }
  const io = new IntersectionObserver((entries) => {
    entries.forEach((en) => {
      if (en.isIntersecting) {
        en.target.classList.add("is-visible");
        io.unobserve(en.target);
      }
    });
  }, { rootMargin: "0px 0px -10% 0px", threshold: 0.1 });
  reveals.forEach((el) => io.observe(el));
})();

// ========== Tilt parallax (desktop) ==========
(() => {
  const supportsHover = window.matchMedia("(hover:hover)").matches;
  if (!supportsHover) return;
  document.querySelectorAll("[data-tilt]").forEach((card) => {
    let raf = null;
    const rect = () => card.getBoundingClientRect();
    const move = (e) => {
      if (raf) cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => {
        const r = rect();
        const x = (e.clientX - r.left) / r.width - 0.5;
        const y = (e.clientY - r.top) / r.height - 0.5;
        const rotX = (y * -6).toFixed(2);
        const rotY = (x * 6).toFixed(2);
        card.style.transform = `perspective(900px) rotateX(${rotX}deg) rotateY(${rotY}deg) translateY(-4px)`;
        card.style.boxShadow = "0 18px 40px rgba(0,0,0,.14)";
      });
    };
    const leave = () => {
      if (raf) cancelAnimationFrame(raf);
      card.style.transform = "";
      card.style.boxShadow = "";
    };
    card.addEventListener("mousemove", move);
    card.addEventListener("mouseleave", leave);
  });
})();

// ========== Favorites (DUY NHẤT) ==========
(() => {
  const KEY = "listfavIds";
  const read = () => { try { return new Set(JSON.parse(localStorage.getItem(KEY) || "[]")); } catch { return new Set(); } };
  const write = (set) => localStorage.setItem(KEY, JSON.stringify(Array.from(set)));
  const favs = read();

  // init trạng thái hiện tại
  document.querySelectorAll(".fav-btn").forEach(btn => {
    const on = favs.has(btn.dataset.id);
    btn.classList.toggle("active", on);
    btn.setAttribute("aria-pressed", String(on));
  });

  // Ủy quyền sự kiện 1 lần cho toàn document
  document.addEventListener("click", (e) => {
    const btn = e.target.closest(".fav-btn");
    if (!btn) return;
    e.preventDefault();

    const id = btn.dataset.id;
    const now = btn.getAttribute("aria-pressed") !== "true";
    btn.classList.toggle("active", now);
    btn.setAttribute("aria-pressed", String(now));

    btn.classList.remove("bump"); void btn.offsetWidth; btn.classList.add("bump");

    if (now) favs.add(id); else favs.delete(id);
    write(favs);
  });
})();
