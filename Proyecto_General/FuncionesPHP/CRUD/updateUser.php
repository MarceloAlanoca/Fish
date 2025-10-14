<?php
include("../../Includes/Connect.php");

header("Content-Type: application/json; charset=utf-8");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $id = intval($_POST['ID']);
    $nombre = mysqli_real_escape_string($conexion, $_POST['nombre']);
    $usuario = mysqli_real_escape_string($conexion, $_POST['usuario']);
    $email = mysqli_real_escape_string($conexion, $_POST['email']);
    $rol = mysqli_real_escape_string($conexion, $_POST['rol']);
    $password = isset($_POST['password']) ? trim($_POST['password']) : "";

    if (!empty($password)) {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $query = "UPDATE usuarios
                  SET Nombre='$nombre', Usuario='$usuario', Email='$email', rol='$rol', Contraseña='$hash'
                  WHERE ID=$id";
    } else {
        $query = "UPDATE usuarios
                  SET Nombre='$nombre', Usuario='$usuario', Email='$email', rol='$rol'
                  WHERE ID=$id";
    }

    if (mysqli_query($conexion, $query)) {
        echo json_encode(["success" => true, "message" => "Usuario actualizado correctamente"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al actualizar usuario"]);
    }
}
?>
