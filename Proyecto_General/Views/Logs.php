<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Registros</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <link rel="stylesheet" href="../CSS/Logs.css">
    <script src="../JS/Logs.js" defer></script>
</head>

<body>
    <main id="updatesContainer">
        <!-- JS cargará aquí las updates -->
    </main>

    <!-- Modal -->
    <div id="bigModal" class="modal-overlay" aria-hidden="true">
        <div class="modal">
            <div class="modal-header">
                <div>
                    <div id="modalTitle" class="modal-title"></div>
                    <div id="modalDate" class="modal-date"></div>
                </div>
                <button class="modal-close" aria-label="Cerrar">✕</button>
            </div>

            <div class="modal-body">
                <div class="modal-content-wrapper">
                    <img id="modalImage" class="presentacion-img" src="" alt="Imagen del parche">
                    <p id="modalDetail" class="modal-text"></p>
                </div>

                <hr>

                <div class="comments">
                    <h4>Comentarios</h4>
                    <div id="commentsList"></div>
                    <div class="comment-form">
                        <textarea id="newComment" placeholder="Escribe un comentario..."></textarea>
                        <button id="addCommentBtn">Agregar comentario</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

</html>