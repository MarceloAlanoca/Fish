<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro</title>
    <link rel="stylesheet" href="../CSS/Register.css">
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
</head>

<body>

    <form action="../FuncionesPHP/Register.php" method="post" id="form">
        <h1>Registro</h1>
        <div class="form">

            <div class="Grupo">
                <input type="text" name="name" required>
                <span class="barra"></span>
                <label>Nombre</label>
            </div>

            <div class="Grupo">
                <input type="text" name="username" required>
                <span class="barra"></span>
                <label>Nombre de visualización</label>
            </div>

            <div class="Grupo">
                <input type="email" name="email" required>
                <span class="barra"></span>
                <label>Correo electrónico</label>
            </div>

            <div class="Grupo">
                <input type="password" name="password" id="password" required>
                <span class="barra"></span>
                <label>Contraseña</label>
                <div class="show-container">
                    <input type="checkbox" id="showPassword" class="checkbox">
                    <span class="ShowPass">Mostrar Contraseña</span>
                </div>
            </div>

            <div class="Grupo">
                <input type="password" name="passwordConfirm" id="passwordConfirm" required>
                <span class="barra"></span>
                <label>Confirmar Contraseña</label>
            </div>

            <button type="button" id="togglePanel" class="OpcBtn">Datos opcionales +</button>
            <button type="submit" class="Enviar">Registrar</button>
        </div>
        <div id="optionalPanel" class="panel">
        <h2>Datos opcionales</h2>

        <div class="Grupo">
            <input type="number" name="edad" min="1" max="100">
            <span class="barra"></span>
            <label>Edad</label>
        </div>

        <div class="Grupo">
            <select name="genero">
                <option value="" selected disabled>Seleccione una opción</option>
                <option value="Hombre">Hombre</option>
                <option value="Mujer">Mujer</option>
                <option value="Otro">Otro</option>
            </select>
            <span class="barra"></span>
            <label style="top:-14px; font-size:12px;">Género</label>
        </div>


        <div class="Grupo">
            <input type="text" name="telefono">
            <span class="barra"></span>
            <label>Teléfono</label>
        </div>

        <button id="closePanel" class="CerrarOpc">Cerrar</button>
    </div>
    </form>
    <script src="../JS/Register.js"></script>
</body>

</html>