<html>
<head>
    <title>POS List</title>
   <?php require_once("header.txt") ?>
<head>
<body>
    <?php require_once("navigation.txt") ?>
    <div class="container-fluid loginform">
        <p class="lead text-center mt-3">Crate Inventory Settings</p>
        <div id="errors"></div>
        <div class="form-group">
            <label for="product">Product:</label>
            <select name="product" id="product" class="form-control form-control-sm"></select>
            <label for="customer">Supplier:</label>
            <select name="customer" id="supplier" class="form-control form-control-sm"></select>
            <label for="glaccount">Create Inventory Account:</label>
            <select name="glaccount" id="glaccount" class="form-control form-control-sm"></select>
            <label for="costcenter">Cost Center:</label>
            <select name="costcenter" id="costcenter" class="form-control form-control-sm"></select>
            <label for="paymentmethod">Refund Payment Method</label>
            <select name="paymentmethod" id="paymentmethod" class="form-control form-control-sm"></select>
            <label for="cashbookaccount">Refund From Account:</label>
            <select name="cashbookaccount" id="cashbookaccount" class="form-control form-control-sm"></select>
            <button id="save" class="btn btn-sm btn-success mt-2"><i class="fas fa-save fa-fw fa-lg"></i> Save Settings</button>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/crateinventorysettings.js"></script>
</html>