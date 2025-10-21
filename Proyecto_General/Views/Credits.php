<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creditos</title>
    <link rel="stylesheet" href="../CSS/Credits.css">
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
        <script src="../JS/Credits.js" defer></script>
</head>

<body>
    <?php include("../FuncionesPHP/SessionCheck.php"); ?> 
    <?php include("header.php");  ?>
    <!-- Primera fila -->
    <div class="creditos-container">
        <div class="integrante">
            <img src="../Imagenes/Iconos/Thiago.jpg" alt="Thiago" class="imagen">
            <p class="nombrev">Thiago</p>

            <div class="mini-modal">
                <h3>Thiago</h3>
                <p>Colider - Backend</p>
                <p>Ayudo a la creacion de las diferentes secciones disponibles en la pagina
                    web, programando tanto Backend como FrontEnd. Ayudó a la documentacion y creacion
                    del Trello mejorando la cordinacion del equipo en FishStack, administrado cada sector para
                    mejorar el flujo de trabajo.
                    Apoyaba a sus compañeros de trabajo al preguntar su opinion y expresar sus aspectos,
                    mejorando y viendose como un integrante fiel a FishStack 
                </p>
            </div>
        </div>

        <div class="integrante">
            <img src="../Imagenes/Iconos/Pedro.jpg" alt="Pedro" class="imagen">
            <p class="nombrev">Pedro</p>

            <div class="mini-modal">
                <h3>Pedro</h3>
                <p>Designer - Tester</p>
                <p>Se encargo de la creacion de dibujo, fondos, iconos de la mayoria de la pagina, sin el
                    todo la FishStack seria un PLACEHOLDER.png. Apoyaba mucho a Navarro generando un ambiente
                    laboral amigable en FishStack, un dueto trabajador.
                    Aporto en el lado del testing de la pagina para comunicar errores a los desarrolladores
                    backend y probar nuevas funcionalidades de FishStack diciendo su opinion.
                </p>
            </div>
        </div>
        
        <div class="integrante">
            <img src="../Imagenes/Iconos/Marcelo.jpg" alt="Marcelo" class="imagen">
            <p class="nombrev">Marcelo</p>

            <div class="mini-modal">
                <h3>Marcelo</h3>
                <p>ScrumMaster - Backend</p>
                <p>Fue el que lidero el equipo y aplico la metologia Scrum de una manera exitosa, tomo decisiones
                    dificiles y fue la representacion de todo el equipo detras de FishStack.
                    Un pilar fundamental al momento de trabajar en la creacion del juego y programar gdscript
                    contando con el mayor conocimiento del equipo sobre Godot.
                    Apoyo en la creacion de diferentes sectores en la pagina mayormente en los que necesitaban
                    ayuda o correcion de errores. 
                </p>
            </div> 
        </div>

        <div class="integrante">
            <img src="../Imagenes/Iconos/Alejandra.jpg" alt="Alejandra" class="imagen">
            <p class="nombrev">Alejandra</p>

            <div class="mini-modal">
                <h3>Alejandra</h3>
                <p>FrontEnd</p>
                <p>La encargada de dar la primera impresion con la seccion de la pagina principal de FishStack
                    permitiendo invitar de manera amigable a todos los usuarios nuevos de nuestra pagina. Tambien
                    fue la responsable de crear la llamativa seccion de la tienda junto a su interfaz intuitiva, aunque 
                    no se comunicaba mucho con sus compañeros de trabajo demostro tener la esperanza en el proyecto y su equipo 
                </p>
            </div> 
        </div>
    </div>

    <!-- Segunda fila -->
    <div class="creditos-container">

        <div class="integrante">
            <img src="../Imagenes/Iconos/Gael.jpg" alt="Gael" class="imagen">
            <p class="nombrev">Gael</p>

            <div class="mini-modal">
                <h3>Gael</h3>
                <p>Designer - Tester</p>
                <p>Un gran aportador en la seccion de diseños de peces, decoraciones marinas, fondos, etc 
                    del videojuego FishStack, tambien se lo conoce como el quien daba mucha moral a su compañeros
                    y apoyandolos de cualquier forma que pudiera. Sin el, el videojuego tendra diseños demasiados simples 
                    y el equipo no tendria ese Carisma especial que el provee.
                </p>
            </div> 
        </div>

        <div class="integrante">
            <img src="../Imagenes/Iconos/Navarro.jpg" alt="Navarro" class="imagen">
            <p class="nombrev">Lautaro</p>

            <div class="mini-modal">
                <h3>Lautaro</h3>
                <p>Designer</p>
                <p>El Colaborador y socio mas apoyado por parte del equipo, hizo varios diseño como 
                    peces, cañas, cebos y multiple cosas mas requeridas para el juego, tambien aporto con la 
                    creacion de los diferente fondos que hay en la pagina web de FishStack. en las reuniones importantes 
                    el actuaba como un Soporte al Scrum Master asegurando que nuestra imagen quedara bien para el publico.
                    Tambien se lo reconocia por su amabilidad y compañerismo con sus compañeros del proyecto.
                </p>
            </div> 
        </div>

        <div class="integrante">
            <img src="../Imagenes/Iconos/John.jpg" alt="Cristian" class="imagen">
            <p class="nombrev">John</p>

            <div class="mini-modal">
                <h3>John</h3>
                <p>Designer - Composer - FrontEnd</p>
                <p>Uno que dio un gran aporte a FishStack en sus difentes aspectos, ayudo con 
                    creacion de dibujos del juego como la pagina web, armo las pistas sonoras originales de FishStack
                    creo la presentacion en github para aquellos que quisieran apoyar o le interesaran FishStack.
                    Un comodin que decidio colaborar y dar fuerzas a FishStack.
                </p>
            </div> 
        </div>
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
    <?php include("Footer.php") ?>
</body>

</html>