<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

if (!isset($_POST['ID'])) {
    echo json_encode(["success" => false, "message" => "Falta el ID."]);
    exit;
}

$id = intval($_POST['ID']);
$query = "SELECT ID, Nombre, Tipo, Precio, Foto, texto_descripcion FROM pases WHERE ID = $id LIMIT 1";
$result = $conexion->query($query);

if ($result && $result->num_rows > 0) {
    echo json_encode(["success" => true, "data" => $result->fetch_assoc()]);
} else {
    echo json_encode(["success" => false, "message" => "Pase no encontrado."]);
}
