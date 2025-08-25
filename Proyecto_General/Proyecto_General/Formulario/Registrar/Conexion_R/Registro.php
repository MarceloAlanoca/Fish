<?php
        include('Conexion.php'); 

        $nombre = filter_input(INPUT_POST, "nombre", FILTER_SANITIZE_SPECIAL_CHARS);
        $apellido = filter_input(INPUT_POST, "apellido", FILTER_SANITIZE_SPECIAL_CHARS);
        $contraseña = filter_input(INPUT_POST, "contraseña", FILTER_SANITIZE_SPECIAL_CHARS);
        $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_SPECIAL_CHARS);

        if(empty($nombre)){
                echo "Porfavor pon el nombre";
                }
        if(empty($apellido)){
                echo "Porfavor pon tu apellido";
        }
        if(empty($contraseña)){
                echo "Porfavor pon la contraseña";
        }
        if(empty($email)){
                echo "Porfavor pon la contraseña";
        }

        mysqli_close($conexion);
?>
