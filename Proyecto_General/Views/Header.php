<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../CSS/Header.css">
    <script src="../JS/Header.js" defer></script>
    <title>Header</title>
</head>

<body>
    <header>
        <div class="left-buttons">
            <a class="Link" href="../../PrincipalPage.php">Página principal</a>
            <button class="Link logout-btn">Cerrar sesión</button>
        </div>

        <div class="center-logo">
            <a href="Home.php" class="logo-container">
                <img src="../Imagenes/IconoFS.png" alt="Logo FishStack" class="logo">
                <h1>FishStack</h1>
            </a>
        </div>

        <nav class="right-links" id="navMenu">
            <a class="card admin-btn" href="CRUD.php">ADMIN</a>
            <a class="Link" href="Shop.php">Tienda</a>
            <a class="Link" href="Credits.php">Créditos</a>
            <a class="Link" href="Game.php">Juego</a>
            <a class="ProfileLink" href="../Views/Profile.php">
                <div class="ProfileDisplay">
                    <img src="" alt="Foto de perfil" class="ImgProfile">
                    <p class="NombreProfile"></p>
                </div>
            </a>
        </nav>

        <!-- Botón Hamburguesa -->
        <div class="menu-toggle" id="menuToggle">
            <div class="bar"></div>
            <div class="bar"></div>
            <div class="bar"></div>
        </div>
    </header>

    <!-- Modal de cierre de sesión -->
    <div id="logoutModal" class="logout-modal">
        <div class="logout-content">
            <h3>¿Seguro que quieres cerrar tu sesión actual?</h3>
            <div class="logout-buttons">
                <button id="confirmLogout" class="confirm">Sí, cerrar sesión</button>
                <button id="cancelLogout" class="cancel">Cancelar</button>
            </div>
        </div>
    </div>
</body>

</html>