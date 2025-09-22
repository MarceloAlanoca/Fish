<?php
session_start();
include("../Includes/Connect.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $user = filter_input(INPUT_POST, "user", FILTER_SANITIZE_SPECIAL_CHARS);
    $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_SPECIAL_CHARS);

    if (empty($user) || empty($password)) {
        echo "<script>alert('Faltan datos en el formulario'); window.history.back();</script>";
    } else {

        $sql = "SELECT * FROM usuarios WHERE Usuario = '$user' OR Email = '$user' LIMIT 1";
        $result = mysqli_query($conexion, $sql);

        if ($result && mysqli_num_rows($result) > 0) {
            $row = mysqli_fetch_assoc($result);


            if (password_verify($password, $row["Contraseña"])) {
                // Guardar sesión
                $_SESSION["id_usuario"] = $row["ID"]; // 
                $_SESSION["usuario"] = $row["Usuario"];
                $_SESSION["email"] = $row["Email"];

                echo "<script>
                alert('Inicio de sesion exitoso ;)');
                window.location.href = '../Views/Home.php';
                </script>";
            exit;
            } else {
                echo "<script>alert('Contraseña incorrecta'); window.history.back();</script>";
            }
        } else {
            echo "<script>alert('Usuario no encontrado'); window.history.back();</script>";
        }
    }
}

mysqli_close($conexion);
?>