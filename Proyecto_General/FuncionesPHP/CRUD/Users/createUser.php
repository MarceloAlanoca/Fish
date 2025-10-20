<?php
header("Content-Type: application/json; charset=utf-8");
include("../../../Includes/Connect.php");

try {
    // Recibir datos del formulario
    $nombre = $_POST["nombre"] ?? '';
    $usuario = $_POST["usuario"] ?? '';
    $email = $_POST["email"] ?? '';
    $password = $_POST["password"] ?? '';
    $rol = $_POST["rol"] ?? '';

    // Validar campos obligatorios
    if (empty($nombre) || empty($usuario) || empty($email) || empty($password) || empty($rol)) {
        echo json_encode([
            "success" => false,
            "message" => "Todos los campos son obligatorios."
        ]);
        exit;
    }

    // Encriptar contraseña
    $passwordHash = password_hash($password, PASSWORD_DEFAULT);

    // Insertar en la base de datos
    $sql = "INSERT INTO usuarios (Nombre, Usuario, Email, Password, rol) VALUES (?, ?, ?, ?, ?)";
    $stmt = $conexion->prepare($sql);

    if (!$stmt) {
        echo json_encode([
            "success" => false,
            "message" => "Error en la preparación de la consulta."
        ]);
        exit;
    }

    $stmt->bind_param("sssss", $nombre, $usuario, $email, $passwordHash, $rol);

    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Usuario creado correctamente."
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Error al crear usuario: " . $stmt->error
        ]);
    }

    $stmt->close();
} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "message" => "Excepción: " . $e->getMessage()
    ]);
}
?>
