// ============================================================
// === PROFILE.JS COMPLETO ACTUALIZADO ========================
// ============================================================

document.addEventListener("DOMContentLoaded", () => {
  // ============================================================
  // === CARGA DE DATOS DEL PERFIL DESDE PHP ====================
  // ============================================================
  fetch("../FuncionesPHP/Profile/Profiledata.php")
    .then((res) => {
      if (!res.ok) throw new Error("Error al obtener los datos");
      return res.json();
    })
    .then((data) => {
      if (data.error) {
        alert(data.error);
        return;
      }

      console.log("Datos cargados:", data);

      document.getElementById("nombre").textContent = data.Nombre;
      document.getElementById("genero").textContent = data.Genero;
      document.getElementById("telefono").textContent = data.Telefono;
      document.getElementById("edad").textContent = data.Edad;
      document.getElementById("usuario").textContent = data.Usuario;
      document.getElementById("fecha").textContent = data.FechadeReg;
      document.getElementById("email").textContent = data.Email;

      const img = document.querySelector(".ImagenP");
      img.src = data.Foto;
    })
    .catch((err) => console.error("Error al obtener datos:", err));

  // ============================================================
  // === CAMBIAR IMAGEN DE PERFIL ===============================
  // ============================================================
  const fileInput = document.getElementById("fileInput");
  const btnCambiar = document.getElementById("btnCambiarImagen");
  const avatar = document.querySelector(".ImagenP");

  btnCambiar.addEventListener("click", () => {
    fileInput.click();
  });

  fileInput.addEventListener("change", () => {
    const file = fileInput.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append("imagen", file);

    fetch("../FuncionesPHP/Profile/ChangeImg.php", {
      method: "POST",
      body: formData,
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.success) {
          avatar.src = data.nuevaRuta;
          alert("Imagen actualizada con éxito!");
        } else {
          alert("Error: " + data.error);
        }
      })
      .catch((err) => console.error("Error al subir la imagen:", err));
  });

  // ============================================================
  // === MODALES PARA DATOS Y CONTRASEÑA ========================
  // ============================================================
  const modalDatos = document.getElementById("modalDatos");
  const modalPass = document.getElementById("modalPass");
  const btnCambiarDatos = document.getElementById("ChangeInfo");
  const btnCambiarPass = document.getElementById("ChangePass");

  // --- Abrir modales ---
  if (btnCambiarDatos && modalDatos) {
    btnCambiarDatos.addEventListener("click", () => {
      modalDatos.classList.add("active");
      document.getElementById("editNombre").value = document.getElementById("nombre").textContent;
      document.getElementById("editTelefono").value = document.getElementById("telefono").textContent;
      document.getElementById("editEdad").value = document.getElementById("edad").textContent;
      document.getElementById("editGenero").value = document.getElementById("genero").textContent;
    });
  }

  if (btnCambiarPass && modalPass) {
    btnCambiarPass.addEventListener("click", () => {
      modalPass.classList.add("active");
    });
  }

  // --- Cerrar modales ---
  const cerrarModalDatos = document.getElementById("cerrarModalDatos");
  const cerrarModalPass = document.getElementById("cerrarModalPass");

  if (cerrarModalDatos) {
    cerrarModalDatos.addEventListener("click", () => modalDatos.classList.remove("active"));
  }
  if (cerrarModalPass) {
    cerrarModalPass.addEventListener("click", () => modalPass.classList.remove("active"));
  }

  // ============================================================
  // === GUARDAR CAMBIOS DE DATOS ===============================
  // ============================================================
  const formDatos = document.getElementById("formDatos");
  if (formDatos) {
    formDatos.addEventListener("submit", (e) => {
      e.preventDefault();
      const data = new FormData(e.target);

      fetch("../FuncionesPHP/Profile/ChangeInfo.php", {
        method: "POST",
        body: data
      })
        .then(res => res.json())
        .then(result => {
          console.log("Respuesta del servidor:", result);

          if (result.success) {
            alert("Datos actualizados correctamente ✅");
            document.getElementById("nombre").textContent = result.Nombre;
            document.getElementById("telefono").textContent = result.Telefono;
            document.getElementById("edad").textContent = result.Edad;
            document.getElementById("genero").textContent = result.Genero;
            modalDatos.classList.remove("active");
          } else {
            alert("Error: " + result.error);
          }
        })
        .catch(err => console.error("Error al actualizar datos:", err));
    });
  }

  // ============================================================
  // === CAMBIAR CONTRASEÑA ====================================
  // ============================================================
  const formPass = document.getElementById("formPass");
  if (formPass) {
    formPass.addEventListener("submit", (e) => {
      e.preventDefault();

      const oldPass = document.getElementById("oldPass").value;
      const newPass = document.getElementById("newPass").value;
      const confirmPass = document.getElementById("confirmPass").value;

      if (newPass !== confirmPass) {
        alert("Las contraseñas no coinciden");
        return;
      }

      const data = new FormData();
      data.append("oldPass", oldPass);
      data.append("newPass", newPass);

      fetch("../FuncionesPHP/Profile/ChangePass.php", {
        method: "POST",
        body: data
      })
        .then(res => res.json())
        .then(result => {
          console.log("Respuesta del servidor:", result);

          if (result.success) {
            alert("Contraseña actualizada correctamente 🔒");
            modalPass.classList.remove("active");
            e.target.reset();
          } else {
            alert("Error: " + result.error);
          }
        })
        .catch(err => console.error("Error al actualizar contraseña:", err));
    });
  }

  // ============================================================
  // === SISTEMA DE ANUNCIOS ALEATORIOS =========================
  // ============================================================
  const adContainer = document.querySelector(".AD");
  if (adContainer) {
    const anuncios = [
      { url: "https://www.innersloth.com/games/among-us/", img: "../Imagenes/Ads/SusAd.png" },
      { url: "https://www.corpgovrisk.com/", img: "../Imagenes/Ads/CGR_Corp.png" },
      { url: "https://www.lebronjames.com/", img: "../Imagenes/Ads/Lebron.png" },
      { url: "https://papulandiamx.wordpress.com/", img: "../Imagenes/Ads/Picnic.png" },
      { url: "https://chisap.com/shop/panchos", img: "../Imagenes/Ads/Panchito.png" },
      { url: "https://bluebullpartners.com/es/", img: "../Imagenes/Ads/isla.png" },
    ];

    const randomIndex = Math.floor(Math.random() * anuncios.length);
    const anuncio = anuncios[randomIndex];
    const link = adContainer.querySelector("a");
    const img = adContainer.querySelector("img");

    link.href = anuncio.url;
    img.src = anuncio.img;
  }
});
