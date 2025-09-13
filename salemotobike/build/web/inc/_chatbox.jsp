<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${cpath}/assets/cssremake/chat.css?v=1"/>

<div id="cb-root" class="cb-root" aria-live="polite">
    <!-- Nút chat nổi -->
    <button id="cb-launcher" class="cb-launcher" aria-label="Mở chat hỗ trợ">
        <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path d="M2 4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H8l-6 4V4z"/></svg>
    </button>

    <!-- Cửa sổ chat -->
    <section id="cb-window" class="cb-window" role="dialog" aria-label="Hỗ trợ trực tuyến" hidden>
        <header class="cb-header">
            <div class="cb-title">Hỗ trợ showroom</div>
            <button id="cb-close" class="cb-close" aria-label="Đóng chat">×</button>
        </header>

        <div id="cb-messages" class="cb-messages">
            <div class="cb-msg cb-msg--bot">
                Xin chào 👋 Mình có thể giúp gì? Bạn có thể gõ: <em>"tay ga", "xe số", "côn tay", "xe điện", "giá rẻ"</em>… hoặc hỏi trực tiếp.
            </div>
        </div>

        <div class="cb-quick" id="cb-quick">
            <button data-q="tay ga">Tay ga</button>
            <button data-q="xe số">Xe số</button>
            <button data-q="côn tay">Côn tay</button>
            <button data-q="xe điện">Xe điện</button>
        </div>

        <form id="cb-form" class="cb-form" autocomplete="off">
            <input id="cb-input" type="text" name="message" placeholder="Nhập nội dung..." aria-label="Tin nhắn">
            <button class="cb-send" type="submit" aria-label="Gửi">Gửi</button>
            <!-- ... trong vùng nhập của chatbox -->
            <button id="chatMic" class="hb-chat-mic" type="button" aria-label="Nhấn để nói">
                <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
                <path d="M12 14a3 3 0 0 0 3-3V6a3 3 0 0 0-6 0v5a3 3 0 0 0 3 3zm-7 0a7 7 0 0 0 14 0h-2a5 5 0 0 1-10 0H5z"/>
                </svg>
            </button>

        </form>
    </section>
</div>

<script>
    window.CB_ENDPOINT = '${cpath}/api/chat';
</script>
<script>
(function(){
  // Phát hiện hỗ trợ
  const SR = window.SpeechRecognition || window.webkitSpeechRecognition;

  const micBtn = document.getElementById('chatMic');
  const form   = document.getElementById('cb-form');
  const input  = document.getElementById('cb-input');

  if(!micBtn) return;
  if(!SR){ micBtn.hidden = true; return; } // Ẩn mic nếu trình duyệt không hỗ trợ

  const rec = new SR();
  rec.lang = 'vi-VN';
  rec.interimResults = true;
  rec.continuous = false;

  let finalText = '';

  micBtn.addEventListener('click', () => {
    if (micBtn.classList.contains('is-recording')) {
      rec.stop(); // đang thu -> dừng
      return;
    }
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

  rec.onerror = (ev) => {
    console.warn('Speech error:', ev.error);
    micBtn.classList.remove('is-recording');
  };

  rec.onend = () => {
    micBtn.classList.remove('is-recording');
    const text = (input.value || '').trim();
    if (text) {
      // Gửi tin bằng flow sẵn có của form
      if (form.requestSubmit) form.requestSubmit();
      else form.dispatchEvent(new Event('submit', {cancelable:true}));
    }
  };

  // ====== TTS: bot đọc trả lời ======
  window.hbChatSpeak = function(text){
    if(!('speechSynthesis' in window)) return;
    const u = new SpeechSynthesisUtterance(text);
    u.lang = 'vi-VN'; u.rate = 1; u.pitch = 1;
    try {
      window.speechSynthesis.cancel();
      window.speechSynthesis.speak(u);
    } catch(e){}
  };
})();
</script>


<script src="${cpath}/assets/jsremake/chat.js?v=1" defer></script>
