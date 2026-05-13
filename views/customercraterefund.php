<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Crate Refund </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Crate Refund"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <p class="lead text-center mt-3">Crate Refund</p>
                <div id="errors"></div>
                <div class="form-group">
                    <label for="quantity">Quantity:</label>
                    <input type="number" name="quantity" id="quantity" class="form-control form-control-sm">
                    <label for="unitprice">Unit Price:</label>
                    <input type="number" name="unitprice" id="unitprice" class="form-control form-control-sm" disabled>
                    <label for="total">Amount Refundable:</label>
                    <input type="text" name="total" id="total" class="form-control form-control-sm" disabled>
                    <label for="reference">Purchasing Receipt Number:</label>
                    <input type="text" name="reference" id="reference" class="form-control form-control-sm">
                    <label for="paymentmode">Payment Mode:</label>
                    <select name="paymentmode" id="paymentmode" class="form-control form-control-sm"></select>
                    <label for="paymentaccount">Payment Account:</label>
                    <select name="paymentaccount" id="paymentaccount" class="form-control form-control-sm"></select>
                    <label for="paymentmodereference">Payment Method Reference:</label>
                    <input type="text" name="paymentmodereference" id="paymentmodereference" class="form-control form-control-sm">
                    <button id="save" class="btn btn-sm btn-success mt-2"><i class="fas fa-save fa-fw fa-lg"></i> Save Crates</button>
                </div>
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/customercraterefund.js"></script>
</html>