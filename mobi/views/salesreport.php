<html>
<head>
<title>Sales Report</title>
<!-- <meta name="viewport" content="initial-scale=1, maximum-scale=1">--> 
<link href="../css/jquery-ui.css" rel="stylesheet">
<link rel="stylesheet" href="../css/jquery.mobile-1.4.5.css" >
<link href="../../css/bootstrap.css" rel="stylesheet" type="text/css" />
<link href="../../css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../css/customicons.css" >
<!-- <link rel="stylesheet" href="../css/jquery.mobile-1.4.5.css" > -->
</head>
<body>

	<!--  triggered to display errors  -->
	<a id="displaygeneralerrors" href="#generalerrors" data-rel="dialog"></a>
	<!--  triggered to display save results -->
	<a id="displaygeneralnotification" href="#notificationlocation" data-rel="dialog"></a>
	<a id="savedialogdisplay" href="fuellingdetails.php#savedialoglocation" data-rel="dialog"></a>
	
    <div id="salesreport" data-role="page">
        <div data-role="header">
            <button id="mainmenubutton" data-role="Button" data-icon="home" data-iconpos="notext">Home</button>
            <h1>Sales report</h1>
        </div>

        <div data-role="content">
            <div id="daterange" class="daterange">
                <button id="daily" data-role="Button"  data-inline="true" data-mini="true" data-shadow="false">Daily</button>
                <button id="weekly" data-role="Button"  data-inline="true" data-mini="true" data-shadow="false">Weekly</button>
                <button id="monthly" data-role="Button" data-inline="true" data-mini="true" data-shadow="false">Monthly</button>
            </div>


            <ul data-role="listview" data-inset="true">
                <li data-role="list-divider">Sales By Value</li>
                <li><canvas id="salesbyvalue"></canvas></li> 
            </ul>

            <ul data-role="listview" data-inset="true">
                <li data-role="list-divider">Sales By Quantity</li>
                <li><canvas id="salesbyquantity"></canvas></li> 
            </ul>

            <ul data-role="listview" data-inset="true">
                <li data-role="list-divider">Sales By Payment Method</li>
                <li><canvas id="salesbypaymentmethod"></canvas></li> 
            </ul>

             <ul data-role="listview" data-inset="true">
                <li data-role="list-divider">Total Sales</li>
                <li id="totalsales"></li> 
            </ul>
            
            <ul data-role="listview" data-inset="true">
                <li data-role="list-divider">Best Selling Products</li>
                <li id="bestsellingproduct"></li> 
            </ul>
           

            
        </div>
    </div>

</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.js" integrity="sha256-qSIshlknROr4J8GMHRlW3fGKrPki733tLq+qeMCR05Q=" crossorigin="anonymous"></script>
<script type="text/javascript" src="../js/jquery-1.12.5.js"></script>
<script src="../js/jquery-ui.js"></script>
<script type="text/javascript" src="../js/jquery.mobile-1.4.5.js"></script>
<script type="text/javascript" src="../../js/jquery.number.js"></script>
<script type="text/javascript" src="../../js/functions.js"></script>
<script type="text/javascript" src="../js/salesreport.js"></script>
</html>