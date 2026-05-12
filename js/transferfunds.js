$(document).ready(function(){
    var sourceaccountfield=$("#sourceaccount"),
        destinationaccountrfield=$("#destinationaccount"),
        errordiv=$("#errors"),
        transferfundsbutton=$("#transferfunds"),
        referencefield=$("#reference"),
        amountfield=$("#amount"),
        inputfields=$("input"),
        selectfields=$("select")

    getCashbookAccounts(sourceaccountfield,'choose')
    getCashbookAccounts(destinationaccountrfield,'choose')

    transferfundsbutton.on("click",function(){
        var sourceaccount=sourceaccountfield.val(),
            sourceaccountname=sourceaccountfield.children(":selected").text(),
            destinationaccount=destinationaccountrfield.val(),
            destinationaccountname=destinationaccountrfield.children(":selected").text()
            reference=referencefield.val(),
            amount=amountfield.val(),
            errors="",
            tabledata=[],
            journaldescription="Funds transferred from "+sourceaccountname+" to "+destinationaccountname
            tabledata.push({"glaccount":sourceaccount,"narration":"Funds transferred to "+destinationaccountname,"debit":0,"credit":amount})
            tabledata.push({"glaccount":destinationaccount,"narration":"Funds transferred from "+sourceaccountname ,"debit":amount,"credit":0})
        // check for blank fields
        if(sourceaccount==""){
            errors="Please select source account"
            sourceaccountfield.focus()
        }else if(destinationaccount==""){
            errors="Please select destination account"
            destinationaccountrfield.focus()
        }else if(reference==""){
            errors="Please provide transaction reference number"
            referencefield.focus()
        }else if(amount=="" || amount==0){
            errors="Please provide amount to be transferred"
            amountfield.focus()
        }else if(sourceaccount==destinationaccount){
            errors="Source and Destination accounts cannot be the same"
        }

        if(errors==""){
            // save the transfer
            errordiv.html("")
            // generate data into array
            var TableData=JSON.stringify(tabledata),
                url="../controllers/journaloperations.php"
                $.post(
                    url,
                    {
                        savejournal:true,
                        referenceno:reference,
                        description:journaldescription,
                        TableData:TableData
                    },
                    function(data){
                        str=$.trim(data.toString())
                        if(str=="success"){
                            errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i></span> Funds transfer from <strong>"+sourceaccountname+"</strong> to <strong>"+destinationaccountname+"</strong> successful.</p>"
                            errordiv.html(errors)
                            // clear form
                            clearForm()
                        }else{
                            errors="<p  class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                            errordiv.html(errors)
                        }
                    }
                )
        }else{
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> "+errors+"</p>"
            errordiv.html(errors)
        }
    })
    

    //listen to change of input and select boxes to hide error message
    inputfields.on("input",function(){
        errordiv.html("")
    })

   selectfields.on("change",function(){
       errordiv.html("")
   })

   function clearForm(){
       inputfields.val("")
       selectfields.val("")
   }
})