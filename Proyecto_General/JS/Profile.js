document.addEventListener("DOMContentLoaded", () => {
    fetch("../Includes/Profiledata.php")
        .then(res => {
            if (!res.ok) throw new Error("Error al obtener los datos");
            return res.json();
        })
        .then(data => {
            if (data.error) {
                alert(data.error);
                return;
            }
            console.log(data);
            document.getElementById("nombre").textContent = data.Nombre;
            document.getElementById("genero").textContent = data.Genero;
            document.getElementById("telefono").textContent = data.Telefono;
            document.getElementById("edad").textContent = data.Edad;
            document.getElementById("usuario").textContent = data.Usuario;
            document.getElementById("fecha").textContent = data.FechadeReg;
            document.getElementById("email").textContent = data.Email;
        })
        .catch(err => console.error(err));
});
