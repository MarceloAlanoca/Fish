document.addEventListener("DOMContentLoaded", () => {
  const boxes = document.querySelector(".boxes");
  if (!boxes) return;

  const anuncios = [
    {
      url: "https://www.innersloth.com/games/among-us/",
      img: "../Imagenes/Ads/SusAd.png",
    },
    {
      url: "https://www.corpgovrisk.com/",
      img: "../Imagenes/Ads/CGR_Corp.png",
    },
    { url: "https://www.lebronjames.com/", img: "../Imagenes/Ads/Lebron.png" },
    {
      url: "https://papulandiamx.wordpress.com/",
      img: "../Imagenes/Ads/Picnic.png",
    },
    {
      url: "https://chisap.com/shop/panchos",
      img: "../Imagenes/Ads/Panchito.png",
    },
    {
      url: "https://bluebullpartners.com/es/",
      img: "../Imagenes/Ads/isla.png",
    },
  ];

  const adBlocks = Array.from(boxes.querySelectorAll(".Ad1, .Ad2"));
  const seleccion = boxes.querySelector(".Seleccion");

  // --- ASIGNAR ANUNCIOS ALEATORIOS ---
  let disponibles = [...anuncios];
  adBlocks.forEach((block) => {
    const link = block.querySelector("a");
    const img = block.querySelector("img");
    if (disponibles.length === 0) disponibles = [...anuncios];
    const index = Math.floor(Math.random() * disponibles.length);
    const anuncio = disponibles.splice(index, 1)[0]; // elimina para no repetir
    link.href = anuncio.url;
    img.src = anuncio.img;
  });

  const orden = [adBlocks[0], seleccion, adBlocks[1]];

  boxes.innerHTML = "";
  orden.forEach((el) => boxes.appendChild(el));

  //Modal
  const openModal = document.querySelector("#btnRegistros");
  const modal = document.querySelector("#modalRegistros");
  const closeModal = document.querySelector(".modal-close");

  openModal.addEventListener("click", (e) => {
    e.preventDefault();
    modal.classList.add("modal-show");
  });

  closeModal.addEventListener("click", (e) => {
    e.preventDefault();
    modal.classList.remove("modal-show");
  });

  const mensaje = document.getElementById("mensajeHorario");
  const body = document.body;
  const hora = new Date().getHours();

  let fondo = "";
  let texto = "";

  if (hora >= 6 && hora < 12) {
    texto = "¡Buenos días, pescador!";
    fondo = "../Imagenes/BackgroundHomeM.jpg";
  } else if (hora >= 12 && hora < 19) {
    texto = " ¡Buena tarde para pescar!";
    fondo = "../Imagenes/BackgroundHomeT.png";
  } else {
    texto = "La noche del océano te espera...";
    fondo = "../Imagenes/BackgroundHomeN.png";
  }

  mensaje.textContent = texto;
  body.style.backgroundImage = `url(${fondo})`;
  body.style.backgroundSize = "cover";
  body.style.backgroundPosition = "center";
  body.style.transition = "background-image 1s ease-in-out";


  const pezAnimado = document.getElementById("pezAnimado");


  const peces = [
    "../Imagenes/Pezecillos/Pez1.png",
    "../Imagenes/Pezecillos/Pez2.png",
    "../Imagenes/Pezecillos/Pez3.png",
  ];

  // Elegir uno al azar
  const pezAleatorio = peces[Math.floor(Math.random() * peces.length)];

  // Asignar imagen
  pezAnimado.src = pezAleatorio;
});
