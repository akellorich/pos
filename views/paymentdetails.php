<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Supplier Payments </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Supplier Payments</span>
            <!-- Page Content -->
            <div class="container-fluid mt-2">
                <input type="hidden" name="id" id="id" value="0">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 1 - Voucher Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="vouchernumber">Voucher Number</label>
                                            <input type="text" id='vouchernumber' class='form-control form-control-sm'>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fom-group groupedcheckbox">
                                            <input type="checkbox" class="form-check-input" id="generatevoucherno">
                                            <label class="form-check-label" for="generatevoucherno">Generate</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="date">Date</label>
                                    <input type="text" id="date" class='form-control form-control-sm'>
                                </div>
                                <div class="form-group">
                                    <label for="supplier">Supplier</label>
                                    <select name="supplier" id="supplier" class='form-control form-control-sm'></select>
                                </div>
                            </div>
                        </div>
                        <div class="card containergroup mt-2">
                            <div class="card-header">
                                <h5>Step 3 - Payment Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group">
                                    <label for="costcenter">Cost Center</label>
                                    <select name="costcenter" id="costcenter" class='form-control form-control-sm'></select>
                                </div>
                                <div class="form-group">
                                    <label for="paymentmode">Payment Mode</label>
                                    <select name="paymentmode" id="paymentmode"  class='form-control form-control-sm'></select>
                                </div>
                                <div class="form-group">
                                    <label for="paidfrom">Paid From</label>
                                    <select name="paidfrom" id="paidfrom"  class='form-control form-control-sm'></select>
                                </div>
                                <div class="form-group">
                                    <label for="referencenumber">Reference Number</label>
                                    <input type="text" id="referencenumber"  class='form-control form-control-sm'>
                                </div>
                            </div>
                        </div>
                    </div>

                <div class="col" id="receiptlist">
                    <div class="containergroup card mb-2">
                        <div class="card-header">
                            <h5>
                                <span class="text-left font-weight-bold">Step 2 - Invoices to Pay...</span>
                                <span class="float-right">
                                    <!-- <a class='btn btn-danger btn-xs' data-toggle='collapse' href='#filteroptions' role='button' aria-expanded='false' aria-controls='filteroptions'><i class="far fa-eye-slash"></i></a>-->
                                    <button class='btn btn-xs btn-dark' id="addtolist"><i class="fas fa-plus-circle fa-fw fa-sm"></i> Add Invoice(s)</button>
                                </span> 
                            </h5>
                        </div>
                        <div class="card-body">
                            <div id="errors" class="mt-2"></div>
                            <table class='table table-striped table-sm' id="paymentdetails">
                                <thead>
                                    <th> Invoice # </th>
                                    <th> Narration </th> 
                                    <th> Account Charged </th>
                                    <th> Amount </th>
                                    <th> Balance </th>
                                    <th> Pay </th>
                                    <th> &nbsp; </th>
                                </thead>

                                <tbody>
                        
                                </tbody>
                                <tfoot>
                                    <td colspan="3">
                                        TOTALS:
                                    </td>
                                    <td id="invoicetotal">0.00</td>
                                    <td id="balancetotal">0.00</td>
                                    <td id="total" class="total">0.00</td>
                                    <td colpan="2">&nbsp;</td>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <button class='btn btn-success btn-sm' id="save"><i class="fas fa-save fa-fw fa-lg"></i> Save Payment</button>
                    <button class='btn btn-danger btn-sm' id="clear"><i class="fas fa-eraser fa-fw fa-lg"></i> Clear Screen</button>
                </div>
            </div>
            <div class="modal fade alert-dismissable fade" id="supplierinvoicesmodal">
                <div class="modal-dialog">
                    <div class="modal-content" id="supplierinvoicedetails">
                        <div class="modal-header">
                            <p  class="modal-title" ><h5>Select Invoices to Pay ...</h5></p>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div> <!-- -->
                        <div class="modal-body">
                            <table class="table-sm table-striped">
                                <thead>
                                    <th>&nbsp;</th>
                                    <th>Invoice #</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Paid</th>
                                    <th>Balance</th>
                                </thead>
                                <tbody id="supplierinvoices"></tbody>
                            </table>
                        </div>
                    
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success btn-sm" id="addinvoicestolist">Add Invoices</button>
                            <button type="button" class="btn btn-danger btn-sm" id="closecustomerinvoices" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script src="../js/paymentdetails.js"></script>
</html>
