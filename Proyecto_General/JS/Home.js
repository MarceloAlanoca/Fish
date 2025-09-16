
document.getElementById("btnTienda").onclick = () => {
  document.getElementById("modalTienda").style.display = "block";
};

document.getElementById("btnRegistros").onclick = () => {
  document.getElementById("modalRegistros").style.display = "block";
};

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
document.addEventListener("DOMContentLoaded", () => {
  // Lista de anuncios posibles
  const anuncios = [
    {
      url: "https://www.innersloth.com/games/among-us/",
      img: "../Imagenes/Ads/SusAd.png"
    },
    {
      url: "https://www.corpgovrisk.com/",
      img: "../Imagenes/Ads/CGR_Corp.png"
    },
    {
      url: "https://store.steampowered.com/app/1562430/DREDGE/",
      img: "../Imagenes/Ads/DredgeAd.png"
    },
    {
      url: "https://www.minecraft.net/",
      img: "../Imagenes/Ads/MinecraftAd.png"
    },
    {
      url: "https://www.epicgames.com/fortnite/",
      img: "../Imagenes/Ads/FortniteAd.png"
    }
  ];

  // Obtener todos los <a> de anuncios dentro de .boxes
  const slots = document.querySelectorAll(".boxes a");

  // Copiamos los anuncios para no repetir
  let disponibles = [...anuncios];

  slots.forEach(slot => {
    if (disponibles.length === 0) disponibles = [...anuncios]; // reiniciar si se acaban

    // Selección aleatoria
    const index = Math.floor(Math.random() * disponibles.length);
    const anuncio = disponibles[index];

    // Asignar valores al <a> y a su <img>
    slot.href = anuncio.url;
    slot.querySelector("img").src = anuncio.img;

    // Quitar anuncio usado para no repetir en otro slot
    disponibles.splice(index, 1);
  });
});
