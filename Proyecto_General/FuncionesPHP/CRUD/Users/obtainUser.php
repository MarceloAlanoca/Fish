
<?php
include("../../../Includes/Connect.php");

header("Content-Type: application/json; charset=utf-8");

if (!isset($_GET['id'])) {
    echo json_encode(["error" => "ID no especificado"]);
    exit;
}

$id = intval($_GET['id']);
$query = "SELECT * FROM usuarios WHERE ID = $id";
$result = mysqli_query($conexion, $query);

if ($user = mysqli_fetch_assoc($result)) {
    echo json_encode($user);
} else {
    echo json_encode(["error" => "Usuario no encontrado"]);
}
?>
