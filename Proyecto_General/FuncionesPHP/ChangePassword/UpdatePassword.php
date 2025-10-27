<?php
include("../../Includes/Connect.php");

if(isset($_POST['token']) && isset($_POST['password'])){
    $token = mysqli_real_escape_string($conexion, $_POST['token']);
    $pass = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $check = mysqli_query($conexion, "SELECT ID FROM usuarios WHERE reset_token='$token' AND reset_expire > NOW() LIMIT 1");

    if(mysqli_num_rows($check) == 1){

        mysqli_query($conexion, "UPDATE usuarios 
            SET Password='$pass', reset_token=NULL, reset_expire=NULL
            WHERE reset_token='$token'");

        echo "<script>window.location='../../Views/Login.php?status=password_updated';</script>";

    } else {
        echo "<script>alert('El enlace expiró, solicitá otro.'); window.location='../../Views/ForgotPassword.php';</script>";
    }
}
?>