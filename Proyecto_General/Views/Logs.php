<!DOCTYPE html>
<html lang="es">

    <head>
    <meta charset="UTF-8">
    <title>Registros</title>
    <link rel="icon" type="image/png" href="../Imagenes/IconWeb.jpg">
    <script src="../JS/Logs.js" defer></script>
    <link rel="stylesheet" href="../CSS/Logs.css">
    </head>

    <body>
            <div class="registro" 
                data-titulo="Parche 1.2" 
                data-fecha="10/10/2025"
                data-img="https://placehold.co/1200x600/png"
                data-detalle="Se corrigieron errores en el sistema de pesca, se mejoró la animación del agua y se añadieron efectos visuales en la caña al capturar peces.">
                <h4>Parche 1.2 — 10/10/2025</h4>
                <p>Se corrigieron errores en el sistema de pesca y se mejoró la animación del agua.</p>
            </div>

        <!-- Modal -->
        <div id="bigModal" class="modal-overlay" role="dialog" aria-modal="true" aria-hidden="true">
            <div class="modal" role="document" aria-labelledby="modalTitle" tabindex="-1">
            <div class="modal-header">
                <div>
                <div id="modalTitle" class="modal-title">Título</div>
                <div id="modalDate" class="modal-date">Fecha</div>
                </div>
                <button class="modal-close" aria-label="Cerrar (Esc)">✕</button>
            </div>

            <img id="modalImage" class="presentacion-img" src="" alt="Imagen de presentación">

            <div class="modal-body">
                <div id="modalDetail" class="modal-text"></div>

                <!-- Comentarios -->
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
