
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FishStack</title>
  <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
  <link rel="stylesheet" href="Proyecto_General/CSS/PAnimation.css">
  <script src="Proyecto_General/JS/PrincipalPage.js" defer></script>
</head>

<body>
  <?php include("Proyecto_General/FuncionesPHP/SessionCheck.php"); ?> 
  <div class="contenedor" id="animacion">
    <img src="Proyecto_General/Imagenes/Logo.png" alt="Logo" class="imagen">
    
    <div class="saludo">
      ¡Bienvenido al sitio web de FishStack!<br>
      Empieza ahora tu aventura pescando en el vasto mundo marino y descubre sus grandes maravillas.
    </div>

    <div class="name">Fish Stack</div>
    <div class="credito">By DevPlay Studio</div>

    <div class="botones">
      <?php if (isset($_SESSION["id_usuario"])): ?>
        <a href="Proyecto_General/Views/Home.php" class="boton-continuar" id="button">Continuar</a>
      <?php else: ?>
        <a href="Proyecto_General/Views/Login.php" class="boton-inicio" id="button">Iniciar sesión</a>
        <a href="Proyecto_General/Views/RegisterView.php" class="boton-registro" id="button">Registrarse</a>
      <?php endif; ?>
    </div>

    <div class="content"></div>
  </div>
</body>
</html>
