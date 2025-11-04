<?php
session_start();
include("../Includes/Connect.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $user = filter_input(INPUT_POST, "username", FILTER_SANITIZE_SPECIAL_CHARS);
    $name = filter_input(INPUT_POST, "name", FILTER_SANITIZE_SPECIAL_CHARS);
    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_EMAIL);
    $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_SPECIAL_CHARS);
    $edad = isset($_POST["edad"]) ? intval($_POST["edad"]) : null;
    $genero = $_POST["genero"] ?? null;
    $telefono = filter_input(INPUT_POST, "telefono", FILTER_SANITIZE_SPECIAL_CHARS);

    // Validación de edad
    if ($edad !== null && ($edad < 1 || $edad > 100)) {
        echo "<script>mostrarModal('⚠ Edad fuera de rango (1 a 100 años)');</script>";
        exit;
    }

    // Validación de género
    $generos_validos = ["Hombre", "Mujer", "Otro"];
    if ($genero !== null && !in_array($genero, $generos_validos)) {
        echo "<script>mostrarModal('⚠ Género inválido.');</script>";
        exit;
    }

    // Validación de campos obligatorios
    if (empty($user) || empty($name) || empty($email) || empty($password)) {
        echo "<script>mostrarModal('⚠ Faltan datos en el formulario');</script>";
        exit;
    }

    // Verificar duplicados
    $check_sql = "SELECT * FROM usuarios WHERE Usuario = '$user' OR Email = '$email'";
    $result = mysqli_query($conexion, $check_sql);

    if (mysqli_num_rows($result) > 0) {
        echo "<script>mostrarModal('⚠ El usuario o correo ya están registrados');</script>";
        exit;
    }

    // Hash de contraseña
    $hash = password_hash($password, PASSWORD_DEFAULT);

    // Insertar nuevo usuario
    $sql = "INSERT INTO usuarios (Usuario, Nombre, Password, Email, Edad, Genero, Telefono)
            VALUES ('$user', '$name', '$hash', '$email', " .
        ($edad !== null ? "'$edad'" : "NULL") . ", " .
        ($genero !== null ? "'$genero'" : "NULL") . ", " .
        ($telefono ? "'$telefono'" : "NULL") . ")";

    if (mysqli_query($conexion, $sql)) {
        $new_id = mysqli_insert_id($conexion);
        $_SESSION["id_usuario"] = $new_id;
        $_SESSION["usuario"] = $user;
        $_SESSION["email"] = $email;
        $_SESSION["rol"] = "cliente";
        header("Location: ../Views/Home.php");
        exit;
    } else {
        echo "<script>mostrarModal('❌ Error al registrar usuario: " . mysqli_error($conexion) . "');</script>";
    }
}
mysqli_close($conexion);
?>