document.addEventListener("DOMContentLoaded", () => {
    fetch("../FuncionesPHP/Profiledata.php")
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

            const img = document.querySelector(".ImagenP");
            img.src = data.Foto;
        })
        .catch(err => console.error(err));


    const fileInput = document.getElementById("fileInput");
    const btnCambiar = document.getElementById("btnCambiarImagen");
    const avatar = document.querySelector(".ImagenP");

    
    btnCambiar.addEventListener("click", () => {
        fileInput.click();
    });

    
    fileInput.addEventListener("change", () => {
        const file = fileInput.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append("imagen", file);

        fetch("../FuncionesPHP/ChangeImg.php", {
            method: "POST",
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                avatar.src = data.nuevaRuta;
                alert("Imagen actualizada con éxito!");
            } else {
                alert("Error: " + data.error);
            }
        })
        .catch(err => console.error("Error al subir la imagen:", err));
    });



    const btnChange = document.getElementById("ChangeInfo");
    const btnSave = document.getElementById("SaveInfo");

    btnChange.addEventListener("click", () => {
        toggleEditMode(true);
    });

    btnSave.addEventListener("click", () => {
        const data = new FormData();
        data.append("Nombre", document.getElementById("editNombre").value);
        data.append("Genero", document.getElementById("editGenero").value);
        data.append("Telefono", document.getElementById("editTelefono").value);
        data.append("Edad", document.getElementById("editEdad").value);

        fetch("../FuncionesPHP/ChangeInfo.php", {
            method: "POST",
            body: data
        })
        .then(res => res.json())
        .then(result => {
            if(result.success){
                alert("Datos actualizados :D");

                // Refrescar la vista
                document.getElementById("nombre").textContent = result.Nombre;
                document.getElementById("genero").textContent = result.Genero;
                document.getElementById("telefono").textContent = result.Telefono;
                document.getElementById("edad").textContent = result.Edad;

                toggleEditMode(false);
            } else {
                alert("Error: " + result.error);
            }
        });
    });

    function toggleEditMode(editing) {
        const spans = ["nombre", "genero", "telefono", "edad"];
        spans.forEach(id => {
            document.getElementById(id).style.display = editing ? "none" : "inline";
            document.getElementById("edit" + capitalize(id)).style.display = editing ? "inline" : "none";
            if (editing) {
                document.getElementById("edit" + capitalize(id)).value = document.getElementById(id).textContent;
            }
        });
        btnChange.style.display = editing ? "none" : "inline";
        btnSave.style.display = editing ? "inline" : "none";
    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }


    const btnChangePass = document.getElementById("ChangePass");
    const passwordForm = document.getElementById("passwordForm");
    const btnSavePass = document.getElementById("SavePass");

    btnChangePass.addEventListener("click", () => {
        passwordForm.style.display = 
            passwordForm.style.display === "none" ? "block" : "none";
    });

    btnSavePass.addEventListener("click", () => {
        const oldPass = document.getElementById("oldPass").value;
        const newPass = document.getElementById("newPass").value;
        const confirmPass = document.getElementById("confirmPass").value;

        if (newPass !== confirmPass) {
            alert("Las contraseñas nuevas no coinciden");
            return;
        }

        const data = new FormData();
        data.append("oldPass", oldPass);
        data.append("newPass", newPass);

        fetch("../FuncionesPHP/ChangePass.php", {
            method: "POST",
            body: data
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert("Contraseña actualizada");
                passwordForm.style.display = "none";
                document.getElementById("oldPass").value = "";
                document.getElementById("newPass").value = "";
                document.getElementById("confirmPass").value = "";
            } else {
                alert("Error: " + result.error);
            }
        })
        .catch(err => console.error("Error al actualizar contraseña:", err));
    });
});
