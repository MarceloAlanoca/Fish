document.addEventListener("DOMContentLoaded", () => {

  // ============================================================
  // === CONFIGURACIÓN BASE ===
  // ============================================================
  const sidebar = document.getElementById("sidebar");
  const toggle = document.getElementById("toggleSidebar");
  const links = document.querySelectorAll(".sidebar a");
  const content = document.getElementById("content");



  // ============================================================
  // === ABRIR / CERRAR SIDEBAR ===
  // ============================================================
  toggle.addEventListener("click", () => {
    sidebar.classList.toggle("closed");
  });



  // ============================================================
  // === CAMBIO DE SECCIONES DEL PANEL ===
  // ============================================================
  links.forEach(link => {
    link.addEventListener("click", (e) => {
      e.preventDefault();

      links.forEach(l => l.parentElement.classList.remove("active"));
      link.parentElement.classList.add("active");

      const section = link.dataset.section;
      mostrarSeccion(section);
    });
  });



  // ============================================================
  // === FUNCIÓN PRINCIPAL DE SECCIONES ===
  // ============================================================
  function mostrarSeccion(section) {
    switch (section) {

      case "usuarios":
        cargarSeccionUsuarios();
        break;

      case "pases":
        content.innerHTML = `
          <h2>Gestión de Pases</h2>
          <p>Controla los pases activos y vencidos.</p>
        `;
        break;

      case "updates":
        cargarSeccionUpdates();
        break;

      default:
        content.innerHTML = `
          <h2>Bienvenido al Panel</h2>
          <p>Selecciona una opción en el menú lateral.</p>
        `;
    }

    if (window.innerWidth < 800) sidebar.classList.add("closed");
  }




  // ======================================================================
  // ======================================================================
  // === SECCIÓN Y CRUD DE USUARIOS =======================================
  // ======================================================================
  // ======================================================================

  function cargarSeccionUsuarios() {
    content.innerHTML = `
      <h2>Gestión de Usuarios</h2>
      <button class="crud-btn crear" id="btnCrear">Crear Usuario</button>
      <table class="crud-tabla">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Usuario</th>
            <th>Email</th>
            <th>Rol</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody id="userTableBody">
          <tr><td colspan="6">Cargando usuarios...</td></tr>
        </tbody>
      </table>

      <!-- MODAL -->
      <div class="modal hidden" id="userModal">
        <div class="modal-content">
          <h3 id="modalTitle">Crear Usuario</h3>
          <form id="userForm">
            <input type="text" name="nombre" placeholder="Nombre" required>
            <input type="text" name="usuario" placeholder="Usuario" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Contraseña (solo si cambia)">
            <select name="rol">
              <option value="cliente">Cliente</option>
              <option value="ADMINISTRADOR">Administrador</option>
            </select>
            <div class="modal-buttons">
              <button type="submit" class="crud-btn crear">Guardar</button>
              <button type="button" id="btnCancelar" class="crud-btn borrar">Cancelar</button>
            </div>
          </form>
        </div>
      </div>
    `;

    inicializarCRUDUsuarios();
  }



  // --------------------------------------------------------------
  // --- CRUD USUARIOS: OPERACIONES PRINCIPALES -------------------
  // --------------------------------------------------------------
  function inicializarCRUDUsuarios() {
    const userTableBody = document.querySelector("#userTableBody");
    const modal = document.getElementById("userModal");
    const modalTitle = document.getElementById("modalTitle");
    const form = document.getElementById("userForm");
    const btnCrear = document.getElementById("btnCrear");
    const btnCancelar = document.getElementById("btnCancelar");

    let currentAction = null;
    let currentUserId = null;



    // --- Cargar usuarios ---
    async function loadUsers() {
      try {
        const res = await fetch("../FuncionesPHP/CRUD/Users/obtainUsers.php");
        const data = await res.json();

        userTableBody.innerHTML = "";

        if (!Array.isArray(data) || data.length === 0) {
          userTableBody.innerHTML = `<tr><td colspan="6">No hay usuarios registrados.</td></tr>`;
          return;
        }

        data.forEach(user => {
          const tr = document.createElement("tr");
          tr.innerHTML = `
            <td>${user.ID}</td>
            <td>${user.Nombre}</td>
            <td>${user.Usuario}</td>
            <td>${user.Email}</td>
            <td>${user.rol}</td>
            <td>
              <button class="crud-btn editar" data-id="${user.ID}">Actualizar</button>
              <button class="crud-btn borrar" data-id="${user.ID}">Borrar</button>
            </td>
          `;
          userTableBody.appendChild(tr);
        });
      } catch (error) {
        console.error("Error cargando usuarios:", error);
        userTableBody.innerHTML = `<tr><td colspan="6">Error cargando datos.</td></tr>`;
      }
    }

    loadUsers();



    // --- Crear usuario ---
    btnCrear.addEventListener("click", () => {
      currentAction = "crear";
      currentUserId = null;
      form.reset();
      modalTitle.textContent = "Crear Usuario";
      modal.classList.remove("hidden");
    });



    // --- Cerrar modal ---
    btnCancelar.addEventListener("click", () => {
      modal.classList.add("hidden");
    });



    // --- Editar / Borrar ---
    userTableBody.addEventListener("click", (e) => {
      if (e.target.classList.contains("editar")) {
        currentAction = "editar";
        currentUserId = e.target.dataset.id;
        openEditModal(currentUserId);
      }

      if (e.target.classList.contains("borrar")) {
        const id = e.target.dataset.id;
        deleteUser(id);
      }
    });



    // --- Cargar datos al editar ---
    async function openEditModal(id) {
      try {
        const res = await fetch(`../FuncionesPHP/CRUD/Users/obtainUser.php?id=${id}`);
        const data = await res.json();

        if (data && data.ID) {
          modalTitle.textContent = "Actualizar Usuario";
          modal.classList.remove("hidden");
          form.nombre.value = data.Nombre;
          form.usuario.value = data.Usuario;
          form.email.value = data.Email;
          form.password.value = "";
          form.rol.value = data.rol;
        }
      } catch (error) {
        console.error("Error obteniendo usuario:", error);
      }
    }



    // --- Enviar formulario ---
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const formData = new FormData(form);
      let endpoint = "";

      if (currentAction === "crear") {
        endpoint = "../FuncionesPHP/CRUD/Users/createUser.php";
      } else if (currentAction === "editar") {
        endpoint = "../FuncionesPHP/CRUD/Users/updateUser.php";
        formData.append("ID", currentUserId);
      }

      try {
        const res = await fetch(endpoint, { method: "POST", body: formData });
        const result = await res.json();

        alert(result.message);
        if (result.success) {
          modal.classList.add("hidden");
          loadUsers();
        }
      } catch (error) {
        console.error("Error al enviar datos:", error);
      }
    });



    // --- Eliminar usuario ---
    async function deleteUser(id) {
      if (!confirm("¿Seguro que deseas eliminar este usuario?")) return;

      try {
        const res = await fetch("../FuncionesPHP/CRUD/Users/deleteUser.php", {
          method: "POST",
          body: new URLSearchParams({ ID: id })
        });

        const result = await res.json();
        alert(result.message);
        if (result.success) loadUsers();
      } catch (error) {
        console.error("Error eliminando usuario:", error);
      }
    }
  }




  // ======================================================================
  // ======================================================================
  // === SECCIÓN Y CRUD DE UPDATES (PRÓXIMO BLOQUE) =======================
  // ======================================================================
  // ======================================================================

