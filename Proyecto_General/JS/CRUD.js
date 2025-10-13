document.addEventListener("DOMContentLoaded", () => {
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

    function mostrarSeccion(section) {
        switch(section) {
            case "usuarios":
                content.innerHTML = `
                    <h2>Gestión de Usuarios</h2>
                    <p>Aquí podrás crear, editar y eliminar usuarios.</p>
                `;
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

        // Cierra el menú automáticamente en pantallas pequeñas
        if (window.innerWidth < 800) {
            sidebar.classList.add("closed");
        }
    }
});
