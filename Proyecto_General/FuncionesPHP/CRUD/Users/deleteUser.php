<?php
include("../../../Includes/Connect.php");

header("Content-Type: application/json; charset=utf-8");

if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST['ID'])) {
    $id = intval($_POST['ID']);

    $query = "DELETE FROM usuarios WHERE ID = $id";
    if (mysqli_query($conexion, $query)) {
        echo json_encode(["success" => true, "message" => "Usuario eliminado correctamente"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al eliminar usuario"]);
    }
}
?>
