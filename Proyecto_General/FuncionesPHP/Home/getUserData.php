<?php
session_start();
include("../../Includes/Connect.php");

// Verificar que la sesión esté activa
if (!isset($_SESSION['usuario']) || !isset($_SESSION['id_usuario'])) {
    echo json_encode(["error" => "No hay sesión activa"]);
    exit;
}

$usuario = $_SESSION['usuario'];
$id = intval($_SESSION['id_usuario']);

// Buscar datos del usuario por ID (más seguro que por nombre)
$query = "SELECT Nombre, foto, rol FROM usuarios WHERE ID = $id";
$result = mysqli_query($conexion, $query);

if ($result && mysqli_num_rows($result) > 0) {
    $data = mysqli_fetch_assoc($result);
    echo json_encode($data);
} else {
    echo json_encode(["error" => "Usuario no encontrado"]);
}
?>
