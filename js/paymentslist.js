$(document).ready(function(){
    var costcenterlist=$("#costcenter"),
        supplierlist=$("#supplier"),
        statuslist=$("#status"),
        paymentmodelist=$("#paymentmode"),
        alldates=$("#alldates"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        addnewbutton=$("#addnew"),
        searchbutton=$("#filterpayments"),
        errordiv=$("#errors"),
        searchresults=$("#results"),
        errordiv1=$("#results1");

    alldates.prop("checked",false);
    startdatefield.prop("disabled",false);
    enddatefield.prop("disabled",false);

    getPointsOfSale(costcenterlist,'all');
    getPaymentModes(paymentmodelist,'all');
    getSuppliers(supplierlist,'all');
    
    var today = new Date();
    var yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);

    startdatefield.flatpickr({
        dateFormat: 'd-M-Y',
        defaultDate: yesterday
    });
    enddatefield.flatpickr({
        dateFormat: 'd-M-Y',
        defaultDate: today
    });
    
    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdatefield.prop("disabled",true);
            enddatefield.prop("disabled",true);
        }else{
            startdatefield.prop("disabled",false);
            enddatefield.prop("disabled",false);
        }
    });

    addnewbutton.on("click",function(){
        window.location.href="paymentdetails.php";
    });

    // Handle floating action button click too
    $("#addnew-floating").on("click",function(e){
        e.preventDefault();
        window.location.href="paymentdetails.php";
    });

    // Toggle filter panel visibility
    $("#toggle-filters").on("click", function(e){
        e.preventDefault();
        var layout = $(".payments-grid-layout");
        layout.toggleClass("filters-hidden");
        
        var icon = $(this).find("i");
        if (layout.hasClass("filters-hidden")) {
            icon.removeClass("fa-chevron-up").addClass("fa-chevron-down");
        } else {
            icon.removeClass("fa-chevron-down").addClass("fa-chevron-up");
        }
        
        localStorage.setItem("show_payments_filters", !layout.hasClass("filters-hidden"));
    });

    // Restore user filter panel preference on page load (defaults to collapsed/false)
    var showFilters = localStorage.getItem("show_payments_filters");
    if (showFilters === null || showFilters === "false") {
        $(".payments-grid-layout").addClass("filters-hidden");
        $("#toggle-filters i").removeClass("fa-chevron-up").addClass("fa-chevron-down");
    }

    searchbutton.on("click",function(){
         var supplierid,posid, stat,paymentmode, startdate,enddate,errors='';
         supplierid=supplierlist.val();
         posid=costcenterlist.val();
         stat=statuslist.val();
         paymentmode=paymentmodelist.val();

        if (alldates.prop("checked")){
            startdate='01-Jan-2018';
            enddate='31-dec-2100';
        }else{
            // check for blank dates
            if(startdatefield.val()==''){
                errors="<p class='alert alert-danger'>Please select start date";
            }else if(enddatefield.val()==''){
                errors="<p class='alert alert-danger'>Please select end date";
            }else{
                startdate=startdatefield.val();
                enddate=enddatefield.val();
            }
        }
        if(errors==''){
            errordiv.html("");
            $.getJSON(
                "../controllers/paymentoperations.php",
                {
                    getpaymentvouchers:true,
                    supplierid:supplierid,
                    posid:posid,
                    stat:stat,
                    paymentmode:paymentmode,
                    startdate:startdate,
                    enddate:enddate
                },function(data){
                    var results="";
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td></td>"; // Dedicated responsive control column
                        results+="<td>"+parseInt(i+1)+"</td>";
                        results+="<td>"+data[i].voucherdate+"</td>";
                        results+="<td>"+data[i].voucherno+"</td>";
                        results+="<td>"+data[i].suppliername+"</td>";
                        results+="<td>"+data[i].posname+"</td>";
                        results+="<td>"+data[i].invoicenumber+"</td>";
                        results+="<td class='text-right'>"+$.number(data[i].vouchertotal)+"</td>";
                        results+="<td>"+data[i].paymentmodedescription+"</td>";
                        results+="<td>"+data[i].accountcode+" - "+data[i].accountname+"</td>";
                        results+="<td>"+data[i].referenceno+"</td>";
                        results+="<td>"+data[i].status+"</td>";
                        results+="<td class='text-center'>";
                        results+="<div class='dropdown'>";
                        results+="<a href='javascript:void(0)' class='text-secondary' data-toggle='dropdown' data-boundary='viewport' aria-haspopup='true' aria-expanded='false'>";
                        results+="<i class='fas fa-ellipsis-v fa-lg'></i>";
                        results+="</a>";
                        results+="<div class='dropdown-menu dropdown-menu-right'>";
                        results+="<a class='dropdown-item print' href='javascript:void(0)' data-id='"+data[i].voucherid+"' data-voucherno='"+data[i].voucherno+"'><i class='fas fa-print fa-fw mr-2 text-primary'></i>Print</a>";
                        results+="<a class='dropdown-item edit' href='javascript:void(0)' data-id='"+data[i].voucherid+"' data-voucherno='"+data[i].voucherno+"'><i class='fas fa-edit fa-fw mr-2 text-warning'></i>Edit</a>";
                        results+="<a class='dropdown-item approve' href='javascript:void(0)' data-id='"+data[i].voucherid+"'><i class='fas fa-thumbs-up fa-fw mr-2 text-success'></i>Approve</a>";
                        results+="<a class='dropdown-item delete' href='javascript:void(0)' data-id='"+data[i].voucherid+"'><i class='fas fa-trash-alt fa-fw mr-2 text-danger'></i>Delete</a>";
                        results+="</div>";
                        results+="</div>";
                        results+="</td></tr>";
                    }
                    if ($.fn.DataTable.isDataTable(searchresults)) {
                        searchresults.DataTable().destroy();
                    }
                    searchresults.find("tbody").html(results);
                    searchresults.DataTable({
                        responsive: {
                            details: {
                                type: 'column',
                                target: 0
                            }
                        },
                        pageLength: 15,
                        lengthMenu: [[10, 15, 25, 50, -1], [10, 15, 25, 50, "All"]],
                        dom: "<'row mb-2'<'col-12'B>><'row mb-3'<'col-6'l><'col-6'f>>rtip",
                        buttons: [
                            {
                                extend: 'excel',
                                className: 'btn btn-success',
                                text: '<i class="fas fa-file-excel mr-1"></i> Excel'
                            },
                            {
                                extend: 'csv',
                                className: 'btn btn-secondary',
                                text: '<i class="fas fa-file-csv mr-1"></i> CSV'
                            },
                            {
                                extend: 'pdf',
                                className: 'btn btn-danger',
                                text: '<i class="fas fa-file-pdf mr-1"></i> PDF'
                            }
                        ],
                        columnDefs: [
                            { className: 'dtr-control', orderable: false, targets: 0 },
                            { responsivePriority: 1, orderable: false, targets: 12 }, // Action column (highest priority, not sortable)
                            { responsivePriority: 2, targets: 3 },  // Voucher #
                            { responsivePriority: 3, targets: 4 },  // Supplier
                            { responsivePriority: 4, targets: 7 },  // Invoice Total (Amount)
                            { responsivePriority: 5, targets: 2 }   // Payment Date
                        ],
                        order: [[ 3, "desc" ]]
                    });
                }
            );
        }else{
            errordiv.html(errors);
        }
    });

    // listen to edit button
    searchresults.on("click",".edit", function(e){
        e.preventDefault();
        var id=$(this).attr("data-id"),
            voucherno=$(this).attr("data-voucherno");
        // check status of the payment voucher 
        $.getJSON(
            "../controllers/paymentoperations.php",
            {
                getvoucherstatus:true,
                id:id
            },
            function(data){
                var results=$.trim(data.toString());
                if(results!='Pending'){
                    bootbox.alert("Sorry! The payment voucher's status is <strong>"+results+"</strong> hence is non-editable");
                }else{
                    window.location.href="paymentdetails.php?id="+voucherno;
                }
            }
        );
    });

    // listen to approve button
    searchresults.on("click",".approve",function(e){
        e.preventDefault();
        var id=$(this).attr("data-id");
        var parent = $(this).closest("tr");
        var itemname=parent.find("td").eq(3).text(); // Index 3 is Voucher # now

        $.getJSON(
            "../controllers/paymentoperations.php",
            {
                getvoucherstatus:true,
                id:id
            },
            function(data){
                var results=$.trim(data.toString());
                if(results!='Pending'){
                    bootbox.alert("Sorry! The payment voucher's status is <strong>"+results+"</strong> hence cannot be approved");
                }else{
                    bootbox.dialog({
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
                                    $.post(
                                        "../controllers/paymentoperations.php",
                                        {
                                            approvepaymentvoucher:true,
                                            id:id
                                        },
                                        function(data){
                                            var results=$.trim(data.toString());
                                            if(results=='success'){
                                                errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Payment voucher # "+itemname+" has been approved successfully</p>";
                                            }else if(results=='not exists'){
                                                errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Sorry! Payment voucher # "+itemname+" was not found in the system</p>";
                                            }else{
                                                errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> "+results+"</p>";
                                            }
                                            errordiv1.html(errors);
                                        }
                                    );
                                    $('.bootbox').modal('hide');
                                }
                            }
                        }
                    });
                }
            }
        );
    });

    // listen to delete button
    searchresults.on("click",".delete",function(e){
        e.preventDefault();
        var id=$(this).attr("data-id");
        var parent = $(this).closest("tr");
        var itemname=parent.find("td").eq(3).text(); // Index 3 is Voucher # now

        $.getJSON(
            "../controllers/paymentoperations.php",
            {
                getvoucherstatus:true,
                id:id
            },
            function(data){
                var results=$.trim(data.toString());
                if(results!='Pending'){
                    bootbox.alert("Sorry! The payment voucher's status is <strong>"+results+"</strong> hence cannot be deleted");
                }else{
                    bootbox.prompt({
                        title: "Please provide reason for Cancellation!",
                        inputType: 'textarea',
                        callback: function (result) {
                            if (result === null) return; // Prompt cancelled
                            $.post(
                                "../controllers/paymentoperations.php",
                                {
                                    cancelpaymentvoucher:true,
                                    reason:result,
                                    id:id
                                },function(data){
                                    var results=$.trim(data.toString());
                                    if(results=="success"){
                                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Payment Voucher # <strong>" +itemname+"</strong> has been Cancelled successfully.</p>";
                                        if($.fn.DataTable.isDataTable(searchresults)){
                                            searchresults.DataTable().row(parent).remove().draw(false);
                                        } else {
                                            parent.remove();
                                        }
                                    }else if(results=='not pending'){
                                        errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Payment Voucher # <strong>" +itemname+"</strong> status is not Pending, hence not deletable.</p>";
                                    }else{
                                        errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> " +result+"</p>";
                                    }
                                    errordiv1.html(errors);
                                }
                            );
                        }
                    });
                }
            }
        );
    });

    searchresults.on("click",".print",function(e){
        e.preventDefault();
        var id=$(this).attr("data-voucherno");
        var url ="../printpaymentvoucher.php?voucherid="+id;
        var win = window.open(url, '_blank');
    });

    // Automatically trigger search on load to render the responsive DataTable
    searchbutton.click();
});