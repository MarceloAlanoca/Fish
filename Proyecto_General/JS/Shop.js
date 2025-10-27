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
                <p><strong>Tipo: </strong><strong  class="${pase.Tipo}">${pase.Tipo}</strong></p>
                <p><strong>Precio: </strong><strong  class="Price">${pase.Precio}$</strong> Pesos</p>
                <button class="ButtonPur">Comprar</button>
            </div>

            <div id="bigModal" class="modal-overlay" aria-hidden="true">
                <div class="modal-body">
                    <button class="Back"></strong>Volver</p></button>
                    <img src="../Imagenes/Passes/${pase.Foto}" alt="${pase.Nombre}">
                    <h3>${pase.Nombre}</h3>
                    <p>${pase.texto_descripcion}<p/>
                    <button class="ButtonConfirmPur"></strong>${pase.Precio} Pesos</p></button>
                </div>
            </div>
        `;

        catalogo.appendChild(item);
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


filtroTipo.addEventListener("change", actualizarVista);
filtroPrecio.addEventListener("change", actualizarVista);


cargarPases();

    /*Modal*/
  const openModal = document.querySelector(".ButtonPur");
  const modal = document.querySelector(".modal-overlay.open");
  const closeModal = document.querySelector(".modal-overlay.close");

  openModal.addEventListener("click", (e) => {
    e.preventDefault();
    modal.classList.add(".modal-overlay.open");
  });

  closeModal.addEventListener("click", (e) => {
    e.preventDefault();
    modal.classList.remove("modal-overlay");
  });