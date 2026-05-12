$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        alldates=$("#alldates"),
        glaccountlist=$("#glaccount"),
        searchbutton=$("#search"),
        errordiv=$("#errors"),
        glstatement=$("#results"),
        errors=""
        // assign date control datepickers
    startdatefield.datepicker({maxDate: new Date()})
    enddatefield.datepicker({maxDate: new Date()})
    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }
    })

    // get all ledger accounts
    getGLAccounts(glaccountlist,0,option='one')
    
    searchbutton.on("click",function(){
        var  results='', runningbalance=0
        errors=''
        if(alldates.prop("checked")){
            startdate='01-Jan-2019'
            enddate='31-Dec-2100'
        }else{
            if(startdatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide start date first</p>"
            }else{
                startdate=startdatefield.val()
            }
            if(enddatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide end date first</p>"
            }else{
                enddate=enddatefield.val()
            }
        }

        if(glaccountlist.val()==""){
            errors="<p class='alert alert-danger'>Please select a GL account first</p>"
        }else{
            glaccount=glaccountlist.val()
        }
        console.log(errors)
        
        if(errors!=""){
            errordiv.html(errors)
        }else{
            errordiv.html("<p class='alert alert-info'>Processing ...</p>")
            glstatement.html("")
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getglstatement:true,
                    startdate:startdate,
                    enddate:enddate,
                    accountid:glaccount
                },
                function(data){
                    if(data.length==0){
                        results="<p class='alert alert-info'>Sorry, No data matching filter criteria provided.</p>"
                    }else{
                        runningbalance=parseFloat(data[0].openingbalance)
                        results="<table class='table table-sm'><tr>"
                        results+="<td> Account #: <span class='font-weight-bold'>"+data[0].accountcode+"</span></td>"
                        results+="<td class='text-right'> Opening Balance: <span class='font-weight-bold'>"+$.number(data[0].openingbalance,2)+"</span></td></tr>"
                        results+="<tr><td> Account Name: <span class='font-weight-bold'>"+data[0].accountname+"</span></td>"
                        results+="<td class='text-right'> Debits: <span class='font-weight-bold'>"+$.number(data[0].debits,2)+"</span></td></tr>"
                        results+="<tr><td> Account Category: <span class='font-weight-bold'>"+data[0].classname+"</span></td>"
                        results+="<td class='text-right'> Credits: <span class='font-weight-bold'>"+$.number(data[0].credits,2)+"</span></td></tr>"
                        results+="<tr><td>&nbsp;</td>"
                        results+="<td class='text-right'> Closing Balance: <span class='font-weight-bold'>"+$.number(data[0].closingbalance,2)+"</span></td></tr></table>"

                        results+="<table class='table table-striped table-sm'><thead><th>Date</th><th>Reference</th><th>Narrative</th><th>Added By</th><th>Debit</th><th>Credit</th><th>Balance</th><thead>"
                        results+="<tbody>"
                        
                        for(var i=0; i<data.length;i++){
                            runningbalance+=parseFloat(data[i].debit)-parseFloat(data[i].credit)
                            results+="<tr><td>"+data[i].transactiondate+"</td>"
                            results+="<td>"+data[i].referenceno+"</td>"
                            results+="<td>"+data[i].narration+"</td>"
                            results+="<td>"+data[i].addedby+"</td>"
                            results+="<td class='text-right'>"+$.number(data[i].debit,2)+"</td>"
                            results+="<td class='text-right'>"+$.number(data[i].credit,2)+"</td>"
                            results+="<td class='text-right'>"+$.number(runningbalance,2)+"</td></tr>"
                        }

                        results+="</tbody></table>"
                    }
                    
                    glstatement.html(results)
                    errordiv.html("")
                }
            )
        }
    })
})