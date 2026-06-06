<?php
require_once("../models/db.php");
class inspect extends db {
    public function showReconciliation() {
        try {
            $pdo = $this->connect();
            $stmt = $pdo->query("SELECT category, COUNT(*) as cnt FROM `stockreconciledbalance` GROUP BY category");
            echo "Reconciliation Counts by Category:\n";
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                echo " - " . $row['category'] . ": " . $row['cnt'] . "\n";
            }
            
            $stmt2 = $pdo->query("SELECT * FROM `stockreconciledbalance` ORDER BY stockreconciledbalanceid DESC LIMIT 5");
            echo "\nRecent Reconciliation Records:\n";
            while ($row2 = $stmt2->fetch(PDO::FETCH_ASSOC)) {
                print_r($row2);
            }
        } catch (Exception $e) {
            echo "Error: " . $e->getMessage() . "\n";
        }
    }
}
$ins = new inspect();
$ins->showReconciliation();
