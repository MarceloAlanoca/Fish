<?php
    session_start();
    include('../Includes/ConexionPHP/Connect.php');
    if (!isset($_SESSION["id_usuario"])) {
        echo "<script> alert('Inicio de sesion requerido para entrar aqui'); </script>";
        header("Location: login.php");
        exit();
    }

    $id_usuario = $_SESSION["id_usuario"];

    $sql = "SELECT Nombre, Genero, Telefono, Edad, Usuario, FechadeReg, Email 
            FROM usuarios 
            WHERE ID = ?";

    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("i", $id_usuario);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode($row, JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["error" => "No se encontraron datos"]);
    }

    $stmt->close();
    $conexion->close();
?>