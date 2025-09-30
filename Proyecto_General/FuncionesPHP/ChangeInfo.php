<?php
session_start();
include('../Includes/Connect.php');

$id_usuario = $_SESSION["id_usuario"];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombre = $_POST["Nombre"];
    $genero = $_POST["Genero"];
    $telefono = $_POST["Telefono"];
    $edad = $_POST["Edad"];

    $sql = "UPDATE usuarios 
            SET Nombre = ?, Genero = ?, Telefono = ?, Edad = ?
            WHERE ID = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("sssii", $nombre, $genero, $telefono, $edad, $id_usuario);

    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "Nombre" => $nombre,
            "Genero" => $genero,
            "Telefono" => $telefono,
            "Edad" => $edad
        ]);
    } else {
        echo json_encode(["success" => false, "error" => "Error al actualizar"]);
    }

    $stmt->close();
    $conexion->close();
}
?>
