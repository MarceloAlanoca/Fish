<?php
include("../../Includes/Connect.php");

require __DIR__ . '/PHPMailer/PHPMailer.php';
require __DIR__ . '/PHPMailer/SMTP.php';
require __DIR__ . '/PHPMailer/Exception.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

if (isset($_POST['email'])) {
    $email = mysqli_real_escape_string($conexion, $_POST['email']);

    $check = mysqli_query($conexion, "SELECT * FROM usuarios WHERE Email='$email' LIMIT 1");

    if (mysqli_num_rows($check) > 0) {

        $token = bin2hex(random_bytes(32));
        $expire = date("Y-m-d H:i:s", strtotime("+1 hour"));

        mysqli_query($conexion, "UPDATE usuarios SET reset_token='$token', reset_expire='$expire' WHERE Email='$email'");

        $link = "http://localhost/Fish/Proyecto_General/Views/ResetPassword.php?token=$token";


        $mail = new PHPMailer(true);

        try {
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;

            $mail->Username = 'fishstack.soporte@gmail.com';
            $mail->Password = 'neja hdjv kpww xhne';


            $mail->SMTPSecure = 'tls';
            $mail->Port = 587;

            $mail->setFrom('fishstack.soporte@gmail.com', 'FishStack - Soporte');
            $mail->addAddress($email);

            $mail->isHTML(true);
            $mail->Subject = 'Restablecer tu Password - FishStack';
            $mail->Body = '
                <div style="font-family: Arial, sans-serif; background: #e8f6ff; padding: 25px; border-radius: 12px; max-width: 500px; margin: auto; border: 1px solid #bcdff5;">
                    
                    <h2 style="color: #0077c8; text-align:center; margin-bottom: 12px;">Restablecer contraseña</h2>

                    <p style="color: #333; font-size: 15px; text-align:center; margin: 0 0 18px;">
                        Recibimos una solicitud para restablecer tu contraseña.<br>
                        Si fuiste vos, podés continuar con el siguiente botón:
                    </p>

                    <div style="text-align:center; margin: 22px 0;">
                        <a href="' . $link . '" 
                        style="background: #0099ff; color: white; padding: 12px 30px; font-size: 16px; border-radius: 30px; text-decoration:none; box-shadow: 0 0 10px rgba(0,153,255,0.4);">
                            Restablecer contraseña
                        </a>
                    </div>

                    <p style="color: #444; font-size: 13px; text-align:center;">
                        Si no solicitaste esto, simplemente ignorá este mensaje.<br>
                        El enlace es válido por <strong>1 hora</strong>.
                    </p>

                    <!-- Pie -->
                    <div style="text-align:center; margin-top: 25px; font-size: 12px; color:#7c8a96;">
                        FishStack © 2025 • Seguridad y soporte
                    </div>

                </div>
            ';

            $mail->send();

            if ($mail->send()) {
                echo "<script>window.location='../../Views/Login.php?status=reset_sended';</script>";
            } else {
                echo "<script>window.location='../../Views/Login.php?status=email_not_found';</script>";
            }
        } catch (Exception $e) {
            echo "Error al enviar correo: {$mail->ErrorInfo}";
        }
    } else {
        echo "<script>window.location='../../Views/Login.php?status=email_not_found';</script>";
    }
}
