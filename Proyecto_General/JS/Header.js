document.addEventListener("DOMContentLoaded", () => {
    fetch("../FuncionesPHP/Home/getUserData.php")
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                console.warn(data.error);
                return;
            }

            const nombre = document.querySelector(".NombreProfile");
            const imagen = document.querySelector(".ImgProfile");

            nombre.textContent = data.Nombre;
            imagen.src = data.foto;
        })
        .catch(err => console.error("Error al obtener usuario:", err));
});