<?php
session_start();
include("../Includes/Connect.php");

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $user = $_POST["username"] ?? "";
    $name = $_POST["name"] ?? "";
    $email = $_POST["email"] ?? "";
    $password = $_POST["password"] ?? "";
    $edad = $_POST["edad"] ?? null;
    $genero = $_POST["genero"] ?? null;
    $telefono = $_POST["telefono"] ?? null;

    if (empty($user) || empty($name) || empty($email) || empty($password)) {
        die("❌ Faltan datos obligatorios");
    }

    $check_sql = "SELECT * FROM usuarios WHERE Usuario='$user' OR Email='$email'";
    $check = mysqli_query($conexion, $check_sql);

    if (mysqli_num_rows($check) > 0) {
        die("❌ Usuario o email ya existe");
    }

    $hash = password_hash($password, PASSWORD_DEFAULT);

    $sql = "INSERT INTO usuarios 
            (Usuario, Nombre, Password, Email, Edad, Genero, Telefono)
            VALUES (
                '$user',
                '$name',
                '$hash',
                '$email',
                " . ($edad ? "'$edad'" : "NULL") . ",
                " . ($genero ? "'$genero'" : "NULL") . ",
                " . ($telefono ? "'$telefono'" : "NULL") . "
            )";

    if (mysqli_query($conexion, $sql)) {

        $_SESSION["id_usuario"] = mysqli_insert_id($conexion);
        $_SESSION["usuario"] = $user;
        $_SESSION["email"] = $email;
        $_SESSION["rol"] = "cliente";

        header("Location: ../Views/Home.php");
        exit;
    } 
    else {
        die("SQL ERROR: " . mysqli_error($conexion) . "<br><br>$sql");
    }
}

mysqli_close($conexion);
?>
