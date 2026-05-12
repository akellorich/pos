<html>
<head>
    <title>Credit Note Details</title>
    <?php require_once("header.txt") ?>
<head>

<body>
    <?php include_once("navigation.txt") ?>
        <div class="container-fluid">
            <div class="lead text-center mt-3 mb-2">Add A Credit Note</div>
            
            <div id="errors"></div>
                
            <div class="row">
                
                <div class="col">
                    <div class="form-group">
                        <label for="customer">Customer:</label>
                        <select name="customer" id="customer"  class="form-control form-control-sm"></select>
                    </div>
                </div>

                <div class="col">
                    <label for="itemcode">Item Code:</label>
                    <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm" placeholder="Enter item code or name">
                    <div id="searchproducts"></div>
                </div>
                <div class="col">
                    <label for="total">Total:</label>
                    <input type="text" name="total" id="total"  class="form-control form-control-sm text-right lead font-weight-bold" disabled placeholder="0.00">
                    <div id="searchproducts"></div>
                </div>
            </div>

            <div class="scrollable mb-3">
                <table  id="salesitems" name="salesitems" class="table table-striped table-sm">
                <thead class="thead-light">
                    <tr>
                        <th>Item Code</th>
                        <th>Item Name</th>
                        <th>Unit Price</th>
                        <th>Quantity</th>
                        <th>Line Total</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                <tbody id="salesitemsdetails"></tbody>
                <tfoot>   
                    
                </tfoot>
                </table>
            </div>

            <div class="row">
                <div class="col">
                    <button type="button" id="save" name="save" class="btn btn-success btn-sm"><i class="fas fa-save fa-fw"></i> Save Credit Note</button>
                    <button type="button" id="clear" name="clear" class="btn btn-danger btn-sm"><i class="fas fa-eraser fa-fw"></i> Clear Form</button> 
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/creditnotedetails.js"></script>
</html>