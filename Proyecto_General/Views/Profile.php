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
    <?php  include ("header.php");  ?>
    <div class="box">

        <div class="Profile">

            

            <div class="content1">

            <div class="ProfileImg">
                <img class="ImagenP" src="../Imagenes/PLACEHOLDER.png" alt="">
                <p>Foto de pefil</p> 
                <button>Cambiar Imagen</button>
            </div>

            <div class="info">
                <div><p>Nombre :</p><span id="nombre"></span></div>
                <div><p>Genero :</p><span id="genero"></span></div>
                <div><p>Telefono :</p><span id="telefono"></span></div>
                <div><p>Edad :</p><span id="edad"></span></div>
            </div>

            <button class="ButtonB" id="ChangeInfo">Cambiar Datos?</button>

            </div>

            <div class="content2">
                <div class="Impinfo">
                    <div><p>Usuario :</p><span id="usuario"></span></div>
                    <div><p>Fecha de registro :</p><span id="fecha"></span></div>
                    <div><p>Correo :</p><span id="email"></span></div>
                    <div><p>contraseña : *******</p></div>
                </div>
            <button class="ButtonC" id="ChangePass">Cambiar contraseña?</button>
            </div> 

        </div>

            <div class="AD"> 
            <img src="../Imagenes/Ads/SusAd.png" alt="">
            </div>

    </div>
</body>
</html>