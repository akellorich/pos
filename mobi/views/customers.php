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
	
    <div id="salesitemsdetails" data-role="page">
        <div data-role="header">
            <button id="homebutton" data-role="Button" data-icon="home" data-iconpos="notext">Home</button>
            <h1>Customers</h1> 
        </div> 
        <div data-role="content" id="productlist">
            <ul data-role="listview" data-inset="true" data-filter="true" id="customerslisted"  data-filter-placeholder="Search Customer ...">
            </ul>
        </div>
    </div>
    
    <div  data-role="page" id="generalerrors">
        <div data-role="header" id="errorsheading">
            <h1>Data Entry Error</h1>
        </div>
        
        <div data-role="content">
            <div id="dataentryerror"></div>

            <div style="text-align: center">
                <a href="#" data-role="button"  data-inline="true" id="dialogback" class="close">Close</a>
            </div>
            
        </div>
    </div>
    
    <div  data-role="page" id="notificationlocation">
        <div data-role="header" id="errorsheading">
            <h1>Save Results</h1>
        </div>
        
        <div data-role="content">
            <div id="notificationposition"></div>

            <div style="text-align: center">
                <a href="#" data-role="button"  data-inline="true" id="dialogback1" class="close">Close</a>
            </div>
            
        </div>
    </div>
    
    <div id="savedialoglocation" data-role="page">
        <div data-role="header">
            <h1>Notification</h1>
        </div>
    
        <div data-role="content">
            <div id="savedialogmessage">
            
            </div>
            
            <div style="text-align: center">
                <a href="button" id="closesavedialog"  data-inline="true" data-role="button">Close</a>
            </div>
            
        </div>
    </div>

    <div id="confirmitemremoval" data-role="page" data-dialog="true">
        <div data-role="header">
            <h1>Remove Item</h1>
        </div>
    
        <div data-role="content">
            <div id="removeitemmessage">

            </div>
            
            <div style="text-align: center">
                <a href="button" id="removeitemno"  data-inline="true" data-role="button">No, Keep Item</a>
                <a href="button" id="removeitemyes"  data-inline="true" data-role="button">Yes, Remove</a>    
            </div>
            
        </div>
    </div>

    
</body>

<script type="text/javascript" src="../js/jquery-1.12.5.js"></script>
<script type="text/javascript" src="../js/jquery-ui.js"></script>
<script type="text/javascript" src="../js/jquery.mobile-1.4.5.js"></script>
<script type="text/javascript" src="../../js/jquery.number.js"></script>
<script type="text/javascript" src="../js/functions.js"></script>
<script type="text/javascript" src="../js/customers.js"></script>

</html>