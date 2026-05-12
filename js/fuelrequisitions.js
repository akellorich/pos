$(document).ready(()=>{
    const requisitionidfield=$("#requisitionid"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        alldatesfield=$("#alldates"),
        filtercostcenterfield=$("#filtercostcenter"),
        filtersupplierfield=$("#filtersupplier"),
        filtervehiclefield=$("#filtervehicle"),
        datepickerfields=$(".datepicker"),
        supplierfield=$("#supplier"),
        costcenterfield=$("#costcenter"),
        vehiclefield=$("#vehicle"),
        addrequisitionbutton=$("#addrequisition"),
        addrequisitionmodal=$("#requisitiondetailsmodal"),
        requestedbyfield=$("#requestedby"),
        approvalbyfield=$("#approvalby"),
        saverequisitionbutton=$("#saverequisition"),
        quantityfield=$("#quantity"),
        unitpricefield=$("#unitprice"),
        odoreadingfield=$("#odoreading"),
        requisitionerrors=$("#requisitionerrors"),
        requisitiontable=$("#fuelrequisitions"),
        filterrequisitionsbutton=$("#filterrequisitions"),
        filtererrors=$("#filtererrors"),
        totalfield=$("#total"),
        requisitiondetailserrors=$("#requisitiondetailerrors")
        pattern={
            number:/^[0-9\.]+$/
        }


    // set up date pickers 
    datepickerfields.datepicker({dateFormat: 'dd-M-yy'})
    alldatesfield.prop("checked",true)
    toggledatefields()

    function toggledatefields(){
        datepickerfields.prop("disabled",!datepickerfields.prop("disabled"))
    }

    alldatesfield.on("click",()=>{
        toggledatefields()
    })

    // get all suppliers, cost centers, vehicles and users
    getSuppliers(filtersupplierfield)
    getSuppliers(supplierfield,'choose')

    getPointsOfSale(filtercostcenterfield)
    getPointsOfSale(costcenterfield,'choose')

    getvehicles(filtervehiclefield)
    getvehicles(vehiclefield,'choose')

    getsystemusers(requestedbyfield,'choose')
    getsystemusers(approvalbyfield,'choose')

    // show add new requisition modal
    addrequisitionbutton.on("click",()=>{
        totalfield.val()
        requisitionerrors.html("")
        addrequisitionmodal.modal("show")
    })

    // save the requisition
    saverequisitionbutton.on("click",()=>{
        const id=requisitionidfield.val(),
            supplierid=supplierfield.val(), 
            costcenterid=costcenterfield.val(), 
            vehicleid=vehiclefield.val(), 
            quantity=quantityfield.val(),
            unitprice=unitpricefield.val(), 
            odoreading=odoreadingfield.val(), 
            requestedby=requestedbyfield.val(), 
            approvalby=approvalbyfield.val()
            
           
        let errors='',notifications=''
        // check for blank fields
        if(supplierid==""){
            errors="Please select the supplier"
            supplierfield.focus()
        }else if(costcenterid==""){
            errors="Please select cost center"
            costcenterfield.focus()
        }else if(vehicleid==""){
            errors="Please select Vehicle"
            vehiclefield.focus()
        }else if(quantity=="" || Number(quantity)==0){
            errors="Please provide correct quantity"
            quantityfield.focus()
        }else if(unitprice=="" || Number(unitprice)==0){
            errors="Please provide correct unit price"
            unitpricefield.focus()
        }else if(odoreading=="" || Number(odoreading)==0){
            errors="Please enter correct odo meter reading"
            odoreadingfield.focus()
        }else if(requestedby==""){
            errors="Please select the requestor"
            requestedbyfield.focus()
        }else if(approvalby==""){
            errors="Please select the approver"
            approvalbyfield.focus()
        }

        if(errors==""){
            $.post(
                "../controllers/fleetoperations.php",
                {
                    savefuelrequisition:true,
                    id,
                    supplierid,
                    costcenterid,
                    vehicleid,
                    requestedby,
                    approvalby,
                    quantity,
                    unitprice,
                    odoreading
                },
                (data)=>{
                    data=data.trim()
                    if(data.length==8 || data.length==9 || data.length==10){
                        notifications=`The requisition has been saved successfully. Requisition # is <strong>${data}</strong>`
                        requisitionerrors.html(showAlert("success",notifications))
                        let url="../printfuelrequisition.php?requisitionno="+data
                        window.open(url, '_blank');
                        // clear the form
                        clearrequisitionform()
                        // refresh the list
                    }else{
                        notifications=`Sorry an error occured.${data}`
                        requisitionerrors.html(showAlert("danger",notifications))
                    }
                }
            )
        }else{
            // display blank field error(s) to the user
            requisitionerrors.html(showAlert("info",errors))
        }
    })

    function clearrequisitionform(){
        requisitionidfield.val("0")
        supplierfield.val("")
        costcenterfield.val("")
        vehiclefield.val("")
        quantityfield.val("")
        unitpricefield.val("")
        odoreadingfield.val("")
        requestedbyfield.val("")
        approvalbyfield.val("")
        totalfield.val("")
    }

    function filterrequisitions(){
        const supplierid=filtersupplierfield.val(),
            costcenterid=filtercostcenterfield.val(),
            vehicleid=filtervehiclefield.val()
        let startdate=startdatefield.val(),
            enddate=enddatefield.val(),
            errors='',
            notifications='',
            i=1,
            requisitiontotal=0

        if(alldatesfield.prop("checked")){
            startdate='01-Jan-2020'
            enddate='31-Dec-2100'
        }else{
            if(startdate==""){ 
                errors="Please provide start date"
            }else if(enddate==""){
                errors="Please provide end date"
            }
        }

        if(errors==""){
            filtererrors.html(showAlert("processing","Processing. Please wait ...",1))
            $.getJSON(
                "../controllers/fleetoperations.php",
                {
                    filterrequisitions:true,startdate,enddate, supplierid, costcenterid,vehicleid
                },
                (data)=>{
                    results=""
                    if(data.length>0){
                        data.forEach((requisition)=>{
                            requisitiontotal=requisition.quantity*requisition.unitprice
                            results+=`<tr><td>${i}</td>`
                            results+=`<td>${requisition.requisitionno}</td>`
                            results+=`<td>${requisition.dateadded}</td>`
                            results+=`<td>${requisition.suppliername}</td>`
                            results+=`<td>${requisition.posname}</td>`
                            results+=`<td>${requisition.vehiclename}</td>`
                            results+=`<td>${requisition.quantity}</td>`
                            results+=`<td>${requisition.unitprice}</td>`
                            results+=`<td>${requisitiontotal}</td>`
                            results+=`<td>${requisition.status}</td>`
                            if(requisition.status=="Pending"){
                                results+=`<td data-id='${requisition.id}' data-requisitionno='${requisition.requisitionno}'>
                                    <div class='d-flex justify-content-center align-items-center'>
                                        <i class='far fa-edit fa-lg editrequisition m-1'></i>
                                        <i class='far fa-thumbs-up fa-lg approverequisition m-1'></i>
                                        <i class='far fa-times-circle fa-lg cancelrequisition m-1'></i>
                                        <!--<i class='far fa-print fa-lg printrequisition m-1'></i>-->
                                    </div>
                                </td></tr>`
                            }else if(requisition.status=="Approved"){
                                results+=`<td data-id='${requisition.id}' data-requisitionno='${requisition.requisitionno}'>
                                <div class='d-flex justify-content-center align-items-center'>
                                    <i class='far fa-print fa-lg printrequisition m-1'></i></td></tr>
                                </div>`
                            }else{
                                results+=`</td></tr>`
                            }
                            i++
                        })
                    }else{
                        results=`<tr><td class='ml-3 mt-3' colspan='11'><i class='far fa-info-circle fa-lg printrequisition'></i> Sorry there are currently no requisitions in the system.</td></tr>`
                    }   
                    // add items to the table
                    requisitiontable.find("tbody").html(results)
                    filtererrors.html("")
                }
            )
        }else{
            filtererrors.html(showAlert("info",errors,1))
        }
    }

    // listen to edit
    requisitiontable.on("click",".editrequisition",function(){
        const $this=$(this),
            parent=$this.parent("div").parent("td"),
            id=parent.attr("data-id")
            // get requisition details and populate in the modal
        $.getJSON(
            "../controllers/fleetoperations.php",
            {
                getrequisitiondetails:true,
                id
            },
            (data)=>{
                requisitionidfield.val(data[0].id)
                supplierfield.val(data[0].supplierid)
                costcenterfield.val(data[0].costcenterid)
                vehiclefield.val(data[0].vehicleid)
                quantityfield.val(data[0].quantity)
                unitpricefield.val(data[0].unitprice)
                approvalbyfield.val(data[0].approvedby)
                requestedbyfield.val(data[0].requestedby)
                totalfield.val(data[0].quantity*data[0].unitprice)
                odoreadingfield.val(data[0].odoreading)
                requisitionerrors.html("")
                addrequisitionmodal.modal("show")
            }
        )
    })

    // listen to update
    requisitiontable.on("click",".approverequisition", function(){
        const $this=$(this),
            parent=$this.parent("div").parent("td"),
            id=parent.attr("data-id"),
            requisitionno=parent.attr("data-requisitionno")
        let notifications=''
        // confirm bootbox
        bootbox.dialog({
            // title: "Confirm Item Removal!",
            message: "Are you sure you want to approve Requisition # <strong>"+requisitionno+"</strong>",
            buttons: {
                success: {
                    label: "Don't Approve",
                    className: "btn-danger btn-sm",
                    callback: function() {
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Approve Requisition",
                    className: "btn-success btn-sm",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/fleetoperations.php",
                            {
                                approverequisition:true,
                                id
                            },
                            (data)=>{
                                data=data.trim()
                                if(data=="success"){
                                    notifications=`Requisition number <strong>${requisitionno}</strong> approved successfully.`
                                    requisitiondetailserrors.html(showAlert("success",notifications))
                                    parent.remove()
                                    $('.bootbox').modal('hide');
                                    // refresh the list
                                    filterrequisitions()
                                }else{
                                    notifications=`Sorry an error occured. ${data}`
                                    requisitiondetailserrors.html(showAlert("danger",notifications,1))
                                    $('.bootbox').modal('hide');
                                }
                            }
                        )
                    }
                }
            }
        })
    })

    // print requisition form
    requisitiontable.on("click",".printrequisition",function(){
        const $this=$(this),
            parent=$this.parent("div").parent("td"),
            // id=parent.attr("data-id"),
            requisitionno=parent.attr("data-requisitionno")
            // console.log(requisitionno)
        // $.post(
        //     "../controllers/printfuelrequisition.php",
        //     {
        //         requisitionno
        //     }
        // )
        window.open(`../controllers/printfuelrequisition.php?requisitionno=${requisitionno}`, "_blank") 
    })

    // filter requisitions
    filterrequisitionsbutton.on("click",()=>{
        filterrequisitions()
    })

    quantityfield.on("input",()=>{
        let quantity=quantityfield.val(),
            unitprice=unitpricefield.val()
        if(pattern.number.test(quantity) && pattern.number.test(unitprice)){
            const total=quantity*unitprice
            totalfield.val(total)
        }else{
            totalfield.val("")
        }
    })

    unitpricefield.on("input",()=>{
        let quantity=quantityfield.val(),
            unitprice=unitpricefield.val()
        if(pattern.number.test(quantity) && pattern.number.test(unitprice)){
            const total=quantity*unitprice
            totalfield.val(total)
        }else{
            totalfield.val("")
        }
    })
    
})