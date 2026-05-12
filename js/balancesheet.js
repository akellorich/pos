$(document).ready(function(){
    var startdatefield=$("#startdate"),
    enddatefield=$("#enddate"),
    generatebutton=$("#generate"),
    errordiv=$("#errors"),
    balancesheet=$("#report")

    startdatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})
    enddatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})

    generatebutton.on("click",function(){
        console.log("clicked")
        var errors=""
        if(startdatefield.val()==""){
            errors="<p class='alert alert-danger'>Please select start date</p>"
        }else if(enddatefield.val()==""){
            errors="<p class='alert alert-danger'>Please select end date</p>"
        }else{
            startdate=startdatefield.val()
            enddate=enddatefield.val()
        }
        if(errors==""){
            errordiv.html("<p class='alert alert-info'>Processing ...</p>")
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getbalancesheet:true,
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){
                    if(data.length>0){
                        var results="<table class='table table-sm'><tr><td colspan='2' class='font-weight-bold text-uppercase'>"+data[0].classname+"s</td></tr>",
                            groupname=data[0].groupname,
                            classname=data[0].classname,
                            grouptotal=0,
                            classtotal=0
                            results+="<tr><td colspan='2' class='font-weight-bold text-uppercase'>&nbsp;&nbsp;&nbsp;&nbsp;"+data[0].groupname+"</td<</tr>"
                        for (var i=0;i<data.length;i++){
                            if(data[i].classname==classname){
                                if(data[i].groupname==groupname){
                                    results+="<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].accountcode +" - "+data[i].accountname+"</td>"
                                    results+="<td  class='text-right'>"+$.number(+data[i].total,2)+"</td></tr>"
                                    grouptotal+=parseFloat(data[i].total)
                                    classtotal+=parseFloat(data[i].total)
                                }else{
                                    // perform total for group
                                    results+="<tr class='font-weight-bold'><td>&nbsp;</td><td  class='text-right'>"+$.number(grouptotal,2)+"</td></tr>"
                                    // add the new group name
                                     results+="<tr><td colspan='2' class='font-weight-bold text-uppercase'>&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].groupname+"</td<</tr>"
                                    //add the new ledger item
                                    results+="<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].accountcode +" - "+data[i].accountname+"</td>"
                                    results+="<td  class='text-right'>"+$.number(+data[i].total,2)+"</td></tr>"
                                    // reset total
                                    grouptotal=0
                                    // change group name 
                                    groupname=data[i].groupname
                                    // perform class total
                                    classtotal+=parseFloat(data[i].total)
                                }
                            }else{
                                // perform group total 
                                results+="<tr class='font-weight-bold'><td>&nbsp;</td><td  class='text-right'>"+$.number(grouptotal,2)+"</td></tr>"
                                // add class totals row
                                results+="<tr class='font-weight-bold text-uppercase'><td>TOTAL "+classname+"</td><td  class='text-right'>"+$.number(classtotal,2)+"</td></tr>"
                                // add the new class
                                results+="<tr><td colspan='2' class='font-weight-bold text-uppercase'>"+data[i].classname+"s</td></tr>"
                                // add new group
                                results+="<tr><td colspan='2' class='font-weight-bold text-uppercase'>&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].groupname+"</td<</tr>"
                                // add the new gl item
                                results+="<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].accountcode +" - "+data[i].accountname+"</td>"
                                results+="<td  class='text-right'>"+$.number(+data[i].total,2)+"</td></tr>"
                                // reset group total
                                grouptotal= parseFloat(data[i].total)
                                // reset class total
                                classtotal=parseFloat(data[i].total)
                                // change group name variable
                                groupname=data[i].groupname
                                // change classname variable
                                classname=data[i].classname
                            }
                        }
                        // output total the last group in the result set
                        results+="<tr class='font-weight-bold'><td>&nbsp;</td><td  class='text-right'>"+$.number(grouptotal,2)+"</td></tr>"
                        // output total for the last class in the result set
                        results+="<tr class='font-weight-bold text-uppercase'><td>TOTAL "+classname+"</td><td  class='text-right'>"+$.number(classtotal,2)+"</td></tr>"
                        console.log(results)
                        balancesheet.html(results)
                        errordiv.html("")
                    }else{
                        balancesheet.html("<p class='alert alert-info'>Sorry. No Records matching filter criteria</p>")
                    }
                }
            )
        }else{
            errordiv.html(errors)
        }
    })
})