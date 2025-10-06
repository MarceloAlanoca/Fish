<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tienda</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <link rel="stylesheet" href="../CSS/Shop.css">
    <script src="../JS/Shop.js" defer></script>
</head>
<body>
    <?php  include ("header.php");  ?>
    <div class="Seleccion">
        
        <p class="Entrada">
            Bienvenido a la seccion de la Tienda, aqui encontraras los diferentes
            pases disponibles que hay para el juego. Estos brindan mejoras comesticas o
            afectando el nivel de juego
        </p>

        <div class="Passbox">
            <div class="Pass">
            <img class="LogoPass" src="../Imagenes/PLACEHOLDER.png" alt="">
            <span class="PassTitle1">Pase de inicio</span>
            </div>
            
                <div class="Descripcion">
                    <p>Con este pase tendras diferentes beneficios en el juego temprano, y objetos exclusivos del mismo
                    es el prime pase de todo FishStack sientete orgulloso por apoyar el juego de esta manera </p>
                    <p>- Caña Dorada (Cualquier pez que pesque brinda un 25% mas de su valor de venta)</p>
                    <p>- Amuleto del vendedor (La velocidad de pique de la caña aumenta un 35% mas de lo normal)</p>
                    <p>- 20.000 Doblones</p>
                    <p>- Skin alterna "Premium George" del protagonista</p>
                </div>
            <button class="ButtonPur">Comprar</button>
        </div>
        
        <div class="Passbox">
            <div class="Pass">
                <img class="LogoPass" src="../Imagenes/PLACEHOLDER.png" alt="">
                <span class="PassTitle2">Pase del coleccionista</span>
            </div>
            <div class="Descripcion">
            <p>Un pase perfecto para la gente que le guste tener muchas skines </p>
            </div>
        </div>

        <div class="Passbox">
            <div class="Pass">
                <img class="LogoPass" src="../Imagenes/PLACEHOLDER.png" alt="">
                <span class="PassTitle3">Pase PRIME</span>
            </div>
            <div class="Descripcion">
            <p></p>
            </div>
        </div>
    </div>
    <?php include("Footer.php") ?>
</body>
</html>