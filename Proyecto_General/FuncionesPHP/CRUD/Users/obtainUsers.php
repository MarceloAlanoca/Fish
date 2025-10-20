<?php
include("../../../Includes/Connect.php");

header("Content-Type: application/json; charset=utf-8");

$query = "SELECT ID, Nombre, Usuario, Email, rol FROM usuarios";
$result = mysqli_query($conexion, $query);

$usuarios = [];
while ($row = mysqli_fetch_assoc($result)) {
    $usuarios[] = $row;
}

echo json_encode($usuarios);
?>
