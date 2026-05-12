<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Change Password </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Change Password</span>
            <!-- Page Content -->
            <div class="container-fluid">
                <input type="hidden" name="id" id="id">
                <p class='lead text-center mt-3 mb-2 font-weight-bold'>Change Your Password</p>
                    
                <div id="errors"></div>
                <div class="form-group">
                    <label for="oldpassword">Current Password:</label>
                    <input type="password" id="oldpassword" name="oldpassword" class="form-control">
                </div>
                <div class="form-group">
                    <label for="newpassword">New Password:</label>
                    <input type="password" id="newpassword" name="newpassword"  class="form-control">
                </div>
                <div class="form-group">
                    <label for="confirmnewpassword">Confirm New Password:</label>
                    <input type="password" id="confirmnewpassword" name="confirmnewpassword"  class="form-control">
                </div>
                <input type="button" id="changepassword" name="changepassword" Value="Change Password" class="btn btn-success">
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/changepassword.js"></script>
</html>


