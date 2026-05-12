$(document).ready(function(){
    var daterangefilter=$("#daterange"),
    salesbyvaluechart=$("#salesbyvalue"),
    salesbypaymentmodechart=$("#salesbypaymentmethod"),
    salesbyquantitychart=$("#salesbyquantity"),
    bestsellingproduct=$("#bestsellingproduct"),
    totalsales=$("#totalsales"),
    homebutton=$("#mainmenubutton"),
    dailybutton=$("#daily"),
    weeklybutton=$("#weekly"),
    monthlybutton=$("#monthly")
    //daterangefilter.center()

    homebutton.on("click",function(){
        window.location.href="main.php"
    })

    dailybutton.on("click",function(){
        getSalesByValue("today")
        getsalesbypaymentmethod("today")
        getSalesByQuantity("today")
        getbestsellingproduct("today")
        getExpandedSalesByPaymentMethod("today")   
        dailybutton.addClass("ui-btn-b") 
        weeklybutton.removeClass("ui-btn-b")
        monthlybutton.removeClass("ui-btn-b")
    })

    weeklybutton.on("click",function(){
        getSalesByValue("week")
        getsalesbypaymentmethod("week")
        getSalesByQuantity("week")
        getbestsellingproduct("week")
        getExpandedSalesByPaymentMethod("week")
        dailybutton.removeClass("ui-btn-b") 
        weeklybutton.addClass("ui-btn-b")
        monthlybutton.removeClass("ui-btn-b")

    })

    monthlybutton.on("click", function(){
        getSalesByValue("month")
        getsalesbypaymentmethod("month")
        getSalesByQuantity("month")
        getbestsellingproduct("month")
        getExpandedSalesByPaymentMethod("month")
        dailybutton.removeClass("ui-btn-b") 
        weeklybutton.removeClass("ui-btn-b")
        monthlybutton.addClass("ui-btn-b")
    
    })

    // make the daily button active
    dailybutton.addClass("ui-btn-b") 
    //get summary of sales by value
    getSalesByValue("today")
    getsalesbypaymentmethod("today")
    getSalesByQuantity("today")
    getbestsellingproduct("today")
    getExpandedSalesByPaymentMethod("today")

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

        $.getJSON("../../controllers/reportoperations.php",
        {
            getsalestrend:true,
            startdate:startdate,
            enddate:enddate,
            range:range,
            all:0
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
  
    function getsalesbypaymentmethod(daterange){
        setDates(daterange)

        var labels=[],
            salesdata=[]
            backcolour=[]
      
        $.getJSON("../../controllers/reportoperations.php",
        {
            getsalesbypaymentmode:true,
            startdate:startdate,
            enddate:enddate,
            all:0
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
    
                window.salesbypaymentmodechart = new Chart(salesbypaymentmodechart, {
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

        $.getJSON("../../controllers/reportoperations.php",
        {
            getsalesbyquantity:true,
            startdate:startdate,
            enddate:enddate,
            range:range,
            all:0
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

                window.salesbyquantitychart = new Chart(salesbyquantitychart, {
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

    function getbestsellingproduct(daterange){
        setDates(daterange)
        $.getJSON(
            "../../controllers/reportoperations.php",
            {
                getbestsellingproduct:true,
                startdate:startdate,
                enddate:enddate,
                all:0
            },
            function(data){
                if(data.length>0){
                    // generate the best product first
                    var results="<div class='row'>"
                    results+="<div class='col'><span >"+data[0].itemname+"</span><p class='small'>"+data[0].categoryname+"</p></div>"
                    results+="<div class='col'><span >"+$.number(parseFloat(data[0].quantity*data[0].unitprice),0)+"</span><p class='small'>Total Sale</p></div>"
                    results+="<div class='col'><span >"+$.number(data[0].quantity,2)+"</span><p class='small'>Quantity</p></div>"
                    results+="</div>"
                    results+="<table class='table table-sm'>"
                    results+="<thead class='small'><th>Product</th><th>Price</th><th>Qty</th><th>Total</th></thead>"
                    results+="<tbody>"
                    for(var i=1;i<data.length;i++){
                        results+="<tr class='small'><td>"+data[i].itemname+"</td>" 
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

    function getExpandedSalesByPaymentMethod(daterange){
        setDates(daterange)
        $.getJSON(
            "../../controllers/reportoperations.php",
            {
                geteaxpanedesalesbypaymentmethod:true,
                startdate:startdate,
                enddate:enddate,
                all:0
            },
            function(data){
                if(data.length>0){
                    // generate the best product first
                    /*var results="<div class='row'>"
                    results+="<div class='col'><span >"+data[0].itemname+"</span><p class='small'>"+data[0].categoryname+"</p></div>"
                    results+="<div class='col'><span >"+$.number(parseFloat(data[0].quantity*data[0].unitprice),0)+"</span><p class='small'>Total Sale</p></div>"
                    results+="<div class='col'><span >"+$.number(data[0].quantity,2)+"</span><p class='small'>Quantity</p></div>"
                    results+="</div>"*/
                    var results="", total=0, totalcount=0
                    results+="<table class='table table-sm'>"
                    results+="<thead class='small'><th>Payment Mode</th><th class='text-center'>Count</th><th class='text-right'>Total</th></thead>"
                    results+="<tbody>"
                    for(var i=0;i<data.length;i++){
                        results+="<tr class='small'><td>"+data[i].paymentmode+"</td>" 
                        results+="<td class='text-center'>("+$.number(data[i].appears,0)+")</td>" 
                        results+="<td class='text-right'>"+$.number(data[i].amount,2)+"</td></tr>" 
                        total+=parseFloat(data[i].amount)
                        totalcount+=1
                    }

                    results+="</tbody>"
                    results+="<tfoot class='small'>"
                    results+="<td>TOTAL:</td>"
                    results+="<td class='text-center'>("+ $.number(totalcount,0)+")</td>"
                    results+="<td class='text-right'>"+$.number(total,2)+"</td></tfoot>"
                    results+="</table>"
            
                    totalsales.html(results)
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


})