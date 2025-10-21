<?php
header('Content-Type: application/json; charset=utf-8');
include('../../Includes/Connect.php');

error_reporting(E_ALL);
ini_set('display_errors', 1);

try {
    $sql = "SELECT Id_Update, Titulo, Tipo, Imagen, Descripcion_Corta, Texto_Detallado, Fecha_Publicacion 
            FROM Updates 
            ORDER BY Fecha_Publicacion DESC";

    $result = $conexion->query($sql);

    $updates = [];
    while ($row = $result->fetch_assoc()) {
    // Normaliza la ruta quitando los ./ o ../ iniciales
    $row['Imagen'] = preg_replace('/^(\.\/|\.\.\/)+/', '', $row['Imagen']);
    // Devuelve la ruta absoluta desde el proyecto principal
    $row['Imagen'] = '../' . $row['Imagen'];

    $updates[] = $row;
}



    echo json_encode($updates, JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    echo json_encode(["error" => $e->getMessage()]);
}
?>
