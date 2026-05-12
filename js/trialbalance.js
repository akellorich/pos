$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        generatebutton=$("#generate"),
        errordiv=$("#errors"),
        trialbalance=$("#report")

        startdatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})
        enddatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})

        generatebutton.on("click",function(){
            if(startdatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide start date</p>"
            }else if(enddatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide end date</p>"
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
                errors=""
            }
            console.log(errors)
            if(errors==""){
                errordiv.html("<p class='alert alert-info>Processing ....</p>")
                $.getJSON(
                    "../controllers/reportoperations.php",
                    {
                        gettrialbalance:true,
                        startdate:startdate,
                        enddate:enddate
                    },
                    function(data){
                        var results="<table class='table table-sm table-striped'><thead><th>Account</th><th class='text-right'>Debit</th><th class='text-right'>Credit</th></thead><tbody>"
                        for(var i=0;i<data.length;i++){
                            if(data[i].accountname=="TOTAL"){
                                results+="</tbody><tfoot><th>"+data[i].accountname+"</th>"
                                results+="<th class='text-right'>"+$.number(data[i].debit,2)+"</th>"
                                results+="<th  class='text-right'>"+$.number(data[i].credit,2)+"</th></tfoot></table>"
                            }else{
                                results+="<tr><td>"+data[i].accountname+"</td>"
                                parseFloat(data[i].debit)? results+="<td class='text-right'>"+$.number(data[i].debit,2)+"</td>":  results+="<td class='text-right'>&nbsp;</td>"
                                parseFloat(data[i].credit)? results+="<td  class='text-right'>"+$.number(data[i].credit,2)+"</td></tr>":  results+="<td class='text-right'>&nbsp;</td></tr>"
                            }
                           
                        }
                        trialbalance.html(results)
                        errordiv.html("")
                    }
                )
            }else{
                errordiv.html(errors)
            }
        })
})