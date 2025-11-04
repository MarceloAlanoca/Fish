const form = document.getElementById("form");
const password = document.getElementById("password");
const passwordConfirm = document.getElementById("passwordConfirm");
const mensaje = document.getElementById("mensaje");
const showPassword = document.getElementById("showPassword");
const showPasswordConfirm = document.getElementById("showPasswordConfirm");

// Mostrar contraseña principal
showPassword.addEventListener("change", () => {
  password.type = showPassword.checked ? "text" : "password";
});

// Mostrar Confirmación (si existe)
if (showPasswordConfirm) {
  showPasswordConfirm.addEventListener("change", () => {
    passwordConfirm.type = showPasswordConfirm.checked ? "text" : "password";
  });
}

// Validaciones
form.addEventListener("submit", function (event) {
  mensaje.textContent = "";

  if (password.value.trim().length < 5 || password.value.trim().length > 15) {
    event.preventDefault();
    mensaje.textContent = "La contraseña debe tener entre 5 y 15 caracteres.";
    password.focus();
    return;
  }

  if (password.value !== passwordConfirm.value) {
    event.preventDefault();
    mensaje.textContent = "Las contraseñas no coinciden, vuelve a intentar.";
    passwordConfirm.focus();
    return;
  }
});

// Panel deslizable
const panel = document.getElementById("optionalPanel");
const openBtn = document.getElementById("togglePanel");
const closeBtn = document.getElementById("closePanel");

if (openBtn && panel) {
  openBtn.addEventListener("click", () => {
    panel.classList.add("open");
  });
}

if (closeBtn && panel) {
  closeBtn.addEventListener("click", () => {
    panel.classList.remove("open");
  });
}

console.log("Panel detectado:", panel);

// Modal de alerta
function mostrarModal(mensaje) {
  document.getElementById('alertText').textContent = mensaje;
  document.getElementById('alertModal').style.display = 'flex';
}
function cerrarModal() {
  document.getElementById('alertModal').style.display = 'none';
}
