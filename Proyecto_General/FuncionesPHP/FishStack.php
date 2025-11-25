<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Leer JSON
$json = file_get_contents("php://input");
$data = json_decode($json, true);

if (!$data) {
    echo json_encode(["status" => "error", "msg" => "JSON inválido"]);
    exit;
}

if (!isset($data["user_id"])) {
    echo json_encode(["status" => "error", "msg" => "Falta user_id"]);
    exit;
}

$user_id = $data["user_id"];
$doblones = $data["doblones"];

$amuletos = json_encode($data["amuletos"]);
$equipados = json_encode($data["equipados"]);
$canas = json_encode($data["canas"]);
$cana_equipada = $data["cana_equipada"];
$barcos = json_encode($data["barcos"]);
$barco_equipado = $data["barco_equipado"];
$skins = json_encode($data["skins"]);
$skin_equipada = $data["skin_equipada"];
$alineaciones = json_encode($data["alineaciones"]);
$alineacion_equipada = $data["alineacion_equipada"];

// Conexión XAMPP
$conn = new mysqli("localhost", "root", "", "fish");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "msg" => $conn->connect_error]);
    exit;
}

// Insertar o actualizar
$sql = "INSERT INTO gamedata (
    user_id, doblones, amuletos, equipados, canas, cana_equipada,
    barcos, barco_equipado, skins, skin_equipada, alineaciones, alineacion_equipada
) VALUES (
    '$user_id', '$doblones', '$amuletos', '$equipados', '$canas', '$cana_equipada',
    '$barcos', '$barco_equipado', '$skins', '$skin_equipada', '$alineaciones', '$alineacion_equipada'
)
ON DUPLICATE KEY UPDATE
    doblones = VALUES(doblones),
    amuletos = VALUES(amuletos),
    equipados = VALUES(equipados),
    canas = VALUES(canas),
    cana_equipada = VALUES(cana_equipada),
    barcos = VALUES(barcos),
    barco_equipado = VALUES(barco_equipado),
    skins = VALUES(skins),
    skin_equipada = VALUES(skin_equipada),
    alineaciones = VALUES(alineaciones),
    alineacion_equipada = VALUES(alineacion_equipada)
";

if ($conn->query($sql)) {
    echo json_encode(["status" => "ok"]);
} else {
    echo json_encode(["status" => "error", "msg" => $conn->error]);
}
