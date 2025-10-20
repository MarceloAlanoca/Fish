<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$query = "SELECT Id_Update, Titulo, Tipo, Imagen, Descripcion_Corta, Texto_Detallado, Fecha_Publicacion, Autor_Id FROM updates ORDER BY Fecha_Publicacion DESC";
$result = mysqli_query($conexion, $query);

$rows = [];
if ($result) {
    while ($r = mysqli_fetch_assoc($result)) $rows[] = $r;
}

echo json_encode(["success" => true, "data" => $rows], JSON_UNESCAPED_UNICODE);
?>
