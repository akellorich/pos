$(document).ready(function(){
    var addvoucherbutton=$("#addvoucher"),
        costcenterlist=$("#costcenter"),
        supplierlist=$("#supplier"),
        statuslist=$("#status"),
        paymentmodelist=$("#paymentmode"),
        alldates=$("#alldates"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate")
        alldates.prop("checked",true)
        startdatefield.prop("disabled",true)
        enddatefield.prop("disabled",true),
        errordiv=$("#errors"),
        filterbutton=$("#filterpayments"),
        searchresults=$("#results")
    
    getPointsOfSale(costcenterlist,'all')
    getPaymentModes(paymentmodelist,'all')
    getSuppliers(supplierlist,'all')
    
    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    startdatefield.datepicker()
    enddatefield.datepicker()

    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }
    })
    
    addvoucherbutton.on("click",function(){
        console.log("clicked")
        window.location.href="pettycashvoucherdetails.php"
    })

    filterbutton.on("click",function(){
        var supplierid,posid, stat,paymentmode, startdate,enddate,errors=''
         supplierid=supplierlist.val()
         posid=costcenterlist.val()
         stat=statuslist.val()
         paymentmode=paymentmodelist.val()

        if (alldates.prop("checked")){
            startdate='01-Jan-2018'
            enddate='31-dec-2100'
        }else{
            // check for blank dates
            if(startdatefield.val()==''){
                errors="<p class='alert alert-danger'>Please select start date"
            }else if(enddatefield.val()==''){
                errors="<p class='alert alert-danger'>Please select end date"
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        }
        if(errors==''){
            errordiv.html("")
            $.getJSON(
                "../controllers/paymentoperations.php",
                {
                    getpaymentvouchers:true,
                    supplierid:supplierid,
                    posid:posid,
                    stat:stat,
                    paymentmode:paymentmode,
                    startdate:startdate,
                    enddate:enddate,
                    pettycashvouchers:1
                },function(data){
                    var results=""
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td>"+parseInt(i+1)+"</td>"
                        results+="<td>"+data[i].voucherdate+"</td>"
                        results+="<td>"+data[i].voucherno+"</td>"
                        results+="<td>"+data[i].suppliername+"</td>"
                        results+="<td>"+data[i].posname+"</td>"
                        //results+="<td>"+data[i].invoicenumber+"</td>"
                        results+="<td>"+$.number(data[i].vouchertotal)+"</td>"
                        results+="<td>"+data[i].paymentmodedescription+"</td>"
                        results+="<td>"+data[i].accountcode+" - "+data[i].accountname+"</td>"
                        results+="<td>"+data[i].referenceno+"</td>"
                        results+="<td>"+data[i].status+"</td>"
                        results+="<td><a href='javascript void(0)' class='print' data-id='"+data[i].voucherid+"' data-voucherno='"+data[i].voucherno+"'><span><i class='fas fa-print fa-sm mt-1'></i></span></a></td>"
                        results+="<td><a href='javascript void(0)' class='edit' data-id='"+data[i].voucherid+"' data-voucherno='"+data[i].voucherno+"'><span><i class='fas fa-edit fa-sm mt-1'></i></span></a></td>"
                        results+="<td><a href='javascript void(0)' class='approve' data-id='"+data[i].voucherid+"'><span><i class='fas fa-thumbs-up fa-sm mt-1'></i></span></a></td>"
                        results+="<td><a href='javascript void(0)' class='delete' data-id='"+data[i].voucherid+"'><span><i class='fas fa-trash-alt fa-sm mt-1'></i></span></a></td></tr>"
                        //console.log(results)
                    }
                    searchresults.find("tbody").html(results)
                }
            )
        }else{
            errordiv.html(errors)
        }
    })
    
    
    // listen to edit button
    searchresults.on("click",".edit", function(e){
        e.preventDefault()
        var id=$(this).attr("data-id"),
            voucherno=$(this).attr("data-voucherno")
        // check status of the payment voucher 
        $.getJSON(
            "../controllers/paymentoperations.php",
            {
                getvoucherstatus:true,
                id:id
            },
            function(data){
                var results=$.trim(data.toString())
                if(results!='Pending'){
                    bootbox.alert("Sorry! The payment voucher's status is <strong>"+results+"</strong> hence is non-editable");
                }else{
                    window.location.href="pettycashvoucherdetails.php?id="+voucherno
                }
            }
        )
        
    })

    /**/

    // listen to approve button
    searchresults.on("click",".approve",function(e){
        e.preventDefault()
        var id=$(this).attr("data-id")
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(2).text()

        // console.log(itemname)

        $.getJSON(
            "../controllers/paymentoperations.php",
            {
                getvoucherstatus:true,
                id:id
            },
            function(data){
                var results=$.trim(data.toString())
                if(results!='Pending'){
                    bootbox.alert("Sorry! The payment voucher's status is <strong>"+results+"</strong> hence cannot be approved");
                }else{
                    // confirm approval and approve
                    
                    bootbox.dialog({
                        // title: "Confirm Item Removal!",
                        message: "Are you sure you want to Approve Voucher # <strong>"+itemname+"</strong>? Once approved the action is permanent.",
                        buttons: {
                            success: {
                                label: "No, Leave Pending",
                                className: "btn-success",
                                callback: function() {
                                    $('.bootbox').modal('hide');
                                }
                            },
                            danger: {
                                label: "Yes, Approve",
                                className: "btn-danger",
                                callback: function() {
                                    //console.log(parent)
                                    $.post(
                                        "../controllers/paymentoperations.php",
                                        {
                                            approvepaymentvoucher:true,
                                            id:id
                                        },
                                        function(data){
                                            var results=$.trim(data.toString())
                                            // console.log(results)
                                            if(results=='success'){
                                                errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Payment voucher # "+itemname+" has been appeoved successfully</p>"
                                            }else if(results=='not exists'){
                                                errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Sorry! Payment voucher # "+itemname+" was not found in the system</p>"
                                            }else{
                                                errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> "+results+"</p>"
                                            }
                                            errordiv1.html(errors)
                                        }
                                    )
                                    $('.bootbox').modal('hide');
                                }
                            }
                        }
                    })
                }
            }
        )
    })
    // listen to delete button
    searchresults.on("click",".delete",function(e){
        e.preventDefault()
        var id=$(this).attr("data-id")
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(2).text()

        $.getJSON(
            "../controllers/paymentoperations.php",
            {
                getvoucherstatus:true,
                id:id
            },
            function(data){
                var results=$.trim(data.toString())
                if(results!='Pending'){
                    bootbox.alert("Sorry! The payment voucher's status is <strong>"+results+"</strong> hence cannot be deleted");
                }else{
                    var parent = $(this).parent("td").parent("tr");
                    var itemname=parent.find("td").eq(2).text()
                    bootbox.prompt({
                        title: "Please provide reason for Cancellation!",
                        inputType: 'textarea',
                        callback: function (result) {
                            //console.log(result);
                            $.post(
                                "../controllers/paymentoperations.php",
                                {
                                    cancelpaymentvoucher:true,
                                    reason:result,
                                    id:id
                                },function(data){
                                    var results=$.trim(data.toString())
                                    if(results=="success"){
                                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Payment Voucher # <strong>" +itemname+"</strong> has been Cancelled successfully.</p>"
                                        parent.remove()
                                    }else if(results=='not pending'){
                                        errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Payment Voucher # <strong>" +itemname+"</strong> status is not Pending, hence to deletable.</p>"
                                    }else{
                                        errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> " +result+"</p>"
                                    }
                                    errordiv1.html(errors)
                                }
                            )
                        }
                    })
                    
                }
            }
        )
    })

    searchresults.on("click",".print",function(e){
        e.preventDefault()
        var id=$(this).attr("data-voucherno")
        var url ="../printpaymentvoucher.php?voucherid="+id
        var win = window.open(url, '_blank');
    })
})