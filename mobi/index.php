<!DOCTYPE html>
<html>
<head>
	<title>Loyalty Mobile</title>
	<meta name="viewport" content="initial-scale=1, maximum-scale=1">
	<meta name="mobile-web-app-capable" content="yes">
	<link rel="shortcut icon" href="images/coke2.png" />
	<link rel="icon" href="images/coke2.png" />

	<link rel="stylesheet" href="css/jquery.mobile-1.4.5.css" >

	<style type="text/css">
		.center-btn {
		    margin: 0 auto !important;
		    width: 30%;
		}
	</style>
</head>
<body>
	<a id="errors" href="#logonerrors" data-rel="dialog" data-transition="pop" style="display:none;"></a>
	<section id="loginpage" data-role="page">
		<form method="post" action="index.php">
			<header data-role="header">
				<h2>Enter Logon Details</h2>
			</header>
			
			<div data-role="content">
				<div id="notices"></div>
				<label for="username">Username:	</label>
				<input type="text" id="username" name="username">
				<label for="password">Password:	</label>
				<input type="password" id="password" name="password">
				<div id="unitoptions">
					<label for="unit">Company:</label>
					<select name="unit" id="unit" data-native-menu="false"></select>
				</div>
				<!-- -->
				<button type="button" id="logon" name="logon" data-inline="true">Log On</button>
				<button type="button" id="reset" data-role="Button" data-inline="true">Clear Fields</button>
				<!--  <label for="fullscreen"><input type="checkbox" id="fullscreen">Enter Fullscreen</label>-->
			</div>
			
			<footer data-role="footer">
				<h2>
					&copy;<span id="year"></span> Cybertrack Ltd.
				</h2>
			</footer>
		</form>
	</section>
	
	
	<div id="logonerrors" data-role="page">
		<div data-role="header">
			<a id="close" data-role="Button" data-icon="delete" data-iconpos="notext" href="#loginpage">Close</a>
			<h1>Logon Failed!</h1>
		</div>
		<div data-role="content">
			<div id="logonerrormessages" >
					
			</div>
			
			<div style="text-align: center">
				<a data-role="button" id="okbutton" data-inline="true" class="center-btn">Close</a>
			</div>
			
		</div>
	</div>
	
</body>

<script type="text/javascript" src="js/jquery-1.12.5.js"></script>
<script type="text/javascript" src="js/jquery.mobile-1.4.5.js"></script>
<script type="text/javascript" src="../js/functions.js"></script>
<script type="text/javascript" src="js/index.js"></script>
</html>