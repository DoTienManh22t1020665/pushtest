(function(){
  const form = document.getElementById('ad-xe-form');
  if(!form) return;

  const q = form.querySelector('input[name="q"]');
  const selects = form.querySelectorAll('select');

  let t = null;
  if(q){
    q.addEventListener('input', () => {
      clearTimeout(t);
      t = setTimeout(() => form.submit(), 400); // debounce 400ms
    });
  }
  selects.forEach(s => s.addEventListener('change', () => form.submit()));
})();
