<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Crates </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Crates</span>
            <div class="loginform">
                <p class="lead text-center mt-3">Crate Addition</p>
                <div id="errors"></div>
                <div class="form-group">
                    <label for="quantity">Quantity:</label>
                    <input type="number" name="quantity" id="quantity" class="form-control form-control-sm">
                    <label for="unitprice">Unit Price</label>
                    <input type="number" name="unitprice" id="unitprice" class="form-control form-control-sm" disabled>
                    <label for="reference">Reference:</label>
                    <input type="text" name="reference" id="reference" class="form-control form-control-sm">
                    <label for="narration">Narration</label>
                    <textarea name="narration" id="narration"  class="form-control form-control-sm"></textarea>
                    <button id="save" class="btn btn-sm btn-success mt-2"><i class="fas fa-save fa-fw fa-lg"></i> Save Crates</button>
                </div>
            </div>
        </div>
    </section>
    
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/addcrates.js"></script>
</html>