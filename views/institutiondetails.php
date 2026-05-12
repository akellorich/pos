<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Instutition Details </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Institution Details</span>
            <!-- Page Content -->
            <div class="container-fluid">
                <div class="card containergroup mt-4">
                    <div class="card-header">
                        <h5>Institution Details</h5>
                    </div>
                    <div class="card-body">
                        <div id="notifications"></div>
                        <div class="row">
                            <div class="col col-md-10">
                                <div class="row">
                                    <div class="col form-group">
                                        <label for="companyname">Company Name</label>
                                        <input type="text" name="companyname" id="companyname" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="pinno">PIN Number</label>
                                        <input type="text" name="pinno" id="pinno" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="mainbusinesstype">Main Business Type</label>
                                        <select name="mainbusinesstype" id="mainbusinesstype" class="form-control form-control-sm">
                                            <option value="">&lt;Choose&gt;</option>
                                            <option value="restaurant">Restaurant</option>
                                            <option value="retail">Retail</option>
                                            <option value="accomodation">Accomodation</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col form-group">
                                        <label for="physicaladdress">Physical Address</label>
                                        <input type="text" name="physicaladdress" id="physicaladdress" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="postaladdress">Postal Address</label>
                                        <input type="text" name="postaladdress" id="postaladdress" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="town">Town</label>
                                        <input type="text" name="town" id="town" class="form-control form-control-sm">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col form-group">
                                        <label for="postalcode">Postal Code</label>
                                        <input type="text" name="postalcode" id="postalcode" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="emailaddress">Email Address</label>
                                        <input type="text" name="emailaddress" id="emailaddress" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="mobile">Mobile Number</label>
                                        <input type="text" name="mobile" id="mobile" class="form-control form-control-sm">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col form-group">
                                        <label for="landline">Landline Number</label>
                                        <input type="text" name="landline" id="landline" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="website">Website</label>
                                        <input type="text" name="website" id="website" class="form-control form-control-sm">
                                    </div>

                                    <div class="col form-group">
                                        <label for="tagline">Tagline</label>
                                        <input type="text" name="tagline" id="tagline" class="form-control form-control-sm">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col form-group">
                                        <label for="defaultcustomer">Default Customer</label>
                                        <select name="defaultcustomer" id="defaultcustomer" class="form-control form-control-sm">
                                            <option value="">&lt;Choose&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="autogrninvoice">Auto add invoice on GRN</label>
                                        <select name="autogrninvoice" id="autogrninvoice" class="form-control form-control-sm">
                                            <option value="">&lt;Choose&gt;</option>
                                            <option value="1">Yes</option>
                                            <option value="0">No</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="showwaiterlogin">Show Waiter login</label>
                                        <select name="showwaiterlogin" id="showwaiterlogin" class="form-control form-control-sm">
                                            <option value="">&lt;Choose&gt;</option>
                                            <option value="1">Yes</option>
                                            <option value="0">No</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="receiptfooter">Receipt Footer</label>
                                    <textarea name="receiptfooter" id="receiptfooter" rows="6" class="form-control form-control-sm"></textarea>
                                </div>
                                
                                <button class="btn btn-sm btn-success" id="saveinstitution"><i class="fal fa-save fa-lg fa-fw"></i> Save Institution Details</button>
                            </div>
                            <div class="col">
                                <img src="../images/noimage.jpg" alt="Institution Logo" id="logopreview" style="width:100%">
                                <input type="file" name="logo" id="logo" class="form-control form-control-sm" accept="image/*">
                            </div>
                        </div>
                    </div>
                </div>

                
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script src="../js/institutiondetails.js"></script>
</html>