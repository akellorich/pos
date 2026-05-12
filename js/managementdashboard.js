$(document).ready(()=>{
    const salesreport=$("#salesreport")
    const stockreport=$("#stockreport")
    const reportdate=$("#daterange")
    const filterbutton=$("#generatereport")
    const suppliersreport=$("#suppliersreport")
    const customersreport=$("#customersreport")
    const expensesreport=$("#expensesreport")
    const bankingsreport=$("#bankingsreport")
    const grossprofitlocation=$("#grossprofit")
    const cratesummary=$("#cratesummary")
    const spoilagereport=$("#spoilagereport")

    let sales, openingstock, closingstock,purchases

    filterbutton.on("click",()=>{
        let daterange=reportdate.val()
        let enddate = new Date(),
            startdate=new Date()

        switch (daterange) {
            case "today":
                startdate= startdate.setDate(enddate.getDate())
                daterange="day"
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
        // get sales report 
        getsalesreport(startdate,enddate).done(()=>{
            //get stock report
            getstockbalances(startdate,enddate) 
            // compute gross profit
            getgrossprofit(startdate,enddate)
        })
       
        // get suppliers / creditors report
        getsuppliersreport(enddate)
        // get debtors report
        getcustomersreport(enddate)
        // get expenses report
        getexpensesreport(startdate,enddate)
        // get bankings report
        getbankings(startdate,enddate)
        // get crate summary
        getcratesummary(enddate)
        // get spoilage report
        getspoilagereport(startdate,enddate)
    })

    function formatdate(date){
        const months = ["JAN", "FEB", "MAR","APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        let current_datetime = new Date(date)
        let formatted_date = current_datetime.getDate() + "-" + months[current_datetime.getMonth()] + "-" + current_datetime.getFullYear()
        return formatted_date
    }

    function getsalesreport(startdate,enddate){
        let dfd=new $.Deferred()
        $.getJSON("../controllers/reportoperations.php",
            {
                getsalesbypaymentmode:true,
                startdate:startdate,
                enddate:enddate
            },
            function(data){
                // console.log(data)
                let results=""
                let counter=0
                let total=0
                data.forEach(({paymentmode,amount})=>{
                    counter++
                    results+=`<tr><td>${counter}</td>`
                    results+=`<td>${paymentmode}</td>`
                    results+=`<td class='text-right'>${$.number(amount,2)}</td></tr>`
                    total+=Number(amount)
                })
                // console.log(results)
                sales=total
                results+=`<tr><td colspan='2'><strong>TOTAL</strong></td><td class='text-right'><strong>${$.number(total,0)}</strong></td><tr>`
                salesreport.html(results)
                dfd.resolve()
            }    
        )
        return dfd.promise()
    }

    function getstockbalances(startdate,enddate){
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getprofitandlossaccountheaders:true,
                startdate:startdate,
                enddate:enddate
            },
            function(data){
                let results="",
                    // sales=data[0].sales,
                    purchases=data[0].purchases,
                    closingstock=data[0].closingstock,
                    openingstock=data[0].openingstock

                results+=`<tr><td>Opening Stock</td><td class='text-right'>${$.number(openingstock,0)}</td></tr>`
                results+=`<tr><td>Purchases</td><td class='text-right'>${$.number(purchases,0)}</td></tr>`
                results+=`<tr><td>Sales</td><td class='text-right'>${$.number(sales,0)}</td></tr>`
                results+=`<tr><td>Closing Stock</td><td class='text-right'>${$.number(closingstock,0)}</td></tr>`
                stockreport.html(results)
            }
        )
    }

    function getsuppliersreport(enddate){
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getaccountspayableaginganalysis:true,
                basedate:enddate
            },
            function(data){
                let counter=0
                let results=""
                for(var i=0;i<data.length;i++){
                    counter++
                    
                    if(data[i].suppliername=="TOTAL"){
                        results+=`<tr><td colspan='2'>${data[i].suppliername}</td>` 
                        results+=`<td class='text-right'>${$.number(data[i].total)}</td></tr>`
                    }else{
                        if(Number(data[i].total)>0){
                            results+=`<tr><td>${counter}` 
                            results+=`<td>${data[i].suppliername}</td>`
                            results+=`<td class='text-right'>${$.number(data[i].total)}</td></tr>`
                        }
                    }
                }
                suppliersreport.html(results)
            }
        )
    }

    function getcustomersreport(enddate){
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getaccountsreceivableaginganalysis:true,
                basedate:enddate
            },
            function(data){
                let counter=0
                let results=""
                for(var i=0;i<data.length;i++){
                    counter++
                    
                    if(data[i].customername=="TOTAL"){
                        results+=`<tr><td colspan='2'>${data[i].customername}</td>` 
                        results+=`<td class='text-right'>${$.number(data[i].total)}</td></tr>`
                    }else{
                        if(Number(data[i].total)>0){
                            results+=`<tr><td>${counter}` 
                            results+=`<td>${data[i].customername}</td>`
                            results+=`<td class='text-right'>${$.number(data[i].total)}</td></tr>`
                        }
                        
                    }
                }
                customersreport.html(results)
            }
        )
    }

    function getexpensesreport(startdate,enddate){
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getprofitandlossaccountdetails:true,
                startdate:startdate,
                enddate:enddate
            },
            function(data){
                let results=""
                let totalexpenses=0
                
                for (var i=0;i<data.length;i++){
                    if(data[i].classname==='Expense'){
                        totalexpenses+=parseFloat(data[i].amount)
                        results+=`"<tr><td>${Number(i+1)}</td><td>${data[i].accountcode} - ${data[i].accountname}</td><td class='text-right'>${$.number(data[i].amount,0)}</td></tr>"`
                    }
                }

                results+=`<tr><td colspan='2'>Total</td><td class='text-right'>${$.number(totalexpenses,0)}</td></tr>`
                // console.log(results)
                expensesreport.html(results)

            }
        )
    }

    function getbankings(startdate,enddate){
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getcashbookdebits:true,
                startdate,
                enddate
            },
            function(data){
                let results=""
                let totaldebits=0
                for(var i=0;i<data.length;i++){
                    results+=`<tr><td>${Number(i+1)}</td>`
                    results+=`<td>${data[i].accountcode} - ${data[i].accountname}</td>`
                    results+=`<td class='text-right'>${$.number(data[i].debits)}</td></tr>`
                    totaldebits+=Number(data[i].debits)
                }
                results+=`<tr><td colspan='2'>TOTAL</td><td class='text-right'>${$.number(totaldebits,0)}</td></tr>`
                bankingsreport.html(results)
            }
        )
    }

    function getgrossprofit(startdate,enddate){
        let results="", totalincome=0, totalexpenses=0, grossprofit=0, costofgoodssold=0, netprofit=0
        // console.log(sales)
        getProfitAndLossAccountHeader(startdate,enddate).done(function(){
            // totalincome=sales
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getprofitandlossaccountdetails:true,
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){
                //    /*  */ console.log(data)
                    // for (var i=0;i<data.length;i++){
                    //     if(data[i].classname==='Income'){
                    //         totalincome+=parseFloat(data[i].amount)
                    //         results+="<tr><td>"+data[i].accountcode+"</td><td>"+data[i].accountname+"</td><td class='text-right'>"+$.number(data[i].amount,2)+"</td><td>&nbsp;</td></tr>"
                    //     }
                    // }
                    costofgoodssold=parseFloat(openingstock)+parseFloat(purchases)-parseFloat(closingstock)
                    grossprofit=parseFloat(sales)-parseFloat(costofgoodssold)
                    results+=`<tr><td>Sales</td><td  class='text-right'>${$.number(sales)}</td></tr>`
                    results+=`<tr><td>Cost of Goods Sold</td><td   class='text-right'>${$.number(costofgoodssold)}</td></tr>`
                    results+=`<tr><td>Gross Profit</td><td  class='text-right'>${$.number(grossprofit)}</td></tr>` 
                    grossprofitlocation.html(results)
                }
            )
        })
    }

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
                // sales=data[0].sales
                purchases=data[0].purchases
                closingstock=data[0].closingstock
                openingstock=data[0].openingstock
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function getcratesummary(enddate){
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getcratesummary:true,
                asatdate:enddate
            },
            function(data){
                let results=""
                if(data.length>0){
                    results+=`<tr><td>Opening Balance</td><td  class='text-right'>${data[0].openingbalance}</td></tr>`
                    results+=`<tr><td>Purchases</td><td  class='text-right'>${data[0].purchases}</td></tr>`
                    results+=`<tr><td>Sales</td><td  class='text-right'>(${data[0].sales})</td></tr>`
                    results+=`<tr><td>Closing Balance</td><td  class='text-right'>${data[0].closingbalance}</td></tr>`
                }
                cratesummary.html(results);
            }
        )
    }

    function getspoilagereport(startdate,enddate){
        $.getJSON(
            "../controllers/spoilageoperations.php",
            {
                filterspoilage:true,
                startdate,
                enddate,
                categoryid:0,
                productid:0
            },
            (data)=>{
                let results="",counter=0
                data.forEach((spoilage)=>{
                    counter++
                    results+=`<tr><td>${counter}</td>`
                    results+=`<td>${spoilage.categoryname}</td>`
                    results+=`<td>${spoilage.itemname}</td>`
                    results+=`<td>${$.number(spoilage.quantity,2)}</td></tr>`
                })
                // console.log(results)
                // filternotifications.html("")
                spoilagereport.html(results)
            }
        )
    }
})