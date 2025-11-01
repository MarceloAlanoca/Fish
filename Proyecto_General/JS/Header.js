document.addEventListener("DOMContentLoaded", () => {
  // --- Obtener datos del usuario ---
  fetch("../FuncionesPHP/Home/getUserData.php")
    .then(res => res.json())
    .then(data => {
      if (data.error) {
        console.warn(data.error);
        return;
      }

      const nombre = document.querySelector(".NombreProfile");
      const imagen = document.querySelector(".ImgProfile");
      const adminBtn = document.querySelector(".admin-btn"); // botón ADMIN

      if (nombre) nombre.textContent = data.Nombre || "";
      if (imagen) imagen.src = data.foto || "";

      if (adminBtn) {
        if (data.rol === "ADMINISTRADOR") {
          adminBtn.style.display = "inline-block"; // se muestra
        } else {
          adminBtn.style.display = "none"; // se oculta
        }
      }
    })
    .catch(err => console.error("Error al obtener usuario:", err));

  // --- Modal de Logout ---
  const logoutBtn = document.querySelector(".logout-btn");
  const modal = document.getElementById("logoutModal");
  const confirmBtn = document.getElementById("confirmLogout");
  const cancelBtn = document.getElementById("cancelLogout");

  if (logoutBtn) {
    logoutBtn.addEventListener("click", (e) => {
      e.preventDefault();
      modal.style.display = "flex";
    });
  }

  if (cancelBtn) {
    cancelBtn.addEventListener("click", () => modal.style.display = "none");
  }

  if (confirmBtn) {
    confirmBtn.addEventListener("click", () => {
      window.location.href = "../FuncionesPHP/Logout.php";
    });
  }

  window.addEventListener("click", (e) => {
    if (e.target === modal) modal.style.display = "none";
  });

  // --- Menú Hamburguesa ---
  const menuToggle = document.getElementById("menuToggle");
  const navMenu = document.getElementById("navMenu");

  if (menuToggle && navMenu) {
    menuToggle.addEventListener("click", () => {
      navMenu.classList.toggle("active");
      menuToggle.classList.toggle("open");
    });
  }
});
