<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$query = "SELECT * FROM pases ORDER BY Fecha_creacion DESC";
$result = $conexion->query($query);

$pases = [];
while ($row = $result->fetch_assoc()) {
    $pases[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $pases
]);
