$(document).ready(function(){
    const startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        searchbutton=$("#search"),
        alldates=$("#alldates"),
        errordiv=$("#errors"),
        report=$("#report"),
        reportdetails=$("#reportdetails"),
        reportnamefield=$("#reportname");
    
    startdatefield.datepicker({maxDate: new Date(), dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({maxDate: new Date(), dateFormat: 'dd-M-yy'})

    // Helper to format date as dd-M-yy (e.g. 02-Jun-2026)
    function formatDate(date) {
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var day = date.getDate();
        var month = months[date.getMonth()];
        var year = date.getFullYear();
        if (day < 10) day = '0' + day;
        return day + '-' + month + '-' + year;
    }

    // Set default filter to last 24 hours
    var today = new Date();
    var yesterday = new Date(Date.now() - 86400000);

    alldates.prop("checked", false);
    startdatefield.prop("disabled", false).val(formatDate(yesterday));
    enddatefield.prop("disabled", false).val(formatDate(today));
    
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

    // Pre-select Sales report and trigger programmatic search on load
    reportnamefield.val("sales");
    searchbutton.trigger('click');
})