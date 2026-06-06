$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        generatebutton=$("#generate"),
        errordiv=$("#errors"),
        trialbalance=$("#report")

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
        var errors = ""
        if(startdatefield.val()==""){
            errors=showAlert("error", "Please provide start date");
        }else if(enddatefield.val()==""){
            errors=showAlert("error", "Please provide end date");
        }else{
            startdate=startdatefield.val()
            enddate=enddatefield.val()
        }
        
        if(errors==""){
            errordiv.html(showAlert("progress", "Processing ...."))
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    gettrialbalance:true,
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){
                    if(data.length==0){
                        var results=showAlert("info", "Sorry, No data matching filter criteria provided.");
                        trialbalance.html(results)
                        errordiv.html("")
                    }else{
                        var results="<table class='table table-sm table-striped'><thead><th>Account</th><th class='text-right'>Debit</th><th class='text-right'>Credit</th></thead><tbody>"
                        for(var i=0;i<data.length;i++){
                            if(data[i].accountname=="TOTAL"){
                                results+="</tbody><tfoot><th>"+data[i].accountname+"</th>"
                                results+="<th class='text-right'>"+$.number(data[i].debit,2)+"</th>"
                                results+="<th class='text-right'>"+$.number(data[i].credit,2)+"</th></tfoot></table>"
                            }else{
                                results+="<tr><td>"+data[i].accountname+"</td>"
                                parseFloat(data[i].debit)? results+="<td class='text-right'>"+$.number(data[i].debit,2)+"</td>": results+="<td class='text-right'>&nbsp;</td>"
                                parseFloat(data[i].credit)? results+="<td class='text-right'>"+$.number(data[i].credit,2)+"</td></tr>": results+="<td class='text-right'>&nbsp;</td></tr>"
                            }
                        }
                        trialbalance.html(results)
                        errordiv.html("")
                    }
                }
            ).fail(function(jqXHR, textStatus, errorThrown) {
                errordiv.html(showAlert("error", "Sorry, an error occurred: " + textStatus));
            })
        }else{
            errordiv.html(errors)
        }
    })
})