<?php
header('Content-Type: application/json; charset=utf-8');
include('../../Includes/Connect.php');

if (!isset($_GET['id_update']) || empty($_GET['id_update'])) {
    http_response_code(400);
    echo json_encode([]);
    exit;
}

$id_update = intval($_GET['id_update']);

$sql = "SELECT 
            c.Id_Comentario, 
            c.Id_Update, 
            c.Id_Usuario, 
            c.Comentario, 
            c.Fecha, 
            u.Usuario, 
            u.foto
        FROM Comentarios c
        LEFT JOIN Usuarios u ON c.Id_Usuario = u.ID
        WHERE c.Id_Update = ?
        ORDER BY c.Fecha DESC";

if ($stmt = $conexion->prepare($sql)) {
    $stmt->bind_param("i", $id_update);
    $stmt->execute();
    $res = $stmt->get_result();
    $rows = $res->fetch_all(MYSQLI_ASSOC);
    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
    $stmt->close();
} else {
    http_response_code(500);
    echo json_encode(["error" => "Error al preparar la consulta"]);
}
?>
