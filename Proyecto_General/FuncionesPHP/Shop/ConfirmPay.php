<?php
session_start();
include("../../Includes/Connect.php");

// Verificar sesión activa
if (!isset($_SESSION['id_usuario'])) {
    header("Location: ../../Views/Login.php?error=login_required");
    exit;
}

$usuarioID = intval($_SESSION['id_usuario']);

// Verificar parámetros simulados
$payment_id = isset($_GET['payment_id']) ? $_GET['payment_id'] : null;
$status = isset($_GET['status']) ? $_GET['status'] : null;
$paseID = isset($_GET['external_reference']) ? intval($_GET['external_reference']) : 0;

if (!$payment_id || !$status || !$paseID) {
    die("Error: Faltan datos del pago.");
}

// Solo registramos si fue aprobado
if ($status === 'approved') {
    // Obtener precio del pase
    $query = "SELECT Precio FROM pases WHERE ID = $paseID";
    $result = mysqli_query($conexion, $query);
    $pase = mysqli_fetch_assoc($result);

    if (!$pase) {
        die("Error: No se encontró el pase.");
    }

    $precio = floatval($pase['Precio']);

    // Registrar la compra en la tabla compras
    $stmt = $conexion->prepare("INSERT INTO compras (Usuario_ID, Pase_ID, Precio) VALUES (?, ?, ?)");
    $stmt->bind_param("iid", $usuarioID, $paseID, $precio);
    $ok = $stmt->execute();
    $stmt->close();

    if ($ok) {
        // Redirigir a la tienda con confirmación
        header("Location: ../../Views/Shop.php?compra=ok");
        exit;
    } else {
        die("Error al registrar la compra: " . $conexion->error);
    }
} else {
    header("Location: ../../Views/Shop.php?compra=no_aprobada");
    exit;
}
?>
