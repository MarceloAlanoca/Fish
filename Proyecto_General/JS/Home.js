
// --- SISTEMA DE MODALES ---
document.addEventListener("DOMContentLoaded", () => {
  const btnTienda = document.getElementById("btnTienda");
  const btnRegistros = document.getElementById("btnRegistros");

  if (btnTienda) {
    btnTienda.onclick = () => {
      document.getElementById("modalTienda").style.display = "block";
    };
  }

  if (btnRegistros) {
    btnRegistros.onclick = () => {
      document.getElementById("modalRegistros").style.display = "block";
    };
  }

  document.querySelectorAll(".close").forEach(btn => {
    btn.onclick = () => {
      document.getElementById(btn.dataset.close).style.display = "none";
    };
  });

  window.onclick = (e) => {
    if (e.target.classList.contains("modal")) {
      e.target.style.display = "none";
    }
  };

  // --- SISTEMA DE ANUNCIOS ALEATORIOS ---
  const boxes = document.querySelector(".boxes");
  if (!boxes) return;

  const anuncios = [
    { url: "https://www.innersloth.com/games/among-us/", img: "../Imagenes/Ads/SusAd.png" },
    { url: "https://www.corpgovrisk.com/", img: "../Imagenes/Ads/CGR_Corp.png" },
    { url: "https://store.steampowered.com/app/1562430/DREDGE/", img: "../Imagenes/PLACEHOLDER.png" },
    { url: "https://www.minecraft.net/", img: "../Imagenes/PLACEHOLDER.png" },
    { url: "https://www.epicgames.com/fortnite/", img: "../Imagenes/PLACEHOLDER.png" }
  ];

  const slots = boxes.querySelectorAll(".Ad1 a, .Ad2 a");
  let disponibles = [...anuncios];

  slots.forEach(slot => {
    if (disponibles.length === 0) disponibles = [...anuncios];
    const index = Math.floor(Math.random() * disponibles.length);
    const anuncio = disponibles[index];
    slot.href = anuncio.url;
    slot.querySelector("img").src = anuncio.img;
  });


  const adBlocks = Array.from(boxes.querySelectorAll(".Ad1, .Ad2"));
  const seleccion = boxes.querySelector(".Seleccion");


  for (let i = adBlocks.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [adBlocks[i], adBlocks[j]] = [adBlocks[j], adBlocks[i]];
  }


  boxes.innerHTML = "";
  adBlocks.forEach(ad => boxes.appendChild(ad));
  if (seleccion) boxes.appendChild(seleccion);
});