function cargarSeccionUpdates() {
  content.innerHTML = `
    <h2>Gestión de Updates</h2>
    <button class="crud-btn crear" id="btnCrearUpdate">Crear Update</button>

    <table class="crud-tabla">
      <thead>
        <tr>
          <th>ID</th>
          <th>Título</th>
          <th>Tipo</th>
          <th>Descripción Corta</th>
          <th>Fecha</th>
          <th>Autor</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody id="updateTableBody">
        <tr><td colspan="7">Cargando updates...</td></tr>
      </tbody>
    </table>

        <!-- MODAL UPDATES -->
    <div class="modal hidden" id="updateModal">
      <div class="modal-content">
        <h3 id="updateModalTitle">Crear Update</h3>
        <form id="updateForm" enctype="multipart/form-data">
          <input type="text" name="Titulo" placeholder="Título" required>

          <select name="Tipo" required>
            <option value="">Seleccionar tipo</option>
            <option value="Parche">Parche</option>
            <option value="Actualización">Actualización</option>
          </select>

          <div class="imagen-container">
            <input type="file" name="Imagen" id="inputImagen" accept="image/*">
            <img id="previewImagen" src="" alt="Vista previa" style="width:100%;border-radius:10px;margin-top:5px;display:none;">
          </div>

          <input type="text" name="Descripcion_Corta" placeholder="Descripción corta" required>
          <textarea name="Texto_Detallado" placeholder="Texto detallado" rows="5" required></textarea>

          <div class="modal-buttons">
            <button type="submit" class="crud-btn crear">Guardar</button>
            <button type="button" id="btnCancelarUpdate" class="crud-btn borrar">Cancelar</button>
          </div>
        </form>
      </div>
    </div>

  `;

  inicializarCRUDUpdates();
}

