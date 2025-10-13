<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PanelDev</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <script src="../JS/CRUD.js" defer></script>
    <link rel="stylesheet" href="../CSS/CRUD.css">
</head>
<body>
    <header>
        <div class="left">
            <!-- Botón del menú -->
            <img class="Side" src="../Imagenes/Iconos/Sidebar.png" alt="Abrir menú" id="toggleSidebar">
        </div>

        <div class="center">
            <a href="Home.php" class="center">
                <img src="../Imagenes/IconoFS.png" alt="Logo FishStack" class="logo">
                <h1>FishStack</h1>
            </a>
            <span class="AP">Admin panel</span>
        </div>
    </header>

    <!-- SIDEBAR -->
    <nav class="sidebar closed" id="sidebar">
        <ul>
            <li class="active"><a href="#" data-section="usuarios">👤 Usuarios</a></li>
            <li><a href="#" data-section="pases">🎟️ Pases</a></li>
            <li><a href="#" data-section="registros">📋 Registros</a></li>
        </ul>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <main id="content">
        <h2>Bienvenido al Panel de Administración</h2>
        <p>Selecciona una sección en el menú lateral.</p>
    </main>
</body>
</html>
