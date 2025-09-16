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
            <img class="decay" src="../Imagenes/Ads/SusAd.png" alt="">
            </div>

            <div class="Seleccion">
                    <button id="btnTienda">Tienda</button>
                    <button id="btnRegistros">Registros</button>
                

                <div id="modalTienda" class="modal">
                    <div class="modal-content">
                        <span class="close" data-close="modalTienda">&times;</span>
                        <h2>Tienda</h2>
                        <p>Aquí va el contenido de la Tienda...</p>
                    </div>
                </div>

                <div id="modalRegistros" class="modal">
                    <div class="modal-content">
                        <span class="close" data-close="modalRegistros">&times;</span>
                        <h2>Registros</h2>
                        <p>Aquí va el contenido de los registros...</p>
                    </div>
                </div>
            </div>

            <div class="Ad2">
            <img class="decay" src="../Imagenes/Ads/CGR_Corp.png" alt="">
            </div>   
        </div>

    <?php include("Footer.php") ?>
    </body>

</html>