<?php
    $bs_servidor = "localhost";
    $bs_usuario = "root";
    $bs_clave = "";
    $bs_nombre = "usuarios_fs";

    try{
        $conn = mysqli_connect($bs_servidor, $bs_usuario, $bs_pass,$bs_nombre);
    }

    catch(mysqli_sql_exception){
            echo "Actualmente la base de datos esta apagada o hay datos faltantes";
    }
?>
