<?php
include('Conexion.php'); // archivo en la misma carpeta

$usuario = $_POST['nombre'];
$email = $_POST['email'];
$pass = $_POST['password'];

$verificacion = mysqli_query($conexion, "SELECT * FROM clientes WHERE Usuario = '$usuario'");
$r = mysqli_num_rows($verificacion);

if ($r > 0) {
    echo '
        <script>
            alert("Esta cuenta está registrada");
            location.href = "../Formulario.php";
        </script>
    ';
    exit;
}

$insertar = mysqli_query($conexion, "INSERT INTO clientes (Usuario, Email, Contraseña, Rol)
VALUES('$usuario','$email','$pass','cliente')");


if ($insertar){
    echo '
        <script>
            alert("Registro exitoso");
            location.href = "../Formulario.html";
        </script>
    ';
}

mysqli_close($conexion);
?>
