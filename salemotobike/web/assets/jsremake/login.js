(function(){
  const root = document.getElementById('or-register');
  if (!root) return;

  const card  = root.querySelector('.or-card');
  const form  = root.querySelector('.or-form');
  const btn   = root.querySelector('.or-btn');
  const left  = root.querySelector('.or-left');
  const closeBtn = root.querySelector('.or-close');

  const inputs = {
    username : root.querySelector('input[name="username"]'),
    phone    : root.querySelector('input[name="phone"]'),
    email    : root.querySelector('input[name="email"]'),
    fullname : root.querySelector('input[name="fullname"]'),
    password : root.querySelector('#or-password'),
    confirm  : root.querySelector('#or-confirm'),
    address  : root.querySelector('input[name="address"]'),
  };

  // Toggle eye cho password & confirm
  root.querySelectorAll('.or-eye').forEach((eye)=>{
    eye.addEventListener('click', ()=>{
      const input = eye.previousElementSibling;
      if (!input) return;
      const isPwd = input.type === 'password';
      input.type = isPwd ? 'text' : 'password';
      eye.classList.toggle('is-on', isPwd);
      input.focus();
    });
  });

  // Ripple
  btn?.addEventListener('click', (e) => {
    const r = document.createElement('span');
    r.className = 'or-ripple';
    const rect = btn.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    r.style.width = r.style.height = `${size}px`;
    r.style.left = `${e.clientX - rect.left - size/2}px`;
    r.style.top  = `${e.clientY - rect.top  - size/2}px`;
    btn.appendChild(r);
    setTimeout(() => r.remove(), 650);
  });

  // Validate
  function setError(input, msg){
    const field = input.closest('.or-field');
    const help = field.querySelector('.or-help');
    input.classList.add('is-invalid'); field.classList.add('is-invalid');
    if (help) help.textContent = msg || '';
  }
  function clearError(input){
    const field = input.closest('.or-field');
    const help = field.querySelector('.or-help');
    input.classList.remove('is-invalid'); field.classList.remove('is-invalid');
    if (help) help.textContent = '';
  }
  function validate(){
    let ok = true;
    const u  = inputs.username.value.trim();
    if (u.length < 3 || u.length > 30){ ok=false; setError(inputs.username, 'Username phải 3–30 ký tự.'); } else clearError(inputs.username);

    const ph = inputs.phone.value.replace(/\D/g,'');
    if (ph.length < 9 || ph.length > 11){ ok=false; setError(inputs.phone, 'Số điện thoại 9–11 chữ số.'); } else clearError(inputs.phone);

    const em = inputs.email.value.trim();
    if (!/\S+@\S+\.\S+/.test(em)){ ok=false; setError(inputs.email, 'Email không hợp lệ.'); } else clearError(inputs.email);

    if (inputs.fullname.value.trim().length < 2){ ok=false; setError(inputs.fullname, 'Nhập họ tên.'); } else clearError(inputs.fullname);

    const pw = inputs.password.value;
    if (pw.length < 6){ ok=false; setError(inputs.password, 'Mật khẩu tối thiểu 6 ký tự.'); } else clearError(inputs.password);

    if (inputs.confirm.value !== pw){ ok=false; setError(inputs.confirm, 'Mật khẩu không khớp.'); } else clearError(inputs.confirm);

    if (inputs.address.value.trim().length < 3){ ok=false; setError(inputs.address, 'Nhập địa chỉ.'); } else clearError(inputs.address);

    return ok;
  }
  Object.values(inputs).forEach(inp=> inp?.addEventListener('input', ()=> clearError(inp)));

  form?.addEventListener('submit', (e)=>{
    if (!validate()){ e.preventDefault(); return; }
    btn?.classList.add('is-loading'); if (btn) btn.disabled = true;
  });

  // Parallax ảnh trái
  if (left){
    const max = 8;
    const onMove = (e) => {
      const rect = left.getBoundingClientRect();
      const x = (e.clientX - rect.left) / rect.width - 0.5;
      const y = (e.clientY - rect.top)  / rect.height - 0.5;
      left.style.setProperty('--or-parallax-x', `${x * max}px`);
      left.style.setProperty('--or-parallax-y', `${y * max}px`);
    };
    const onLeave = () => {
      left.style.setProperty('--or-parallax-x', `0px`);
      left.style.setProperty('--or-parallax-y', `0px`);
    };
    left.addEventListener('mousemove', onMove);
    left.addEventListener('mouseleave', onLeave);
  }

  // Tilt nhẹ cho card
  if (card){
    const maxDeg = 1.8;
    const onMove = (e) => {
      const r = card.getBoundingClientRect();
      const cx = r.left + r.width/2;
      const cy = r.top  + r.height/2;
      const dx = (e.clientX - cx) / (r.width/2);
      const dy = (e.clientY - cy) / (r.height/2);
      card.style.transform = `translateY(-1px) rotateX(${(+dy*maxDeg).toFixed(2)}deg) rotateY(${(-dx*maxDeg).toFixed(2)}deg)`;
    };
    const onLeave = () => { card.style.transform = ''; };
    card.addEventListener('mousemove', onMove);
    card.addEventListener('mouseleave', onLeave);
  }

  // Đóng bằng nút X / ESC
  closeBtn?.addEventListener('click', ()=> { root.querySelector('.or-stage').style.display='none'; });
  document.addEventListener('keydown', e=>{ if(e.key==='Escape') root.querySelector('.or-stage').style.display='none'; });
})();
