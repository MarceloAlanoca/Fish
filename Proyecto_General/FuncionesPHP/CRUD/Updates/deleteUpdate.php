<?php
header("Content-Type: application/json; charset=utf-8");
include('../../../Includes/Connect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['Id_Update'])) {
    $id = intval($_POST['Id_Update']);
    $query = "DELETE FROM updates WHERE Id_Update = $id";
    if (mysqli_query($conexion, $query)) {
        echo json_encode(["success" => true, "message" => "Update eliminada correctamente."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al eliminar: " . mysqli_error($conexion)]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Solicitud inválida."]);
}
?>
