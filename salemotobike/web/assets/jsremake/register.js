(function(){
  const root = document.getElementById('or-register');
  if (!root) return;

  const stage = root.querySelector('.or-stage');
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
  const eyes = root.querySelectorAll('.or-eye');
  eyes.forEach((eye)=>{
    eye.addEventListener('click', ()=>{
      const input = eye.previousElementSibling; // input ngay trước eye
      if (!input) return;
      const isPwd = input.type === 'password';
      input.type = isPwd ? 'text' : 'password';
      eye.classList.toggle('is-on', isPwd);
      input.focus();
    });
  });

  // Ripple effect
  if (btn){
    btn.addEventListener('click', (e) => {
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
  }

  // Validate helpers
  function setError(input, msg){
    const field = input.closest('.or-field');
    const help = field.querySelector('.or-help');
    input.classList.add('is-invalid');
    field.classList.add('is-invalid');
    if (help) help.textContent = msg || '';
  }
  function clearError(input){
    const field = input.closest('.or-field');
    const help = field.querySelector('.or-help');
    input.classList.remove('is-invalid');
    field.classList.remove('is-invalid');
    if (help) help.textContent = '';
  }

  // Basic rules
  function validate(){
    let ok = true;

    // username: 3-30, không space ở đầu/cuối
    const u = inputs.username.value.trim();
    if (u.length < 3 || u.length > 30){ ok=false; setError(inputs.username, 'Username phải 3–30 ký tự.'); } else clearError(inputs.username);

    // phone: 9–11 số
    const ph = inputs.phone.value.replace(/\D/g,'');
    if (ph.length < 9 || ph.length > 11){ ok=false; setError(inputs.phone, 'Số điện thoại 9–11 chữ số.'); } else clearError(inputs.phone);

    // email: regex đơn giản
    const em = inputs.email.value.trim();
    if (!/\S+@\S+\.\S+/.test(em)){ ok=false; setError(inputs.email, 'Email không hợp lệ.'); } else clearError(inputs.email);

    // fullname
    if (inputs.fullname.value.trim().length < 2){ ok=false; setError(inputs.fullname, 'Nhập họ tên.'); } else clearError(inputs.fullname);

    // password: tối thiểu 6
    const pw = inputs.password.value;
    if (pw.length < 6){ ok=false; setError(inputs.password, 'Mật khẩu tối thiểu 6 ký tự.'); } else clearError(inputs.password);

    // confirm: trùng password
    if (inputs.confirm.value !== pw){ ok=false; setError(inputs.confirm, 'Mật khẩu không khớp.'); } else clearError(inputs.confirm);

    // address
    if (inputs.address.value.trim().length < 3){ ok=false; setError(inputs.address, 'Nhập địa chỉ.'); } else clearError(inputs.address);

    return ok;
  }

  // Re-validate khi nhập lại
  Object.values(inputs).forEach(inp=>{
    inp?.addEventListener('input', ()=> clearError(inp));
  });

  // Submit + spinner
  if (form){
    form.addEventListener('submit', (e)=>{
      if (!validate()){
        e.preventDefault();
        return;
      }
      if (btn){
        btn.classList.add('is-loading');
        btn.disabled = true;
      }
    });
  }

  // Parallax ảnh trái
  if (left){
    const max = 10; // px
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
    const maxDeg = 2.2;
    const onMove = (e) => {
      const r = card.getBoundingClientRect();
      const cx = r.left + r.width/2;
      const cy = r.top  + r.height/2;
      const dx = (e.clientX - cx) / (r.width/2);
      const dy = (e.clientY - cy) / (r.height/2);
      const rotX = (+dy * maxDeg).toFixed(2);
      const rotY = (-dx * maxDeg).toFixed(2);
      card.style.transform = `translateY(-2px) rotateX(${rotX}deg) rotateY(${rotY}deg)`;
    };
    const onLeave = () => { card.style.transform = ''; };
    card.addEventListener('mousemove', onMove);
    card.addEventListener('mouseleave', onLeave);
  }

  // Đóng bằng nút X
  closeBtn?.addEventListener('click', ()=> { root.querySelector('.or-stage').style.display='none'; });

  // ESC để đóng (nếu cần)
  document.addEventListener('keydown', e=>{ if(e.key==='Escape') root.querySelector('.or-stage').style.display='none'; });
})();
