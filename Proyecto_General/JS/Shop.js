const catalogo = document.getElementById("catalogo");
const filtroTipo = document.getElementById("filtroTipo");
const filtroPrecio = document.getElementById("filtroPrecio");

let pases = [];

async function cargarPases() {
    const response = await fetch("../FuncionesPHP/Shop/getPases.php");
    pases = await response.json();
    actualizarVista(); // Mostrar al inicio
}

function mostrarPases(lista) {
    catalogo.innerHTML = "";

    lista.forEach(pase => {
        const item = document.createElement("div");
        item.classList.add("item");

        item.innerHTML = `
            <img src="../Imagenes/Passes/${pase.Foto}" alt="${pase.Nombre}">
            <div class="item-info">
                <h3>${pase.Nombre}</h3>
                <p>${pase.texto_descripcion}</p>
                <p><strong>Tipo: </strong>${pase.Tipo}</p>
                <p><strong>Precio: </strong>${pase.Precio} Pesos</p>
                <button class="ButtonPur">Comprar</button>
            </div>
        `;

        catalogo.appendChild(item);
    });
}

/* === FUNCIÓN CENTRAL DE FILTRADO + ORDENADO === */
function actualizarVista() {
    let resultado = [...pases];

    // 1) FILTRO POR TIPO
    const tipoElegido = filtroTipo.value.toLowerCase();
    if (tipoElegido !== "") {
        resultado = resultado.filter(p => p.Tipo.toLowerCase() === tipoElegido);
    }

    // 2) ORDEN POR PRECIO
    const ordenElegido = filtroPrecio.value;
    if (ordenElegido === "asc") {
        resultado.sort((a, b) => Number(a.Precio) - Number(b.Precio));
    } else if (ordenElegido === "desc") {
        resultado.sort((a, b) => Number(b.Precio) - Number(a.Precio));
    }

    mostrarPases(resultado);
}

/* === EVENTOS DE SELECT === */
filtroTipo.addEventListener("change", actualizarVista);
filtroPrecio.addEventListener("change", actualizarVista);

cargarPases();
