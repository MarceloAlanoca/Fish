<?php
session_start();

// Páginas libres (que no requieren sesión)
$paginas_libres = ['Login.php', 'Register.php', 'PrincipalPage.php'];

// Detectar la página actual
$pagina_actual = basename($_SERVER['PHP_SELF']);

// Si no tiene sesión y no está en páginas libres
if (!in_array($pagina_actual, $paginas_libres) && !isset($_SESSION["id_usuario"])) {
    // Limpiamos el buffer de salida por si se imprimió algo antes
    ob_clean();

    // Mostramos un modal en pantalla
    echo '
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Acceso restringido</title>
        <style>
            * {
                box-sizing: border-box;
            }
            body {
                margin: 0;
                font-family: "Poppins", sans-serif;
                background-color: rgba(0, 0, 0, 0.85);
                background-image: url(../Imagenes/RestrictedZone.jpg);
                color: white;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .modal {
                background: #1e1e1e;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 0 20px rgba(0,0,0,0.6);
                text-align: center;
                max-width: 400px;
                width: 90%;
            }
            .modal h2 {
                color: #FFD700;
                margin-bottom: 15px;
            }
            .modal p {
                font-size: 16px;
                line-height: 1.4em;
                margin-bottom: 20px;
            }
            .modal button {
                background-color: #FFD700;
                color: #1e1e1e;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.3s ease;
            }
            .modal button:hover {
                background-color: #ffcc00;
                transform: scale(1.05);
            }
        </style>
    </head>
    <body>
        <div class="modal">
            <h2>Acceso restringido</h2>
            <p>Debes iniciar sesión para acceder a esta página.</p>
            <button onclick="redirigir()">Volver al inicio</button>
            <p>Seras redireccionado pronto...</p>
        </div>

        <script>
            function redirigir() {
                window.location.href = "../Views/PrincipalPage.php";
            }

            setTimeout(redirigir, 10000);
        </script>
    </body>
    </html>
    ';
    exit; // Detiene toda la ejecución posterior
}
?>
