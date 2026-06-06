<?php
require_once('../models/user.php');
require_once('../models/mail.php');

header('Content-Type: application/json');

$username_or_email = isset($_POST['username_or_email']) ? trim($_POST['username_or_email']) : '';

if (empty($username_or_email)) {
    echo json_encode(["status" => "error", "message" => "Please enter your username or email address."]);
    exit;
}

$user = new User();
$pdo = $user->connect();

try {
    $stmt = $pdo->prepare("SELECT userid, email, username, firstname FROM user WHERE username = ? OR email = ?");
    $stmt->execute([$username_or_email, $username_or_email]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        echo json_encode(["status" => "error", "message" => "No account found with that username or email."]);
        exit;
    }

    $email = trim($row['email']);
    if (empty($email)) {
        echo json_encode(["status" => "error", "message" => "This account does not have a registered email address. Please contact an administrator."]);
        exit;
    }

    // Generate a 6-digit OTP
    $otp = mt_rand(100000, 999999);

    // Save to session
    $_SESSION['reset_otp'] = $otp;
    $_SESSION['reset_userid'] = $row['userid'];
    $_SESSION['reset_otp_time'] = time();

    // Instantiate and send email
    $mail = new mail();
    $subject = "Password Reset OTP - POS System";
    $message = "
        <div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 8px; max-width: 600px; margin: auto;'>
            <h2 style='color: #28a745; text-align: center;'>POS Password Reset</h2>
            <p>Hello <strong>" . htmlspecialchars($row['firstname']) . "</strong>,</p>
            <p>You have requested to reset your password. Please use the following One-Time Password (OTP) to complete the reset process:</p>
            <div style='background-color: #f8f9fa; border: 1px dashed #28a745; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #28a745; margin: 20px 0;'>
                " . $otp . "
            </div>
            <p style='color: #6c757d; font-size: 13px;'>Note: This OTP is valid for 15 minutes. If you did not request a password reset, please ignore this email.</p>
            <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;' />
            <p style='font-size: 12px; color: #999; text-align: center;'>POS System Administrator</p>
        </div>
    ";

    $mail_result = $mail->sendEmail($email, $subject, $message, "POS System Admin");

    if ($mail_result === "success") {
        echo json_encode([
            "status" => "success",
            "message" => "A password reset OTP has been successfully sent to your registered email: " . htmlspecialchars($email)
        ]);
    } else {
        // Fallback for offline SMTP / local networks
        echo json_encode([
            "status" => "success", 
            "message" => "An OTP has been successfully generated! (Note: Email delivery failed due to: " . htmlspecialchars($mail_result) . ". For local testing/demonstration, your OTP is: " . $otp . ")",
            "otp" => $otp
        ]);
    }

} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => "An error occurred: " . $e->getMessage()]);
}
?>
