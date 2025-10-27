<?php
include("../Includes/Connect.php");

if (!isset($_GET['token'])) {
  die("Token no válido");
}

$token = mysqli_real_escape_string($conexion, $_GET['token']);
$q = "SELECT ID FROM usuarios WHERE reset_token='$token' AND reset_expire > NOW() LIMIT 1";
$r = mysqli_query($conexion, $q);

if (!$r || mysqli_num_rows($r) === 0) {
  die("El enlace ha expirado o no es válido.");
}
?>
