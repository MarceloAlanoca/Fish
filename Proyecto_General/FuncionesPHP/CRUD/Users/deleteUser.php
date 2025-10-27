<?php
header("Content-Type: application/json; charset=utf-8");
session_start();
include("../../../Includes/Connect.php");

$id = intval($_POST['ID'] ?? 0);

if (!$id) {
    echo json_encode(["success" => false, "message" => "ID inválido."]);
    exit;
}

$currentUserRole = $_SESSION['rol'] ?? 'cliente';

$res = $conexion->query("SELECT rol FROM usuarios WHERE ID = $id LIMIT 1");
if (!$res || $res->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Usuario no encontrado."]);
    exit;
}

$userRole = $res->fetch_assoc()['rol'];

// 🔥 Restricción:
// Si el usuario a eliminar es ADMINISTRADOR y el usuario actual también es ADMINISTRADOR → Bloquear
if ($userRole === "ADMINISTRADOR" && $currentUserRole === "ADMINISTRADOR") {
    echo json_encode([
        "success" => false,
        "message" => "No puedes eliminar a otro administrador."
    ]);
    exit;
}

// Eliminar usuario
$ok = $conexion->query("DELETE FROM usuarios WHERE ID = $id");

echo json_encode([
    "success" => $ok,
    "message" => $ok ? "Usuario eliminado correctamente." : "Error al eliminar usuario."
]);
