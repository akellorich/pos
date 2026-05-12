<html>
<head>
    <title>Fuel Requisitions</title>
    <?php require_once("header.txt") ?>
<head>
<body>
    <?php require_once("navigation.txt") ?>
    <div class="container-fluid">
        <!--         
            <p class="lead mt-2 text-center">Receive Ordered Items</p>
        -->
        <div class="row mt-2">
            <div class="col col-md-3">
                <div class="card containergroup">
                    <div class="card-header">
                        <h5>Filter Options</h5>
                    </div>
                    <div class="card-body card-body-list">
                        <div id="filtererrors"></div>
                        <div class="form-group">
                            <input type="checkbox" name="alldates" id="alldates"> All Dates
                        </div>

                        <div class="row">
                            <div class="col">
                                <div class="form-group">
                                    <label for="startdate">Start Date</label>
                                    <input type="text" name="startdate" id="startdate" class='form-control form-control-sm datepicker'>
                                </div>
                            </div>

                            <div class="col">
                                <div class="form-group">
                                    <label for="enddate">End Date</label>
                                    <input type="text" name="enddate" id="enddate" class='form-control form-control-sm datepicker'>
                                </div>
                            </div>  
                        </div>
                      
                        <div class="form-group">
                            <label for="filtersupplier">Supplier:</label>
                            <select name="filtersupplier" id="filtersupplier"  class="form-control form-control-sm"></select>
                        </div>

                        <div class="form-group">
                            <label for="filtercostcenter">Cost Center:</label>
                            <select id="filtercostcenter" name="filtercostcenter"  class="form-control form-control-sm"> </select>
                        </div>

                        <div class="form-group">
                            <label for="filtervehicle">Vehicle:</label>
                            <select name="filtervehicle" id="filtervehicle"  class="form-control form-control-sm"></select>
                        </div> 

                        <button id="filterrequisitions" name="filterrequisitions"  class="btn btn-secondary btn-sm mt-2"><i class="fas fa-save fa-lg fa-fw"></i> Apply Filter</button>
                        <button id="addrequisition" name="addrequisition"  class="btn btn-success btn-sm mt-2"><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add New </button>
                    </div>
                </div>
                <!-- <input type="button" id="gotomain" name="gotomain" value="Main Menu" class="btn btn-primary btn-sm w-100">-->
            </div> 

            <div class="col" id="receiptlist">
                <div class="card containergroup">
                    <div class="card-header">
                        <h5>Requisitions in the System</h5>
                    </div>
                    <div class="card-body card-body-list">
                        <div id="requisitiondetailerrors"></div>
                        <table  id="fuelrequisitions" name="fuelrequisitions" class="table table-striped table-sm">
                            <thead class="thead-light">
                                <tr>
                                    <th>#</th>
                                    <th>Ref #</th>
                                    <th>Requisition Date</th>
                                    <th>Supplier</th>
                                    <th>Cost Center</th>
                                    <th>Vehicle</th>
                                    <th>Qty Ordered</th>
                                    <th>Unit Price</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>&nbsp;</th><!-- Edit Approve Cancel Print -->
                                </tr>
                            </thead>
                            <tbody id="fuelrequisitionsdetails"></tbody>
                            <tfoot>     
                            </tfoot>
                        </table>
                    </div>
                </div>
                
            </div>
        </div>
    </div>

    <div class="modal" tabindex="-1" role="dialog" id="requisitiondetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">Requisition Details</h6>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div id="requisitionerrors"></div>
                <input type="hidden" id="requisitionid" value="0">
                <input type="hidden" name="requisitionid" value="" id="requisitionid">
                <div class="form-group">
                    <label for="supplier">Supplier</label>
                    <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                </div>
                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="costcenter">Cost Center</label>
                            <select name="costcenter" id="costcenter" class="form-control form-control-sm"></select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="vehicle">Vehicle</label>
                            <select name="vehicle" id="vehicle" class="form-control form-control-sm"></select>
                        </div>
                    </div>
                </div>
               
                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="quantity">Quantity</label>
                            <input type="number" name="quantity" id="quantity" class="form-control form-control-sm">
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="unitprice">Unit Price</label>
                            <input type="number" name="unitprice" id="unitprice" class="form-control form-control-sm">
                        </div>
                    </div>
                </div>
              
                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="odoreading">ODO Meter Reading</label>
                            <input type="number" name="odoreading" id="odoreading" class="form-control form-control-sm">
                        </div>
                        
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="total">Total</label>
                            <input type="number" name="total" id="total" class="form-control form-control-sm" disabled>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="requestedby">Requested By</label>
                            <select name="requestedby" id="requestedby" class="form-control form-control-sm"></select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="approvedby">For Approval By</label>
                            <select name="approvalby" id="approvalby" class="form-control form-control-sm"></select>
                        </div>
                    </div>
                </div>
               
                
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success btn-sm" id="saverequisition"> <i class="fas fa-save fa-lg fa-fw"></i> Save Serials</button>
                <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle  fa-lg fa-fw"></i> Close</button>
            </div>

        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/fuelrequisitions.js"></script>
</html>