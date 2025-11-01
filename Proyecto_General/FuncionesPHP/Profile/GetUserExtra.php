<?php
session_start();
include("../../Includes/Connect.php");

if (!isset($_SESSION['id_usuario'])) {
    echo json_encode(["error" => "No hay sesión activa"]);
    exit;
}

$id = intval($_SESSION['id_usuario']);
$data = [];

// --- PASES ADQUIRIDOS ---
$queryPases = "
    SELECT p.Nombre AS PaseNombre, p.Foto, c.Precio, c.Fecha_compra
    FROM compras c
    INNER JOIN pases p ON c.Pase_ID = p.ID
    WHERE c.Usuario_ID = $id
    ORDER BY c.Fecha_compra DESC
";
$resPases = mysqli_query($conexion, $queryPases);
$pases = [];
while ($row = mysqli_fetch_assoc($resPases)) {
    $pases[] = $row;
}
$data["pases"] = $pases;

// --- COMENTARIOS ---
$queryCom = "
    SELECT u.Titulo AS UpdateTitulo, u.Imagen, c.Comentario, c.Fecha
    FROM comentarios c
    INNER JOIN updates u ON c.Id_Update = u.Id_Update
    WHERE c.Id_Usuario = $id
    ORDER BY c.Fecha DESC
";
$resCom = mysqli_query($conexion, $queryCom);
$comentarios = [];
while ($row = mysqli_fetch_assoc($resCom)) {
    $comentarios[] = $row;
}
$data["comentarios"] = $comentarios;

echo json_encode($data);
?>
