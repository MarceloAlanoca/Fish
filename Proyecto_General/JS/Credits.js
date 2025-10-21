function mostrarModal(id) {
    document.getElementById(id).style.display = "block";
}

function cerrarModal(id) {
    document.getElementById(id).style.display = "none";
}


window.onclick = function(event) {
    let modals = document.getElementsByClassName("modal");
    for (let modal of modals) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
}

function mostrarModal(id) {
  document.getElementById(id).style.display = "block";
}

function cerrarModal(id) {
  document.getElementById(id).style.display = "none";
}

window.onclick = function (event) {
  let modals = document.getElementsByClassName("modal");
  for (let modal of modals) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
};

const imagenes = document.querySelectorAll('.imagen');
const intensidad = 25;

imagenes.forEach((imagen) => {
  imagen.addEventListener('mousemove', (e) => {
    const rect = imagen.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const centroX = rect.width / 2;
    const centroY = rect.height / 2;

    const rotX = ((y - centroY) / centroY) * -intensidad;
    const rotY = ((x - centroX) / centroX) * intensidad;

    imagen.style.transform = `rotateX(${rotX}deg) rotateY(${rotY}deg) scale(1.05)`;
    imagen.classList.add('hover');
  });

  imagen.addEventListener('mouseleave', () => {
    imagen.style.transform = `rotateX(0deg) rotateY(0deg) scale(1)`;
    imagen.classList.remove('hover');
  });
});
