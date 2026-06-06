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
        receiptssummary=$("#summary"),
        receiptslist=$("#pendingreceipts"),
        postreceipts=$("#bankreceipts"),
        narrationfield=$("#narration"),
        postasfield=$("#postas"),
        referencefield=$("#referenceno"),
        pendingreceiptdetails=$("#pendingreceiptdetails")

    // Helper to format date as dd-M-yy (e.g., 31-May-2026)
    function getFormattedDate(date) {
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var day = date.getDate();
        var month = months[date.getMonth()];
        var year = date.getFullYear();
        return (day < 10 ? '0' + day : day) + '-' + month + '-' + year;
    }

    // Default to the last 1 day (yesterday to today)
    var today = new Date();
    var yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);

    alldates.prop('checked', false);
    startdatefield.prop("disabled", false);
    enddatefield.prop("disabled", false);
    startdatelabel.prop("disabled", false);
    enddatelabel.prop("disabled", false);

    startdatefield.datepicker();
    enddatefield.datepicker();

    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    startdatefield.val(getFormattedDate(yesterday));
    enddatefield.val(getFormattedDate(today));

    getPointsOfSale(poslist).done(function(){
        poslist.append("<option value='receipt'>&lt;Customer Receipts&gt;</option>");
        // Auto-populate data on load
        setTimeout(function(){
            filterbutton.click();
        }, 100);
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
                errors=showAlert("danger", "Please provide start date")
                startdatefield.focus()
            }else if(enddatefield.val()==""){
                errors=showAlert("danger", "Please provide end date")
                enddatefield.focus()
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
                            results+="<td class='d-none d-md-table-cell'>"+data[i].posname+"</td>"
                            results+="<td>"+data[i].customername+"</td>"
                            results+="<td class='d-none d-sm-table-cell'>"+data[i].receiptno+"</td>"
                            results+="<td>"+data[i].description+"</td>" 
                            results+="<td class='d-none d-md-table-cell'>"+refno+"</td>"
                            results+="<td class='text-right font-weight-bold'>"+$.number(data[i].amount,0)+"</td>"
                            results+="<td class='d-none d-lg-table-cell'>"+data[i].addedby+"</td></tr>"
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
            errors=showAlert("info", "Please select Cashbook Account")
            cashbookaccountslist.focus()
        }else if(narration==''){
            errors=showAlert("info", "Please provide narration for the banking")
            narrationfield.focus()
        }else if(reference==''){
            errors=showAlert("info", "Please provide reference for the banking")
            referencefield.focus()
        }else if(postas==''){
            errors=showAlert("info", "Please select how to post the transactions in the cashbook")
            postasfield.focus()
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
            
            // Reset to loading state inside modal
            var loadingHTML = `
                <div class="spinner-border text-primary mb-4" role="status" style="width: 3rem; height: 3rem;">
                    <span class="sr-only">Loading...</span>
                </div>
                <h4 class="font-weight-bold text-dark mb-2">Processing Banking</h4>
                <p class="text-muted mb-0">Please wait while we bank the selected receipts and post to the general ledger...</p>
            `;
            $("#progressModalBody").html(loadingHTML);

            // Show glassmorphic progress modal on mobile/tablet viewports
            if ($(window).width() < 992) {
                $("#progressModal").modal("show");
            }

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
                        errors=showAlert("success", "Payments posted successfully")
                        
                        // Show Success in Modal on Mobile/Tablet
                        if ($(window).width() < 992) {
                            var successHTML = `
                                <div class="text-center">
                                    <div class="mb-4">
                                        <i class="fal fa-check-circle text-success" style="font-size: 4rem;"></i>
                                    </div>
                                    <h4 class="font-weight-bold text-success mb-2">Success!</h4>
                                    <p class="text-muted mb-4">Payments posted successfully.</p>
                                    <button type="button" class="btn btn-success btn-block py-2" data-dismiss="modal" style="border-radius: 8px !important; font-weight: 500;">Close</button>
                                </div>
                            `;
                            $("#progressModalBody").html(successHTML);
                        }
                        
                        // Clear banking inputs and reset filters to page load defaults
                        cashbookaccountslist.val("")
                        narrationfield.val("")
                        referencefield.val("")
                        postasfield.val("")
                        receiptssummary.find(".card-body").html("")
                        selectall.prop("checked", false)

                        applyDefaultFilters()
                        filterbutton.click()
                    }else{
                        errors=showAlert("danger", result)
                        
                        // Show Failure in Modal on Mobile/Tablet
                        if ($(window).width() < 992) {
                            var errorHTML = `
                                <div class="text-center">
                                    <div class="mb-4">
                                        <i class="fal fa-times-circle text-danger" style="font-size: 4rem;"></i>
                                    </div>
                                    <h4 class="font-weight-bold text-danger mb-2">Failed!</h4>
                                    <p class="text-muted mb-4">${result}</p>
                                    <button type="button" class="btn btn-secondary btn-block py-2" data-dismiss="modal" style="border-radius: 8px !important; font-weight: 500;">Close</button>
                                </div>
                            `;
                            $("#progressModalBody").html(errorHTML);
                        }
                    }
                    errordiv.html(errors)
                }
            ).fail(function(){
                // Safety show network error in Modal on Mobile/Tablet
                if ($(window).width() < 992) {
                    var failHTML = `
                        <div class="text-center">
                            <div class="mb-4">
                                <i class="fal fa-exclamation-triangle text-warning" style="font-size: 4rem;"></i>
                            </div>
                              <h4 class="font-weight-bold text-warning mb-2">Connection Error!</h4>
                              <p class="text-muted mb-4">A network error occurred. Please check your connection and try again.</p>
                              <button type="button" class="btn btn-secondary btn-block py-2" data-dismiss="modal" style="border-radius: 8px !important; font-weight: 500;">Close</button>
                          </div>
                      `;
                      $("#progressModalBody").html(failHTML);
                  } else {
                      errordiv.html(showAlert("danger", "A network error occurred."))
                  }
              })
          }else{
              errordiv.html(errors)
          }
    })

    function applyDefaultFilters(){
        var today = new Date();
        var yesterday = new Date();
        yesterday.setDate(today.getDate() - 1);

        alldates.prop('checked', false);
        startdatefield.prop("disabled", false);
        enddatefield.prop("disabled", false);
        startdatelabel.prop("disabled", false);
        enddatelabel.prop("disabled", false);

        startdatefield.val(getFormattedDate(yesterday));
        enddatefield.val(getFormattedDate(today));

        poslist.val("0");
        paymentmethodlist.val("0");
    }

    function resetForm(){
        receiptssummary.find("card-body").html("")
        poslist.val("0")
        paymentmethodlist.val("0")
        startdatefield.val("")
        enddatefield.val("")
        cashbookaccountslist.val("")
        narrationfield.val("")
        referencefield.val("")
        postasfield.val("")
        pendingreceipts.find("tbody").html(" <tr><td colspan='10'>No Records Listed. Apply filter options first</td></tr>")
    }

    // Bind Clear button to reset form
    $("#clear").on("click", function(){
        resetForm();
    });

    // Toggle Sidebar Settings collapsible panel text & icons on mobile
    $('#step1FilterCollapse').on('show.bs.collapse', function () {
        $('#toggleSidebarBtn span').text('Close Filters');
        $('#toggleSidebarBtn i').removeClass('fa-filter').addClass('fa-times');
    });
    $('#step1FilterCollapse').on('hide.bs.collapse', function () {
        $('#toggleSidebarBtn span').text('Filters');
        $('#toggleSidebarBtn i').removeClass('fa-times').addClass('fa-filter');
    });
})