<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Journals </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Journals</span>
            <div class="container-fluid">
                <div class="lead text-center mt-3 mb-2">Make Journal Entry</div> 
                <div class="row">
                    <div class="col col-md-3">
                        <div class="form-group">
                            <label for="journaldescription">Journal Entry Description:</label>
                            <input type="text" autocomplete="off" id="journaldescription" class='form-control form-control-sm'>
                        </div> 
                        <div class="form-group">
                            <label for="referenceno">Reference Number:</label>
                            <input type="text" autocomplete="off" class="form-control form-control-sm" name="referenceno" id="referenceno">
                        </div>
                        <div class="form-check form-check-inline">
                            <input type="checkbox" name="posttogl" id="posttogl" class="form-check-input d-block">
                            <label for="posttogl" class="form-check-label">  Post to GL</label>
                        </div>
                    </div>
                    <div class="col">
                        <div id="errors"></div>
                        <div class="row">
                            <div class="col">
                                <div class="form-group">
                                    <label for="glaccount">GL Account</label>
                                    <select name="glaccount" id="glaccount" class='form-control form-control-sm'></select>
                                </div>
                            </div>
                            <div class="col">
                                <div class="form-group">
                                    <label for="narration">Narration</label>
                                    <input type="text" autocomplete="off" id="narration" name="narration" class="form-control form-control-sm">
                                </div>
                            </div>

                            <div class="col col-md-2">
                                <div class="form-group">
                                    <label for="debit">Debit</label>
                                    <input type="number" autocomplete="off" name="debit" id="debit" class='form-control form-control-sm'>
                                </div>
                            </div>

                            <div class="col col-md-2">
                                <div class="form-group">
                                    <label for="credit">Credit</label>
                                    <input type="number" autocomplete="off" name="credit" id="credit"  class='form-control form-control-sm'>
                                </div>
                            </div>
                            <div class="col col-md-2">
                                <div class="form-group">
                                    <label for="">&nbsp;</label>
                                    <button class='btn btn-secondary btn-sm mt-4' class='form-control form-control-sm d-block' id="add"><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add to List</button>
                                </div>
                            </div>
                        </div>  
                        <table class='table table-sm table-striped' id="journalentries">
                            <thead>
                                <th>#</th>
                                <th>Account Name</th>
                                <th>Narration</th>
                                <th>Debit</th>
                                <th>Credit</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </thead>
                            <tbody></tbody>
                            <tfoot class='font-weight-bold text-secondary'>
                                <td colspan="2">TOTALS</td>
                                <td id="difference">Difference:</td>
                                <td id='debits'>DR:</td>
                                <td id='credits'>CR:</td>
                                <td colspan="2">&nbsp;</td>
                            </tfoot>
                        </table>
                        <button class='btn btn-success btn-sm' id="save"><i class="fas fa-save fa-fw fa-lg"></i> Save Journal</button>
                        <button class='btn btn-danger btn-sm' id="clear"><i class="fas fa-eraser fa-fw fa-lg"></i> Clear Form</button>
                    </div>
                </div>
            </div>
        </div>
        
    </section>

</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/journalentry.js"></script>
</html>