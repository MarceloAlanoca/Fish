<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$id = intval($_POST['ID'] ?? 0);
if (!$id) {
    echo json_encode(["success" => false, "message" => "Falta el ID."]);
    exit;
}

// Eliminar imagen del servidor
$imgQuery = $conexion->query("SELECT Foto FROM pases WHERE ID = $id");
if ($imgQuery && $imgQuery->num_rows > 0) {
    $row = $imgQuery->fetch_assoc();
    if ($row['Foto'] && file_exists("../../../Imagenes/Pases/" . $row['Foto'])) {
        unlink("../../../Imagenes/Passes/" . $row['Foto']);
    }
}

$ok = $conexion->query("DELETE FROM pases WHERE ID = $id");

echo json_encode([
    "success" => $ok,
    "message" => $ok ? "Pase eliminado correctamente." : "Error al eliminar pase."
]);
