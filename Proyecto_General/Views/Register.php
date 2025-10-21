<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro</title>
    <link rel="stylesheet" href="../CSS/Register.css">
    <link rel="icon" type="image/png" href="/Imagenes/IconWeb.jpg">
</head>
<body>
    <form action="../FuncionesPHP/Register.php" method="post" id="form">
        <h1>Registro</h1>
        <div class="form">

            <<div class="Grupo">
                <input type="text" name="name" id="name" required>
                <span class="barra"></span>
                <label for="name">Nombre</label>
            </div>


            <div class="Grupo">
                <input type="text" name="username" id="username" required>
                <span class="barra"></span>
                <label for="username">Nombre de visualizacion</label>
            </div>


            <div class="Grupo">
                <input type="email" name="email" id="email" required>
                <span class="barra"></span>
                <label for="email">Correo electrónico</label>
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


            <div class="Grupo">
                <input type="password" name="passwordConfirm" id="passwordConfirm" required>
                <span class="barra"></span>
                <label for="passwordConfirm">Confirmar Contraseña</label>
                <div class="show-container">
                    <input type="checkbox" id="showPasswordConfirm" class="checkbox">
                    <span class="ShowPass">Mostrar Contraseña</span>
                </div>
            </div>

            <div id="mensaje" style="color: rgb(226, 0, 0); margin-top: 10px;"></div>

            <button type="submit" id="subir" name="subir" class="Enviar">Enviar</button>
        </div>
    </form>

    <form action="../FuncionesPHP/Register.php" method="post" id="form">
        <h1>Datos opcionales</h1>
        <div class="form">
            <div class="Grupo">
                <input type="text" name="name" id="name" required>
                <span class="barra"></span>
                <label for="name">Edad</label>
            </div>

            <div class="Grupo">
                <input type="text" name="username" id="username" required>
                <span class="barra"></span>
                <label for="username">Genero</label>
            </div>

            <div class="Grupo">
                <input type="email" name="email" id="email" required>
                <span class="barra"></span>
                <label for="email">Telefono</label>
            </div>

            <div id="mensaje" style="color: rgb(226, 0, 0); margin-top: 10px;"></div>

            <button type="submit" id="subir" name="subir" class="Enviar">Enviar</button>
        </div>
    </form>


    <script src="../JS/Register.js" defer></script>
</body>
</html>

<?php
?>