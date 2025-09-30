<?php
session_start();
include("../Includes/Connect.php"); 

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $user = filter_input(INPUT_POST, "username", FILTER_SANITIZE_SPECIAL_CHARS);
    $name = filter_input(INPUT_POST, "name", FILTER_SANITIZE_SPECIAL_CHARS);
    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_SPECIAL_CHARS);
    $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_SPECIAL_CHARS);

    if (empty($user) || empty($name) || empty($email) || empty($password)) {
        echo "<script>alert('Faltan datos en el formulario');</script>";
    } else {
        $check_sql = "SELECT * FROM usuarios WHERE Usuario = '$user' OR Email = '$email'";
        $result = mysqli_query($conexion, $check_sql);

        if (mysqli_num_rows($result) > 0) {
            echo "<script>alert('El usuario o correo ya están registrados');</script>";
            header("Location: ../Views/Register.php");
            exit;
        } else {
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $sql = "INSERT INTO usuarios (Usuario, Nombre, Contraseña, Email)
                    VALUES ('$user', '$name', '$hash', '$email')";

            if (mysqli_query($conexion, $sql)) {
                $new_id = mysqli_insert_id($conexion);

                // Guardar datos en sesión
                $_SESSION["id_usuario"] = $new_id;
                $_SESSION["usuario"] = $user;
                $_SESSION["email"] = $email;

                header("Location: ../Views/Home.php");
                exit;
            } else {
                echo "Error al registrar usuario: " . mysqli_error($conexion);
            }
        }
    }
}

mysqli_close($conexion);
?>
