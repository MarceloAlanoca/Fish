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
    Bienvenido a la Tienda de FishStack, aquí encontrarás diferentes pases.
  </p>
</div>

<div class="Filtros">
  <select id="filtroTipo">
    <option value="">Todos los tipos</option>
    <option value="Progreso">Progreso</option>
    <option value="Cosmetico">Cosmetico</option>
    <option value="Evento">Evento</option>
  </select>

  <select id="filtroPrecio">
    <option value="">Sin ordenar precio</option>
    <option value="asc">Menor a mayor</option>
    <option value="desc">Mayor a menor</option>
  </select>
</div>

<section class="catalogo">
  <h2>Artículos disponibles</h2>
  <div class="catalogo-container" id="catalogo"></div>
</section>

<?php include("Footer.php"); ?>
</body>
</html>
