<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock Transfer </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Stock Transfer</span>
            <div class="container-fluid containergroup">
                <!-- <p class="lead fornt-weight-bold text-center mt-3 font-weight-bold">Stock Movement Details</p> -->
                <div class="row mt-2">
                    <div class="col col-md-3">
                        <div class="card containergroup"> <!---->
                            <div class="card-header">
                                <h5>Step 1 - Select Source and Destination</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div class="form-group">
                                    <label for="source">Source:</label>
                                    <select name="source" id="source"  class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="sourceitem">Source Location:</label>
                                    <select name="sourceitem" id="sourceitem"  class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="destination">Destination:</label>
                                    <select name="destination" id="destination"  class="form-control form-control-sm"></select>
                                </div>
                                <div class="form-group">
                                    <label for="destinationitem">Destination Location:</label>
                                    <select name="destinationitem" id="destinationitem"  class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="issuedto">Issued To</label>
                                    <select name="issuedto" id="issuedto" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="storecontroller">Store Controller</label>
                                    <select name="storecontroller" id="storecontroller" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>
                                <button type="button" id="save" name="save" class="btn btn-success btn-sm mt-2"> <i class="fal fa-save fa-lg"></i> Save Transfer</button>
                                <button type="button" id="clear" name="clear"  class="btn btn-danger btn-sm mt-2"><i class="fal fa-hand-sparkles fa-lg"></i> Clear Form</button>
                            </div>
                        </div>  
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup"> <!---->
                            <div class="card-header">
                                <h5>Step 2 - Add items to transfer</h5>
                            </div>
                            <div class="card-body">
                                <div id="errors"></div>
                                <div class="row">
                                    <div class="col col-md-9">
                                        <div class="form-group">
                                            <label for="itemcode">Item Code:</label>
                                            <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm"> 
                                        </div>
                                        <div id="searchproducts"></div>
                                    </div>
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="overalltotal" class="text-right">Total:</label>
                                            <input type="text" name="overalltotal" id="overalltotal"  class="form-control form-control-sm lead font-weight-bold text-right" disabled value='0.00'> 
                                        </div>
                                        <!-- <p  class="alert alert-info total text-right  font-weight-bold">TOTAL: <span id="overalltotal">0.00</span></p> -->
                                    </div>
                                </div>

                                <!-- <div class="mb-3 mr-1 ml-2"> -->
                                    <div class="card-body-list-withheader">
                                            <table  id="transferreditems" name="transferreditems" class="table table-striped table-sm">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th>Item Code</th>
                                                    <th>Item Name</th>
                                                    <th>Quantity in Stock</th>
                                                    <th>Unit Price</th>
                                                    <th>Quantity Transferred</th>
                                                    <th>Serial #</th>
                                                    <th>Line Total</th>
                                                    <th>&nbsp;</th> <!--  -->
                                                </tr>
                                            </thead>
                                            <tbody id="transferreditemsdetails"></tbody>
                                        </table>
                                    </div>
                                    
                                <!-- </div> -->
                            </div>
                        </div> <!----> 
                    </div>
                </div>
            </div> 
        </div>
    </section>
    <!-- Add Serial numbers Modal -->
    <div class="modal" tabindex="-1" role="dialog" id="serialsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">Add Serial Numbers</h6>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div id="serialserrors"></div>
                <input type="hidden" name="serialitemid" value="" id="serialitemid">
                <div class="row">
                    <div class="col col-md-9">
                        <div class="form-group">
                            <label for="serialitemname" class="text-muted">Item Name:</label>
                            <input type="text" name="serialitemname" id="serialitemname" class="form-control form-control-sm" disabled>
                        </div>   
                    </div>

                    <div class="col">
                        <div class="form-group">
                            <label for="serialquantity" class="text-muted">Quantity:</label>
                            <input type="text" name="serialquantity" id="serialquantity" class="form-control form-control-sm" disabled>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col">
                        <label for="serialnumbers">Serial Number:</label>
                        <div class="input-group mb-3">                            
                            <select id="serialnumbers" class="form-control from-control-sm"  aria-describedby="basic-addon2"></select>
                            <div class="input-group-append">
                                <button class="btn btn-secondary btn-sm" type="button" id="saveserialnumbers"><i class="fas fa-plus-circle fa-lg fa-fw"></i></button>
                            </div>
                        </div>
                        
                    </div>
                </div>
                <table class="table table-sm table-striped" id="serialstable">
                    <thead>
                        <th>#</th>
                        <th>Serial Number</th>
                        <th>&nbsp;</th>
                    </thead>
                    <tbody></tbody>
                </table>
                <span id="serialstotals"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success btn-sm" id="updateserials"> <i class="fal fa-check-circle fa-lg fa-fw"></i> Done</button>
                <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fal fa-times-circle  fa-lg fa-fw"></i> Close</button>
            </div>

        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/transferitems.js"></script>
</html>