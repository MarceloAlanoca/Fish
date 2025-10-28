<?php
// ===========================================================
// === SIMULAR COMPRA (modo sin Mercado Pago) =================
// ===========================================================

session_start();
include("../../Includes/Connect.php");

// --- VERIFICAR SESIÓN ---
if (!isset($_SESSION['id_usuario'])) {
    // No hay sesión iniciada, redirigir al login
    header("Location: ../../Views/Login.php?error=login_required");
    exit;
}

$usuarioID = intval($_SESSION['id_usuario']); // guardamos por claridad

// --- VERIFICAR PARÁMETRO ---
if (!isset($_GET['pase_id'])) {
    die("No se especificó un pase.");
}

$paseID = intval($_GET['pase_id']);

// --- BUSCAR EL PASE ---
$query = "SELECT Nombre, Precio FROM pases WHERE ID = $paseID";
$result = mysqli_query($conexion, $query);
$pase = mysqli_fetch_assoc($result);

if (!$pase) {
    die("Pase no encontrado.");
}

// --- GENERAR DATOS SIMULADOS ---
$payment_id = 'SIM-' . strtoupper(uniqid());
$status = 'approved';
$external_reference = $paseID;

// --- REDIRIGIR AL CONFIRM PAY ---
$url = "ConfirmPay.php?payment_id=" . urlencode($payment_id)
     . "&status=" . urlencode($status)
     . "&external_reference=" . urlencode($external_reference);

header("Location: " . $url);
exit;
