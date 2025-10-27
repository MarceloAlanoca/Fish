<?php
include("../../Includes/Connect.php");
header("Content-Type: application/json; charset=utf-8");

$query = "SELECT ID, Nombre, Precio, Tipo, Foto, texto_descripcion FROM pases";
$result = mysqli_query($conexion, $query);

$pases = [];

while ($row = mysqli_fetch_assoc($result)) {
    $pases[] = $row;
}

echo json_encode($pases);
