<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $titulo = mysqli_real_escape_string($conexion, $_POST['Titulo'] ?? '');
    $tipo = mysqli_real_escape_string($conexion, $_POST['Tipo'] ?? '');
    $desc = mysqli_real_escape_string($conexion, $_POST['Descripcion_Corta'] ?? '');
    $texto = mysqli_real_escape_string($conexion, $_POST['Texto_Detallado'] ?? '');
    $autor = $_SESSION['id_usuario'] ?? 0; // obtiene ID del usuario logueado

    if ($titulo === '' || $desc === '' || $tipo === '') {
        echo json_encode(["success" => false, "message" => "Faltan campos obligatorios."]);
        exit;
    }

    // Subida de imagen
    $imagenRuta = "";
    if (isset($_FILES['Imagen']) && $_FILES['Imagen']['error'] === UPLOAD_ERR_OK) {
        $nombreArchivo = uniqid("update_") . "_" . basename($_FILES['Imagen']['name']);
        $rutaDestino = "../../../Imagenes/Thumbnails/" . $nombreArchivo;
        if (move_uploaded_file($_FILES['Imagen']['tmp_name'], $rutaDestino)) {
            $imagenRuta = "./Imagenes/Thumbnails/" . $nombreArchivo;
        }
    }

    $fecha = date("Y-m-d H:i:s");
    $query = "INSERT INTO updates (Titulo, Tipo, Imagen, Descripcion_Corta, Texto_Detallado, Fecha_Publicacion, Autor_Id)
            VALUES ('$titulo', '$tipo', '$imagenRuta', '$desc', '$texto', '$fecha', $autor)";

    if (mysqli_query($conexion, $query)) {
        echo json_encode(["success" => true, "message" => "Update creada correctamente."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al crear update: " . mysqli_error($conexion)]);
    }
}
?>
