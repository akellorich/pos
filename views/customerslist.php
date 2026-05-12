<html>
<head>
    <title>Customers' List</title>
    <?php require_once("header.txt") ?>
<head>
<body>
    <?php include_once("navigation.txt") ?>
    <div class="container-fluid">
        <p class="lead text-center mt-3">Customers In The System</p>
      
        <table class="table table table-striped table-sm" id="customertable">
            <thead clas="thead-light">
                <th>Category</th>
                <th>Customer Name</th>
                <th>Physical Address</th>
                <th>Postal Address</th>
                <th>Mobile</th>
                <th>Email</th>
                <th>Date Added</th>
                <th>Added By</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
            </thead>
            <tbody id="customerlist"></tbody>
            <tfoot></tfoot>
        </table>
        <div class="col-md-12 text-center">
        <ul class="pagination pagination-lg pager" id="myPager"></ul>
        <input type="button" id="addcustomer" name="addcustomer" Value="Add Customer" class="btn btn-success">
        <input type="button" id="goback" name="goback" Value="Main Menu" class="btn btn-primary">
    </div>  
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/customerslist.js"></script>
</html>