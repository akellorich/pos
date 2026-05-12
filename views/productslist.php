<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Products </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <div class="home-content">
        <i class='bx bx-menu' ></i>
        <span class="text">Products</span>
        <div class="container-fluid">
            <p  class="lead text-center mt-2">Products In The System</p>
            <div id="errors"></div>
            <table class="table table-striped table-sm" id="productstable">
                <thead class="thead-light">
                    <th>#</th>
                    <th>Category Name</th>
                    <th>Item Code</th>
                    <th>Item Name</th>
                    <th>Buying Price</th>
                    <th>Retail Price</th>
                    <th>Wholesale Price</th>
                    <th>Date Added</th>
                    <th>Added By</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                </thead>

                <tbody id="productlist"></tbody>
                <tfoot></tfoot>
            </table>            
            <!-- <div class="col-md-12 text-center">
                <ul class="pagination pagination-lg pager" id="myPager"></ul>
            </div> -->
            <button id="addproduct" name="addproduct" class='btn btn-success btn-sm mb-3'><i class="fas fa-plus-circle fa-lg"></i> Add New Product</button>
            <!-- <button id="goback" name="goback" class='btn btn-primary btn-sm mb-3'><i class="fas fa-bars fa-lg"></i> Main Menu</button> -->
        </div>
    </div>
  </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/productlist.js"></script>
</html>