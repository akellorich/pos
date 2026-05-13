<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Requisition Details </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Requisition Details"; require_once("topbar.php"); ?>
            <div class="container-fluid ">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card containergroup filteroptions">
                            <div class="card-header">
                                <h5>Step 1. - Setup</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div class="row" id="reqnodetails" style="display:none">
                                    <div class="col col-md-8">
                                        <div class="form-group">
                                            <label for="requisitionno"><span id="requisitionlabel">Requisition Number</span> </label>
                                            <input type="text" name="requisitionno" id="requisitionno" class="form-control form-control-sm">
                                        </div>
                                    </div>

                                    <div class="col">
                                        <div class="form-group form-check">
                                            <input type="checkbox" name="autogenerate" id="autogenerate" class="form-check-input">
                                            <label for="autogenerate" class="form-check-label">Generate</label>
                                        </div>
                                    </div>
                                </div>
                            
                                <div class="form-group">
                                    <label for="purchaserequisition">Purchase Requisition</label>
                                    <select name="purchaserequisition" id="purchaserequisition" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                        <option value="1">Yes</option>
                                        <option value="0">No</option>
                                    </select>
                                </div>
                                
                                <div class="form-group mt-2">
                                    <label for="refno">Reference Number</label>
                                    <input type="text" name="refno" id="refno" class="form-control form-control-sm">
                                </div>

                                <div class="form-group" id="supplierfields" style="display:none">
                                    <label for="supplier"><span id="supplierlabel">Supplier</span></label>
                                    <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="department">Department</label>
                                    <select name="department" id="department" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="requisitionnarration">Narration</label>
                                    <textarea type="text" name="requisitionnarration" id="requisitionnarration" class="form-control form-control-sm"></textarea>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="col"id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 2. - Select Requisition Items</h5>
                            </div>

                            <div class="card-body card-body-list">
                                <div id="requisitionerrors"></div>
                                <input type="hidden" name="id" value="0" id="id">
                                <div class="row">
                                    <div class="col col-md-4">
                                        <div class="from-group">
                                            <label for="item">Item Name</label>
                                            <input type="text" name="itemname" id="itemname" class="form-control form-control-sm" data-id="0" data-uom="" data-unitprice="" data-itemcode="">
                                            <div id="searchmaterials"></div>
                                        </div>
                                    </div>

                                    <div class="col col-md-3">
                                        <div class="form-group">
                                            <label for="quantity">Quantity</label>
                                            <input type="number" name="quantity" id="quantity" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                    
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="narration">Narration</label>
                                           
                                            <div class="input-group">
                                                <input type="text" name="narration" id="narration" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button class="btn btn-secondary btn-sm d-block" id="additem"><i class="fal fa-plus-circle fa-lg fa-fw"></i> </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                                <div class="requisitionmateriallist ">
                                    <table class="table table-sm table-striped" id="materialslist">
                                        <thead>
                                            <th>#</th>
                                            <th>Item Code</th>
                                            <th>Item Name</th>
                                            <th>Narration</th>
                                            <th>Unit</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                            <th>&nbsp;</th><!-- Edit -->
                                            <th>&nbsp;</th><!-- Delete -->
                                            <th>&nbsp;</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                
                                <div class="row">
                                    <div class="col col-md-9 mt-2">
                                        <button class="btn btn-sm btn-success mt-2" id="saverequisition"><i class="fal fa-save fa-lg fa-fw"></i> Save Changes</button>
                                        <button class="btn btn-sm btn-outline-danger mt-2" id="clearfields"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> Clear Fields</button>
                                    </div>
                                    <div  class=" col alert alert-warning mt-2 mr-2 font-weight-bold">
                                        <span>Total:</span><span id="total" class="text-right ml-2">0.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div class="modal" tabindex="-1" role="dialog" id="activitymaterialsummary">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Activity Material Summary</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row ml-1 mr-1 text-white text-center activitymaterialsummary">
                        <div class="approved bg-success col">
                            <i class="fas fa-check-circle fa-2x fa-fw mt-1"></i>
                            <br><small>Approved</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="issued bg-secondary col  text-center">
                            <i class="fas fa-people-carry  fa-2x fa-fw mt-1"></i> 
                            <br><small>Issued</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="committed bg-primary col text-center">
                            <i class="fas fa-handshake fa-2x fa-fw mt-1"></i> 
                            <br><small>Committed</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="available bg-danger col text-center">
                            <i class="fas fa-receipt fa-2x fa-fw mt-1"></i>
                            <br><small>Available</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="instock bg-dark col text-center">
                            <i class="fas fa-receipt fa-2x fa-fw mt-1"></i>
                            <br><small>In-stock</small>
                            <p class='lead'>0.00</p>
                        </div>

                    </div>
                   
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/requisitiondetails.js"></script>
</html>
