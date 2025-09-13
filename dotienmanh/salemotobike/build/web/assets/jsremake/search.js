(function(){
  const root = document.documentElement;
  const cpath = root.getAttribute('data-cpath') || ''; // lấy contextPath nếu có

  // Toggle "yêu thích" tại chỗ (UI-first). Tuỳ chọn: gọi AJAX backend của bạn.
  document.addEventListener('click', async (e) => {
    const btn = e.target.closest('.fav-btn, .sr-heart');
    if(!btn) return;

    const id = btn.dataset.id;
    btn.classList.toggle('active');

    // Nếu bạn đã có API toggle favorites, mở comment đoạn dưới:
    /*
    try {
      const res = await fetch(`${cpath}/listfav/toggle?id=${encodeURIComponent(id)}`, {
        method: 'POST',
        headers: {'X-Requested-With':'XMLHttpRequest'}
      });
      if(!res.ok){ throw new Error('HTTP '+res.status); }
    } catch(err){
      console.error(err);
      // rollback nếu lỗi
      btn.classList.toggle('active');
      alert('Không thể cập nhật yêu thích, vui lòng thử lại.');
    }
    */
  });
})();
