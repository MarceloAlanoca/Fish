<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['Id_Update'])) {
    $id = intval($_POST['Id_Update']);
    $titulo = mysqli_real_escape_string($conexion, $_POST['Titulo'] ?? '');
    $tipo = mysqli_real_escape_string($conexion, $_POST['Tipo'] ?? '');
    $desc = mysqli_real_escape_string($conexion, $_POST['Descripcion_Corta'] ?? '');
    $texto = mysqli_real_escape_string($conexion, $_POST['Texto_Detallado'] ?? '');
    $autor = $_SESSION['id_usuario'] ?? 0;

    // Obtener imagen actual
    $imagenRuta = "";
    $res = mysqli_query($conexion, "SELECT Imagen FROM updates WHERE Id_Update = $id");
    if ($res && mysqli_num_rows($res) === 1) {
        $fila = mysqli_fetch_assoc($res);
        $imagenRuta = $fila['Imagen'];
    }

    // Si hay nueva imagen subida
    if (isset($_FILES['Imagen']) && $_FILES['Imagen']['error'] === UPLOAD_ERR_OK) {
        $nombreArchivo = uniqid("update_") . "_" . basename($_FILES['Imagen']['name']);
        $rutaDestino = "../../../Imagenes/Thumbnails/" . $nombreArchivo;
        if (move_uploaded_file($_FILES['Imagen']['tmp_name'], $rutaDestino)) {
            $imagenRuta = "./Imagenes/Thumbnails/" . $nombreArchivo;
        }
    }

    $query = "UPDATE updates SET 
                Titulo='$titulo',
                Tipo='$tipo',
                Imagen='$imagenRuta',
                Descripcion_Corta='$desc',
                Texto_Detallado='$texto',
                Autor_Id=$autor
                WHERE Id_Update = $id";

    if (mysqli_query($conexion, $query)) {
        echo json_encode(["success" => true, "message" => "Update actualizada correctamente."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al actualizar: " . mysqli_error($conexion)]);
    }
}
?>
