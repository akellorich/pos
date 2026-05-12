$(document).ready(function(){
    var startdatefield=$("#startdate"),
        searchbutton=$("#search"),
        report=$("#report"),
        errordiv=$("#errors")


    // assign date picker to date fields
    startdatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})
    searchbutton.on("click",function(){
        if(startdatefield.val()==""){
            errors="<p class='alert alert-danger'>Please provide the base date first</p>"
            errordiv.html(errors)
        }else{
            errordiv.html("<p class='alert alert-info'>Processing ...</p>")
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getaccountspayableaginganalysis:true,
                    basedate:startdatefield.val()
                },
                function(data){
                    console.log(data.toString())
                    if(data.length==0){
                        results="<p class='alert alert-info alert-sm'>Sorry no aging available for filter options provided.</p>"
                    }else{
                        // initialize the table
                        results="<table class='table table-striped table-sm'><thead><th>Supplier Name</th><th>1-30</th><th>31-60</th><th>61-90</th><th>91-120</th><th>120+</th><th>TOTAL</th></thead>"
                       for(var i=0;i<data.length;i++){
                            results+="<tr><td>"+data[i].suppliername+"</td>"
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
            )
        }
    })
})