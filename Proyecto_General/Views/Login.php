<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
</head>
<body>
    <form action="../PHP/Login.php" method="post" id="form">
        <div class="form">
            <div class="Grupo">
                <input type="text" name="user" id="user">
                <label for="">Usuario</label>
            </div>
            <div class="Grupo">
                <input type="password" name="password" id="password" required>
                <label for="">Contraseña</label>
            </div>
            <button>Enviar</button>
        </div>
    </form>
</body>
</html>