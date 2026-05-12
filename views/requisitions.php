<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Requisitions </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

  <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Requisitions</span>
            <div class="container-fluid">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card containergroup filteroptions">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>

                            <div class="card-body card-body-list">

                                <div class="form-group form-check">
                                    <input type="checkbox" name="alldates" id="alldates" class="form-check-input">
                                    <label for="alldates" class="form-check-label">All Dates</label>
                                </div>

                                <div class="form-group">
                                    <label for="startdate"><span id="startdatelabel">Start date</span></label>
                                    <input type="text" name="startdate" id="startdate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="enddate"><span id="enddatelabel">End date</span></label>
                                    <input type="text" name="enddate" id="enddate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="requisitionno">Requisition Number</label>
                                    <input type="text" name="requisitionno" id="requisitionno" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="requisitiontype">Requisition Type</label>
                                    <select name="" id="requisitiontype" class="form-control form-control-sm">
                                        <option value="">&lt;All&gt;</option>
                                        <option value="purchase">Purchase</option>
                                        <option value="issue">Issue Only</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="department">Department</label>
                                    <select name="department" id="department" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="supplier">Supplier</label>
                                    <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="status">Status</label>
                                    <select name="status" id="status" class="form-control form-control-sm"></select>
                                </div>

                                <div class="row">
                                    <div class="col">
                                        <button class="btn btn-sm btn-secondary w-100" id="filterrequisitions"><i class="fal fa-filter fa-lg fa-fw"></i> Apply Filter</button>
                                    </div>

                                    <div class="col">
                                        <button class="btn btn-success btn-sm w-100" id="addnewrequisition"><i class="fal fa-plus-circle fa-lg fa-fw"></i> Add New</button>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                        
                    </div>
                    
                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Requisitions in the System</h5>
                            </div>
                            <div class="card-body card-body-list scrollable-y">
                                <div class="">
                                    <table class="table table-sm table-striped" id="requisitionslist">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Requisition #</th>
                                            <th>Type</th>
                                            <th>Department</th>
                                            <th>Supplier</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>&nbsp;</th><!-- Edit -->
                                            <th>&nbsp;</th><!-- Approve -->
                                            <th>&nbsp;</th><!-- Reject -->
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Modal for approving requisitions  -->
    <div class="modal" tabindex="-1" role="dialog" id="approverequisitionmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Approve requisition as ...</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="approvallevels">

                    </div>
                    <div class="form-group">
                        <label for="narration">Approval Remark</label>
                        <textarea name="approvalnarration" id="approvalnarration" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="approverequisitionbtn">Approve</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for rejecting requisitions  -->
    <div class="modal" tabindex="-1" role="dialog" id="rejectrequisitionmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Reject requisition as ...</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="rejectionlevels">

                    </div>
                    <div class="form-group">
                        <label for="rejectedreason">Rejection Remark:</label>
                        <textarea name="rejectedreason" id="rejectedreason" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="rejectrequisitionbtn">Reject</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/requisitions.js"></script>
</html>
