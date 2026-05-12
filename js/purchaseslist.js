$(document).ready(function(){
    const   addorder=$("#addorder"),
            orderlist=$("#orderlist"),
            ordertable=$("#ordertable"),
            supplierslist=$("#supplier"),
            startdatefield=$("#startdate"),
            enddatefield=$("#enddate"),
            alldates=$("#alldates"),
            filterpurchaseordersbutton =$("#search"),
            approvepurchaseordermodal=$("#approvepurchaseordermodal"),
            approvepurchaseorderbutton=$("#approvepurchaseorderbtn"),
            approvalnarrationfield=$("#approvalnarration"),
            // approvallevels=$("#approvalevels"),
            rejectpurchaseordermodal=$("#rejectpurchaseordermodal"),
            rejectionlevels=$("#rejectionlevels"),
            rejectpurchaseorderbutton=$("#rejectpurchaseorderbtn"),
            rejectionnarrationfield=$("#rejectionnarration"),
            rejecterrors=$("#rejecterrors"),
            purchaseordererors=$("#purchaseordererrors")

    filterpurchaseordersbutton.on("click",()=>{
        refreshorderslist()
    })

    addorder.on("click",function(){
        window.location.href="purchasedetails.php"
    })

    // get existing suppliers
    getSuppliers(supplierslist, option='all')

    // populate list with orders
    refreshorderslist()

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    // set datepickers 
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})
    
    // listen to select all 
    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }
    })
    
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    function refreshorderslist(){
        $.getJSON(
            "../controllers/purchaseorderoperations.php",
            {
               getpurchaseorders: true
            },
   
           function(data){
               // Populate the data in the table
               let results=""
               // console.log(data.length)
               for(i=0 ; i<data.length; i++){
                    results+=`<tr data-id=${data[i].id}><td>${$.number(i+1)}</td>`
                    results+=`<td>${data[i].id}</td>`
                    results+=`<td>${data[i].purchaseorderno}</td>`
                    results+=`<td>${data[i].suppliername}</td>`
                    results+=`<td>${$.number(data[i].ordertotal)}</td>`
                    results+=`<td>${data[i].status}</td>`
                    results+=`<td>${data[i].date}</td>`
                    results+=`<td>${data[i].addedby}</td>`
                    results+=`<td>${data[i].status=='Approved'?"<span><i class='fal fa-edit fa-lg text-secondary'></i></span>":"<a href='#' data-id="+data[i].id+" class='edit'><span><i class='fal fa-edit fa-lg' ></i></span>"}</a></td>`
                    results+=`<td>${data[i].status=='Approved'?"<span><i class='fal fa-hourglass-half fa-lg text-secondary'></i></span>":"<a href='#' class='approve'><span><i class='fal fa-hourglass-half fa-lg' ></i></span></a>"}</td>`
                    results+=`<td>${data[i].status=='Approved'?"<span><i class='fal fa-times fa-lg text-secondary'></i></span>":"<a href='#' class='cancel'><span><i class='fal fa-times fa-lg'></span></i></a>"}</td>`
                    results+=`<td>${data[i].status!='Approved'?"<span><i class='fal fa-envelope fa-lg text-secondary'></i></span>":"<a href='#' class='email'><span><i class='fal fa-envelope fa-lg' ></i></span></a>"}</td>`
                    results+=`<td>${data[i].status!='Approved'?"<span><i class='fal fa-print fa-lg text-secondary'></i></span>":"<a href='#' class='print'><span><i class='fal fa-print fa-lg'></span></i></a>"}</td></tr>` 
               }
                //    $(results).appendTo(orderlist)
                //    ordertable.DataTable()
                makedatatable(orderlist,results,15)
           }
       )
    }

    // listen to delete data click event
    orderlist.on("click",".edit",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        $.getJSON(
            "../controllers/purchaseorderoperations.php",
            {
                getpurchaseorderdetails:true,
                id:id
            },
            function(data){
                 // check if cancelled 
                 if(data[0].status=="Cancelled"){
                     bootbox.alert({
                         message: "The Purchase order has been cancelled and cannot be edited",
                     })
                     
                 }else if(data[0].status=='Received'){
                     bootbox.alert({
                         message: "The Purchase order has been received and hence cannot be edited",
                     })
                 }else{
                    window.location.href="purchasedetails.php?id="+id
                 }
            }
        )
    })

    //  Purchse order approval
    orderlist.on("click",".approve",function(e){
        // check permission
        e.preventDefault()
        var parent=$(this).parent("td").parent("tr"),
            purchaseorderno=parent.find("td").eq(2).text()
        // check if the user is allowed to approve the purchase order at any level for the department from which the po was made
        $.post(
            "../controllers/rawmaterialsoperations.php",
            {
                checkpurchaseorderapprovallevel:true,
                purchaseorderno
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    bootbox.alert({
                    message: `<i class="fas fa-exclamation-triangle fa-lg text-danger"></i> Sorry. Your are not allowed to perform this operation.`,
                    buttons: {
                        ok: {
                            label: 'Got it',
                            className: 'btn-sm btn-danger'
                        }
                        }
                    })
                }else{
                    // get purchaseorder approval status
                    $.getJSON(
                        "../controllers/rawmaterialsoperations.php",
                        {
                            getpurchaseorderapprovalstatus:true,
                            purchaseorderno
                        },
                        function(data){
                            var results='',
                                current=false
                            for(var i=0;i<data.length;i++){
                                if(data[i].status=='Approved'){
                                    results+=`<div class='text-success mb-2'><i class="fal fa-check-circle fa-lg"></i> ${data[i].description}</div>`
                                }else{
                                    if(current==false){
                                        // add the currently approved
                                        results+=`<div class='text-success data-current font-weight-bold mb-2' data-id='${data[i].id}' data-purchaseorderno='${purchaseorderno}'><i class="fas fa-check-circle fa-lg" ></i> ${data[i].description}</div>`
                                        current=true
                                    }else{
                                        results+=`<div class='text-secondary text-muted mb-2'><i class="fal fa-check-circle fa-lg"></i> ${data[i].description}</div>`
                                    }
                                }
                            }
                            results+=`<label for="approvalnarration">Approval Remarks:</label><textarea name="approvalnarration" id="approvalnarration" class="form-control form-control-sm"></textarea>`
                            approvepurchaseordermodal.find(".modal-body").html(results)
                            //$(results).appendTo(approvallevels)
                        }
                    )
                    approvepurchaseordermodal.modal("show")
                    // enable the approve button
                    approvepurchaseorderbutton.prop("disabled",false)
                }
            }
        )
    })

    // Cancel purchase order
    orderlist.on("click",".cancel",function(e){
        // check permission
        e.preventDefault()
        var parent=$(this).parent("td").parent("tr"),
            purchaseorderno=parent.find("td").eq(2).text()
        // check if the user is allowed to approve the purchase order at any level for the department from which the po was made
        $.post(
            "../controllers/rawmaterialsoperations.php",
            {
                checkpurchaseorderapprovallevel:true,
                purchaseorderno
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    bootbox.alert({
                    message: `<i class="fas fa-exclamation-triangle fa-lg text-danger"></i> Sorry. Your are not allowed to perform this operation.`,
                    buttons: {
                        ok: {
                            label: 'Got it',
                            className: 'btn-sm btn-danger'
                        }
                        }
                    })
                }else{
                    // get purchaseorder approval status
                    $.getJSON(
                        "../controllers/rawmaterialsoperations.php",
                        {
                            getpurchaseorderapprovalstatus:true,
                            purchaseorderno
                        },
                        function(data){
                            var results='',
                                current=false
                            for(var i=0;i<data.length;i++){
                                if(data[i].status=='Approved'){
                                    results+=`<div class='text-secondary mb-2'><i class="fal fa-check-circle fa-lg"></i> ${data[i].description}</div>`
                                }else{
                                    if(current==false){
                                        // add the currently approved
                                        results+=`<div class='text-secondary data-current font-weight-bold mb-2' data-id='${data[i].id}' data-purchaseorderno='${purchaseorderno}'><i class="fas fa-check-circle fa-lg" ></i> ${data[i].description}</div>`
                                        current=true
                                    }else{
                                        results+=`<div class='text-secondary text-muted mb-2'><i class="fal fa-check-circle fa-lg"></i> ${data[i].description}</div>`
                                    }
                                }
                            }
                            rejectionlevels.html(results)
                            //$(results).appendTo(approvallevels)
                        }
                    )
                    rejectpurchaseordermodal.modal("show")
                    // enable the approve button
                   rejectpurchaseorderbutton.prop("disabled",false)
                }
            }
        )
    })

    // approve purchaseorder
    approvepurchaseorderbutton.on("click", function(){
        var currentapprovallevel=approvepurchaseordermodal.find(".modal-body .data-current"),
            purchaseorderno=currentapprovallevel.attr("data-purchaseorderno"),
            approvallevel=currentapprovallevel.attr("data-id"),
            narration=approvalnarrationfield.val()
            notifications=""

        notifications="Processing. Please wait ..."
        approvepurchaseordermodal.find(".modal-body").html(showAlert("processing", notifications,1))
        // check if the user is allowed to approve purchase order for the selected level
        $.post(
            "../controllers/rawmaterialsoperations.php",
            {
                checkpurchaseorderapprovallevel:true,
                purchaseorderno,
                approvallevel
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    notifications="Sorry, you are not allowed to Approve the Purchase Order for the Level"
                    approvepurchaseordermodal.find(".modal-body").html(showAlert("danger", notifications,1))
                }else{
                    $.post(
                        "../controllers/rawmaterialsoperations.php",
                        {
                            approvepurchaseorder:true,
                            purchaseorderno,
                            approvallevel,
                            narration
                        },
                        function(data){
                            data=$.trim(data)
                            if(data=="success"){
                                notifications="purchaseorder approved succesfully."
                                approvepurchaseordermodal.find(".modal-body").html(showAlert("success", notifications))
                                // disable the approve button so as not to attempt another approval
                                approvepurchaseorderbutton.prop("disabled",true)
                                // refresh the list to show changes
                                // filterpurchaseordersbutton.trigger("click")
                                refreshorderslist()
                            }else{
                                notifications=`Sorry an error occured. ${data}`
                                approvepurchaseordermodal.find(".modal-body").html(showAlert("danger", notifications,1))
                            }
                        }
                    )
                }
            }
        )
    })

    orderlist.on("click",".print",function(e){
        e.preventDefault()
        const pono=$(this).closest("tr").find("td").eq(2).text() 
        let notifications=""
        // purchaseordererors.html(showAlert("processing","Processing. Please wait ...",1))
        $.post(
            "../controllers/useroperations.php",
            {
              getuserprivilege:true,
              objectid: 51
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    bootbox.alert({
                    message: `<i class="fas fa-exclamation-triangle fa-lg text-danger"></i> Sorry. Your are not allowed to perform this operation.`,
                    buttons: {
                        ok: {
                            label: 'Got it',
                            className: 'btn-sm btn-danger'
                        }
                        }
                    })
                }else{
                    url="../controllers/dispatchpurchaseorder.php?pono="+pono+"&print=true" 
                    window.open(url, '_blank'); 
                }
            }
        )
    })

    //dispatch purchase order
    orderlist.on("click",".email",function(e){
        e.preventDefault()
        // url="../controllers/dispatchpurchaseorder.php?pono="+pono
        // window.open(url, '_blank')
        // check if user is allowed to perform the operation
        const pono=$(this).closest("tr").find("td").eq(1).text() 
        let notifications=""
        purchaseordererors.html(showAlert("processing","Processing. Please wait ...",1))
        $.post(
            "../controllers/useroperations.php",
            {
              getuserprivilege:true,
              objectid: 50
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    bootbox.alert({
                    message: `<i class="fas fa-exclamation-triangle fa-lg text-danger"></i> Sorry. Your are not allowed to perform this operation.`,
                    buttons: {
                        ok: {
                            label: 'Got it',
                            className: 'btn-sm btn-danger'
                        }
                        }
                    })
                }else{
                    purchaseordererors.html(showAlert("processing","Processing PO dispatch. Please wait ...",1))   
                    $.post(
                        "../controllers/dispatchpurchaseorder.php",
                        {
                            pono
                        },
                        function(data){
                                data=$.trim(data)
                            if(data=="success"){
                                notifications=`Purchase order number <strong>${pono}</strong> dispatched succesfully via Email`
                                purchaseordererors.html(showAlert("success",notifications))
                            }else{
                                notifications=`Sorry an error occured. ${data}`
                                purchaseordererors.html(showAlert("danger",notifications,1))
                            }
                        }
                    )
                }
            }
        )
    })

    // reject purchase order
    rejectpurchaseorderbutton.on("click", function(){
        // check if user is allowed to approve the purchase order at the current level
        const currentapprovallevel=rejectpurchaseordermodal.find(".modal-body .data-current"),
            purchaseorderno=currentapprovallevel.attr("data-purchaseorderno"),
            approvallevel=currentapprovallevel.attr("data-id"),
            narration=rejectionnarrationfield.val()
        let notifications=""
        // check if rejection reason has been provided
        if(narration==""){
            rejecterrors.html(showAlert("info","Please provide rejection reason"))
        }else{
            notifications="Processing. Please wait ..."
            rejectpurchaseordermodal.find(".modal-body").html(showAlert("processing", notifications,1))
            // check if the user is allowed to approve purchase order for the selected level
            $.post(
                "../controllers/rawmaterialsoperations.php",
                {
                    checkpurchaseorderapprovallevel:true,
                    purchaseorderno,
                    approvallevel
                },
                function(data){
                    var allowed=parseInt($.trim(data.toString()))
                    if(allowed==0){
                        notifications="Sorry, you are not allowed to Approve the Purchase Order for the Level"
                        rejectpurchaseordermodal.find(".modal-body").html(showAlert("danger", notifications,1))
                        // disable the reject button
                    }else{
                        $.post(
                            "../controllers/rawmaterialsoperations.php",
                            {
                                rejectpurchaseorder:true,
                                purchaseorderno,
                                approvallevel,
                                narration
                            },
                            function(data){
                                data=$.trim(data)
                                if(data=="success"){
                                    notifications="purchaseorder rejected succesfully."
                                    rejectpurchaseordermodal.find(".modal-body").html(showAlert("success", notifications))
                                    // disable the reject button so as not to attempt another approval
                                    rejectpurchaseorderbutton.prop("disabled",true)
                                    // refresh the list to show changes
                                    filterpurchaseordersbutton.trigger("click")
                                }else{
                                    notifications=`Sorry an error occured. ${data}`
                                    rejectpurchaseordermodal.find(".modal-body").html(showAlert("danger", notifications,1))
                                }
                            }
                        )
                    }
                }
            )
        }
        
    })

    // hide notification when user is typing the reject reason
    rejectionnarrationfield.on("input",function(){
        rejecterrors.html("")
    })

    const departmentlist=$("#filterdepartment")
    const filtercurrencylist=$("#filtercurrency")

    getdepartments(departmentlist)
    getscurrencies(filtercurrencylist)

})