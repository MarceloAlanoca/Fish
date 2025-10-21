<?php
session_start();


$paginas_libres = ['Login.php', 'Register.php', 'PageInitial.php'];


$pagina_actual = basename($_SERVER['PHP_SELF']);

if (!in_array($pagina_actual, $paginas_libres) && !isset($_SESSION["id_usuario"])) {
    echo "
    <script>
        alert('Debes iniciar sesión para acceder a esta página.');
        window.location.href = '../Views/PrincipalPage.php';
    </script>";
    exit;
}
?>
