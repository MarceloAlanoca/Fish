document.getElementById("form").addEventListener("submit", function(e) {
    e.preventDefault(); // esto evita recargar la pagina

    // da los valores de cada input
    let nombre = document.querySelector('input[name="text"]').value;
    let email = document.querySelector('input[name="email"]').value;
    let password = document.getElementById("password").value;

    // esta es la parte de la zona donde esta la info se guarda
    let info = {
        name: nombre,
        email: email,
        password: password
    };

    // Guardar en localStorage como JSON
    localStorage.setItem("info", JSON.stringify(info));

    // Mostrar en consola
    console.log("Datos guardados:", info);

    alert("Datos guardados en el navegador");
});

// Al cargar la página, cargar los datos si existen
window.addEventListener("load", function() {
    let datosGuardados = localStorage.getItem("info");

    if (datosGuardados) {
        let info = JSON.parse(datosGuardados); 
        document.querySelector('input[name="text"]').value = info.name;
        document.querySelector('input[name="email"]').value = info.email;
        document.getElementById("password").value = info.password;

        console.log("Datos cargados desde localStorage:", info);
    }
});