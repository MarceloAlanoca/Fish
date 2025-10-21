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
  <?php include("../FuncionesPHP/SessionCheck.php"); ?> 
  <?php include("header.php"); ?>

  <div class="Seleccion">
    <p class="Welcome">
      Bienvenido a la Tienda de FishTack, aquí encontrarás diferentes
      tipos de objetos y pases disponibles que hay.Los cuales te ayudaran a lo largo del juego para
      que sea mas facil.
    </p>
  </div>
   <section class="catalogo">
    <h2>Artículos disponibles</h2>
    <div class="catalogo-container">
      <div class="item">
        <img src="../Imagenes/CanaDorada.jpg" alt="Caña Dorada">
        <div class="item-info">
          <h3>Caña Dorada</h3>
          <p>Pesca con estilo y gana 25% más de monedas por venta.</p>
          <div class="rating">
            <input type="radio" id="star5" name="rating1" value="5"><label for="star5">★</label>
            <input type="radio" id="star4" name="rating1" value="4"><label for="star4">★</label>
            <input type="radio" id="star3" name="rating1" value="3"><label for="star3">★</label>
            <input type="radio" id="star2" name="rating1" value="2"><label for="star2">★</label>
            <input type="radio" id="star1" name="rating1" value="1"><label for="star1">★</label>
          </div>
          <button class="ButtonPur">Comprar</button>
        </div>
      </div>
      <div class="item">
        <img src="../Imagenes/SkinGeorge.jpg" alt="Skin Premium George">
        <div class="item-info">
          <h3>Skin Premium George</h3>
          <p>Una versión especial del protagonista, disponible solo en la tienda.</p>
          <div class="rating">
            <input type="radio" id="star6" name="rating2" value="5"><label for="star6">★</label>
            <input type="radio" id="star7" name="rating2" value="4"><label for="star7">★</label>
            <input type="radio" id="star8" name="rating2" value="3"><label for="star8">★</label>
            <input type="radio" id="star9" name="rating2" value="2"><label for="star9">★</label>
            <input type="radio" id="star10" name="rating2" value="1"><label for="star10">★</label>
          </div>
          <button class="ButtonPur">Comprar</button>
        </div>
      </div>

      <div class="item">
        <img src="../Imagenes/Amuleto.jpg" alt="Amuleto del vendedor">
        <div class="item-info">
          <h3>Amuleto del vendedor</h3>
          <p>Aumenta la velocidad de pique un 35% y mejora tus ventas.</p>
          <div class="rating">
            <input type="radio" id="star11" name="rating3" value="5"><label for="star11">★</label>
            <input type="radio" id="star12" name="rating3" value="4"><label for="star12">★</label>
            <input type="radio" id="star13" name="rating3" value="3"><label for="star13">★</label>
            <input type="radio" id="star14" name="rating3" value="2"><label for="star14">★</label>
            <input type="radio" id="star15" name="rating3" value="1"><label for="star15">★</label>
          </div>
          <button class="ButtonPur">Comprar</button>
        </div>
      </div>

      <div class="item">
        <img src="../Imagenes/Doblones.jpg" alt="Paquete de doblones">
        <div class="item-info">
          <h3>Paquete de doblones</h3>
          <p>20.000 doblones para invertir en mejoras y objetos raros.</p>
          <div class="rating">
            <input type="radio" id="star16" name="rating4" value="5"><label for="star16">★</label>
            <input type="radio" id="star17" name="rating4" value="4"><label for="star17">★</label>
            <input type="radio" id="star18" name="rating4" value="3"><label for="star18">★</label>
            <input type="radio" id="star19" name="rating4" value="2"><label for="star19">★</label>
            <input type="radio" id="star20" name="rating4" value="1"><label for="star20">★</label>
          </div>
          <button class="ButtonPur">Comprar</button>
        </div>
      </div>
  </section>

  <?php include("Footer.php"); ?>
</body>
</html>