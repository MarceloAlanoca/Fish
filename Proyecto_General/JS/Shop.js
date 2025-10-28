const catalogo = document.getElementById("catalogo");
const filtroTipo = document.getElementById("filtroTipo");
const filtroPrecio = document.getElementById("filtroPrecio");

let pases = [];
let pasesComprados = [];

// =====================================================
// === CARGAR PASES DESDE LA BASE DE DATOS =============
// =====================================================
async function cargarPases() {
    const response = await fetch("../FuncionesPHP/Shop/getPases.php");
    pases = await response.json();
    await cargarComprasUsuario(); // Espera a tener los comprados
    actualizarVista();
}

// =====================================================
// === CARGAR COMPRAS DEL USUARIO ======================
// =====================================================
async function cargarComprasUsuario() {
    try {
        const res = await fetch("../FuncionesPHP/Shop/getPurchases.php");
        pasesComprados = await res.json();
    } catch (error) {
        console.error("Error al cargar compras del usuario:", error);
    }
}

// =====================================================
// === MOSTRAR LOS PASES EN PANTALLA ===================
// =====================================================
function mostrarPases(lista) {
    catalogo.innerHTML = "";

    lista.forEach(pase => {
        const item = document.createElement("div");
        item.classList.add("item");

        const comprado = pasesComprados.includes(Number(pase.ID));

        item.innerHTML = `
            <img src="../Imagenes/Passes/${pase.Foto}">
            <div class="item-info">
                <h3>${pase.Nombre}</h3>
                <p><strong>Tipo: </strong><span class="${pase.Tipo}">${pase.Tipo}</span></p>
                <p><strong>Precio: </strong><span class="Price">${pase.Precio}$</span> Pesos</p>
                <button class="ButtonPur" data-id="${pase.ID}" ${comprado ? "disabled" : ""}>
                    ${comprado ? "Ya comprado" : "Ver"}
                </button>
            </div>
        `;

        catalogo.appendChild(item);

        const boton = item.querySelector(".ButtonPur");
        if (!comprado) {
            boton.addEventListener("click", () => abrirModal(pase));
        } else {
            boton.classList.add("disabled");
        }
    });
}


function actualizarVista() {
    let resultado = [...pases];

    const tipoElegido = filtroTipo.value.toLowerCase();
    if (tipoElegido !== "") {
        resultado = resultado.filter(p => p.Tipo.toLowerCase() === tipoElegido);
    }

    const ordenElegido = filtroPrecio.value;
    if (ordenElegido === "asc") {
        resultado.sort((a, b) => Number(a.Precio) - Number(b.Precio));
    } else if (ordenElegido === "desc") {
        resultado.sort((a, b) => Number(b.Precio) - Number(a.Precio));
    }

    mostrarPases(resultado);
}

const modal = document.getElementById("modalCompra");
const cerrarModalBtn = document.getElementById("cerrarModal");
const btnComprar = document.getElementById("btnComprar");
let paseActual = null;

function abrirModal(pase) {
    paseActual = pase;
    document.getElementById("modalImagen").src = `../Imagenes/Passes/${pase.Foto}`;
    document.getElementById("modalTitulo").textContent = pase.Nombre;
    document.getElementById("modalTipo").textContent = pase.Tipo;
    document.getElementById("modalDescripcion").textContent = pase.texto_descripcion;
    btnComprar.textContent = `Comprar por ${pase.Precio} pesos`;
    modal.classList.add("open");
}

cerrarModalBtn.addEventListener("click", () => {
    modal.classList.remove("open");
});

filtroTipo.addEventListener("change", actualizarVista);
filtroPrecio.addEventListener("change", actualizarVista);


cargarPases();

btnComprar.addEventListener("click", () => {
    if (!paseActual) return;

    // Redirigir directamente al ConfirmPay simulando pago aprobado
    const params = new URLSearchParams({
        payment_id: "SIM-" + Date.now(),      // id simulado
        status: "approved",                   // estado simulado
        external_reference: paseActual.ID     // id del pase
    });

    window.location.href = "../FuncionesPHP/Shop/ConfirmPay.php?" + params.toString();
});
