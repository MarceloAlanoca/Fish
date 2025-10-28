<?php
session_start();
include("../../Includes/Connect.php");

if (!isset($_SESSION['id_usuario'])) {
    echo json_encode([]);
    exit;
}

$usuarioID = intval($_SESSION['id_usuario']);

$query = "SELECT Pase_ID FROM compras WHERE Usuario_ID = $usuarioID";
$result = mysqli_query($conexion, $query);

$compras = [];
while ($row = mysqli_fetch_assoc($result)) {
    $compras[] = intval($row['Pase_ID']);
}

echo json_encode($compras);
?>
