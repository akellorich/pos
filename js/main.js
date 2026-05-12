$(document).ready(function(){
    var salesbyvalue=document.getElementById("salesbyvalue").getContext('2d'),
        salesbyquantity=document.getElementById("salesbyquantity").getContext('2d'),
        salesbypaymentmode=document.getElementById("salesbypaymentmode").getContext('2d'),
        salesbycustomercount=document.getElementById("salesbycustomercount").getContext('2d'),
        salebyvaluebutton=$("#salebyvaluedropdown"),
        salebyvaluetoday=$("#salesbyvaluetoday"),
        salebyvalueweek=$("#salesbyvalueweek"),
        salebyvaluemonth=$("#salesbyvaluemonth"),
        salebyvalueyear=$("#salesbyvalueyear"),
        salesbyquantitytoday=$("#salesbyquantitytoday"),
        salesbyquantityweek=$("#salesbyquantityweek"),
        salesbyquantitymonth=$("#salesbyquantitymonth"),
        salesbyquantityyear=$("#salesbyquantityyear"),
        salesbyquantitybutton=$("#salebyquantitydropdown"),
        salebycustomercountbutton=$("#salebycustomercountdropdown"),
        salebycustomercounttoday=$("#salebycustomercounttoday"),
        salebycustomercountweek=$("#salebycustomercountweek"),
        salebycustomercountmonth=$("#salebycustomercountmonth"),
        salebycustomercountyear=$("#salebycustomercountyear"),
        salesbysalesperson=$("#salesbysalesperson"),
        bestsellingproduct=$("#bestsellingproduct"),
        bestsellingcategory=$("#bestsellingcategory"),
        startdate,enddate,
        salesbypaymentmodebutton=$("#salebypaymentmodedropdown"),
        salesbypaymentmodetoday=$("#salesbypaymentmodetoday"),
        salesbypaymentmodeweek=$("#salesbypaymentmodeweek"),
        salesbypaymentmodemonth=$("#salesbypaymentmodemonth"),
        salesbypaymentmodeyear=$("#salesbypaymentmodeyear"),
        salebyoutletbutton=$("#salebyoutletdropdown"),
        salebyoutlettoday=$("#salebyoutlettoday"),
        salebyoutletweek=$("#salebyoutletweek"),
        salebyoutletmonth=$("#salebyoutletmonth"),
        salebyoutletyear=$("#salebyoutletyear"),
        salesbysalesmanbutton=$("#salebysalesmandropdown"),
        salesbysalesmantoday=$("#salesbysalesmantoday"),
        salesbysalesmanweek=$("#salesbysalesmanweek"),
        salesbysalesmanmonth=$("#salesbysalesmanmonth"),
        salesbysalesmanyear=$("#salesbysalesmanyear"),
        bestsellingproductbutton=$("#bestsellingproductdropdown"),
        bestsellingproducttoday=$("#bestsellingproducttoday"),
        bestsellingproductweek=$("#bestsellingproductweek"),
        bestsellingproductmonth=$("#bestsellingproductmonth"),
        bestsellingproductyear=$("#bestsellingproductyear"),
        bestsellingcategorybutton=$("#bestsellingcategorydropdown"),
        bestsellingcategorytoday=$("#bestsellingcategorytoday"),
        bestsellingcategoryweek=$("#bestsellingcategoryweek"),
        bestsellingcategorymonth=$("#bestsellingcategorymonth"),
        bestsellingcategoryyear=$("#bestsellingcategoryyear"),
        salesbycustomervaluebutton=$("#"),
        salesbycustomervaluetoday=$("#salesbycustomervaluetoday"),
        salesbycustomervalueweek=$("#salesbycustomervalueweek"),
        salesbycustomervaluemonth=$("#salesbycustomervaluemonth"),
        salesbycustomervalueyear=$("#salesbycustomervalueyear"),
        activecustomersplaceholder=$("#activecustomersplaceholder"),
        openreceivablesplaceholder=$("#openreceivablesplaceholder"),
        openpayablesplaceholder=$("#openpayablesplaceholder"),
        openpurchaseorderplaceholder=$("#openpurchaseordersplaceholder")

    // change legend point style
    //Chart.defaults.global.legend.labels.usePointStyle = true
    //show dashboard based on today
    getdashboardheader()
    getSalesByValue("today")
    getSalesByQuantity("today")
    getsalesbypeymentmethod("today")
    getsalesbycustomercount("today")
    getsalesbyoutlet("today")
    getsalesbysalesperson("today")
    getbestsellingproduct("today")
    getbestsellingcategory("today")
    getsalesbycustomervalue("today")

    salebyvaluetoday.on("click",function(){
        getSalesByValue("today")
        salebyvaluebutton.html("Today")
    })

    salebyvalueweek.on("click",function(){
        getSalesByValue("week")
        salebyvaluebutton.html("Week")
    })

    salebyvaluemonth.on("click",function(){
        getSalesByValue("month")
        salebyvaluebutton.html("Month")
    })

    salebyvalueyear.on("click",function(){
        getSalesByValue("year")
        salebyvaluebutton.html("Year")
    })

    salesbyquantitytoday.on("click",function(){
        getSalesByQuantity("today")
        salesbyquantitybutton.html("Today")
    })

    salesbyquantityweek.on("click",function(){
        getSalesByQuantity("week")
        salesbyquantitybutton.html("Week")
    })

    salesbyquantitymonth.on("click",function(){
        getSalesByQuantity("month")
        salesbyquantitybutton.html("Month")
    })

    salesbyquantityyear.on("click",function(){
        getSalesByQuantity("year")
        salesbyquantitybutton.html("Year")
    })

    salebycustomercounttoday.on("click",function(){
        getsalesbycustomercount("today")
        salebycustomercountbutton.html("Today")
    })

    salebycustomercountweek.on("click",function(){
        getsalesbycustomercount("week")
        salebycustomercountbutton.html("Week")
    })

    salebycustomercountmonth.on("click",function(){
        getsalesbycustomercount("month")
        salebycustomercountbutton.html("Month")
    })

    salebycustomercountyear.on("click",function(){
        getsalesbycustomercount("year")
        salebycustomercountbutton.html("Year")
    })

    // listen to sale by payment mode drop down
    salesbypaymentmodetoday.on("click",function(){
        getsalesbypeymentmethod("today")
        salesbypaymentmodebutton.html("Today")
    })

    salesbypaymentmodeweek.on("click",function(){
        getsalesbypeymentmethod("week")
        salesbypaymentmodebutton.html("Week")
    })

    salesbypaymentmodemonth.on("click",function(){
        getsalesbypeymentmethod("month")
        salesbypaymentmodebutton.html("Month")
    })

    salesbypaymentmodeyear.on("click",function(){
        getsalesbypeymentmethod("year")
        salesbypaymentmodebutton.html("Year")
    })

    // listen to sale by outlet dropdown
    salebyoutlettoday.on("click",function(){
        getsalesbyoutlet("today")
        salebyoutletbutton.html("Today")
    })

    salebyoutletweek.on("click",function(){
        getsalesbyoutlet("week")
        salebyoutletbutton.html("Week")
    })

    salebyoutletmonth.on("click",function(){
        getsalesbyoutlet("month")
        salebyoutletbutton.html("Month")
    })

    salebyoutletyear.on("click",function(){
        getsalesbyoutlet("year")
        salebyoutletbutton.html("Year")
    })

    // listen to sales by salesman dropdown menu
    salesbysalesmantoday.on("click",function(){
        getsalesbysalesperson("today")
        salesbysalesmanbutton.html("Today")
    })

    salesbysalesmanweek.on("click",function(){
        getsalesbysalesperson("week")
        salesbysalesmanbutton.html("Week")
    })

    salesbysalesmanmonth.on("click",function(){
        getsalesbysalesperson("month")
        salesbysalesmanbutton.html("Month")
    })

    salesbysalesmanyear.on("click",function(){
        getsalesbysalesperson("year")
        salesbysalesmanbutton.html("Year")
    })

    // listen to best selling product dropdown
    bestsellingproducttoday.on("click",function(){
        getbestsellingproduct("today")
        bestsellingproductbutton.html("Today")
    })

    bestsellingproductweek.on("click",function(){
        getbestsellingproduct("week")
        bestsellingproductbutton.html("Week")
    })

    bestsellingproductmonth.on("click",function(){
        getbestsellingproduct("month")
        bestsellingproductbutton.html("Month")
    })

    bestsellingproductyear.on("click",function(){
        getbestsellingproduct("year")
        bestsellingproductbutton.html("Year")
    })

    // listen to best selling category 
    bestsellingcategorytoday.on("click",function(){
        getbestsellingcategory("today")
        bestsellingcategorybutton.html("Today")
    })

    bestsellingcategoryweek.on("click",function(){
        getbestsellingcategory("week")
        bestsellingcategorybutton.html("Week")
    })

    bestsellingcategorymonth.on("click",function(){
        getbestsellingcategory("month")
        bestsellingcategorybutton.html("Month")
    })

    bestsellingcategoryyear.on("click",function(){
        getbestsellingcategory("year")
        bestsellingcategorybutton.html("Year")
    })

    // listen to sale by customer value dropdown
    salesbycustomervaluetoday.on("click",function(){
        getsalesbycustomervalue("today")
        salesbycustomervaluebutton.html("Today")
    })

    salesbycustomervalueweek.on("click",function(){
        getsalesbycustomervalue("week")
        salesbycustomervaluebutton.html("Week")
    })

    salesbycustomervaluemonth.on("click",function(){
        getsalesbycustomervalue("month")
        salesbycustomervaluebutton.html("Month")
    })

    salesbycustomervalueyear.on("click",function(){
        getsalesbycustomervalue("year")
        salesbycustomervaluebutton.html("Year")
    })

    function getSalesByValue(daterange){
        // fetch the data from the server
        setDates(daterange)
        var labels=[],
            salesdata=[]
        switch (daterange) {
            case "today":
                range="Day"
                break;
            case "week":
                range="Week"
                break;
            case "month":
                range="Month"
                break;
            case "year":
                range="Year"
                break;
        }

        $.getJSON("../controllers/reportoperations.php",
        {
            getsalestrend:true,
            startdate:startdate,
            enddate:enddate,
            range:range
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].transactiondate)
                    salesdata.push(data[i].amount)
                }
                // generate the sales trend chat
                var salesbyvaluechart = new Chart(salesbyvalue, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Sales By Value',
                            data: salesdata,
                            backgroundColor: [
                                //'rgba(255, 99, 132, 0.2)'
                                "#94baf8"
                            ],
                            borderColor: [
                                //'rgba(255, 99, 132, 1)'
                                "#94baf8"
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                    // responsive: false,
                        legend: {
                            display: false
                        },
                        tooltips: {
                            callbacks: {
                            label: function(tooltipItem) {
                                    return tooltipItem.yLabel;
                            }
                            }
                        }
                    }
                })
            }
            
        }    
        )
    }

    // get sales by quantity
    function getSalesByQuantity(daterange){
        // fetch the data from the server
        setDates(daterange)
        var labels=[],
            salesdata=[]
            backcolour=[]
        switch (daterange) {
            case "today":
                range="Day"
                break;
            case "week":
                range="Week"
                break;
            case "month":
                range="Month"
                break;
            case "year":
                range="Year"
                break;
        }

        $.getJSON("../controllers/reportoperations.php",
        {
            getsalesbyquantity:true,
            startdate:startdate,
            enddate:enddate,
            range:range
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].transactiondate)
                    salesdata.push(data[i].quantity)
                    backcolour.push('rgba(47,194,178)')
                }

                // generate the sales by quantity chat
                if (window.salesbyquantitychart !=undefined){             
                window.salesbyquantitychart.destroy();
                }

                window.salesbyquantitychart = new Chart(salesbyquantity, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Sales By Quantity',
                            data: salesdata,
                            backgroundColor: backcolour,
                            borderColor: backcolour,
                            borderWidth: 1
                        }]
                    },
                    options: {
                    // responsive: false,
                        legend: {
                            display: false
                        },
                        tooltips: {
                            callbacks: {
                            label: function(tooltipItem) {
                                    return tooltipItem.yLabel;
                            }
                            }
                        }
                    }
                })
            }
            
        }    
        )
    }

    function getsalesbypeymentmethod(daterange){
        setDates(daterange)

        var labels=[],
            salesdata=[]
            backcolour=[]
      
        $.getJSON("../controllers/reportoperations.php",
        {
            getsalesbypaymentmode:true,
            startdate:startdate,
            enddate:enddate,
            //range:range
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].paymentmode)
                    salesdata.push(data[i].amount)
                }

                if (window.salesbypaymentmodechart !=undefined){             
                    window.salesbypaymentmodechart.destroy();
                }
    
                window.salesbypaymentmodechart = new Chart(salesbypaymentmode, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Sales By Payment Method',
                            data: salesdata,
                            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
                            borderWidth: 1
                        }]
                    },
                    options: {
                    // responsive: false,
                        legend: {
                            display: true,
                            position: "bottom",
                            
                            labels: {
                                usePointStyle: true,
                            }
                        },
                    /* plugins: {
                            labels: {
                                // render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
                                render: 'percentage'
                            }
                        },*/
                        tooltips: {
                            callbacks: {
                            label: function(tooltipItem, data) {
                                var dataset = data.datasets[tooltipItem.datasetIndex];
                                var meta = dataset._meta[Object.keys(dataset._meta)[0]];
                                var total = meta.total;
                                var currentValue = dataset.data[tooltipItem.index];
                                var percentage = parseFloat((currentValue/total*100).toFixed(1));
                                return currentValue + ' (' + percentage + '%)';
                            },
                            title: function(tooltipItem, data) {
                                return data.labels[tooltipItem[0].index];
                            }
                            }
                        }
                    }
                })
            }
            
        }    
        )
    }

    function getsalesbycustomercount(daterange){
        setDates(daterange)
        var labels=[],
            salesdata1=[],
            salesdata2=[],
            backcolour=[]
        switch (daterange) {
            case "today":
                range="Day"
                break;
            case "week":
                range="Week"
                break;
            case "month":
                range="Month"
                break;
            case "year":
                range="Year"
                break;
        }

        $.getJSON("../controllers/reportoperations.php",
        {
            getsalesbycustomercount:true,
            startdate:startdate,
            enddate:enddate,
            range:range
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].transactiondate)
                    salesdata1.push(data[i].walkin)
                    salesdata2.push(data[i].Regular)
                }
            
                window.salesbycustomercount = new Chart(salesbycustomercount, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "Walkin",
                            data: salesdata1,
                            borderColor: "#f50747",
                            backgroundColor:"#f50747",
                            //borderColor: backcolour,
                            borderWidth: 2,
                            fill:"No"
                        },{
                            label:"Regular",
                            data:salesdata2,
                            borderColor:"#1667c4",
                            backgroundColor:"#1667c4",
                            borderWidth:2,
                            fill:"No"
                        }]
                    },
                    options: {
                    // responsive: false,
                        legend: {
                            display: true,
                            position: "bottom",
                            labels: {
                                usePointStyle: true,
                            }
                        },
                    /* plugins: {
                            labels: {
                                // render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
                                render: 'percentage'
                            }
                        },*/
                        
                    }
                })
            }
            
        }    
        )
    }

    function getsalesbyoutlet(daterange){
        setDates(daterange)
       
        var labels=[],
            salesdata=[]
            backcolour=[]
        switch (daterange) {
            case "today":
                range="Day"
                break;
            case "week":
                range="Week"
                break;
            case "month":
                range="Month"
                break;
            case "year":
                range="Year"
                break;
        }

        $.getJSON("../controllers/reportoperations.php",
        {
            getsalesbyoutlet:true,
            startdate:startdate,
            enddate:enddate
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].pointofsale)
                    salesdata.push(data[i].total)
                    //backcolour.push("#d0b7f1")
                }

                // generate the sales by quantity chat
                if (window.salesbyoutletchart !=undefined){             
                    window.salesbyoutletchart.destroy();
                }

                window.salesbyoutletchart = new Chart(salesbyoutlet, {
                    type: 'horizontalBar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Sales By Outlet',
                            data: salesdata,
                            backgroundColor: "#d0b7f1",
                            borderColor: "#d0b7f1",
                            borderWidth: 1
                        }]
                    },
                    options: {
                        // responsive: false,
                        legend: {
                            display: false
                        },
                        tooltips: {
                            callbacks: {
                                label: function(tooltipItem) {
                                        return tooltipItem.yLabel;
                                }
                            }
                        }
                    }
                })
            }
            
        }    
        )
    }

    function getsalesbysalesperson(daterange){
        setDates(daterange)
        var chartColors = window.chartColors
        var color = Chart.helpers.color
        
        var labels=[],
            salesdata=[]
            backcolour=[]
        switch (daterange) {
            case "today":
                range="Day"
                break;
            case "week":
                range="Week"
                break;
            case "month":
                range="Month"
                break;
            case "year":
                range="Year"
                break;
        }

        $.getJSON("../controllers/reportoperations.php",
        {
            getsalesbysalesperson:true,
            startdate:startdate,
            enddate:enddate
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].userfullname)
                    salesdata.push(data[i].total)
                    //backcolour.push("#d0b7f1")
                }

                // generate the sales by quantity chat
                if (window.salesbysalespersonchart !=undefined){             
                    window.salesbysalespersonchart.destroy();
                }

                var config = {
                    data: {
                        datasets: [{
                            data:salesdata,
                            backgroundColor: [
                                color("#3e95cd").alpha(0.6).rgbString(), 
                                color("#8e5ea2").alpha(0.6).rgbString(),
                                color("#3cba9f").alpha(0.6).rgbString(),
                                color("#e8c3b9").alpha(0.6).rgbString(),
                                color("#c45850").alpha(0.6).rgbString()
                            ],
                            label: 'Sales By Salesperson' // for legend
                        }],
                        labels: labels
                    },
                    options: {
                        responsive: true,
                        legend: {
                            position: 'right',
                            labels: {
                                usePointStyle: true,
                            }
                        },
                        title: {
                            display: false,
                            text: 'Sales by Salesperson'
                        },
                        scale: {
                            ticks: {
                                beginAtZero: true
                            },
                            reverse: false
                        },
                        animation: {
                            animateRotate: false,
                            animateScale: true
                        }
                    }
                }
                window.salesbysalespersonchart =Chart.PolarArea(salesbysalesperson, config)
            }
        }    
        )
    }

    function getbestsellingproduct(daterange){
        setDates(daterange)
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getbestsellingproduct:true,
                startdate:startdate,
                enddate:enddate
            },
            function(data){
                if(data.length>0){
                    // generate the best product first
                    var results="<div class='row font-weight-bold'>"
                    results+="<div class='col'><span class='lead'>"+data[0].itemname+"</span><p class='small'>"+data[0].categoryname+"</p></div>"
                    results+="<div class='col'><span class='lead'>"+$.number(parseFloat(data[0].quantity*data[0].unitprice),0)+"</span><p class='small'>Total Sale</p></div>"
                    results+="<div class='col'><span class='lead'>"+$.number(data[0].quantity,2)+"</span><p class='small'>Quantity</p></div>"
                    results+="</div>"
                    results+="<table class='table table-sm'>"
                    results+="<thead><th>PRODUCT DETAILS</th><th>PRICE</th><th>QTY</th><th>TOTAL VALUE</th></thead>"
                    results+="<tbody>"
                    for(var i=1;i<data.length;i++){
                        results+="<tr><td>"+data[i].itemname+"</td>" 
                        results+="<td>"+$.number(data[i].unitprice,2)+"</td>" 
                        results+="<td>"+$.number(data[i].quantity,2)+"</td>" 
                        results+="<td>"+$.number(parseFloat(data[i].unitprice*data[i].quantity),2)+"</td></tr>" 
                    }

                    results+="</tbody>"
                    results+="</table>"
            
                    bestsellingproduct.html(results)
                }  
            }
        ) 
    }

    
    function getbestsellingcategory(daterange){
        setDates(daterange)
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getbestsellingcategory:true,
                startdate:startdate,
                enddate:enddate
            },
            function(data){
                if(data.length>0){
                    // generate the best product first
                    var results="<div class='row font-weight-bold'>"
                    results+="<div class='col'><span class='lead'>"+data[0].categoryname+"</span><p class='small'>Category Name</p></div>"
                    results+="<div class='col'><span class='lead'>"+$.number(parseFloat(data[0].quantity*data[0].unitprice),0)+"</span><p class='small'>Total Sale</p></div>"
                    results+="<div class='col'><span class='lead'>"+$.number(data[0].quantity,2)+"</span><p class='small'>Quantity</p></div>"
                    results+="</div>"
                    /*results+="<div class='row'>"
                    results+="<div class='col'>"*/
                    results+="<table class='table table-sm'>"
                    results+="<thead><th>CATEGORY</th><th>AVG PRICE</th><th>QTY</th><th>TOTAL VALUE</th></thead>"
                    results+="<tbody>"
                    for(var i=1;i<data.length;i++){
                        results+="<tr><td>"+data[i].categoryname+"</td>" 
                        results+="<td>"+$.number(data[i].unitprice,2)+"</td>" 
                        results+="<td>"+$.number(data[i].quantity,2)+"</td>" 
                        results+="<td>"+$.number(parseFloat(data[i].unitprice*data[i].quantity),2)+"</td></tr>" 
                    }
                    //console.log(results)
                    results+="</tbody>"
                    results+="</table>"
            
                    bestsellingcategory.html(results) 
                } 
            }
        ) 
    }

    function getsalesbycustomervalue(daterange){
        setDates(daterange)
        var labels=[],
            salesdata1=[],
            salesdata2=[],
            backcolour=[]
        switch (daterange) {
            case "today":
                range="Day"
                break;
            case "week":
                range="Week"
                break;
            case "month":
                range="Month"
                break;
            case "year":
                range="Year"
                break;
        }

        $.getJSON("../controllers/reportoperations.php",
        {
            getsalesbycustomervalue:true,
            startdate:startdate,
            enddate:enddate,
            range:range
        },
        function(data){
            if(data.length>0){
                for(var i=0;i<data.length;i++){
                    labels.push(data[i].transactiondate)
                    salesdata1.push(data[i].walkin)
                    salesdata2.push(data[i].regular)
                }
                if (window.salesbycustomervaluechart !=undefined){             
                    window.salesbycustomervaluechart.destroy();
                }
                window.salesbycustomervaluechart = new Chart(salesbycustomervalue, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "Walkin",
                            data: salesdata1,
                            borderColor: "#f50747",
                            backgroundColor:"#f50747",
                            //borderColor: backcolour,
                            borderWidth: 2,
                            fill:"No"
                        },{
                            label:"Regular",
                            data:salesdata2,
                            borderColor:"#1667c4",
                            backgroundColor:"#1667c4",
                            borderWidth:2,
                            fill:"No"
                        }]
                    },
                    options: {
                    // responsive: false,
                        legend: {
                            display: true,
                            position: "bottom",
                            labels: {
                                usePointStyle: true,
                            }
                        },
                    /* plugins: {
                            labels: {
                                // render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
                                render: 'percentage'
                            }
                        },*/
                        
                    }
                })
            }
            
        }    
        )
    }

    function setDates(daterange){  
        enddate = new Date()
        startdate=new Date()
        switch (daterange) {
            case "today":
                startdate= startdate.setDate(enddate.getDate())
                break;
            case "week":
                startdate= startdate.setDate(enddate.getDate() -7 )
                break;
            case "month":
                startdate=startdate.setDate(enddate.getDate() -30 )
                break;
            case "year":
                startdate=startdate.setDate(enddate.getDate() -365)
                break;
            default:
                break;
        }
        startdate=formatdate(startdate)
        enddate=formatdate(enddate)
    }

    function formatdate(date){
        const months = ["JAN", "FEB", "MAR","APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        let current_datetime = new Date(date)
        let formatted_date = current_datetime.getDate() + "-" + months[current_datetime.getMonth()] + "-" + current_datetime.getFullYear()
        return formatted_date
    }

    function getdashboardheader(){
        setDates("today")
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getdashboardheader:true,
                date:enddate
            },
            function(data){
                activecustomersplaceholder.html($.number(data[0].activecustomers,0))
                openreceivablesplaceholder.html($.number(data[0].openreceivables,0))
                openpayablesplaceholder.html($.number(data[0].openpayables,0))
                openpurchaseorderplaceholder.html($.number(data[0].openorders,0))
            }
        )
    }
})