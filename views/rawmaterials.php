<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Raw Materials</title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Raw Materials"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <div class="row mt-2">
                <!-- Filter Options -->
                <div class="col col-md-3">
                    <!-- <div class="card-body"> -->
                    <div class="row filters">
                        <div class="col">
                            <a href="#" id="addcustomer" class="btn btn-success btn-sm w-100 text-left"><i class="fas fa-user-plus fa-lg"></i>  Manage Categories</a>
                            <a href="#" id="filtercustomer" class="btn btn-secondary btn-sm w-100 mt-1 text-left" data-toggle="modal" data-target="#filtercustomers"><i class="fas fa-search-plus fa-lg"></i>  Add Item</a>
                            <!-- <a href="#" id="cancelfilter" class="btn btn-danger btn-sm w-100 mt-1 text-left"><i class="fas fa-search-minus fa-lg"></i>  Cancel Filters</a> -->
                            <a href="#" id="deletecustomer" class="btn btn-danger btn-sm w-100 mt-1 text-left"><i class="fas fa-user-times fa-lg"></i>  Delete Item</a>
                        </div>
                    </div>
                    <div class="row filterresults">
                        <div class="col">
                            <select name="materiallist" id="materiallist" multiple class="form-control form-control-sm list-big mt-2"></select>
                        </div>
                    </div>
                    
                </div>

                <!-- Details Section -->
                <div class="col" id="receiptlist">
                    <div class="containergroup card">
                        <div class="card-body">
                            <ul class="nav nav-tabs mt-1" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" data-toggle="tab" href="#info" role="tab">Item Details</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-toggle="tab" href="#additions" role="tab">Additions</a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link" data-toggle="tab" href="#utilization" role="tab">Utilization</a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link" data-toggle="tab" href="#notes" role="tab">Notes</a>
                                </li>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content mt-3">
                                <div class="tab-pane active" id="info" role="tabpanel">
                                    <div id="itemnotifications"></div>
                                    <input type="hidden" name="materialid" id="materialid" value="0">
                                    <div class="row">
                                        <!-- <div class="col"> -->
                                        <div class="col form-group">
                                            <label for="itemcategory">Category</label>
                                            <select name="itemcategory" id="itemcategory" class="form-control form-control-sm"></select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="generatecode">Generate Code</label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <div class="input-group-text">
                                                        <input type="checkbox" id="generatecode">
                                                    </div>
                                                </div>
                                                <input type="text" class="form-control form-control-sm" value="Yes">
                                            </div>
                                        </div>
                                        <!-- </div> -->
                                       <div class="col form-group">
                                            <label for="itemcode">Item Code</label>
                                            <input type="text" name="itemcode" id="itemcode" class="form-control form-control-sm">
                                       </div>
                                       <div class="col form-group">
                                            <label for="itemname">Item Name</label>
                                            <input type="text" name="itemname" id="itemname" class="form-control form-control-sm">
                                       </div>
                                    </div>

                                    <div class="row">
                                        <div class="col form-group">
                                            <label for="unitofmeasure">Unit of Measure</label>
                                            <select name="unitofmeasure" id="unitofmeasure" class="form-control form-control-sm"></select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="physicalproduct">Physical Product</label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <div class="input-group-text">
                                                        <input type="checkbox" id="physicalproduct">
                                                    </div>
                                                </div>
                                                <input type="text" class="form-control form-control-sm" value="Yes">
                                            </div>
                                        </div>
                                        <div class="col form-group">
                                            <label for="unitprice">Unit Price</label>
                                            <input type="number" name="unitprice" id="unitprice" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="unitsinstock">Units in Stock</label>
                                            <input type="number" name="unitsonstock" id="unitsinstock" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                    <div id="buttons">
                                        <button class="btn btn-sm btn-success" id="savematerial"><i class="fal fa-save fa-lg fa-fw"></i> Save Item</button>
                                        <button class="btn btn-sm btn-outline-secondary mr-2 ml-2" id="clearbutton"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> Clear Form</button>
                                        <button class="btn btn-sm btn-outline-danger"><i class="fal fa-trash-alt fa-lg fa-fw"></i> Delete Item</button>
                                    </div>

                                </div> 
                                <div class="tab-pane" id="additions" role="tabpanel">
                                    <h5>Additions</h5>
                                </div>
                                <div class="tab-pane" id="utilization" role="tabpanel">
                                    <h5>Utilizations</h5>
                                </div>
                                <div class="tab-pane" id="notes" role="tabpanel">
                                    <h5>Notes</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body> 
<!-- Add footer  -->
<?php require_once("footer.txt")?>
<script src="../js/rawmaterials.js"></script>
</html>