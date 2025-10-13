<?php
header('Content-Type: application/json; charset=utf-8');
include('../../Includes/Connect.php');
session_start();

$id_update = isset($_POST['id_update']) ? intval($_POST['id_update']) : 0;
$comentario = isset($_POST['comentario']) ? trim($_POST['comentario']) : '';
$id_usuario = isset($_SESSION['id_usuario']) ? intval($_SESSION['id_usuario']) : 0;

if ($id_update <= 0 || $comentario === '') {
    http_response_code(400);
    echo json_encode(['error' => 'Datos incompletos.']);
    exit;
}

if ($id_usuario <= 0) {
    http_response_code(403);
    echo json_encode(['error' => 'Debes iniciar sesión para comentar.']);
    exit;
}

$insertSql = "INSERT INTO Comentarios (Id_Update, Id_Usuario, Comentario, Fecha) VALUES (?, ?, ?, NOW())";
if ($stmt = $conexion->prepare($insertSql)) {
    $stmt->bind_param("iis", $id_update, $id_usuario, $comentario);
    if ($stmt->execute()) {
        $stmt->close();

        // Devuelve comentarios actualizados
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


        if ($stmt2 = $conexion->prepare($sql)) {
            $stmt2->bind_param("i", $id_update);
            $stmt2->execute();
            $res = $stmt2->get_result();
            $rows = $res->fetch_all(MYSQLI_ASSOC);
            echo json_encode(['success' => true, 'comments' => $rows], JSON_UNESCAPED_UNICODE);
            $stmt2->close();
        } else {
            echo json_encode(['success' => true]);
        }
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'No se pudo guardar el comentario.']);
    }
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Error en la consulta.']);
}
?>
