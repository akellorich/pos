<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Customers </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Customers"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid">
                <p class='lead text-center mb-3 mt-3'>Please Provide POS Details</p>
                <input type="hidden" id="id" name="id" value="
                    <?php if(isset($_GET["id"])){
                        echo $_GET['id'] ;
                        }else{
                            echo 0;
                        } 
                    ?>"
                    />
                <div id="errors"></div>
                <div class="form-group">
                    <label for="posname">POS Name:</label>
                    <input type="text" id="posname" name="posname"  class="form-control">
                </div>

                <div class="row">
                    <div class="col" id="posproductcategories">  
                    </div>
                </div>

                <input type="button" id="savepos" name="savepos" Value="Save POS" class="btn btn-success btn-sm">
                <input type="button" id="gotolist" name="gotolist" Value="Back to List" class="btn btn-secondary btn-sm">
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/pointofsaledetails.js"></script>
</html>
