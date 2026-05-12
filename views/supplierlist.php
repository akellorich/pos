<html>
<head>
    <title>Suppliers List</title>
   <?php require_once("header.txt") ?>
<head>
<body>
    <?php require_once("navigation.txt") ?>
    <div class="container-fluid">       
            <p class="lead text-center mt-3">Suppliers In The System</p> 
            <div id="errors"></div>       
            <table class="table table-striped table-sm" id="suppliertable">
                <thead class="thead-light">
                    <th>#</th>
                    <th>Supplier Name</th>
                    <th>Physical Address</th>
                    <th>Postal Address</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>Date Added</th>
                    <th>Added By</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                </thead>

                <tbody id="supplierlist"></tbody>            
                <tfoot></tfoot>
            </table>
            <div class="col-md-12 text-center">
            <ul class="pagination pagination-lg pager" id="myPager"></ul>
            <input type="button" id="addsupplier" name="addsupplier" Value="Add Supplier" class="btn btn-success">
            <input type="button" id="goback" name="goback" Value="Main Menu" class="btn btn-primary"> 
    </div>
 
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/supplierlist.js"></script>
</html>