<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Pettycash </title>
    <style>
      /* Layout structure for Petty Cash Vouchers page: desktop vs mobile */
      @media (min-width: 992px) {
          .pettycash-grid-layout {
              display: grid !important;
              grid-template-columns: 380px 1fr !important;
              column-gap: 10px !important;
              row-gap: 12px !important;
              align-items: stretch !important;
          }
          .filter-wrapper {
              grid-column: 1 !important;
          }
          .list-wrapper {
              grid-column: 2 !important;
          }
          .equal-height-card {
              height: calc(100vh - 90px) !important;
          }
      }

      @media (max-width: 991.98px) {
          .pettycash-grid-layout {
              display: flex !important;
              flex-direction: column !important;
              gap: 16px !important;
          }
          .filter-wrapper {
              order: 1 !important;
          }
          .list-wrapper {
              order: 2 !important;
          }
      }

      /* Card aesthetics styling to make it feel premium */
      .containergroup.card {
          border: none !important;
          border-radius: 8px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
          background: #ffffff !important;
          margin-bottom: 0 !important;
          display: flex !important;
          flex-direction: column !important;
      }

      .card-header {
          background-color: #ffffff !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.08) !important;
          padding: 12px 16px 20px 16px !important;
          flex-shrink: 0 !important;
      }

      .card-header h5 {
          margin: 0 !important;
          font-size: 1.05rem !important;
          font-weight: 600 !important;
          color: #2b3e50 !important;
      }

      .containergroup.card .card-body {
          flex: 1 1 auto !important;
          overflow-y: auto !important;
          padding: 8px !important;
      }
      .table-container {
          border-radius: 6px !important;
          border: 1px solid #e9ecef !important;
          width: 100% !important;
          overflow: hidden !important;
      }

      .checkbox-group input[type="checkbox"] {
          width: 16px;
          height: 16px;
          vertical-align: middle;
      }

      /* Floating action button style for mobile & tablet */
      .btn-floating-action {
          position: fixed !important;
          bottom: 24px !important;
          right: 24px !important;
          width: 44px !important;
          height: 44px !important;
          background-color: #28a745 !important;
          color: white !important;
          border-radius: 50% !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3) !important;
          z-index: 1000 !important;
          text-decoration: none !important;
          transition: transform 0.2s ease, background-color 0.2s ease !important;
      }
      .btn-floating-action:hover {
          background-color: #218838 !important;
          transform: scale(1.05) !important;
          color: white !important;
      }
      .btn-floating-action i {
          font-size: 16px !important;
      }

      @media (min-width: 992px) {
          .btn-floating-action {
              display: none !important;
          }
      }

      /* DataTables Custom Styling to make it look premium and modern */
      .dataTables_wrapper .dataTables_length select {
          border: 1px solid #ced4da !important;
          border-radius: 4px !important;
          padding: 4px 24px 4px 8px !important;
          font-size: 0.875rem !important;
          color: #495057 !important;
          background-color: #fff !important;
          min-width: 65px !important;
      }
      .dataTables_wrapper .dataTables_filter input {
          border: 1px solid #ced4da !important;
          border-radius: 4px !important;
          padding: 4px 12px 4px 8px !important;
          font-size: 0.875rem !important;
          color: #495057 !important;
          margin-left: 0.5rem !important;
          margin-right: 8px !important;
          width: 110px !important;
          display: inline-block !important;
      }
      .dt-buttons {
          display: inline-flex !important;
          gap: 6px !important;
      }
      .dt-buttons .btn {
          font-size: 0.7rem !important;
          padding: 3px 8px !important;
          border-radius: 4px !important;
          font-weight: 500 !important;
      }
      .dt-buttons .btn i {
          font-size: 0.8rem !important;
          vertical-align: -1px !important;
      }
      .dataTables_wrapper .dataTables_filter {
          text-align: right !important;
      }
      .dataTables_wrapper .dataTables_length {
          text-align: left !important;
      }
      .dropdown-item i {
          font-size: inherit !important;
          vertical-align: middle !important;
      }
      .container-fluid {
          padding-left: 6px !important;
          padding-right: 6px !important;
      }
      @media (max-width: 767.98px) {
          .card-header h5 {
              font-size: 0.9rem !important;
          }
          #results th, #results td {
              font-size: 0.75rem !important;
              padding: 6px 6px !important;
          }
          .dataTables_wrapper {
              font-size: 0.75rem !important;
          }
          .dataTables_wrapper .dataTables_filter input {
              width: 85px !important;
              margin-left: 0.25rem !important;
              margin-right: 0 !important;
              padding: 2px 6px !important;
              font-size: 0.75rem !important;
          }
          .dt-buttons {
              gap: 4px !important;
          }
          .dt-buttons .btn {
              font-size: 0.65rem !important;
              padding: 2px 6px !important;
          }
      }
       #results th {
          background-color: #ebf0f3 !important;
          color: #2b3e50 !important;
          font-weight: 600 !important;
          font-size: 0.85rem !important;
          border-bottom: 2px solid #dee2e6 !important;
          padding-top: 10px !important;
          padding-bottom: 10px !important;
          padding-left: 8px !important;
      }
      #results td {
          padding: 8px 8px !important;
          vertical-align: middle !important;
          font-size: 0.85rem !important;
          border-bottom: 1px solid #eef2f5 !important;
      }
      #results tbody tr:hover {
          background-color: rgba(0, 0, 0, 0.02) !important;
      }
      .text-secondary i.fa-ellipsis-v {
          cursor: pointer !important;
          transition: color 0.15s ease-in-out;
      }
      .text-secondary i.fa-ellipsis-v:hover {
          color: #2b3e50 !important;
      }
      table.dataTable.dtr-inline.collapsed > tbody > tr > td.dtr-control,
      table.dataTable.dtr-inline.collapsed > tbody > tr > th.dtr-control {
          padding-left: 20px !important;
      }
      ul.dtr-details {
          padding-left: 4px !important;
          padding-right: 4px !important;
      }
      ul.dtr-details > li {
          padding: 4px 0 !important;
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Pettycash"; require_once("topbar.php"); ?>
        <div class="container-fluid mt-2">
            <div class="pettycash-grid-layout">
                <!-- Filter Options Column -->
                <div class="filter-wrapper">
                    <div class="containergroup card equal-height-card">
                        <div class="card-header">
                            <h5>Filter Options</h5>
                        </div>
                        <div class="card-body">
                            <div id="errors" class="errors"></div>
                            <div class="form-group">
                                <label for="supplier">Supplier</label>
                                <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="costcenter">Cost Center</label>
                                <select name="costcenter" id="costcenter" class='form-control form-control-sm'></select>
                            </div>
                            <div class="form-group">
                                <div class="checkbox-group mb-2">
                                    <input type="checkbox" name="alldates" id="alldates" class="mr-1"> All Dates
                                </div>
                            </div>

                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="startdate">Start Date</label>
                                        <input type="text" name="startdate" id="startdate" class='form-control form-control-sm' autocomplete="off">
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="form-group">
                                        <label for="enddate">End Date</label>
                                        <input type="text" name="enddate" id="enddate" class='form-control form-control-sm' autocomplete="off">
                                    </div>
                                </div>  
                            </div>
                        
                            <div class="form-group">
                                <label for="status">Status</label>
                                <select name="status" id="status" class='form-control form-control-sm'>
                                    <option value="all">&lt;All&gt;</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Approved">Approved</option>
                                    <option value="Paid">Paid</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="paymentmode">Payment Mode</label>
                                <select name="paymentmode" id="paymentmode" class='form-control form-control-sm'></select>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-3">
                                <button class='btn btn-sm btn-dark w-50 mr-2' id='filterpayments'><i class="fas fa-search fa-fw fa-sm mr-1"></i> Filter Payments</button>
                                <button class="btn btn-sm btn-success w-50" id="addvoucher"><i class="fas fa-plus-circle fa-fw fa-sm mr-1"></i> Add Voucher</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Petty Cash Vouchers List Column -->
                <div class="list-wrapper" id="receiptlist">
                    <div class="card containergroup equal-height-card">
                        <div class="card-header">
                            <h5>Petty Cash Vouchers</h5>
                        </div>
                        <div class="card-body">
                            <div class="results1" id="results1"></div>
                            <div class="table-container p-2 mt-2">
                                <table class='table table-striped table-sm mb-0 nowrap' id="results" style="width: 100%;">
                                    <thead class="thead-light">
                                        <tr>
                                            <th style="width: 20px;"></th>
                                            <th>#</th>
                                            <th>Payment Date</th>
                                            <th>Voucher #</th>
                                            <th>Supplier</th>
                                            <th>Cost Center</th>
                                            <th class="text-right">Amount Paid</th>
                                            <th>Payment Mode</th>
                                            <th>Paid Thru'</th>
                                            <th>Reference</th>
                                            <th>Status</th>
                                            <th class="text-center" style="width: 50px;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan='12' class="text-center text-muted py-4">No payments displayed. Apply filters and try again!</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Floating action button for mobile and tablet -->
        <a href="pettycashvoucherdetails.php" class="btn-floating-action d-lg-none" title="Add Voucher" id="addvoucher-floating">
            <i class="fas fa-plus"></i>
        </a>
    </section>

</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/pettycashvouchers.js"></script>
</html>