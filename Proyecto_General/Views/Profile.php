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
    <?php  include ("header.php");  ?>
    <div class="box">

        <div class="Profile">

            

            <div class="content1">

            <div class="ProfileImg">
            <img class="ImagenP" src="" alt="Foto de perfil">
                <p>Foto de pefil</p> 
                <input type="file" id="fileInput" accept="image/*" style="display: none;">
                <button id="btnCambiarImagen">Cambiar Imagen</button>
            </div>

            <div class="info">
                <div><p>Nombre :</p><span id="nombre"></span><input class="inputrow" type="text" id="editNombre" style="display:none;"></div>
                <div><p>Telefono :</p><span id="telefono"></span><input class="inputrow" type="text" id="editTelefono" style="display:none;"></div>
                <div><p>Edad :</p><span id="edad"></span><input class="inputrow" type="number" id="editEdad" style="display:none;"></div>
                <div><p>Genero :</p><span id="genero"></span><input class="inputrow" type="text" id="editGenero" style="display:none;"></div>
            </div>

            <button class="ButtonB" id="ChangeInfo">Cambiar Datos?</button>
            <button class="ButtonB" id="SaveInfo" style="display:none;">Guardar Cambios</button>
            </div>

            <div class="content2">
                <div class="Impinfo">
                    <div><p>Usuario :</p><span id="usuario"></span></div>
                    <div><p>Fecha de registro :</p><span id="fecha"></span></div>
                    <div><p>Correo :</p><span id="email"></span></div>
                    <div><p>contraseña : *******</p></div>
                </div>
            <button class="ButtonC" id="ChangePass">Cambiar contraseña?</button>

                <div id="passwordForm" style="display:none; margin-top:10px;">
                    <input class="inputrow" type="password" id="oldPass" placeholder="Contraseña actual"><br>
                    <input class="inputrow" type="password" id="newPass" placeholder="Nueva contraseña"><br>
                    <input class="inputrow" type="password" id="confirmPass" placeholder="Confirmar nueva contraseña"><br>
                    <button id="SavePass">Guardar</button>
                    
                </div>
            </div> 

        </div>

            <div class="AD"> 
            <img src="../Imagenes/Ads/SusAd.png" alt="">
            </div>

    </div>
</body>
</html>