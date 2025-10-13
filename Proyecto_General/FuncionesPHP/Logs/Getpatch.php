<?php
include('../Includes/Connect.php');

$id = $_GET['id'] ?? 0;
$query = "SELECT * FROM parches WHERE id = $id";
$res = mysqli_query($conn, $query);
$parche = mysqli_fetch_assoc($res);

$comentarios = mysqli_query($conn, "SELECT * FROM comentarios WHERE id_parche = $id ORDER BY fecha DESC");
?>

<div class="detalle-parche">
    <img src="<?= $parche['imagen'] ?>" alt="">
    <h2><?= $parche['titulo'] ?></h2>
    <p><?= $parche['descripcion_larga'] ?></p>

    <h3>Comentarios</h3>
    <form id="formComentario">
        <input type="hidden" name="id_parche" value="<?= $id ?>">
        <input type="text" name="usuario" placeholder="Tu nombre" required>
        <textarea name="comentario" placeholder="Escribe tu comentario..." required></textarea>
        <button type="submit">Publicar</button>
    </form>

    <div id="listaComentarios">
        <?php while ($c = mysqli_fetch_assoc($comentarios)): ?>
        <div class="comentario">
            <strong><?= htmlspecialchars($c['usuario']) ?></strong>
            <p><?= htmlspecialchars($c['comentario']) ?></p>
            <small><?= $c['fecha'] ?></small>
        </div>
        <?php endwhile; ?>
    </div>
    </div>

    <script>
    document.querySelector("#formComentario").addEventListener("submit", e => {
    e.preventDefault();
    const data = new FormData(e.target);

    fetch("../PHP/addComentario.php", {
        method: "POST",
        body: data
    })
    .then(res => res.text())
    .then(html => {
        document.querySelector("#listaComentarios").innerHTML = html;
        e.target.reset();
    });
});
</script>