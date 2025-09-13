(function () {
    const root = document.querySelector('.pd');
    if (!root)
        return;

    const hero = document.getElementById('pd-hero');
    const favBtn = root.querySelector('.pd-fav');

    /* ===== Hero crossfade ===== */
    function swapHero(url) {
        if (!hero || !url)
            return;
        hero.classList.add('is-fading');
        const img = new Image();
        img.onload = () => {
            hero.src = url;
            hero.classList.remove('is-fading');
        };
        img.onerror = () => {
            hero.classList.remove('is-fading');
        };
        img.src = url;
    }

    /* ===== Mini carousel (no progress bar) ===== */
    const mini = root.querySelector('.pd-mini');
    let items = [], prev, next, dotsWrap, track, vp, idx = 0, t = null, wantAuto = true, interval = 3500;

    if (mini && hero) {
        track = mini.querySelector('.pd-mini-track');
        vp = mini.querySelector('.pd-mini-viewport');
        items = Array.from(mini.querySelectorAll('.pd-mini-item'));
        prev = mini.querySelector('.pd-mini-prev');
        next = mini.querySelector('.pd-mini-next');
        dotsWrap = root.querySelector('.pd-mini-dots');
        wantAuto = mini.getAttribute('data-autoplay') !== 'false';
        interval = parseInt(mini.getAttribute('data-interval') || '3500', 10);

        const dots = items.map((_, i) => {
            const d = document.createElement('button');
            d.setAttribute('role', 'tab');
            d.setAttribute('aria-label', 'Ảnh ' + (i + 1));
            d.addEventListener('click', () => goTo(i, true));
            dotsWrap.appendChild(d);
            return d;
        });

        idx = Math.max(0, items.findIndex(b => b.classList.contains('is-active')));
        if (idx < 0)
            idx = 0;

        function metric() {
            const w = items[0]?.getBoundingClientRect().width || 92;
            const gap = parseFloat(getComputedStyle(track).gap) || 10;
            const per = w + gap;
            const visible = Math.max(1, Math.floor(vp.clientWidth / per));
            return {per, visible};
        }
        function sync() {
            items.forEach((b, i) => b.classList.toggle('is-active', i === idx));
            dots.forEach((d, i) => d.setAttribute('aria-selected', i === idx ? 'true' : 'false'));
            const {per, visible} = metric();
            const start = Math.max(0, Math.min(idx - Math.floor((visible - 1) / 2), Math.max(0, items.length - visible)));
            track.style.transform = `translateX(${-(per * start)}px)`;
            const url = items[idx]?.getAttribute('data-full');
            if (url)
                swapHero(url);
        }
        function goTo(i, user) {
            if (!items.length)
                return;
            idx = (i + items.length) % items.length;
            sync();
            if (user)
                restart();
        }

        items.forEach((b, i) => b.addEventListener('click', () => goTo(i, true)));
        prev?.addEventListener('click', () => goTo(idx - 1, true));
        next?.addEventListener('click', () => goTo(idx + 1, true));
        window.addEventListener('resize', () => requestAnimationFrame(sync));

        // autoplay (không hiển thị progress)
        function start() {
            if (!wantAuto || items.length <= 1)
                return;
            stop();
            t = setInterval(() => goTo(idx + 1, false), interval);
        }
        function stop() {
            if (t)
                clearInterval(t), t = null;
        }
        function restart() {
            stop();
            start();
        }
        mini.addEventListener('mouseenter', stop);
        mini.addEventListener('mouseleave', start);
        document.addEventListener('visibilitychange', () => document.hidden ? stop() : start());

        // init
        sync();
        start();
        if (items.length <= 1) {
            prev?.classList.add('is-hidden');
            next?.classList.add('is-hidden');
            dotsWrap?.classList.add('is-hidden');
        }
    }

    /* ===== Fav ===== */
    favBtn?.addEventListener('click', () => {
        const pressed = favBtn.getAttribute('aria-pressed') === 'true';
        favBtn.setAttribute('aria-pressed', (!pressed).toString());
    });

    /* ===== Micro drag on hero ===== */
    if (hero) {
        let down = false;
        const MAX = 10;
        const move = (e) => {
            if (!down)
                return;
            const r = hero.getBoundingClientRect();
            const x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5;
            hero.style.transform = `scale(1.02) translate(${(-x * MAX).toFixed(1)}px, ${(-y * MAX).toFixed(1)}px)`;
        };
        hero.addEventListener('mousedown', e => {
            down = true;
            move(e);
        });
        window.addEventListener('mouseup', () => {
            down = false;
            hero.style.transform = 'none';
        });
        hero.addEventListener('mousemove', move);
        hero.addEventListener('mouseleave', () => {
            down = false;
            hero.style.transform = 'none';
        });
    }

    /* ===== Share & Print ===== */
    const shareBtn = root.querySelector('.pd-share');
    shareBtn?.addEventListener('click', async () => {
        const data = {title: document.title, text: root.querySelector('.pd-title')?.textContent || '', url: location.href};
        if (navigator.share) {
            try {
                await navigator.share(data);
            } catch {
            }
        } else {
            navigator.clipboard?.writeText(location.href);
            shareBtn.classList.add('copied');
            setTimeout(() => shareBtn.classList.remove('copied'), 1200);
        }
    });
    const printBtn = root.querySelector('.pd-print');
    printBtn?.addEventListener('click', () => window.print());

    /* ===== Accordion ===== */
    root.querySelectorAll('.pd-acc').forEach(sec => {
        const head = sec.querySelector('.pd-acc-head');
        head?.addEventListener('click', () => {
            const open = sec.classList.toggle('is-open');
            head.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
    });
    // Mobile: collapse default (trừ mục đầu)
    const isMobile = () => matchMedia('(max-width:980px)').matches;
    function setAccordionInitial() {
        root.querySelectorAll('.pd-acc').forEach((sec, i) => {
            if (isMobile() && i > 0) {
                sec.classList.remove('is-open');
                sec.querySelector('.pd-acc-head')?.setAttribute('aria-expanded', 'false');
            } else {
                sec.classList.add('is-open');
                sec.querySelector('.pd-acc-head')?.setAttribute('aria-expanded', 'true');
            }
        });
    }
    setAccordionInitial();
    window.addEventListener('resize', setAccordionInitial);

    /* ===== Topbar on scroll ===== */
    const topbar = document.querySelector('.pd-topbar');
    const heroFigure = document.querySelector('.pd-hero');
    if (topbar && heroFigure) {
        const io = new IntersectionObserver(([e]) => {
            if (e.isIntersecting)
                topbar.classList.remove('is-show');
            else
                topbar.classList.add('is-show');
        }, {threshold: 0.05});
        io.observe(heroFigure);
    }

    /* ===== Lightbox ===== */
    const lb = document.querySelector('.pd-lightbox');
    const lbImg = lb?.querySelector('.pd-lb-img');
    const lbPrev = lb?.querySelector('.pd-lb-prev');
    const lbNext = lb?.querySelector('.pd-lb-next');
    const lbClose = lb?.querySelector('.pd-lb-close');
    const sources = Array.from(lb?.querySelectorAll('.pd-lb-sources [data-src]') || []).map(s => s.getAttribute('data-src'));
    let lbIndex = 0;
    function openLB(index = 0) {
        if (!lb || !sources.length)
            return;
        lbIndex = (index + sources.length) % sources.length;
        lbImg.src = sources[lbIndex];
        lb.removeAttribute('hidden');
        lb.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
        // >>> thêm dòng này
        document.documentElement.classList.add('pd-lb-open');
    }

    function closeLB() {
        if (!lb)
            return;
        lb.setAttribute('aria-hidden', 'true');
        lb.setAttribute('hidden', '');
        document.body.style.overflow = '';
        // >>> và dòng này
        document.documentElement.classList.remove('pd-lb-open');
    }


    function navLB(step) {
        openLB(lbIndex + step);
    }

    root.querySelector('.pd-zoom-btn')?.addEventListener('click', () => {
        const active = Array.from(root.querySelectorAll('.pd-mini-item')).findIndex(b => b.classList.contains('is-active'));
        openLB(active >= 0 ? active : 0);
    });
    lbPrev?.addEventListener('click', () => navLB(-1));
    lbNext?.addEventListener('click', () => navLB(1));
    lbClose?.addEventListener('click', closeLB);
    lb?.addEventListener('click', (e) => {
        if (e.target === lb || e.target.classList.contains('pd-lb-backdrop'))
            closeLB();
    });

    window.addEventListener('keydown', (e) => {
        if (lb && lb.getAttribute('aria-hidden') === 'false') {
            if (e.key === 'Escape')
                closeLB();
            if (e.key === 'ArrowLeft')
                navLB(-1);
            if (e.key === 'ArrowRight')
                navLB(1);
            e.preventDefault();
        } else {
            if (e.key === 'ArrowLeft')
                prev?.click();
            if (e.key === 'ArrowRight')
                next?.click();
        }
    });

    /* CTA nhấn nhá nhẹ */
    const cta = root.querySelector('.pd-btn--cta');
    if (cta) {
        setTimeout(() => {
            cta.animate([
                {boxShadow: '0 12px 28px rgba(255,153,0,.28)'},
                {boxShadow: '0 22px 44px rgba(255,153,0,.42)'},
                {boxShadow: '0 12px 28px rgba(255,153,0,.28)'}
            ], {duration: 900, iterations: 1, easing: 'ease-in-out'});
        }, 900);
    }
})();
