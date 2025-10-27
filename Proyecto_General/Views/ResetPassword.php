<?php
include("../Includes/Connect.php");

if (!isset($_GET['token'])) {
    die("Token no válido");
}

$token = mysqli_real_escape_string($conexion, $_GET['token']);
$q = "SELECT ID FROM usuarios WHERE reset_token='$token' AND reset_expire > NOW() LIMIT 1";
$r = mysqli_query($conexion, $q);

if (!$r || mysqli_num_rows($r) === 0) {
    die("El enlace ha expirado o no es válido.");
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Restablecer contraseña</title>
    <link rel="stylesheet" href="../CSS/ChangePass.css">
</head>

<body>
    <form action="../FuncionesPHP/ChangePassword/UpdatePassword.php" method="post">
        <h1>Nueva contraseña</h1>

        <input type="hidden" name="token" value="<?php echo htmlspecialchars($token); ?>">

        <div class="Grupo">
            <input type="password" name="password" required minlength="6">
            <span class="barra"></span>
            <label>Nueva contraseña</label>
        </div>

        <button type="submit" class="Enviar">Actualizar</button>
    </form>
</body>

</html>