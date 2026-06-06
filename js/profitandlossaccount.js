$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        generatebutton=$("#generate"),
        errordiv=$("#errors"),
        profitandlossaccount=$("#report"),
        sales=0,openingstock=0,closingstock=0,purchases=0

    // assign date control datepickers
    startdatefield.datepicker({
        dateFormat: 'dd-M-yy',
        maxDate: new Date()
    })
    enddatefield.datepicker({
        dateFormat: 'dd-M-yy',
        maxDate: new Date()
    })

    generatebutton.on("click",function(){
        console.log("clicked")
        var errors=""
        if(startdatefield.val()==""){
            errors=showAlert("error", "Please select start date");
        }else if(enddatefield.val()==""){
            errors=showAlert("error", "Please select end date");
        }else{
            startdate=startdatefield.val()
            enddate=enddatefield.val()
        }
        if(errors==""){
            errordiv.html(showAlert("progress", "Processing ..."))
            var results="", totalincome=0, totalexpenses=0, grossprofit=0, costofgoodssold=0, netprofit=0
            getProfitAndLossAccountHeader(startdate,enddate).done(function(){
                // add the sales collumn
                results="<table class='table table-sm table-striped'><tr><td colspan='4' class='font-weight-bold text-uppercase'>REVENUES</td></tr>"
                results+="<tr><td>&nbsp;</td><td>Sales</td><td class='text-right'>"+$.number(sales,2)+"</td><td>&nbsp;</td></tr>"
                totalincome=sales
                // get profit and loss account body
                $.getJSON(
                    "../controllers/reportoperations.php",
                    {
                        getprofitandlossaccountdetails:true,
                        startdate:startdate,
                        enddate:enddate
                    },
                    function(data){
                        for (var i=0;i<data.length;i++){
                            if(data[i].classname==='Income'){
                                totalincome+=parseFloat(data[i].amount)
                                results+="<tr><td>"+data[i].accountcode+"</td><td>"+data[i].accountname+"</td><td class='text-right'>"+$.number(data[i].amount,2)+"</td><td>&nbsp;</td></tr>"
                            }
                        }
                        // sum up total revenue
                        results+="<tr class='font-weight-bold'><td>TOTAL REVENUE</td><td>&nbsp;</td><td>&nbsp;</td><td class='text-right'>"+$.number(totalincome,2)+"</td></tr>"
                        // add opening stock
                        results+="<tr><td>&nbsp;</td><td>Opening Stock</td><td class='text-right'>"+$.number(openingstock,2)+"</td><td>&nbsp;</td></tr>"
                        // add purchases
                        results+="<tr><td>&nbsp;</td><td>Add Purchases</td><td class='text-right'>"+$.number(purchases,2)+"</td><td>&nbsp;</td></tr>"
                        // less closing stock and cost of goods sold
                        costofgoodssold=parseFloat(openingstock)+parseFloat(purchases)-parseFloat(closingstock)
                        results+="<tr><td>&nbsp;</td><td>Less Closing Stock</td><td class='text-right'>("+$.number(closingstock,2)+")</td><td class='text-right'>"+$.number(costofgoodssold,2)+"</td></tr>"
                        // compute gross profit
                        grossprofit=parseFloat(totalincome)-parseFloat(costofgoodssold)
                        results+="<tr class='font-weight-bold'><td>&nbsp;</td><td>GROSS PROFIT</td><td>&nbsp;</td><td class='text-right'>"+$.number(grossprofit,2)+"</td></tr>"
                        results+="<tr class='font-weight-bold'><td>LESS EXPENSES</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                        // add all the expenses
                        for (var i=0;i<data.length;i++){
                            if(data[i].classname==='Expense'){
                                totalexpenses+=parseFloat(data[i].amount)
                                results+="<tr><td>"+data[i].accountcode+"</td><td>"+data[i].accountname+"</td><td class='text-right'>"+$.number(data[i].amount,2)+"</td><td>&nbsp;</td></tr>"
                            }
                        }
                        // sum up all expenses
                        results+="<tr class='font-weight-bold'><td>TOTAL EXPENSES</td><td>&nbsp;</td><td>&nbsp;</td><td class='text-right'>"+$.number(totalexpenses,2)+"</td></tr>"
                        netprofit=parseFloat(grossprofit)-parseFloat(totalexpenses)
                        results+="<tr class='font-weight-bold'><td>&nbsp;</td><td>NET PROFIT</td><td>&nbsp;</td><td class='text-right'>"+$.number(netprofit,2)+"</td></tr>"
                        results+="</table>"
                        profitandlossaccount.html(results)
                        errordiv.html("")
                    }
                ).fail(function(jqXHR, textStatus, errorThrown) {
                    errordiv.html(showAlert("error", "Sorry, an error occurred: " + textStatus));
                })
            }).fail(function() {
                errordiv.html(showAlert("error", "Sorry, an error occurred while fetching headers."));
            })
        }else{
            errordiv.html(errors)
        }
    })

    function getProfitAndLossAccountHeader(startdate,enddate){
        var dfd= new $.Deferred()
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getprofitandlossaccountheaders:true,
                startdate:startdate,
                enddate:enddate
            },
            function(data){
                sales=data[0].sales
                purchases=data[0].purchases
                closingstock=data[0].closingstock
                openingstock=data[0].openingstock
                dfd.resolve()
            }
        ).fail(function() {
            dfd.reject()
        })
        return dfd.promise()
    }
})