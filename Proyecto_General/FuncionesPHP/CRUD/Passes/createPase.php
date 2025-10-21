<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

$nombre = $_POST['Nombre'] ?? '';
$tipo = $_POST['Tipo'] ?? '';
$precio = $_POST['Precio'] ?? '';

if (empty($nombre) || empty($tipo) || empty($precio)) {
    echo json_encode(["success" => false, "message" => "Todos los campos son obligatorios."]);
    exit;
}

// Guardar imagen
$fotoNombre = null;
if (isset($_FILES['Foto']) && $_FILES['Foto']['error'] === 0) {
    $carpeta = "../../../Imagenes/Passes/";
    if (!file_exists($carpeta)) mkdir($carpeta, 0777, true);

    $fotoNombre = uniqid() . "_" . basename($_FILES['Foto']['name']);
    move_uploaded_file($_FILES['Foto']['tmp_name'], $carpeta . $fotoNombre);
}

$query = $conexion->prepare("INSERT INTO pases (Nombre, Tipo, Precio, Foto) VALUES (?, ?, ?, ?)");
$query->bind_param("ssds", $nombre, $tipo, $precio, $fotoNombre);
$ok = $query->execute();

echo json_encode([
    "success" => $ok,
    "message" => $ok ? "Pase creado correctamente." : "Error al crear el pase."
]);
