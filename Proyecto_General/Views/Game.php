<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Juego</title>
    <link rel="stylesheet" href="../CSS/Game.css">
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <script src="../JS/Game.js" defer> </script>
</head>
<body>
    <?php include("../FuncionesPHP/SessionCheck.php"); ?> 
    <?php include("Header.php"); ?>

    <div class="Game">
        <div class="Gameinfo">
            <div class="TextGame">
                <h1>¡Bienvenido a FishStack!</h1>
                <br>
                <h2>¿Cómo se juega?</h2>
                <p>
                    Tu objetivo es pescar con tu caña los diferentes peces que habitan en este mar.
                    ¡Descubrí qué tan buen pescador sos enfrentando los retos del océano!
                </p>

                <!-- Contenedor del juego -->
                <div class="GameFrame">
                    <iframe 
                        id="gameFrame"
                        src="../../Juegos_Prototipo/FishStack.html" 
                        width="1200" 
                        height="800" 
                        frameborder="0" 
                        allowfullscreen>
                    </iframe>

                    <!-- Barra negra inferior -->
                    <div class="GameBar">
                        <div class="GameBarCenter">
                            <img src="../Imagenes/IconWeb.jpg" alt="FishStack Logo" class="logobar">
                            <span class="game-title">FishStack</span>
                        </div>

                        <div class="GameBarRight">
                            <button id="fullscreenBtn" class="bar-btn" title="Pantalla completa">⛶</button>
                            <button id="soundBtn" class="bar-btn" title="Sonido">🔊</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php include("Footer.php"); ?>
</body>
</html>