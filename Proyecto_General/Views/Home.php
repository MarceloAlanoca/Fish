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
        <?php include("../FuncionesPHP/SessionCheck.php"); ?> 
        <?php  include ("header.php");  ?>
    
            <div class="boxes">
                <div class="Ad1">
                <a href="" target="_blank"><img class="decay" src="" alt="" id="Ad1"></a>
                </div>

                <div class="Seleccion">
                    <button id="btnRegistros">Registros</button>
                    <a href="Game.php">
                        <button>PESCAR</button>
                    </a>
                </div>

                <div class="Ad2">
                <a href="" target="_blank"><img class="decay" src="" alt="" id="Ad5"></a>
                </div>   
            </div>

            <section class="modal" id="modalRegistros">
                <div class="modal-container">
                    <h2 class="modal-title">Actualizaciones de FishStack</h2>
    <!-- IFRAME para mostrar el contenido de otra sección o página -->
                <iframe
                    src="Logs.php"
                    class="modal-iframe"
                    title="Registros de FishStack"
                    frameborder="0"
                ></iframe>

                    <a href="#" class="modal-close">Volver a Home</a>
                </div>
            </section>

        <?php include("Footer.php") ?>
    </body>

</html>