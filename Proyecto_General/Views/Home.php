<!DOCTYPE html>
<html lang="en">
<head>
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <script src="../JS/Home.js" defer></script>
    <link rel="stylesheet" href="../CSS/Home.css">
    </head>
</head>
    <body>  
    <?php  include ("header.php");  ?>
        <div class="boxes">

            <div class="Ad1">
            <a href="" target="_blank"><img class="decay" src="" alt="" id="Ad1"></a>
            </div>

            <div class="Seleccion">
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
            <a href="" target="_blank"><img class="decay" src="" alt="" id="Ad5"></a>
            </div>   
        </div>

    <?php include("Footer.php") ?>
    </body>

</html>