<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>login</title>
    <link rel="stylesheet" href="login.css">
    <link rel="icon" type="image/png" href="/Imagenes/IconWeb.jpg">
</head>
<body>
    <form action="../Includes/Register.php" method="post" id="form">
        <h1>Iniciar sesion</h1>
        <div class="form">


            <div class="Grupo">
                <input type="text" name="userEmail" id="userEmail" required>
                <span class="barra"></span>
                <label for="userEmail">Usuario o Email</label>
            </div>

            <div class="Grupo">
                <input type="password" name="password" id="password" required>
                <span class="barra"></span>
                <label for="password">Contraseña</label>
                <div class="show-container">
                    <input type="checkbox" id="showPassword" class="checkbox">
                    <span class="ShowPass">Mostrar Contraseña</span>
                </div>
            </div>
            <button type="submit"class="Enviar">Enviar</button>
        </div>
    </form>
    <script src="login.js" defer></script>
</body>
</html>