<?php
session_start(); // ← NECESARIO para saber qué rol tiene el que está logueado
include("../../../Includes/Connect.php");

header("Content-Type: application/json; charset=utf-8");

$query = "SELECT ID, Nombre, Usuario, Email, rol FROM usuarios";
$result = mysqli_query($conexion, $query);

$usuarios = [];
while ($row = mysqli_fetch_assoc($result)) {
    $usuarios[] = $row;
}

echo json_encode([
    "success" => true,
    "currentUserRole" => $_SESSION['rol'] ?? 'cliente', // ← Rol del que está usando el panel
    "data" => $usuarios
]);
