<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$id = intval($_POST['ID'] ?? 0);
$nombre = $_POST['Nombre'] ?? '';
$tipo = $_POST['Tipo'] ?? '';
$precio = $_POST['Precio'] ?? '';

if (!$id || empty($nombre) || empty($tipo)) {
    echo json_encode(["success" => false, "message" => "Datos incompletos."]);
    exit;
}

// Obtener imagen actual
$actual = $conexion->query("SELECT Foto FROM pases WHERE ID = $id")->fetch_assoc();
$foto = $actual['Foto'];

// Nueva imagen
if (isset($_FILES['Foto']) && $_FILES['Foto']['error'] === 0) {
    $carpeta = "../../../Imagenes/Passes/";
    if (!file_exists($carpeta)) mkdir($carpeta, 0777, true);

    $foto = uniqid() . "_" . basename($_FILES['Foto']['name']);
    move_uploaded_file($_FILES['Foto']['tmp_name'], $carpeta . $foto);
}

$stmt = $conexion->prepare("UPDATE pases SET Nombre=?, Tipo=?, Precio=?, Foto=? WHERE ID=?");
$stmt->bind_param("ssdsi", $nombre, $tipo, $precio, $foto, $id);
$ok = $stmt->execute();

echo json_encode([
    "success" => $ok,
    "message" => $ok ? "Pase actualizado correctamente." : "Error al actualizar el pase."
]);
