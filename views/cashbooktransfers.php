<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Cashbook Transfer </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Cashbook Transfer"; require_once("topbar.php"); ?>
            <div class='container-fluid '>
                <input type="hidden" name="id" id="id">
                <p class='lead text-center  mb-3'>Cashbook Funds Transfer</p>  
                <div id="errors" class="mt-1"></div>
                <div class="form-group">
                    <label for="sourceaccount">Source GL Account:</label>
                    <select id="sourceaccount" name="sourceaccount" class="form-control form-control-sm"></select>
                </div>
                <div class="form-group">
                    <label for="destinationaccount">Destination GL Account:</label>
                    <select id="destinationaccount" name="destinationaccount" class="form-control form-control-sm"></select>
                </div>
                <div class="form-group">
                    <label for="reference">Reference Number:</label>
                    <input type="text" id="reference" name="reference"  class="form-control form-control-sm">
                </div>
                <div class="form-group">
                    <label for="amount">Amount:</label>
                    <input type="number" id="amount" name="amount"  class="form-control form-control-sm">
                </div>
                <button type="button" id="transferfunds" name="transferfunds" class="btn btn-success btn-sm"><i class="fas fa-exchange-alt fa-fw fa-sm"></i> Transfer Funds</button>
            </div>
        </div>
        
    </section>
   
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/transferfunds.js"></script>
</html>