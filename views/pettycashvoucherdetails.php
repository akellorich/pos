<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Pettycash </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Pettycash</span>
            <div class="container-fluid">
                <div class="row">
                    <div class="col col-md-3 mt-2">
                        <div class="containergroup card">
                            <div class="card-header">
                                <h5>Step 1 -- Voucher Parameters</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group">
                                    <label for="voucherno">Voucher Number:</label>
                                    <div class="row">
                                        <div class="col">
                                            <input type="text" autocomplete='off' name="voucherno" id="voucherno" class="form-control form-control-sm">
                                        </div>
                                        <div class="col">
                                            <input type="checkbox" name="autogenerate" id="autogenerate"> Generate
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="voucherdate">Voucher Date:</label>
                                    <input type="text" autocomplete='off' name="voucherdate" id="voucherdate" class="form-control form-control-sm">
                                </div>
                                <div class="form-group">
                                    <label for="costcenter">Cost Center</label>
                                    <select name="costcenter" id="costcenter" class="form-control form-control-sm"></select>
                                </div>
                                <div class="form-group">
                                    <label for="supplier">Supplier:</label>
                                    <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                                </div>
                                <div class="form-group">
                                    <label for="paymentmode">Payment Mode:</label>
                                    <select name="paymentmode" id="paymentmode" class="form-control form-control-sm"></select>
                                </div>
                                <div class="form-group">
                                    <label for="referenceno">Reference Number</label>
                                    <input type="text" name="referencenumber" id="referencenumber" class="form-control form-control-sm">
                                </div>
                                <div class="form-group">
                                    <label for="payfrom">Pay From:</label>
                                    <select name="payfrom" id="payfrom" class="form-control form-control-sm"></select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col mt-2" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 2 -- Voucher Details</h5>
                            </div>
                            <div class="card-body">
                                <div id="errors"></div>
                                <div class="row">
                                    <input type="hidden" name="idfield" id="idfield" value="0">
                                    <div class="col form-group col-md-2">
                                        <label for="reference">Reference</label>
                                        <input type="text" autocomplete='off' name="reference" id="reference" class="form-control form-control-sm">
                                    </div>
                                    <div class="col form-group">
                                        <label for="narration">Narration</label>
                                        <input type="text" autocomplete='off' name="narration" id="narration" class="form-control form-control-sm">
                                    </div>
                                    <div class="col form-group col-md-3">
                                        <label for="accountcharged">Account Charged</label>
                                        <select name="accountcharged" id="accountcharged" class="form-control form-control-sm"></select>
                                    </div>
                                    <div class="col form-group col-md-2">
                                        <label for="amount">Amount</label>
                                        <input type="number" autocomplete='off' name="amount" id="amount" class="form-control form-control-sm">
                                    </div>
                                    <div class="col form-group col-md-1 mr-3">
                                        <label for="">&nbsp;</label>
                                        <button class="btn btn-secondary btn-sm d-block" id="additem"><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add</button>
                                    </div>
                                </div>
                                <table class="table table-sm table-striped" id="itemslist">
                                    <thead>
                                        <th>#</th>
                                        <th>Reference</th>
                                        <th>Narration</th>
                                        <th>Account Charged</th>
                                        <th>Amount</th>
                                        <th>&nbsp;</th><!-- Edit -->
                                        <th>&nbsp;</th><!-- Delete -->
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col col-md-7">
                                <button class="btn btn-sm btn-success mt-2" id="savevoucher"><i class="fas fa-save fa-fw fa-lg"></i> Save Voucher</button>
                                <button class="btn btn-danger btn-sm mt-2" id="clearvoucher"><i class="fas fa-eraser fa-fw fa-lg"></i> Clear</button>
                            </div>
                            <div class="col">
                                <div class="text-secondary text-right lead mt-2 mr-2">Total: <span id="totalfield" class="font-weight-bold">0.00</span></div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
        
    </section>
   
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/pettycashvoucherdetails.js"></script>
</html>