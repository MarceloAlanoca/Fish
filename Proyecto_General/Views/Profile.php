<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <link rel="stylesheet" href="../CSS/Profile.css">
    <script src="../JS/Profile.js" defer></script>
</head>

<body>
    <?php include("../FuncionesPHP/SessionCheck.php"); ?>
    <?php include("header.php");  ?>

    <div class="box">
        <div class="Profile">
            <div class="content1">
                <div class="ProfileImg">
                    <img class="ImagenP" src="" alt="Foto de perfil">
                    <p class="FP">Foto de perfil</p>
                    <input type="file" id="fileInput" accept="image/*" style="display: none;">
                    <button id="btnCambiarImagen">Cambiar Imagen</button>
                </div>
                <div class="info">
                    <div>
                        <p>Nombre :</p><span id="nombre"></span>
                    </div>
                    <div>
                        <p>Teléfono :</p><span id="telefono"></span>
                    </div>
                    <div>
                        <p>Edad :</p><span id="edad"></span>
                    </div>
                    <div>
                        <p>Género :</p><span id="genero"></span>
                    </div>
                </div>
                <button class="ButtonB" id="ChangeInfo">Cambiar Datos?</button>
            </div>
            <div class="content2">
                <div class="Impinfo">
                    <div>
                        <p>Usuario :</p><span id="usuario"></span>
                    </div>
                    <div>
                        <p>Fecha de registro :</p><span id="fecha"></span>
                    </div>
                    <div>
                        <p>Correo :</p><span id="email"></span>
                    </div>
                    <div>
                        <p>Contraseña : *******</p>
                    </div>
                </div>
                <button class="ButtonC" id="ChangePass">Cambiar contraseña?</button>
            </div>
        </div>

        <div class="AD">
            <a href="" target="_blank"><img class="decay" src="" alt="Anuncio" id="AdProfile"></a>
        </div>
    </div>

    <div class="box">
        <div class="UserData">
            <div class="column">
                <h2>Pases adquiridos</h2>
                <div id="userPasses" class="scrollable"></div>
            </div>

            <div class="column">
                <h2>Comentarios realizados</h2>
                <div id="userComments" class="scrollable"></div>
            </div>
        </div>

        <div class="AD">
            <a href="" target="_blank"><img class="decay" src="" alt="Anuncio" id="AdProfile2"></a>
        </div>
    </div>


    <div id="modalDatos" class="modal-overlay">
        <div class="modal">
            <h2>Editar Datos</h2>
            <form id="formDatos">
                <label>Nombre:</label>
                <input type="text" id="editNombre" name="Nombre" required><br>
                <label>Teléfono:</label>
                <input type="text" id="editTelefono" name="Telefono" required><br>
                <label>Edad:</label>
                <input type="number" id="editEdad" name="Edad" required><br>
                <label>Género:</label>
                <select id="editGenero" name="Genero" required>
                    <option value="">Seleccionar...</option>
                    <option value="Hombre">Hombre</option>
                    <option value="Mujer">Mujer</option>
                    <option value="Otro">Otro</option>
                </select><br>
                <div class="modal-buttons">
                    <button type="submit">Guardar</button>
                    <button type="button" id="cerrarModalDatos">Cancelar</button>
                </div>
            </form>
        </div>
    </div>

    <div id="modalPass" class="modal-overlay">
        <div class="modal">
            <h2>Cambiar contraseña</h2>
            <form id="formPass">
                <label>Contraseña actual:</label>
                <input type="password" id="oldPass" required><br>
                <label>Nueva contraseña:</label>
                <input type="password" id="newPass" required><br>
                <label>Confirmar nueva contraseña:</label>
                <input type="password" id="confirmPass" required><br>
                <div class="modal-buttons">
                    <button type="submit">Guardar</button>
                    <button type="button" id="cerrarModalPass">Cancelar</button>
                </div>
            </form>
        </div>
    </div>

    <?php include("Footer.php"); ?>
</body>

</html>