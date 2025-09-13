(function () {
  const $ = (s, r = document) => r.querySelector(s);
  const root = $('#cb-root');
  if (!root) return;

  // ==== DOM refs ====
  const win = $('#cb-window');
  const launcher = $('#cb-launcher');
  const closeBtn = $('#cb-close');
  const messages = $('#cb-messages');
  const form = $('#cb-form');
  const input = $('#cb-input');
  const quick = $('#cb-quick');
  const micBtn = $('#chatMic');
  const EP = window.CB_ENDPOINT;

  // ==== Session id ====
  const sidKey = 'cb_session_id';
  const sid = localStorage.getItem(sidKey) || (Date.now().toString(36) + Math.random().toString(36).slice(2));
  localStorage.setItem(sidKey, sid);

  // ==== Helpers ====
  function addMsg(text, me = false, cls = '') {
    const div = document.createElement('div');
    div.className = `cb-msg ${me ? 'cb-msg--me' : 'cb-msg--bot'} ${cls}`;
    div.textContent = text;
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
    return div;
  }

  function typing(on = true) {
    let el = $('.cb-typing', messages);
    if (on && !el) addMsg('Đang gõ...', false, 'cb-typing');
    if (!on && el) el.remove();
  }

  // ==== TTS ====
  // Khởi động danh sách voice (Chrome có thể trả mảng rỗng lần đầu)
  if ('speechSynthesis' in window) {
    try { window.speechSynthesis.getVoices(); } catch (e) {}
  }

  function speak(text) {
    if (!('speechSynthesis' in window)) return;
    const u = new SpeechSynthesisUtterance(text);
    u.lang = 'vi-VN';
    u.rate = 1;
    u.pitch = 1;
    try {
      const voices = window.speechSynthesis.getVoices();
      const vi = voices && voices.find(v => /vi/i.test(v.lang) || /vietnam/i.test(v.name));
      if (vi) u.voice = vi;
      window.speechSynthesis.cancel();
      window.speechSynthesis.speak(u);
    } catch (e) {}
  }

  // Một số trình duyệt cần resume sau tương tác đầu tiên
  document.addEventListener('click', () => {
    try {
      if (window.speechSynthesis && window.speechSynthesis.paused) window.speechSynthesis.resume();
    } catch (e) {}
  }, { once: true });

  // ==== Gửi chat ====
  function send(text) {
    if (!text || !text.trim()) return;
    addMsg(text, true);
    typing(true);

    const body = new URLSearchParams({ message: text, sessionId: sid });

    fetch(EP, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body
    })
      .then(r => r.ok ? r.json() : Promise.reject(new Error('Bad response')))
      .then(data => {
        typing(false);

        const replyText = (data && data.reply) ? data.reply : 'Mình chưa hiểu, bạn thử diễn đạt khác nhé!';
        addMsg(replyText);
        // Gọi TTS (đặt setTimeout 0 để tránh block rendering)
        if (window.speechSynthesis) setTimeout(() => speak(replyText), 0);

        // Gợi ý nhanh
        if (Array.isArray(data?.suggestions) && data.suggestions.length) {
          quick.innerHTML = '';
          data.suggestions.forEach(q => {
            const b = document.createElement('button');
            b.textContent = q;
            b.dataset.q = q;
            b.addEventListener('click', (e) => {
              e.preventDefault();
              input.value = q;
              if (form.requestSubmit) form.requestSubmit();
              else form.dispatchEvent(new Event('submit', { cancelable: true }));
            });
            quick.appendChild(b);
          });
        }

        // Kết quả xe
        if (Array.isArray(data?.results) && data.results.length) {
          data.results.slice(0, 5).forEach(item => {
            const a = document.createElement('a');
            a.href = item.url;
            a.target = '_self';
            a.textContent = '• ' + item.title + (item.price ? (' — ' + item.price) : '');
            a.className = 'cb-msg cb-msg--bot';
            messages.appendChild(a);
          });
          messages.scrollTop = messages.scrollHeight;
        }
      })
      .catch(() => {
        typing(false);
        addMsg('Có lỗi kết nối. Thử lại sau nhé!');
      });
  }

  // ==== UI events ====
  launcher.addEventListener('click', () => {
    win.hidden = !win.hidden;
    if (!win.hidden) input.focus();
  });

  closeBtn.addEventListener('click', () => {
    win.hidden = true;
  });

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const text = input.value;
    input.value = '';
    send(text);
  });

  quick.addEventListener('click', (e) => {
    const b = e.target.closest('button[data-q]');
    if (!b) return;
    e.preventDefault();
    input.value = b.dataset.q;
    if (form.requestSubmit) form.requestSubmit();
    else form.dispatchEvent(new Event('submit', { cancelable: true }));
  });

  // ==== STT (Speech-to-Text) ====
  (function setupSTT() {
    const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!micBtn) return;
    if (!SR) { micBtn.hidden = true; return; }

    const rec = new SR();
    rec.lang = 'vi-VN';
    rec.interimResults = true;
    rec.continuous = false;

    let finalText = '';

    micBtn.addEventListener('click', () => {
      if (micBtn.classList.contains('is-recording')) { rec.stop(); return; }
      finalText = '';
      try {
        rec.start();
        micBtn.classList.add('is-recording');
      } catch (err) {
        console.warn('Speech start error:', err);
      }
    });

    rec.onresult = (e) => {
      let interim = '';
      for (let i = e.resultIndex; i < e.results.length; i++) {
        const t = e.results[i][0].transcript;
        if (e.results[i].isFinal) finalText += t;
        else interim += t;
      }
      input.value = (finalText + ' ' + interim).trim();
    };

    rec.onerror = () => {
      micBtn.classList.remove('is-recording');
    };

    rec.onend = () => {
      micBtn.classList.remove('is-recording');
      const text = (input.value || '').trim();
      if (text) {
        if (form.requestSubmit) form.requestSubmit();
        else form.dispatchEvent(new Event('submit', { cancelable: true }));
      }
    };
  })();

})();
