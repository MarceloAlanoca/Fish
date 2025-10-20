<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['ID'])) {
    $id = intval($_POST['ID']);
    $query = "SELECT Id_Update, Titulo, Tipo, Imagen, Descripcion_Corta, Texto_Detallado, Fecha_Publicacion, Autor_Id FROM updates WHERE Id_Update = $id LIMIT 1";
    $res = mysqli_query($conexion, $query);
    if ($res && mysqli_num_rows($res) === 1) {
        $row = mysqli_fetch_assoc($res);
        echo json_encode(["success" => true, "data" => $row], JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["success" => false, "message" => "Update no encontrada."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Solicitud inválida."]);
}
?>
