<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <!-- Include datatables css -->
    <title> SalesFlow | Session Management </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Sessions</span>
            <!-- Page Content -->
            <div class="container-fluid">
                <div class="card containergroup">
                    <div class="card-body">
                        <div id="sessionnotifications"></div>
                        <table class="table table-sm table-striped table-hover mb-3" id="sessionstable">
                            <thead>
                                <th>#</th>
                                <th>Session ID</th>
                                <th>Start Time</th>
                                <th>Started By</th>
                                <th>End Time</th>
                                <th>Ended By</th>
                                <th>Status</th>
                                <th>&nbsp;</th>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <button class="btn btn-success btn-sm" id="sessionstatus" data-role="activate">Activate Session</button>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Modal for Session Summaries -->
    <div class="modal" tabindex="-1" role="dialog" id="sessiondetailsmodal">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Session Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                   <table class="table table-sm table-striped table-hover" id="sessioncollectiontable">
                        <thead>
                            <th>#</th>
                            <th>Description</th>
                            <th>Amount</th>
                            <th>&nbsp;</th>
                        </thead>
                        <tbody></tbody>
                   </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-success btn-sm"><i class="fal fa-print fa-lg fa-fw"></i> Print</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal"><i class="fal fa-times fa-fw fa-lg"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<!-- Include datatables js -->
<script src="../js/sessionmanagement.js"></script>
</html>