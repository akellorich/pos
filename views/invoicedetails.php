<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Invoices </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Invoices"; require_once("topbar.php"); ?>
            <div class="container-fluid invoice">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card mt-2 mb-4 containergroup">
                            <div class="card-header">
                                <h5>Step 1 - Filter Options</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group">
                                    <label for="supplier">Supplier</label>
                                    <select name="supplier" id="supplier" class='form-control form-control-sm'></select>
                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="checkbox-group">
                                            <input type="checkbox"  autocomplete="off" name="alldates" id="alldates"> All Dates
                                        </div>
                                    </div>
                                </div>
                            
                                <div class="row">
                                    <div class="col">
                                        <label for="startdate">Start Date</label>
                                        <input type="text"  autocomplete="off" id="startdate" name="startdate" class='form-control form-control-sm'>
                                    </div>
                                    <div class="col">
                                        <label for="enddate">End Date</label>
                                        <input type="text"  autocomplete="off" id="enddate" name="enddate" class='form-control form-control-sm'>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col">
                                        <button class='btn btn-dark btn-sm mt-2' id="searchgrn"><i class="fas fa-search fa-fw fa-lg"></i> Filter GRNs</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card mt-2 mb-4 containergroup">
                            <div class="card-header">
                                <h5>Step 3 - Invoice Details</h5>
                            </div>
                            <div class="card-body ">
                                <div class="form-group">
                                    <label for="invoicetotal">Invoice Amount</label>
                                    <input type="text"  autocomplete="off" id="invoicetotal" disabled class='form-control form-control-sm text-right lead font-weight-bold' value="0.00">
                                </div>
                                <div class="form-group">
                                    <label for="invoiceno">Invoice #</label>
                                    <input type="text"  autocomplete="off" id="invoiceno" class='form-control form-control-sm'>
                                </div>
                                <div class="form-group">
                                    <label for="invoicedate">Invoice Date</label>
                                    <input type="text" autocomplete="off" id="invoicedate" name="invoicedate" class="form-control form-control-sm">
                                </div>

                                <div class="buttons">
                                    <button class='btn btn-success btn-sm' id="saveinvoice"><i class="fas fa-save fa-fw fa-lg"></i> Save Invoice</button>
                                    <button class='btn btn-danger btn-sm'><i class="fas fa-eraser fa-fw fa-lg"></i> Clear Form</button>
                                </div>
                            </div>
                        </div>
                    </div> 
                
                    <div class="col" id="receiptlist">
                        <div class="card mt-2 mb-2 containergroup">
                            <div class="card-header">
                                <h5>Step 2 - Uninvoiced Goods Received Notes</h5>
                            </div>
                            <div class='card-body card-body-list  scrollable-y'>
                                <div id="errors" class="errors"></div>
                            
                                <div>
                                    <table class="table table-striped table-sm">
                                        <thead>
                                            <th><input type='checkbox' id='allgrn'></th>
                                            <th>#</th>
                                            <th>GRN Number</th>
                                            <th>Delivery Note Number</th>
                                            <th>Date Received</th>
                                            <th>Amount</th>
                                        </thead>
                                        <tbody id="uninvoicedgrns" class="scrollable">
                                        </tbody>
                                    </table> 
                                </div>
                            
                            </div>
                        </div>
                    
                    </div>
                </div>

            </div>
        </div>
        
    </section>

</body>
<?php require_once("footer.txt") ?>
<script src="../js/invoicedetails.js"></script>
</html>