<?php
session_start();
include('../Includes/Connect.php');

$id_usuario = $_SESSION["id_usuario"];

if (isset($_FILES['imagen'])) {
    $nombre = basename($_FILES['imagen']['name']);
    $tmp = $_FILES['imagen']['tmp_name'];

    // Carpeta donde guardar imágenes
    $carpeta = "../Imagenes/Usuarios/";
    if (!is_dir($carpeta)) {
        mkdir($carpeta, 0777, true);
    }

    $rutaDestino = $carpeta . $id_usuario . "_" . $nombre;

    if (move_uploaded_file($tmp, $rutaDestino)) {
        // Guardar ruta en DB
        $sql = "UPDATE usuarios SET Foto = ? WHERE ID = ?";
        $stmt = $conexion->prepare($sql);
        $stmt->bind_param("si", $rutaDestino, $id_usuario);

        if ($stmt->execute()) {
            echo json_encode(["success" => true, "nuevaRuta" => $rutaDestino]);
        } else {
            echo json_encode(["success" => false, "error" => "Error al actualizar la base de datos"]);
        }
    } else {
        echo json_encode(["success" => false, "error" => "Error al mover el archivo"]);
    }
} else {
    echo json_encode(["success" => false, "error" => "No se recibió imagen"]);
}
?>
