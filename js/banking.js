$(document).ready(function(){
    

    var poslist=$("#pos"),
        paymentmethodlist=$("#paymentmethod"),
        cashbookaccountslist=$("#cashbookaccount"),
        alldates=$("#alldates"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        startdatelabel=$("#startdatelabel"),
        enddatelabel=$("#enddatelabel"),
        errordiv=$("#errors"),
        filterbutton=$("#filterreceipts"),
        pendingreceipts=$("#pendingreceipts"),
        selectall=$("#all"),
        receiptssummary=$("#summary")
        receiptslist=$("#pendingreceipts"),
        postreceipts=$("#bankreceipts"),
        narrationfield=$("#narration"),
        postasfield=$("#postas"),
        referencefield=$("#referenceno"),
        pendingreceiptdetails=$("#pendingreceiptdetails")

    // select all dates by default
    alldates.prop('checked',true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)
    startdatelabel.prop("disabled",true)
    enddatelabel.prop("disabled",true)

    startdatefield.datepicker()
    enddatefield.datepicker()

    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    getPointsOfSale(poslist).done(function(){
        poslist.append("<option value='receipt'>&lt;Customer Receipts&gt;</option>")
    })
    
    getPaymentModes(paymentmethodlist)
    getCashbookAccounts(cashbookaccountslist,option='one')

    alldates.on("click",function(){
       if(alldates.prop('checked')) {
           startdatefield.prop("disabled",true)
           enddatefield.prop("disabled",true)
           startdatelabel.prop("disabled",true)
           enddatelabel.prop("disabled",true)

       }else{
           startdatefield.prop("disabled",false)
           enddatefield.prop("disabled",false)
           startdatelabel.prop("disabled",false)
           enddatelabel.prop("disabled",false)

       }
    })

    filterbutton.on("click",function(){
        var errors=""
        //console.log("clicked")
        if(alldates.prop('checked')){
            startdate='01-Jan-2000'
            enddate='31-dec-2100'
        }else{
            // check if dates have been provided
            if(startdatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide start date </p>"
            }else if(enddatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide end date </p>"
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        }
        //console.log(errors)
        if(errors==""){
            posid=poslist.val()
            paymentmode=paymentmethodlist.val()
            if(posid=='receipt'){
                // get customer receipts not posted
                operation="getposcustomerreceiptsforbanking"
            }else{
                operation="getposreceiptsforbanking"
            }
            $.getJSON(
                "../controllers/possalesoperations.php",
                {
                    operation:operation,
                    paymentmode:paymentmode,
                    posid:posid,
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){
                    var results="",
                        refno=''
                        console.log(data.length)
                    if (data.length==0){
                        // tell the user we didnt find anything 
                        results="<tr><td colspan='10'>No data matching filter criteria found. Please try again</td></tr>"
                    }else{
                    /**/
                        // clear all errors
                        errordiv.html("")
                        // loop through results and output on the table 
                        for(var i=0;i<data.length;i++){
                            data[i].reference==""?refno="-":refno=data[i].reference
                            results+="<tr id='"+data[i].id+"'><td><input type='checkbox' class='checkoption'></td>"
                            results+="<td>"+parseInt(i+1)+"</td>"
                            results+="<td>"+data[i].date+"</td>"
                            results+="<td>"+data[i].posname+"</td>"
                            results+="<td>"+data[i].customername+"</td>"
                            results+="<td>"+data[i].receiptno+"</td>"
                            results+="<td>"+data[i].description+"</td>" 
                            results+="<td>"+refno+"</td>"
                            results+="<td class='text-right font-weight-bold'>"+$.number(data[i].amount,0)+"</td>"
                            results+="<td>"+data[i].addedby+"</td></tr>"
                        }
                        selectall.prop("checked",false)
                    }
                    // getReceiptSummaries()
                    receiptssummary.find(".card-body").html("")
                    //console.log(results)
                    //pendingreceipts.DataTable().destroy() 
                    pendingreceiptdetails.html(results)
                    //pendingreceipts.DataTable().draw()
                    
                    // reset receipt summaries
                }
            )
            
        }else{
            errordiv.html(errors)
        }
    })

    // listen to select all
    selectall.on("click",function(){
        if(selectall.prop("checked")){
            $(".checkoption").prop("checked",true)
            getReceiptSummaries()
        }else{
            $(".checkoption").prop("checked",false)
            receiptssummary.find(".card-body").html("")
        }
    })
    // get users

    // get cash book accounts

    function getReceiptSummaries(){      
        var data = [];
        var paymode='',amount1=0
        var results=''
        var totalnumber=0
        var totalamount=0
        receiptssummary.find("card-body").html("<p>Processing ...</p>")
        $(".checkoption").each(function(){
            if($(this).prop("checked")){
                parent=$(this).parent("td").parent("tr")
                paymode=parent.find("td").eq(6).text()
                amount1=parent.find("td").eq(8).text()
                amount1=amount1.replace(/,/g, '')
                var found=0
                for(var i=0;i<data.length;i++){
                    if(paymode==data[i].paymentmode){  
                        data[i].count=parseInt(data[i].count+1)
                        data[i].amount=parseFloat(data[i].amount)+parseFloat(amount1)
                        found=1
                    }
                }

                if(found==0){
                    data.push({paymentmode: paymode, count:1, amount: amount1})
                }
            }
        })
        
        results="<table class='table table-sm'><tbody>"
        for(var i=0;i<data.length;i++){
            results+="<tr><td>"+data[i].paymentmode+"</td>"
            results+="<td class='text-center'> (<span >"+$.number(data[i].count,0)+"</span>)</td>"
            results+="<td class='text-right'><span >"+$.number(data[i].amount,2)+"<span></td></tr>"
            totalamount+=parseFloat(data[i].amount)
            totalnumber+=parseInt(data[i].count)
        }
        results+="<tr class='font-weight-bold'><td>TOTAL:</td>"
        results+="<td class='text-center'><span>("+$.number(totalnumber,0)+")</span></td>"
        results+="<td class='text-right'><span >"+$.number(totalamount,2)+"</span></td><tr></tbody></table>"
        // console.log(results)
        receiptssummary.find(".card-body").html(results)
        // format the number fields
    }

    // listen to onclick of individual check buttons

    receiptslist.on("click",".checkoption",function(){
       // console.log(" checkbox clicked")
        getReceiptSummaries()
    })


    postreceipts.on("click",function(){
        // check for blank fields
        var cashbook=cashbookaccountslist.val(),
            narration=narrationfield.val(),
            reference=referencefield.val(),
            postas=postasfield.val(),
            errors=""
        receiptbanked=poslist.val()=='receipt'?'customerreceipt':'pos'
        if(cashbook==''){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-sm fa-fw'></i>Please select Cashbook Account</p>"
        }else if(narration==''){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-sm fa-fw'></i>Please provide narration for the banking</p>"
        }else if(reference==''){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-sm fa-fw'></i>Please provide reference for the banking</p>"
        }else if(postas==''){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-sm fa-fw'></i>Please select how to post the transactions in the cashbook</p>"
        }
        if(errors==''){
            var data = [], paymode,amount,  reference1,receiptno,customername, id
            receiptssummary.find("card-body").html("<p>Processing ...</p>")
            $(".checkoption").each(function(){
                if($(this).prop("checked")){
                    parent=$(this).parent("td").parent("tr")
                    id=parent.prop("id")
                    reference1=parent.find("td").eq(7).text()
                    amount=parent.find("td").eq(8).text()
                    amount=amount.replace(/,/g, '')
                    customername=parent.find("td").eq(4).text()
                    receiptno=parent.find("td").eq(5).text()
                    data.push({id: id, reference:reference1, amount: amount, customername: customername, receiptno: receiptno})
                }
            })
            TableData=JSON.stringify(data)
            $.post(
                "../controllers/possalesoperations.php",
                {
                    savebanking:true,
                    TableData: TableData,
                    cashbookaccount: cashbook,
                    narration:narration,
                    reference:reference,
                    postas:postas,
                    receiptbanked:receiptbanked
                },
                function(data){
                    var result=$.trim(data.toString())
                    if(result=="success"){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-sm fa-fw'></i>Payments posted successfully</p>"
                        // clear the form
                        resetForm()
                    }else{
                        errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-fw fa-sm'></i>"+result+"</p>"
                    }
                    errordiv.html(errors)
                }
            )
        }else{
            errordiv.html(errors)
        }
    })

    function resetForm(){
        receiptssummary.find("card-body").html("")
        poslist.val("")
        paymentmethodlist.val("")
        startdatefield.val("")
        enddatefield.val("")
        cashbookaccountslist.val("")
        narrationfield.val("")
        referencefield.val("")
        postasfield.val("")
        pendingreceipts.find("tbody").html(" <tr><td colspan='10'>No Records Listed. Apply filter options first</td></tr>")
    }
})