<html>
<head>
    <title>Category Details</title>
    <?php require_once("header.txt") ?>
<head>
<body>
    <?php include_once("navigation.txt") ?>
    <div class="container-fluid">        
        <p class="lead mb-2 text-center mt-3">
            Enter Category Name
        </p>
        <div id="errors"></div>
        <div class="form-group">
            <label for="categoryname">Category Name:</label>
            <input type="text" id="categoryname" name="categoryname" class="form-control">
        </div>

        <input type="hidden" id="id" name="id"  class="field-long" value="<?php 
            if(isset($_GET['id'])){
                echo $_GET['id'];
            }else{
                echo 0;
            }
        ?>">
        <input type="button" id="savecategory" name="savecategory" Value="Save Category" class="btn btn-success">
        <input type="button" id="backtolist" name="backtolist" Value="Back To List" class="btn btn-secondary">
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/categorydetails.js"></script>
</html>