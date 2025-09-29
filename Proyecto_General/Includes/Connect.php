<?php 

    $Server = "localhost";
    $User = "root";
    $Pass = "";
    $DB = "fish";

    try{
        $conexion = mysqli_connect($Server, $User, $Pass, $DB);
    }
    catch(mysqli_sql_exception){
        echo "No te pudiste conectar a la BASEDEDATOS";
    }

?>