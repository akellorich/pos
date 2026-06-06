<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
     <!-- Include datatables css -->
     <title> SalesFlow | Session Management </title>
    <style>
        /* Custom card group styling for consistency */
        .containergroup.card {
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            height: calc(100vh - 95px) !important;
            margin-bottom: 20px;
            display: flex !important;
            flex-direction: column !important;
            padding-bottom: 15px !important;
        }
        .containergroup.card .card-body {
            flex: 1 1 auto !important;
            overflow-y: auto !important;
            padding: 16px !important;
            display: flex !important;
            flex-direction: column !important;
        }
        .table-container {
            border-radius: 6px !important;
            border: 1px solid #e9ecef !important;
            width: 100% !important;
            overflow: auto !important;
            margin-top: 15px !important;
            padding: 8px !important;
        }
        .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #eef2f6;
            padding: 15px 20px;
        }
        .card-header h5 {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }
        @media (max-width: 576px) {
            .card-header h5 {
                font-size: 0.92rem !important;
            }
            .card-header h5 i {
                font-size: 0.85rem !important;
            }
        }
        /* Make table header text premium and responsive */
        #sessionstable thead th {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
            padding: 10px 8px;
            border-bottom: 2px solid #dee2e6;
        }
        #sessionstable tbody td {
            font-size: 0.78rem;
            padding: 8px 8px;
            vertical-align: middle;
        }
        /* Align DataTable Buttons and Search on same row or with beautiful space */
        .dt-buttons-container {
            display: block !important;
            width: 100% !important;
            overflow-x: auto !important;
            white-space: nowrap !important;
            -webkit-overflow-scrolling: touch;
            margin-bottom: 1.2rem !important;
            padding-bottom: 5px !important;
        }
        .dt-buttons {
            display: inline-flex !important;
            flex-wrap: nowrap !important;
            white-space: nowrap !important;
        }
        .dt-buttons .btn {
            display: inline-block !important;
            float: none !important;
            margin-bottom: 0 !important;
            white-space: nowrap !important;
        }
        .dt-controls-container {
            display: flex !important;
            flex-direction: row !important;
            justify-content: space-between !important;
            align-items: center !important;
            flex-wrap: nowrap !important;
            width: 100%;
            margin-bottom: 1.2rem;
            gap: 15px;
        }
        .dataTables_length, .dataTables_filter {
            margin: 0 !important;
        }
        .dataTables_length label, .dataTables_filter label {
            margin: 0 !important;
            display: flex !important;
            align-items: center !important;
            gap: 5px !important;
            font-size: 0.78rem !important;
        }
        .dataTables_length select {
            font-size: 0.78rem !important;
            padding: 2px 24px 2px 8px !important;
            height: auto !important;
            border-radius: 4px !important;
            min-width: 65px !important;
        }
        .dataTables_filter input {
            font-size: 0.78rem !important;
            padding: 4px 10px !important;
            height: auto !important;
            border-radius: 4px !important;
            border: 1px solid #ced4da !important;
            max-width: 120px !important;
        }
        @media (min-width: 576px) {
            .dataTables_filter input {
                max-width: 180px !important;
            }
        }
        .dt-buttons .btn {
            padding: 6px 16px;
            font-size: 0.8rem;
            font-weight: 500;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.04);
            transition: all 0.2s ease;
        }
        .dt-buttons .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }
        .dropdown-menu {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.05);
            border-radius: 8px;
        }
        .dropdown-item {
            transition: background 0.15s ease;
        }
        .dropdown-item:hover {
            background-color: #f8f9fa;
        }
        .dropdown-toggle-nocaret::after {
            display: none !important;
        }
        @media (max-width: 991px) {
            .container-fluid {
                padding-left: 0 !important;
                padding-right: 0 !important;
            }
            .containergroup.card {
                border-radius: 0 !important;
                margin-left: 0 !important;
                margin-right: 0 !important;
                border: none !important;
                box-shadow: none !important;
            }
            .card-body {
                padding-left: 8px !important;
                padding-right: 8px !important;
            }
        }
        @media (max-width: 576px) {
            #sessionstable thead th {
                font-size: 0.65rem !important;
                padding: 6px 4px !important;
            }
            #sessionstable tbody td {
                font-size: 0.72rem !important;
                padding: 6px 4px !important;
            }
        }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Sessions"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid mt-3">
                <div class="containergroup card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 font-weight-bold text-dark"><i class="fal fa-history mr-2 text-primary" style="font-size: 1rem;"></i>Sessions</h5>
                    </div>
                    <div class="card-body">
                        <div id="sessionnotifications"></div>
                        <div class="table-container">
                            <table class="table table-sm table-striped table-hover mb-0" id="sessionstable">
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
                        </div>
                        <div class="mt-3">
                            <button class="btn btn-success btn-sm" id="sessionstatus" data-role="activate">Activate Session</button>
                        </div>
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