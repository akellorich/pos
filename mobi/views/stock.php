<html>
<head>
<title>Customers</title>
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
<link href="../css/jquery-ui.css" rel="stylesheet">
<link rel="stylesheet" href="../css/jquery.mobile-1.4.5.css" >
<link rel="stylesheet" href="../../css/all.css" >
<link rel="stylesheet" href="../css/customicons.css" >

</head>
<body>

	<!--  triggered to display errors  -->
	<a id="displaygeneralerrors" href="#generalerrors" data-rel="dialog"></a>
	<!--  triggered to display save results -->
	<a id="displaygeneralnotification" href="#notificationlocation" data-rel="dialog"></a>
	<a id="savedialogdisplay" href="fuellingdetails.php#savedialoglocation" data-rel="dialog"></a>
	
    <div id="salesitemsdetails" data-role="page" data-theme="a" data-title="Outlet Stock Summary">
        <div data-role="header">
            <button id="homebutton" data-role="Button" data-icon="home" data-iconpos="notext">Home</button>
            <h1>Stock in Outlet</h1> 
        </div> 

        <div data-role="content" id="productlist">

            <div id="outletdiv">
                <label for="outlet">Outlet:</label>
                <select name="outlet" id="outlet"  data-native-menu="false"></select>
            </div>

            <table id="stocktable" data-role="table" data-mode="columntoggle" class="ui-responsive table-stripe">
                <thead>
                    <tr>
                        <!-- <th>#</th> -->
                        <th>Item</th>
                        <th>Sales</th>
                        <th data-priority="1">Opening Stock</th>
                        <th data-priority="2">Transfers In</th>
                        <th data-priority="3">Transfers Out</th>
                        <th>Closing Stock</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

    </div>
    
</body>

<script type="text/javascript" src="../js/jquery-1.12.5.js"></script>
<script type="text/javascript" src="../js/jquery-ui.js"></script>
<script type="text/javascript" src="../js/jquery.mobile-1.4.5.js"></script>
<script type="text/javascript" src="../../js/jquery.number.js"></script>
<script type="text/javascript" src="../js/functions.js"></script>
<script type="text/javascript" src="../js/stock.js"></script>

</html>