<?php 

    $servidor = "localhost";
    $usuario = "root";
    $clave = "";
    $BaseDeDatos = "fish";
    $conexion = "";

    try{
        $conexion = mysqli_connect($servidor, $usuario, $clave, $BaseDeDatos);
    }
    catch(mysqli_sql_exception){
        echo "No te pudiste conectar a la BASEDEDATOS";
    }

?>