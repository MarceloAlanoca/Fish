<?php
session_start();
include("../../Includes/Connect.php"); // sube dos carpetas desde /Home/

if (!isset($_SESSION['usuario'])) {
    echo json_encode(["error" => "No hay sesión activa"]);
    exit;
}

$usuario = $_SESSION['usuario'];

$query = "SELECT Nombre, foto, rol FROM usuarios WHERE Usuario = '$usuario'";
$result = mysqli_query($conexion, $query);

if ($result && mysqli_num_rows($result) > 0) {
    $data = mysqli_fetch_assoc($result);
    echo json_encode($data);
} else {
    echo json_encode(["error" => "Usuario no encontrado"]);
}
?>
