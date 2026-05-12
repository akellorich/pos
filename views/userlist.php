<html>
<head>
    <title>Users List</title>
    <?php require_once("header.txt") ?>
<head>
<body>
    <?php require_once("navigation.txt") ?>
    <div class="container-fluid">
        <p class="lead text-center mt-3 font-weight-bold">Users In The System</p>
        <div id="errors"></div>
        <table class="table table-striped table-sm" id="usertable">
            <thead>
                <th>#</th>
                <th>Username</th>
                <th>Fullname</th>
                <th>Mobile</th>
                <th>Email</th>
                <th>Date Added</th>
                <th>Added By</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
            </thead>

            <tbody id="userlist">

            </tbody>
            
            <tfoot>

            </tfoot>
        </table>

        <div class="col-md-12 text-center">
        <ul class="pagination pagination-lg pager" id="myPager"></ul>

        <input type="button" id="adduser" name="adduser" Value="Add New User" class="btn btn-success">
        <input type="button" id="goback" name="goback" Value="Main Menu" class="btn btn-primary">
    </div>

</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/userlist.js"></script>
</html>