const password = document.getElementById("password");
const showPassword = document.getElementById("showPassword");

// Mostrar / ocultar contraseña
showPassword.addEventListener("change", () => {
  password.type = showPassword.checked ? "text" : "password";
});

// ===== MODAL =====

const params = new URLSearchParams(window.location.search);

if (params.get("status") === "reset_sended") {
  document.getElementById("modalReset").style.display = "flex";
}

document.getElementById("closeModal")?.addEventListener("click", () => {
  document.getElementById("modalReset").style.display = "none";
  window.history.replaceState({}, document.title, window.location.pathname);
});

if (params.get("status") === "email_not_found") {
  console.log("Mostrando modal email not found");
  document.getElementById("modalEmailFail").style.display = "flex";
}

document.getElementById("closeModalFail")?.addEventListener("click", () => {
  document.getElementById("modalEmailFail").style.display = "none";
  window.history.replaceState({}, document.title, window.location.pathname);
});

if (params.get("status") === "password_updated") {
  document.getElementById("modalPassUpdated").style.display = "flex";
}

document.getElementById("closeModalPassUpdated")?.addEventListener("click", () => {
  document.getElementById("modalPassUpdated").style.display = "none";
  window.history.replaceState({}, document.title, window.location.pathname);
});

