<!DOCTYPE html>
<html lang="en">
<head>
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link rel="stylesheet" href="../CSS/Home.css">
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <script src="../JS/Home.js" defer></script>
    </head>
</head>
    <body>  
    <?php  include ("header.php");  ?>
        <div class="boxes">

            <div class="Ad1">
            <a href="https://www.innersloth.com/games/among-us/" target="_blank"><img class="decay" src="../Imagenes/Ads/SusAd.png" alt="" id="Ad1"></a>
            <a href="" target="_blank"><img src="../Imagenes/PLACEHOLDER.png" alt="" class="decay" id="Ad2"></a>
            <a href="" target="_blank"><img src="../Imagenes/PLACEHOLDER.png" alt="" class="decay" id="Ad3"></a>
            <a href="" target="_blank"><img src="../Imagenes/PLACEHOLDER.png" alt="" class="decay" id="Ad4"></a>
            </div>

            <div class="Seleccion">
                    <a href="Shop.php" class="Shop"><span class="shine">Tienda</span></a>
                    <button id="btnRegistros">Registros</button>
                
                <div id="modalRegistros" class="modal">
                    <div class="modal-content">
                        <span class="close" data-close="modalRegistros">&times;</span>
                        <h2>Registros</h2>
                        <p>Aquí va el contenido de los registros...</p>
                    </div>
                </div>
            </div>

            <div class="Ad2">
            <a href="https://www.corpgovrisk.com/" target="_blank"><img class="decay" src="../Imagenes/Ads/CGR_Corp.png" alt="" id="Ad5"></a>
            <a href="" target="_blank"><img src="../Imagenes/PLACEHOLDER.png" alt="" class="decay" id="Ad6"></a>
            <a href="" target="_blank"><img src="../Imagenes/PLACEHOLDER.png" alt="" class="decay" id="Ad7"></a>
            <a href="" target="_blank"><img src="../Imagenes/PLACEHOLDER.png" alt="" class="decay" id="Ad8"></a>
            </div>   
        </div>

    <?php include("Footer.php") ?>
    </body>

</html>