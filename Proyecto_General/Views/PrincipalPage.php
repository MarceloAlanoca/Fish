<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fish Stack</title>
  <link rel="stylesheet" href="../CSS/PAnimation.css">
</head>

<body>
  <div class="contenedor" id="animacion">
    <img src="../Imagenes/Logo.png" alt="Logo" class="imagen">
    <div class="saludo">¡Bienvenido!</div>
    <div class="name">Fish Stack</div>
        <div class="credito">By DevPlay studio</div>
    <div class="botones">
      <a href="Login.php" class="boton-inicio">Iniciar sesión</a>
      <a href="Register.php" class="boton-registro">Registrarse</a>
    </div>
  </div>
  <script>
    setTimeout(() => {
      document.getElementById("animacion").classList.add("final");
    }, 3000);
  </script>
</body>
</html>