<?php
session_start();
include("../../Includes/Connect.php");

if (!isset($_SESSION["id_usuario"])) {
    echo json_encode(["success" => false, "message" => "No hay sesión activa"]);
    exit;
}

$id_usuario = $_SESSION["id_usuario"];
$carnet_ingresado = $_POST["carnet"] ?? '';

$sql = "SELECT carnet FROM usuarios WHERE ID = '$id_usuario' LIMIT 1";
$result = mysqli_query($conexion, $sql);

if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    if ($row["carnet"] === $carnet_ingresado) {
        $_SESSION["verificado_admin"] = true;
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "message" => "Carnet incorrecto"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Usuario no encontrado"]);
}

mysqli_close($conexion);
?>
