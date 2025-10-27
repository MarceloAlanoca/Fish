<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$query = "SELECT ID, Nombre, Tipo, Precio, Fecha_creacion, Foto, texto_descripcion FROM pases ORDER BY ID DESC";
$result = $conexion->query($query);

$pases = [];
while ($row = $result->fetch_assoc()) {
    $pases[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $pases
]);
