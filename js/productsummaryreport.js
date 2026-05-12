$(document).ready(function(){
    const startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        searchbutton=$("#search"),
        alldates=$("#alldates"),
        errordiv=$("#errors"),
        report=$("#report"),
        reportdetails=$("#reportdetails"),
        reportnamefield=$("#reportname")
    
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)
    
    alldates.on("click",function(){
       if(alldates.prop("checked")) {
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
       }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
       }
    })

    searchbutton.on("click",function(){
        var startdate,enddate, 
            errors="", 
            reportname=reportnamefield.val()

        // errordiv1.html("")
        if(reportname==""){
            errors="Please select report to display"
            reportnamefield.focus()
        }else if(alldates.prop('checked')){
            startdate='01-Jan-2000'
            enddate='31-dec-2100'
        }else{
            // check if dates have been provided
            if(startdatefield.val()==""){
                errors="Please provide start date"
            }else if(enddatefield.val()==""){
                errors="Please provide end date"
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        } 

        //console.log(errors)
        if(errors==""){
            errordiv.html("")
            const productreport=reportname=="purchases"?`getproductpurchasessummary`:`getproductsalessummary`
            // paymentmode=paymentmodelist.val()
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    productreport,
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){
                    reportdetails.find("thead th").eq(3).html(reportname=="purchases"?"Buying Price":"Selling Price")
                    data=data.map(item => {
                        return {
                            ...item,
                            unitprice: $.number(parseFloat(item.unitprice), 2), 
                            quantity: $.number(parseFloat(item.quantity), 2),
                            total: $.number(parseFloat(item.total), 2)
                        }
                    })
                    json2table(reportdetails,data)
                    // results+='</tbody></table>'
                    errordiv.html("")   
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })

    reportnamefield.on("change",()=>{
        errordiv.html("")
    })

   
})