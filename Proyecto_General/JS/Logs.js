// ../JS/Logs.js
document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("updatesContainer");
  const modalOverlay = document.getElementById("bigModal");
  const modal = modalOverlay.querySelector(".modal");
  const modalTitle = document.getElementById("modalTitle");
  const modalDate = document.getElementById("modalDate");
  const modalImage = document.getElementById("modalImage");
  const modalDetail = document.getElementById("modalDetail");
  const commentsList = document.getElementById("commentsList");
  const newComment = document.getElementById("newComment");
  const addCommentBtn = document.getElementById("addCommentBtn");
  const closeBtn = modalOverlay.querySelector(".modal-close");

  let currentUpdateId = null;

  async function loadUpdatesFromServer() {
    try {
      const res = await fetch("../FuncionesPHP/Logs/getUpdates.php");
      if (!res.ok) throw new Error("Error al obtener actualizaciones");
      const updates = await res.json();

      container.innerHTML = ""; // limpiar contenedor

      if (!Array.isArray(updates) || updates.length === 0) {
        container.innerHTML = "<p>No hay actualizaciones disponibles.</p>";
        return;
      }

      updates.forEach((update) => {
        const div = document.createElement("div");
        div.className = "registro";
        div.dataset.id = update.Id_Update;
        div.dataset.titulo = update.Titulo;
        div.dataset.fecha = new Date(
          update.Fecha_Publicacion
        ).toLocaleDateString();
        div.dataset.img = update.Imagen; //Problemas con src
        div.dataset.detalle = update.Texto_Detallado;

        div.innerHTML = `
          <h4>${escapeHtml(update.Titulo)}</h4>
          <p>${escapeHtml(update.Descripcion_Corta)}</p>
        `;

        div.addEventListener("click", () => openModal(update));
        container.appendChild(div);
      });
    } catch (err) {
      console.error(err);
      container.innerHTML = "<p>Error cargando las actualizaciones.</p>";
    }
  }

  async function openModal(update) {
    currentUpdateId = update.Id_Update;

    modalTitle.textContent = update.Titulo;
    modalDate.textContent = new Date(
      update.Fecha_Publicacion
    ).toLocaleDateString();
    modalImage.src = update.Imagen;
    modalImage.alt = update.Titulo;
    modalDetail.textContent = update.Texto_Detallado;

    modalOverlay.classList.add("open");
    modalOverlay.setAttribute("aria-hidden", "false");
    modal.focus();

    await loadComments(update.Id_Update);
  }

  // ✅ Cargar comentarios con fetch
  async function loadComments(idUpdate) {
    commentsList.innerHTML = "<p>Cargando comentarios...</p>";
    try {
      const res = await fetch(
        `../FuncionesPHP/Logs/getComments.php?id_update=${encodeURIComponent(
          idUpdate
        )}`
      );
      if (!res.ok) throw new Error("Error al obtener comentarios");
      const comments = await res.json();

      if (!Array.isArray(comments) || comments.length === 0) {
        commentsList.innerHTML = "<p>No hay comentarios aún.</p>";
        return;
      }

      commentsList.innerHTML = comments
        .map(
          (c) => `
        <div class="comment">
          <small>${new Date(c.Fecha).toLocaleString()} — <b>${escapeHtml(
            c.Usuario
          )}</b></small>
          <p>${escapeHtml(c.Comentario)}</p>
        </div>
      `
        )
        .join("");
    } catch (err) {
      console.error(err);
      commentsList.innerHTML = "<p>Error al cargar los comentarios.</p>";
    }
  }

  // ✅ Enviar nuevo comentario usando fetch POST
  addCommentBtn.addEventListener("click", async () => {
    const texto = newComment.value.trim();
    if (!texto) return alert("Escribí un comentario antes de enviar.");

    const formData = new FormData();
    formData.append("id_update", currentUpdateId);
    formData.append("comentario", texto);

    addCommentBtn.disabled = true;
    addCommentBtn.textContent = "Enviando...";

    try {
      const res = await fetch("../FuncionesPHP/Logs/addComments.php", {
        method: "POST",
        body: formData,
      });

      const data = await res.json();

      if (data.error) {
        alert(data.error);
      } else {
        newComment.value = "";
        await loadComments(currentUpdateId);
      }
    } catch (err) {
      console.error(err);
      alert("Error al enviar comentario.");
    } finally {
      addCommentBtn.disabled = false;
      addCommentBtn.textContent = "Agregar comentario";
    }
  });

  function closeModal() {
    modalOverlay.classList.remove("open");
    modalOverlay.setAttribute("aria-hidden", "true");
    currentUpdateId = null;
    commentsList.innerHTML = "";
  }

  closeBtn.addEventListener("click", closeModal);
  modalOverlay.addEventListener("click", (e) => {
    if (e.target === modalOverlay) closeModal();
  });
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") closeModal();
  });

  function escapeHtml(str) {
    if (!str) return "";
    return String(str)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  loadUpdatesFromServer();
});
