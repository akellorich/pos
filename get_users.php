<?php
require_once("models/db.php");
$db = new db();
$pdo = $db->connect();

$stmt = $pdo->query("SELECT userid, username, status, isactive FROM user");
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
