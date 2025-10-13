<?php
include('../Includes/Connect.php');

$id_parche = $_POST['id_parche'];
$usuario = $_POST['usuario'];
$comentario = $_POST['comentario'];

mysqli_query($conn, "INSERT INTO comentarios (id_parche, usuario, comentario) VALUES ('$id_parche', '$usuario', '$comentario')");

$res = mysqli_query($conn, "SELECT * FROM comentarios WHERE id_parche = $id_parche ORDER BY fecha DESC");

while ($c = mysqli_fetch_assoc($res)) {
  echo "<div class='comentario'>
          <strong>".htmlspecialchars($c['usuario'])."</strong>
          <p>".htmlspecialchars($c['comentario'])."</p>
          <small>".$c['fecha']."</small>
        </div>";
}
?>
