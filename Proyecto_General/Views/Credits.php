<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creditos</title>
    <link rel="stylesheet" href="../CSS/Credits.css">
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
</head>
<body>
    <?php  include ("header.php");  ?>
    <!-- Primera fila -->
    <div class="creditos-container">
        <div class="integrante" onclick="mostrarModal('modal1')">
            <img src="../Imagenes/Iconos/Thiago.jpg" alt="Thiago">
            <p class="nombrev">Thiago</p>
        </div>

        <div class="integrante" onclick="mostrarModal('modal2')">
            <img src="../Imagenes/Iconos/Pedro.jpg" alt="Pedro">
            <p class="nombrev">Pedro</p>
        </div>

        <div class="integrante" onclick="mostrarModal('modal3')">
            <img src="../Imagenes/Iconos/Marcelo.jpg" alt="Marcelo">
            <p class="nombrev">Marcelo</p>
        </div>

        <div class="integrante" onclick="mostrarModal('modal4')">
            <img src="../Imagenes/PLACEHOLDER.png" alt="Alejandra">
            <p class="nombrev">Alejandra</p>
        </div> 
    </div>

    <!-- Segunda fila -->
    <div class="creditos-container">
        <div class="integrante" onclick="mostrarModal('modal5')">
            <img src="../Imagenes/Iconos/Gael.jpg" alt="Gael">
            <p class="nombrev">Gael</p>
        </div>

        <div class="integrante" onclick="mostrarModal('modal6')">
            <img src="../Imagenes/Iconos/Navarro.jpg" alt="Navarro">
            <p class="nombrev">Lautaro</p>
        </div>
        <div class="integrante" onclick="mostrarModal('modal7')">
            <img src="../Imagenes/Iconos/John.jpg" alt="Cristian">
            <p class="nombrev">John</p>
        </div>
    </div>

    <!-- Modales -->
    <div id="modal1" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal('modal1')">&times;</span>
            <h2>Thiago</h2>
            <p>Codirector del proyecto</p>
            <p>Se encargó de la documentación y Trello,
                la mayoría de apartados front-end de la página fueron diseñados por él, incluyendo este.</p>
        </div>
    </div>

    <div id="modal2" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal('modal2')">&times;</span>
            <h2>Pedro</h2>
            <p>Bla bla bla</p>
        </div>
    </div>

    <div id="modal3" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal('modal3')">&times;</span>
            <h2>Marcelo</h2>
            <p>Bla bla bla</p>
        </div>
    </div>

    <div id="modal4" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal('modal4')">&times;</span>
            <h2>Alejandra</h2>
            <p>Bla bla bla</p>
        </div>
    </div>

    <div id="modal5" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal('modal5')">&times;</span>
            <h2>Gael</h2>
            <p>Art - Tester</p>
            <p>Se encargo de hacer la mayoria de peces del juego y probar las pagina web
                en busca de errores.
            </p>
        </div>
    </div>

    <div id="modal6" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal('modal6')">&times;</span>
            <h2>Lautaro</h2>
            <p>Bla bla bla</p>
        </div>
    </div>

    <div class="caja">
    <p>
    Como equipo estamos tomando este proyecto en modo de aprendizaje y diverision,
    haciendo cosas que nos gustan y aprendiendo diferentes cosa a base de la progresion
    de nuestras obra
    </p>
    <p class="r">Atte : Todo el equipo de FishStack</p>
    </div>
    <audio autoplay loop>
        <source src="../Songs/Nightlight.mp3" type="audio/mpeg">
        Tu navegador no soporta el audio.
    </audio>

    <script src="../JS/Credits.js"></script>

    <?php include ("Footer.php")?>
</body>
</html>
