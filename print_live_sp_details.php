<?php
require_once("models/db.php");
$db = new db();
$pdo = $db->connect();
try {
    $stmt = $pdo->query("SHOW CREATE PROCEDURE spgetpaymentvoucherdetails");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    echo $row['Create Procedure'] . "\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
