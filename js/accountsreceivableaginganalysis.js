$(document).ready(function(){
    var startdatefield=$("#startdate"),
        searchbutton=$("#search"),
        report=$("#report"),
        errordiv=$("#errors")

    // Set default value to today's date in dd-mmm-yyyy format
    startdatefield.val(todaysDate());

    // assign date picker to date fields
    startdatefield.datepicker({
        dateFormat: 'dd-M-yy',
        maxDate: new Date()
    })

    searchbutton.on("click",function(){
        if(startdatefield.val()==""){
            errordiv.html(showAlert("error", "Please provide the base date first"));
        }else{
            errordiv.html(showAlert("progress", "Processing ..."));
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getaccountsreceivableaginganalysis:true,
                    basedate:startdatefield.val()
                },
                function(data){
                    if(data.length==0){
                        var results=showAlert("info", "Sorry no aging available for filter options provided.");
                        report.html(results)
                        errordiv.html("")
                    }else{
                        // initialize the table
                        var results="<table class='table table-striped table-sm'><thead><th>Customer Name</th><th>1-30</th><th>31-60</th><th>61-90</th><th>91-120</th><th>120+</th><th>TOTAL</th></thead>"
                        for(var i=0;i<data.length;i++){
                            results+="<tr><td>"+data[i].customername+"</td>"
                            results+="<td>"+$.number(data[i].thirty)+"</td>"
                            results+="<td>"+$.number(data[i].sixty)+"</td>"
                            results+="<td>"+$.number(data[i].ninety)+"</td>"
                            results+="<td>"+$.number(data[i].onetwenty)+"</td>"
                            results+="<td>"+$.number(data[i].aboveonetwenty)+"</td>"
                            results+="<td>"+$.number(data[i].total)+"</td></tr>"
                        }
                        results+="</table>"
                        report.html(results)
                        errordiv.html("")
                    }
                }
            ).fail(function(jqXHR, textStatus, errorThrown) {
                errordiv.html(showAlert("error", "Sorry, an error occurred: " + textStatus));
            })
        }
    })
})