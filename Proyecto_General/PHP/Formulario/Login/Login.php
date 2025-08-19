<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="Login.css">
</head>
<body>
    <form action="Conexion_L/Buscar_L.php" method="post" id="form">
        <div class="form">
            <h1 class="hols">Hola, Bienvenido</h1>
            <br>
            <p class="hols">Ingrese sus datos</p>
            <div class="Grupo">
                <input type="text" name="nombre" required>
                <label for="">Nombre</label>
            </div>
            <div class="Grupo">
                <input type="password" name="password" id="password" required>
                <label for="">Contraseña</label>
            </div>
            <button>Enviar</button>
        </div>
    </form>
</body>
</html>