function inicializarCRUDUpdates() {
  const tablaBody = document.getElementById("updateTableBody");
  const modal = document.getElementById("updateModal");
  const form = document.getElementById("updateForm");
  const btnCrear = document.getElementById("btnCrearUpdate");
  const btnCancelar = document.getElementById("btnCancelarUpdate");
  const modalTitle = document.getElementById("updateModalTitle");
  const inputImagen = document.getElementById("inputImagen");
  const previewImagen = document.getElementById("previewImagen");

  inputImagen.addEventListener("change", (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        previewImagen.src = reader.result;
        previewImagen.style.display = "block";
      };
      reader.readAsDataURL(file);
    }
  });


  let editando = false;
  let idEditando = null;

  // Cargar updates
  async function loadUpdates() {
    try {
      const res = await fetch("../FuncionesPHP/CRUD/Updates/obtainUpdates.php");
      const json = await res.json();
      tablaBody.innerHTML = "";

      if (!json.success || !Array.isArray(json.data) || json.data.length === 0) {
        tablaBody.innerHTML = "<tr><td colspan='7'>No hay updates registradas.</td></tr>";
        return;
      }

      json.data.forEach(u => {
        const tr = document.createElement("tr");
        tr.innerHTML = `
          <td>${u.Id_Update}</td>
          <td>${u.Titulo}</td>
          <td>${u.Tipo}</td>
          <td>${u.Descripcion_Corta}</td>
          <td>${u.Fecha_Publicacion}</td>
          <td>${u.Autor_Id}</td>
          <td>
            <button class="crud-btn editar" data-id="${u.Id_Update}">Editar</button>
            <button class="crud-btn borrar" data-id="${u.Id_Update}">Eliminar</button>
          </td>
        `;
        tablaBody.appendChild(tr);
      });

      // Delegación: editar / borrar
      tablaBody.querySelectorAll(".crud-btn.editar").forEach(b => b.addEventListener("click", () => editarUpdate(b.dataset.id)));
      tablaBody.querySelectorAll(".crud-btn.borrar").forEach(b => b.addEventListener("click", () => eliminarUpdate(b.dataset.id)));

    } catch (err) {
      console.error("Error cargando updates:", err);
      tablaBody.innerHTML = "<tr><td colspan='7'>Error al cargar updates.</td></tr>";
    }
  }

  loadUpdates();

  // Mostrar modal crear
  btnCrear.addEventListener("click", () => {
    editando = false;
    idEditando = null;
    form.reset();
    modalTitle.textContent = "Crear Update";
    modal.classList.remove("hidden");
  });

  // Cancelar modal
  btnCancelar.addEventListener("click", () => {
    modal.classList.add("hidden");
    form.reset();
  });

  // Enviar formulario (crear o actualizar)
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const fd = new FormData(form);

    let url = "";
    if (editando) {
      fd.append("Id_Update", idEditando);
      url = "../FuncionesPHP/CRUD/Updates/updateUpdate.php";
    } else {
      url = "../FuncionesPHP/CRUD/Updates/createUpdate.php";
    }

    try {
      const res = await fetch(url, { method: "POST", body: fd });
      const json = await res.json();

      alert(json.message);
      if (json.success) {
        modal.classList.add("hidden");
        loadUpdates();
      }
    } catch (err) {
      console.error("Error al enviar formulario:", err);
      alert("Error de conexión.");
    }
  });

  // Editar: obtener datos y mostrar modal con campos llenos
  async function editarUpdate(id) {
    try {
      const fd = new FormData();
      fd.append("ID", id);

      const res = await fetch("../FuncionesPHP/CRUD/Updates/obtainUpdate.php", { method: "POST", body: fd });
      const json = await res.json();

      if (!json.success) {
        alert(json.message || "No se encontró la update.");
        return;
      }

      const data = json.data;
      editando = true;
      idEditando = id;
      modalTitle.textContent = "Editar Update";

      // Rellenar formulario
      form.Titulo.value = data.Titulo || "";
      form.Tipo.value = data.Tipo || "";
      form.Descripcion_Corta.value = data.Descripcion_Corta || "";
      form.Texto_Detallado.value = data.Texto_Detallado || "";

      // Mostrar la imagen actual (si existe)
      if (data.Imagen) {
        previewImagen.src = `../Imagenes/Thumbnails${data.Imagen}`;
        previewImagen.style.display = "block";
      } else {
        previewImagen.style.display = "none";
      }


      modal.classList.remove("hidden");
    } catch (err) {
      console.error("Error al obtener update:", err);
      alert("Error al obtener datos de la update.");
    }
  }

  // Eliminar
  async function eliminarUpdate(id) {
    if (!confirm("¿Seguro que deseas eliminar esta update?")) return;

    try {
      const fd = new FormData();
      fd.append("Id_Update", id);

      const res = await fetch("../FuncionesPHP/CRUD/Updates/deleteUpdate.php", { method: "POST", body: fd });
      const json = await res.json();
      alert(json.message);
      if (json.success) loadUpdates();
    } catch (err) {
      console.error("Error al eliminar update:", err);
      alert("Error de conexión.");
    }
  }
}





  //MODAL DE VERIFICACIÓN DE CARNET

  const modal = document.getElementById("carnetModal");
  const confirmBtn = document.getElementById("confirmCarnet");
  const cancelBtn = document.getElementById("cancelCarnet");
  const input = document.getElementById("carnetInput");

  // Mostrar el modal al entrar a CRUD
  modal.style.display = "flex";

  cancelBtn.addEventListener("click", () => {
    window.location.href = "Home.php";
  });

  confirmBtn.addEventListener("click", () => {
    const carnet = input.value.trim();
    if (!carnet) {
      alert("Por favor, ingresa tu carnet.");
      return;
    }

    fetch("../FuncionesPHP/CRUD/VerifyCarnet.php", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "carnet=" + encodeURIComponent(carnet)
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          modal.style.display = "none";
        } else {
          alert("Carnet incorrecto o no autorizado.");
          input.value = "";
        }
      })
      .catch(err => {
        console.error("Error al verificar carnet:", err);
        alert("Error de conexión con el servidor.");
      });
  });

  // Bloquear clic fuera del modal
  window.addEventListener("click", (e) => {
    if (e.target === modal) e.stopPropagation();
  });
});
