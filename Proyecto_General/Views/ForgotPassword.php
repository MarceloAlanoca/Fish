<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Recuperar contraseña</title>
    <link rel="stylesheet" href="../CSS/ChangePass.css">
</head>

<body>

    <form action="../FuncionesPHP/ChangePassword/SendReset.php" method="post">
        <h1>Recuperar contraseña</h1>

        <div class="Grupo">
            <input type="email" name="email" required>
            <span class="barra"></span>
            <label>Correo registrado</label>
        </div>

        <button type="submit" class="Enviar">Enviar enlace</button>
    </form>

</body>

</html>