<?php 

    $servidor = "localhost";
    $usuario = "root";
    $clave = "";
    $BaseDeDatos = "cliente";

    $conexion = mysqli_connect($servidor, $usuario, $clave, $BaseDeDatos);

    if (!$conexion) {
    die("Error de conexión: " . mysqli_connect_error());
}


?>