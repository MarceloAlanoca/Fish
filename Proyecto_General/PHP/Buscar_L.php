<?php 

include('../PHP/ConexionPHP/Connect.php');

$usuario = $_POST['nombre'];
$pass = $_POST['password'];

$Resultado = mysqli_query($conexion, "SELECT * FROM cliente WHERE Usuario = $usuario and Contraseña = $pass");
$r = mysqli_num_rows($Resultado);

if($r > 0 ){
    session_start();
    $_SESSION['cliente'] = $usuario;
    header("location:../Login.php");
}else{
    echo'
    
    <script 
    alert("El correi o la contraseña son invalidos");
    location.href = "../Login.php";
    </script>

    ';
}

mysqli_free_result($Resultado);
mysqli_close($conexion);
?>