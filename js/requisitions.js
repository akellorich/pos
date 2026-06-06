$(document).ready(function(){
    var alldates=$("#alldates"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        startdatelabel=$("#startdatelabel"),
        enddatelabel=$("#enddatelabel")
        suppliersfield=$("#supplier"),
        departmentsfield=$("#department"),
        requisitionstatusfield=$("#status"),
        requisitionusecasefield=$("#usecase"),
        addrequisitionbutton=$("#addnewrequisition, #mobileAddPurchaseFAB"),
        filterrequisitionsbutton=$("#filterrequisitions"),
        requisitionslist=$("#requisitionslist"),
        approverequisitionmodal=$("#approverequisitionmodal"),
        approverequisitionbutton=$("#approverequisitionbtn"),
        validaterequisitionapproval=$(".validaterequisitionapproval"),
        approvallevels=$("#approvallevels"),
        approvalnarrationfield=$("#approvalnarration"),
        rejectrequisitionmodal=$("#rejectrequisitionmodal"),
        rejectrequisitionbutton=$("#rejectrequisitionbtn"),
        rejectreasonfield=$("#rejectedreason")
        requisitionnofield=$("#requisitionno")
    // filter all dates byu default
    alldates.prop("checked",true)
    // disable date fields
    disabledatefields()

    //set date fields
    startdatefield.datepicker({dateFormat: 'dd-M-yy',maxDate:  new Date()})
    enddatefield.datepicker({dateFormat: 'dd-M-yy',maxDate:  new Date()})

    // get departments
    getdepartments(departmentsfield)

    // get suppliers
    getSuppliers(suppliersfield)

    // populate status filter options
    getrequisitionstatus(requisitionstatusfield)
    // get material use cases
    // getmaterialusecases(requisitionusecasefield)
    //getrequisitionscope(requisitionscopefield)
   
    // toggle enable date fields
    alldates.on("click",function(){
        $(this).prop("checked")?disabledatefields():enabledatefields()
    })

    // show add new requisition formm
    addrequisitionbutton.on("click",()=>{
        window.location.href="requisitiondetails.php"
    })

    // filter requisitions
    filterrequisitionsbutton.on("click",function(){
        var startdate=startdatefield.val(),
            enddate=enddatefield.val(),
            departmentid=departmentsfield.val(),
            supplierid=suppliersfield.val(),
            usecaseid=requisitionusecasefield.val(),
            requisitionstatus=requisitionstatusfield.val(),
            requisitionno=requisitionnofield.val()
        if (alldates.prop("checked")){
            startdate='01-Jan-2020'
            enddate='31-Dec-2100'
        }
        if(requisitionstatus==0){
            requisitionstatus='All'
        }
        $.getJSON(
            "../controllers/materialoperations.php",
            {
                filterrequisitions:true,
                startdate,
                enddate,departmentid,
                supplierid,
                usecaseid,
                requisitionstatus,
                requisitionno
            },
            function(data){
                var results=""
                if(data.length>0){
                    for(var i=0;i<data.length;i++){
                        var isRejected = data[i].status == "Rejected";
                        var isApproved = data[i].status == "Approved";
                        var rowClass = isRejected ? "class='rejected'" : (isApproved ? "class='approved'" : "");
                        
                        results+=`<tr ${rowClass}>`
                        results+=`<td class="d-none d-md-table-cell ${isRejected ? 'text-danger' : ''}">${Number(i+1)}</td>`
                        results+=`<td class="d-none d-md-table-cell ${isRejected ? 'text-danger' : ''}">${data[i].requestdate}</td>`
                        results+=`<td class="${isRejected ? 'text-danger' : ''}">${data[i].requisitionno}</td>`
                        results+=`<td class="${isRejected ? 'text-danger' : ''}">${data[i].departmentname}</td>`
                        results+=`<td class="d-none d-md-table-cell ${isRejected ? 'text-danger' : ''}">${data[i].suppliername}</td>`
                        results+=`<td class="d-none d-md-table-cell ${isRejected ? 'text-danger' : ''}">${data[i].projectname}</td>`
                        results+=`<td class="d-none d-md-table-cell ${isRejected ? 'text-danger' : ''}">${data[i].usecasename}</td>`
                        results+=`<td class="${isRejected ? 'text-danger' : ''}">${$.number(data[i].requisitionamount,2)}</td>`
                        results+=`<td class="${isRejected ? 'text-danger' : ''}">${data[i].status}</td>`
                        
                        // Action dropdown
                        results+=`<td class="text-center">`
                        if (isRejected) {
                            results+=`-`
                        } else {
                            results+=`
                            <div class="dropdown">
                                <a class="btn btn-sm btn-link text-secondary p-0" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-size: 1.2rem; text-decoration: none;">
                                    <i class="fal fa-ellipsis-v"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right shadow border-0" style="border-radius: 8px; font-size: 0.85rem; z-index: 1050 !important;">
                                    <a class="dropdown-item editdata ${isApproved?'disabled text-muted':''}" href="${isApproved?'#':'requisitiondetails.php?requisitionno='+data[i].requisitionno}" data-id="${data[i].id}">
                                        <i class="fal fa-edit fa-fw mr-2" style="color: #6c757d; font-size: 0.72rem;"></i> Edit
                                    </a>
                                    ${isApproved ? `
                                    <a class="dropdown-item disabled text-success" href="#">
                                        <i class="fal fa-check-circle fa-fw mr-2"></i> Approved
                                    </a>
                                    ` : `
                                    <a class="dropdown-item approvedata" href="#" data-id="${data[i].id}">
                                        <i class="fal fa-check-circle fa-fw mr-2" style="color: green; font-size: 0.72rem;"></i> Approve
                                    </a>
                                    `}
                                    <a class="dropdown-item canceldata ${isApproved?'disabled text-muted':''}" href="#" data-id="${data[i].id}">
                                        <i class="fal fa-times fa-fw mr-2" style="color: red; font-size: 0.72rem;"></i> Cancel
                                    </a>
                                </div>
                            </div>`
                        }
                        results+=`</td></tr>`
                    }
                }else{
                    results='<tr><td colspan="12" class="text-primary"><i class="fas fa-info-circle fa-lg"></i> Sorry, no records matching filter criteria found.</td></tr>'
                }
                makedatatable(requisitionslist, results, 15)
            }
        )
    })

    // approve requisition
    approverequisitionbutton.on("click", function(){
        var currentapprovallevel=approverequisitionmodal.find(".modal-body .data-current"),
            requisitionno=currentapprovallevel.attr("data-requisitionno"),
            approvallevel=currentapprovallevel.attr("data-id"),
            notifications="",
            narration=approvalnarrationfield.val()

        notifications="Processing. Please wait ..."
        approverequisitionmodal.find(".modal-body").html(showAlert("processing", notifications,1))
        // check if user is allowed to approve for this level
        $.post(
            "../controllers/materialoperations.php",
            {
                checkrequisitionapprovallevel:true,
                requisitionno,
                approvallevel
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    notifications="Sorry. You are not allowed to Approve this requisition for the selected level."
                    approverequisitionmodal.find(".modal-body").html(showAlert("danger", notifications,1))
                    // disable the approve button
                    approverequisitionbutton.prop("disabled",true)
                }else{
                    $.post(
                        "../controllers/materialoperations.php",
                        {
                            approverequisition:true,
                            requisitionno,
                            approvallevel,
                            narration
                        },
                        function(data){
                            data=$.trim(data)
                            if(data=="success"){
                                notifications="Requisition approved succesfully."
                                approverequisitionmodal.find(".modal-body").html(showAlert("success", notifications))
                                // disable the approve button so as not to attempt another approval
                                approverequisitionbutton.prop("disabled",true)
                                // refresh the list to show changes
                                filterrequisitionsbutton.trigger("click")
                            }else{
                                notifications=`Sorry an error occured. ${data}`
                                approverequisitionmodal.find(".modal-body").html(showAlert("danger", notifications,1))
                            }
                        }
                    )
                }
            } 
        )
    })

    // check if user is allowed to approve requisition any level for the department from which the requisition was made
    requisitionslist.on("click",".approvedata",function(e){
        e.preventDefault()
        //console.log("clicked")
        var   parent=$(this).parent("td").parent("tr"),
              requisitionno=parent.find("td").eq(2).text()
  
        $.post(
              "../controllers/materialoperations.php",
              {
                  checkrequisitionapprovallevel:true,
                  requisitionno
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
                    $.getJSON(
                    "../controllers/materialoperations.php",
                    {
                        getrequisitionapprovalstatus:true,
                        requisitionno
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
                                    results+=`<div class='text-success data-current font-weight-bold mb-2' data-id='${data[i].id}' data-requisitionno='${requisitionno}'><i class="fas fa-check-circle fa-lg" ></i> ${data[i].description}</div>`
                                    current=true
                                }else{
                                    results+=`<div class='text-secondary text-muted mb-2'><i class="fal fa-check-circle fa-lg"></i> ${data[i].description}</div>`
                                }
                            }
                        }
                        results+=` <div class="form-group">
                            <label for="narration">Approval Remark</label>
                            <textarea name="approvalnarration" id="approvalnarration" class="form-control form-control-sm"></textarea>
                        </div>`
                        approverequisitionmodal.find(".modal-body").html(results)
                        //approvallevels.html(results)
                    }
                )
                approverequisitionmodal.modal("show")
                // enable the approve button
                approverequisitionbutton.prop("disabled",false)
                }
            }
        )
    })

    requisitionslist.on("click",".canceldata",function(e){
        e.preventDefault()
        //console.log("clicked")
        var   parent=$(this).parent("td").parent("tr"),
              requisitionno=parent.find("td").eq(2).text()
        $.post(
              "../controllers/materialoperations.php",
              {
                  checkrequisitionapprovallevel:true,
                  requisitionno
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
                    $.getJSON(
                    "../controllers/materialoperations.php",
                    {
                        getrequisitionapprovalstatus:true,
                        requisitionno
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
                                    results+=`<div class='text-secondary data-current font-weight-bold mb-2' data-id='${data[i].id}' data-requisitionno='${requisitionno}'><i class="fas fa-check-circle fa-lg" ></i> ${data[i].description}</div>`
                                    current=true
                                }else{
                                    results+=`<div class='text-secondary text-muted mb-2'><i class="fal fa-check-circle fa-lg"></i> ${data[i].description}</div>`
                                }
                            }
                        }
                        results+=`<div class="form-group">
                            <label for="rejectedreason">Rejection Remark:</label>
                            <textarea name="rejectedreason" id="rejectedreason" class="form-control form-control-sm"></textarea>
                        </div>`
                        rejectrequisitionmodal.find(".modal-body").html(results)
                    }
                )
                rejectrequisitionmodal.modal("show")
                // enable the approve button
                rejectrequisitionbutton.prop("disabled",false)
                rejectreasonfield.focus()
                }
            }
        )
    })

    rejectrequisitionbutton.on("click",function(){
        var currentapprovallevel=rejectrequisitionmodal.find(".modal-body .data-current"),
            requisitionno=currentapprovallevel.attr("data-requisitionno"),
            approvallevel=currentapprovallevel.attr("data-id"),
            rejectedreason=rejectreasonfield.val()
        // check if user is allowed to approve requisition at this level
        $.post(
            "../controllers/materialoperations.php",
            {
                checkrequisitionapprovallevel:true,
                requisitionno,
                approvallevel
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    bootbox.alert({
                        message: `<i class="fas fa-exclamation-triangle fa-lg text-danger"></i> Sorry. Your are not allowed to perform this operation.`,
                        buttons: {
                            ok: 
                            {
                                label: 'Got it',
                                className: 'btn-sm btn-danger'
                            }
                        }
                    })
                }else{
                    $.post(
                        "../controllers/materialoperations.php",
                        {
                            rejectmaterialrequisition:true,
                            requisitionno,
                            approvallevel,
                            rejectedreason
                        },
                        function(data){
                            data=$.trim(data).toString()
                            if(data=="success"){
                                message="The requisition has been rejected successfully"
                                rejectrequisitionmodal.find(".modal-body").html(showAlert("success",message))
                                rejectrequisitionbutton.prop("disabled",true)
                            }else{
                                message=`Sorry an error occured ${data}`
                                rejectrequisitionmodal.find(".modal-body").html(showAlert("danger",message,1))
                            }     
                        }
                    )
                }
            }
        )
    })

    function disabledatefields(){   
        startdatefield.prop("disabled",true)
        enddatefield.prop("disabled",true)
        startdatelabel.addClass("text-muted")
        enddatelabel.addClass("text-muted")
    }

    function enabledatefields(){
        startdatefield.prop("disabled",false)
        enddatefield.prop("disabled",false)
        startdatelabel.removeClass("text-muted")
        enddatelabel.removeClass("text-muted")
    }

    // Toggle Filters collapsible panel text & icons
    $('#filterCollapse').on('show.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Close');
        $('#toggleFiltersBtn i').removeClass('fa-filter').addClass('fa-times');
    });
    $('#filterCollapse').on('hide.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Filters');
        $('#toggleFiltersBtn i').removeClass('fa-times').addClass('fa-filter');
    });

})