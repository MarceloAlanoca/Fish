<?php
session_start();
include('../../Includes/Connect.php');
header("Content-Type: application/json; charset=utf-8");

if (!isset($_SESSION["id_usuario"])) {
    echo json_encode(["success" => false, "error" => "Sesión no iniciada"]);
    exit;
}

$id_usuario = intval($_SESSION["id_usuario"]);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombre = $_POST["Nombre"] ?? null;
    $genero = $_POST["Genero"] ?? null;
    $telefono = $_POST["Telefono"] ?? null;
    $edad = $_POST["Edad"] ?? null;

    if (!$nombre || !$genero || !$telefono || !$edad) {
        echo json_encode(["success" => false, "error" => "Faltan datos"]);
        exit;
    }

    $sql = "UPDATE usuarios SET Nombre = ?, Genero = ?, Telefono = ?, Edad = ? WHERE ID = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("ssssi", $nombre, $genero, $telefono, $edad, $id_usuario);

    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "Nombre" => $nombre,
            "Genero" => $genero,
            "Telefono" => $telefono,
            "Edad" => $edad
        ]);
    } else {
        echo json_encode(["success" => false, "error" => $stmt->error]);
    }

    $stmt->close();
    $conexion->close();
}
?>
