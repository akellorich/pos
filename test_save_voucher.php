<?php
session_start();
$_SESSION['userid'] = 1;

require_once("models/payment.php");
$payment = new payment();

// Let's create a temporary detail record in temppaymentvoucherdetails first
// because spsavepaymentvoucher selects from it
$refno = "TEST_REF_123";
$itemcode = "ITEM001";
$description = "Test Item";
$quantity = 1;
$unitprice = 100.00;
$accountcharged = 1; // Assuming account 1 exists
$invoicenumber = "INV-001";

echo "1. Saving temp voucher details...\n";
$payment->savetemppaymentvoucherdetails($refno, $itemcode, $description, $quantity, $unitprice, $accountcharged, $invoicenumber);

// Now let's save the permanent voucher
$id = 0; // New voucher
$voucherdate = "04-Jun-2026";
$voucherno = "PV-TEST-123";
$pos = 1;
$supplier = 1;
$paymentmode = 1;
$cashbookaccount = 1;
$reference = "REF-TEST";
$generatevoucherno = 0; // Let's use our specified voucherno
$pettycash = 1;
$craterefund = 0;

echo "2. Saving permanent payment voucher...\n";
// Let's modify models/payment.php temporarily or print the SQL statement we are going to run
$sql = "CALL spsavepaymentvoucher({$payment->branchid},'{$refno}',{$id},'{$payment->mySQLDate($voucherdate)}','{$voucherno}',{$pos},{$supplier},{$paymentmode},{$cashbookaccount},'{$reference}',{$generatevoucherno},{$_SESSION['userid']},{$pettycash},{$craterefund})";
echo "Executing SQL: $sql\n";

$payment->savepaymentvoucher($refno, $id, $voucherdate, $voucherno, $pos, $supplier, $paymentmode, $cashbookaccount, $reference, $generatevoucherno, $pettycash, $craterefund);

echo "\n3. Checking the inserted voucher in database...\n";
$pdo = $payment->connect();
$stmt = $pdo->query("SELECT * FROM paymentvouchers WHERE voucherno = 'PV-TEST-123'");
$row = $stmt->fetch(PDO::FETCH_ASSOC);
print_r($row);

// Clean up
$pdo->exec("DELETE FROM paymentvoucherdetails WHERE voucherid = {$row['paymentvoucherid']}");
$pdo->exec("DELETE FROM paymentvouchers WHERE paymentvoucherid = {$row['paymentvoucherid']}");
echo "Cleaned up.\n";
?>
