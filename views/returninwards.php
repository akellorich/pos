<html>
<head>
    <title>Return Inwards</title>
   <?php require_once("header.txt") ?>
<head>
<body>
    <?php require_once("navigation.txt") ?>
    <div class="container-fluid">
       <div class="row">
           <div class="col col-md-3 mt-2">
               <div class="containergroup card">
                   <div class="card-header">
                        <h5>Filter Options</h5>
                   </div>
                   <div class="card-body card-body-list">
                       <div id="filtererrors"></div>
                        <div class="form-group">
                            <label for="startdate">Start Date:</label>
                            <input type="text" name="startdate" id="startdate" class="form-control form-control-sm datepicker">
                        </div>
                        <div class="form-group">
                            <label for="enddate">End Date:</label>
                            <input type="text" name="enddate" id="enddate" class="form-control form-control-sm datepicker">
                        </div>
                        <button class="btn btn-secondary btn-sm" id="filterreturniwards"><i class="fas fa-binoculars fa-lg fa-fw"></i> Filter Returns</button>
                        <button id="addreturninwards" class="btn btn-success btn-sm"><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add Return Inwards</button>
                    </div>
               </div> 
           </div>

           <div class="col mt-2" id="receiptlist">
                <div class="containergroup card">
                    <div class="card-header">
                        <h5>Existing Returns Inwards</h5>
                    </div>
                    <div class="card-body card-body-list scrollable-y">
                        <div id="resultserrors"></div>
                        <table class="table table-sm table-striped" id="existingreturnstable">
                            <thead>
                                <th>#</th>
                                <th>Date</th>
                                <th>Receipt #</th>
                                <th>Item Code</th>
                                <th>Name</th>
                                <th>Serial #</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Line Total</th>
                                <th>&nbsp;</th>
                            </thead>
                            <tbody></tbody>
                        </table>
                        
                    </div>
                </div>
           </div>
       </div>
    </div>
    <!-- Modal for adding return inwards details  -->
    <div class="modal alert-dismissable fade" id="returninwardsmodal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Return Inwards Details</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="returndetailserrors"></div>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control form-control-sm" placeholder="Enter Purchase Receipt Number" aria-label="Enter Purchase Receipt Number" aria-describedby="basic-addon2" id="receiptnumber" >
                        <div class="input-group-append">
                            <button class="btn btn-secondary btn-sm" type="button" id="getreceiptitems"><i class="fas fa-binoculars fa-lg fa fw"></i> Items</button>
                        </div>
                    </div>

                    <div class="input-group mb-3">
                        <select type="text" class="form-control form-control-sm" aria-describedby="basic-addon2" id="returnitem"></select>
                        <div class="input-group-append">
                            <button class="btn btn-secondary btn-sm" type="button" id="addreturnitemtolist"><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <textarea name="narration" id="narration" class="form-control form-control-sm" placeholder="Please enter return reason"></textarea>
                    </div>

                    <table class="table table-sm table-striped" id="returneditemslist">
                        <thead>
                            <th>#</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Serial#</th>
                            <th>Quantity</th>
                            <th>Unit_Price</th>
                            <th>Total</th>
                            <th>&nbsp;</th> <!-- Delete the entry -->
                            <th>&nbsp;</th>
                        </thead>
                        <tbody></tbody>
                        
                    </table>
                    <div class="row mt-2 mr-1">
                        <div class="col col-sm-7"></div>
                        <div class="col alert alert-warning font-weight-bold text-right">
                            Total: <span id="total">0.00</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savereturninward"> <i class="fas fa-save fa-lg fa-fw"></i> Save Return Inward</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle  fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal for collecting item returned inwards -->
    <div class="modal alert-dismissable fade" id="returncollectionmodal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Item Collection Details</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="returncollectionserrors"></div>
                    <input type="hidden" name="collectionid" id="collectionid">
                    <div class="form-group">
                        <label for="collectionrefno" class="text-muted">Reference Number</label>
                        <input type="text" name="collectionrefno" id="collectionrefeno" class="form-control form-control-sm" disabled>
                    </div>
                    <div class="form-group">
                        <label for="collectionitemcode" class="text-muted">Item Code</label>
                        <input type="text" name="collectionitem" id="colletionitemcode" class="form-control form-control-sm" disabled>
                    </div>
                    <div class="form-group">
                        <label for="collectionitemname" class="text-muted">Item Name</label>
                        <input type="text" name="collectionitemnanme" id="collectionitemname" class="form-control form-control-sm" disabled>
                    </div>
                    <div class="form-group">
                        <label for="collectionserialno" class="text-muted">Serial No</label>
                        <input type="text" name="collectionserialno" id="collectionserialno" class="form-control form-control-sm" disabled>
                    </div>
                    <div class="form-group">
                        <label for="collectioncollectedby">Collected By</label>
                        <input type="text" name="collectioncollectedby" id="collectioncollectedby" class="form-control form-control-sm">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savereturncollection"> <i class="fas fa-save fa-lg fa-fw"></i> Save Item Collected</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle  fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/returninwards.js"></script>
</html>