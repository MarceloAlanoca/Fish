<?php
session_start();
include('../../Includes/Connect.php');

$id_usuario = $_SESSION["id_usuario"];

if (isset($_FILES['imagen'])) {
    $nombre = basename($_FILES['imagen']['name']);
    $tmp = $_FILES['imagen']['tmp_name'];

    // Ruta real donde guardar (sube dos niveles)
    $carpeta = "../../Imagenes/Usuarios/";

    // Si no existe, la crea
    if (!is_dir($carpeta)) {
        mkdir($carpeta, 0777, true);
    }

    // Ruta física (en el servidor)
    $rutaDestino = $carpeta . $id_usuario . "_" . $nombre;

    // Ruta que se guardará en la DB (para mostrar en el navegador)
    $rutaWeb = "../Imagenes/Usuarios/" . $id_usuario . "_" . $nombre;

    // Mover archivo subido
    if (move_uploaded_file($tmp, $rutaDestino)) {

        // Guardar ruta en la base de datos
        $sql = "UPDATE usuarios SET Foto = ? WHERE ID = ?";
        $stmt = $conexion->prepare($sql);
        $stmt->bind_param("si", $rutaWeb, $id_usuario);

        if ($stmt->execute()) {
            echo json_encode(["success" => true, "nuevaRuta" => $rutaWeb]);
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

