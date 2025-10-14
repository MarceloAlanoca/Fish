document.addEventListener("DOMContentLoaded", () => {
  // === ELEMENTOS BASE ===
  const sidebar = document.getElementById("sidebar");
  const toggle = document.getElementById("toggleSidebar");
  const links = document.querySelectorAll(".sidebar a");
  const content = document.getElementById("content");

  // --- ABRIR / CERRAR SIDEBAR ---
  toggle.addEventListener("click", () => {
    sidebar.classList.toggle("closed");
  });

  // --- CAMBIO DE SECCIONES ---
  links.forEach(link => {
    link.addEventListener("click", (e) => {
      e.preventDefault();

      links.forEach(l => l.parentElement.classList.remove("active"));
      link.parentElement.classList.add("active");

      const section = link.dataset.section;
      mostrarSeccion(section);
    });
  });

  // --- FUNCIÓN PRINCIPAL DE SECCIONES ---
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
      case "registros":
        content.innerHTML = `
          <h2>Registros del Sistema</h2>
          <p>Consulta logs y movimientos.</p>
        `;
        break;
      default:
        content.innerHTML = `
          <h2>Bienvenido al Panel</h2>
          <p>Selecciona una opción en el menú lateral.</p>
        `;
    }

    if (window.innerWidth < 800) sidebar.classList.add("closed");
  }

  // === SECCIÓN USUARIOS ===
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

  // === CRUD USUARIOS ===
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
        const res = await fetch("../FuncionesPHP/CRUD/obtainUsers.php");
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

    // --- Crear ---
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
        const res = await fetch(`../FuncionesPHP/CRUD/obtainUser.php?id=${id}`);
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
        endpoint = "../FuncionesPHP/CRUD/createUser.php";
      } else if (currentAction === "editar") {
        endpoint = "../FuncionesPHP/CRUD/updateUser.php";
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

    // --- Eliminar ---
    async function deleteUser(id) {
      if (!confirm("¿Seguro que deseas eliminar este usuario?")) return;

      try {
        const res = await fetch("../FuncionesPHP/CRUD/deleteUser.php", {
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
});
