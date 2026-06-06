<?php
require_once('../models/user.php');

header('Content-Type: application/json');

$otp = isset($_POST['otp']) ? trim($_POST['otp']) : '';
$new_password = isset($_POST['new_password']) ? $_POST['new_password'] : '';

if (empty($otp)) {
    echo json_encode(["status" => "error", "message" => "Please enter the OTP."]);
    exit;
}

if (empty($new_password)) {
    echo json_encode(["status" => "error", "message" => "Please enter your new password."]);
    exit;
}

if (strlen($new_password) < 4) {
    echo json_encode(["status" => "error", "message" => "Password must be at least 4 characters long."]);
    exit;
}

$user = new User();

// Verify OTP
if (!isset($_SESSION['reset_otp']) || $_SESSION['reset_otp'] != $otp) {
    echo json_encode(["status" => "error", "message" => "Invalid OTP. Please check and try again."]);
    exit;
}

// Check expiration (15 minutes = 900 seconds)
if ((time() - $_SESSION['reset_otp_time']) > 900) {
    echo json_encode(["status" => "error", "message" => "This OTP has expired. Please request a new one."]);
    exit;
}

try {
    $userid = $_SESSION['reset_userid'];
    $result = $user->resetUserPassword($userid, $new_password);

    if ($result === "success") {
        // Clear session keys
        unset($_SESSION['reset_otp']);
        unset($_SESSION['reset_userid']);
        unset($_SESSION['reset_otp_time']);

        echo json_encode(["status" => "success", "message" => "Your password has been successfully reset! You can now log in."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to reset password: " . $result]);
    }

} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => "An error occurred: " . $e->getMessage()]);
}
?>
