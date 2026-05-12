<html>
<head>
    <title>Main Menu</title>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../css/jquery.mobile-1.4.5.css" >
    <link rel="stylesheet" href="../css/customicons.css" >
	<link rel="stylesheet" href="../../css/all.css" >
</head>
<body>
<a id="errorsdisplay" href="#errorlocation" data-rel=dialog></a>
<a id="successdisplay" href="#successlocation" data-rel=dialog></a>
<section data-role="page">
	<div id="header" data-role="header">
			<!--  <button id="logoff" data-role="button" data-icon="back" data-iconpos="notext">Log Out</button>-->
			<a href="#panel" data-role="button" data-icon="bars" data-iconpos="notext">Panel</a>
			<h1>Pick A Task</h1>
	</div>

	<div id="navigation" data-role="content">
		<ul data-role="listview" data-inset="true">
			<li><a href="#" rel="external"><span class="fal fa-tachometer fa-lg fa-fw ui-li-icon"></span>&nbsp;&nbsp;View Dashboard</a></li>
			<li><a href="sales.php" rel="external"><span class="fal fa-scanner-keyboard fa-lg fa-fw ui-li-icon"></span>&nbsp;&nbsp;Make Sale</a></li>
			<li><a href="customers.php" rel="external"><span class="fal fa-users-crown fa-lg fa-fw ui-li-icon"></span>&nbsp;&nbsp;Customers List</a></li>
			<li><a href="stock.php" rel="external"><span class="fal fa-warehouse-alt fa-lg fa-fw ui-li-icon"></span>&nbsp;&nbsp;Stock Report</a></li>
			<li><a href="salesbypaymentmethod.php" rel="external"><span class="fal fa-analytics fa-lg fa-fw ui-li-icon"></span>&nbsp;&nbsp;Sales Report</a></li>
			<li><a href="printer.php" rel="external"><span class="fal fa-print fa-lg fa-fw ui-li-icon"></span>&nbsp;&nbsp;Printer Settings</a></li>
		</ul>
	</div>
	
	<div id="panel" data-role="panel">
		<ul data-role="listview" data-inset="true">
			<li>
				<img id="portrait"  class="thumbnail" src="">
				<br>
				<span >
					<p class='ui-li-aside' id="username"></p>
				</span>
			</li>
			<li>Offline Data</li>
			<li>
				<a href="#"  rel="external">Sales</a>
				<p class='ui-li-count ui-li-aside'><span id="unpostedsales">0</span></p>	
			</li>
			<li>User Actions</li>
			<li><a href="#" rel="external">Change Password</a></li>
			<!-- <li><a href="command.php" rel="external">Execute Command</a></li> -->
			<li><a href="#" rel="external">Settings</a></li>
			<li><a id="signout" href="../../controllers/useroperations.php?logoutmobiuser=yes" rel="external">Sign Out</a></li>
			<li><a id="emptydata" rel="external" >Update Local DB</a></li> <!--  data-role="button" -->
		</ul>
	</div>
</section>


<div id="errorlocation" data-role="page">
	<div data-role="header">
		<h1>Notification</h1>
	</div>
	
	<div data-role="content">
		<div id="errormessage">
		
		</div>
		
		<div style="text-align: center">
			<a href="button" id="closeerror"  data-inline="true" data-role="button">Close</a>
		</div>
		
	</div>
</div>

<div id="successlocation" data-role="page">
	<div data-role="header">
		<h1>Notification</h1>
	</div>
	
	<div data-role="content">
		<div id="successmessage">
		
		</div>
		
		<div style="text-align: center">
			<a href="button" id="closesuccess"  data-inline="true" data-role="button">Close</a>
		</div>
		
	</div>
</div>
</body>

<script type="text/javascript" src="../js/jquery-1.12.5.js"></script>
<script type="text/javascript" src="../js/jquery.mobile-1.4.5.js"></script>
<script type="text/javascript" src="../js/main.js"></script>

</html>