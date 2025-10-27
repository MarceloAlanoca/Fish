<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$id = intval($_POST['ID'] ?? 0);
if (!$id) {
    echo json_encode(["success" => false, "message" => "Falta el ID."]);
    exit;
}

// Eliminar imagen
$imgQuery = $conexion->query("SELECT Foto FROM pases WHERE ID = $id");
if ($imgQuery && $imgQuery->num_rows > 0) {
    $row = $imgQuery->fetch_assoc();
    $ruta = "../../../Imagenes/Passes/" . $row['Foto'];
    if ($row['Foto'] && file_exists($ruta)) unlink($ruta);
}

$ok = $conexion->query("DELETE FROM pases WHERE ID = $id");

echo json_encode([
    "success" => $ok,
    "message" => $ok ? "Pase eliminado correctamente." : "Error al eliminar pase."
]);
