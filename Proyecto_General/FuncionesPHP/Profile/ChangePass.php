<?php
session_start();
include('../../Includes/Connect.php');

$id_usuario = $_SESSION["id_usuario"];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $oldPass = $_POST["oldPass"];
    $newPass = $_POST["newPass"];

    // Traer contraseña actual de la DB
    $sql = "SELECT Password FROM usuarios WHERE ID = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("i", $id_usuario);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        $hash = $row["Password"];

        // Verificar la contraseña actual
        if (password_verify($oldPass, $hash)) {
            // Crear hash nuevo
            $newHash = password_hash($newPass, PASSWORD_DEFAULT);

            $sqlUpdate = "UPDATE usuarios SET Password = ? WHERE ID = ?";
            $stmtUpdate = $conexion->prepare($sqlUpdate);
            $stmtUpdate->bind_param("si", $newHash, $id_usuario);

            if ($stmtUpdate->execute()) {
                echo json_encode(["success" => true]);
            } else {
                echo json_encode(["success" => false, "error" => "Error al actualizar"]);
            }
        } else {
            echo json_encode(["success" => false, "error" => "Contraseña actual incorrecta"]);
        }
    } else {
        echo json_encode(["success" => false, "error" => "Usuario no encontrado"]);
    }
}
?>
