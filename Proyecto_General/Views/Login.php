<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>login</title>
    <link rel="stylesheet" href="../CSS/login.css">
    <link rel="icon" type="image/png" href="/Imagenes/IconWeb.jpg">
    <script src="../JS/login.js" defer></script>
</head>

<body>
    <form action="../FuncionesPHP/Login.php" method="post" id="form">
        <h1>Iniciar sesion</h1>
        <div class="form">


            <div class="Grupo">
                <input type="text" name="userEmail" id="userEmail" required>
                <span class="barra"></span>
                <label for="userEmail">Usuario</label>
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
            <button type="submit" class="Enviar">Enviar</button>
            <a href="ForgotPassword.php" class="forgot">¿Olvidaste tu contraseña?</a>
        </div>
    </form>

    <div id="modalReset" class="modal-overlay" style="display:none;">
        <div class="modal">
            <h2>Correo enviado ✅</h2>
            <p>Te enviamos un enlace para restablecer tu contraseña.<br> Revisa tu bandeja de entrada.</p>
            <button id="closeModal">Cerrar</button>
        </div>
    </div>

    <div id="modalEmailFail" class="modal-overlay" style="display:none;">
        <div class="modal">
            <h2>Correo no encontrado ❌</h2>
            <p>El correo ingresado no está registrado.<br>Verifica e intenta nuevamente.</p>
            <button id="closeModalFail">Cerrar</button>
        </div>
    </div>

    <div id="modalPassUpdated" class="modal-overlay" style="display:none;">
        <div class="modal">
            <h2>Contraseña actualizada ✅</h2>
            <p>Tu contraseña se ha cambiado correctamente.<br> Ahora puedes iniciar sesión.</p>
            <button id="closeModalPassUpdated">Cerrar</button>
        </div>
    </div>

</body>

</html>