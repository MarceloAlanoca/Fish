<?php 

include('Connect.php');

$Usuario = $_POST['nombre'];
$Pass = $_POST['password'];

$Resultado = mysqli_query($conexion, "SELECT * FROM cliente WHERE Usuario = '$Usuario' and Contraseña = '$Pass'");
$r = mysqli_num_rows($Resultado);

if($r > 0 ){
    session_start();
    $_SESSION['cliente'] = $Usuario;
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