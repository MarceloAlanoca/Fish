<!DOCTYPE html>
<html lang="es">
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
    Bienvenido a la Tienda de FishStack, aquí encontrarás diferentes pases que podras adquirir y se veran reflejados
    en el juego junto a ser permanentes en la cuenta.
  </p>
</div>

<div class="Filtros">
  <select id="filtroTipo" class="opcion">
    <option value="" class="opcion">Todos los tipos</option>
    <option value="Progreso" class="opcion">Progreso</option>
    <option value="Cosmetico" class="opcion">Cosmetico</option>
    <option value="Evento" class="opcion">Evento</option>
  </select>

  <select id="filtroPrecio" class="opcion">
    <option value="" class="opcion">Sin ordenar precio</option>
    <option value="asc" class="opcion">Menor a mayor</option>
    <option value="desc" class="opcion">Mayor a menor</option>
  </select>
</div>

<section class="catalogo">
  <h2>Artículos disponibles</h2>
  <div class="catalogo-container" id="catalogo"></div>
</section>

<?php include("Footer.php"); ?>
</body>
</html>
