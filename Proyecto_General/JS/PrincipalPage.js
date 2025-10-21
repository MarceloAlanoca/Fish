 setTimeout(() => {
    document.getElementById("animacion").classList.add("final");
}, 3000);

const imagen = document.querySelector('.imagen');

// Sensibilidad del efecto
const intensidad = 45;

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
