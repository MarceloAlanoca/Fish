<?php
$servidor = "localhost";
$usuario = "root";
$clave = "";
$BaseDeDatos = "cliente";

// Conectar a la base de datos
$conexion = mysqli_connect($servidor, $usuario, $clave, $BaseDeDatos);

// Verificar si hubo error en la conexión
if (!$conexion) {
    die("Error de conexión: " . mysqli_connect_error());
}

// echo "Conexión exitosa"; // Opcional: solo para pruebas
?>
