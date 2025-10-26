<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recuperar Contraseña</title>
    <link rel="stylesheet" href="../CSS/login.css">
</head>
<body>
<form action="../FuncionesPHP/SendReset.php" method="post" id="form">
    <h1>Recuperar contraseña</h1>

    <div class="Grupo">
        <input type="email" name="email" required>
        <span class="barra"></span>
        <label for="email">Correo registrado</label>
    </div>

    <button type="submit" class="Enviar">Enviar enlace</button>
</form>
</body>
</html>
