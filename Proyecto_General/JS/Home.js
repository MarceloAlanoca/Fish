
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