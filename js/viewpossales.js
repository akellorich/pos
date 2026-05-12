$(document).ready(function(){
    
    const poslist=$("#pos"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        paymentmodelist=$("#paymentmode"),
        searchbutton=$("#search"),
        alldates=$("#alldates"),
        errordiv=$("#errors"),
        report=$("#report"),
        errordiv1=$("#errors1"),
        cancelreceiptmodal=$("#cancelreceiptmodal"),
        modalerrordiv=$("#modalerror"),
        modalokbutton=$("#cancelreceipt"),
        modalreason=$("#cancelreason"),
        receiptidfield=$("#receiptid"),
        possaleslisttable=$("#possaleslist")
        
    let  id,parent,itemname

    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})
    
    getPointsOfSale(poslist)
    getPaymentModes(paymentmodelist)

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)
    
    alldates.on("click",function(){
       if(alldates.prop("checked")) {
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
       }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
       }
    })

    searchbutton.on("click",function(){
        var startdate,enddate, errors="", posid, paymentmode
        errordiv1.html("")
        startdatefield.removeClass("is-invalid text-danger")
        enddatefield.removeClass("is-invalid text-danger")

        if(alldates.prop('checked')){
            startdate='01-Jan-2000'
            enddate='31-dec-2100'
        }else{
            // check if dates have been provided
            if(startdatefield.val()==""){
                errors="Please provide start date"
                startdatefield.addClass("is-invalid text-danger")
            }else if(enddatefield.val()==""){
                errors="Please provide end date"
                enddatefield.addClass("is-invalid text-danger")
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        }
        //console.log(errors)
        if(errors==""){
            errordiv.html(showAlert("processing","Please wait ...",1))
            posid=poslist.val()
            paymentmode=paymentmodelist.val()
            $.getJSON(
                "../controllers/possalesoperations.php",
                {
                    getpossales:"GET",
                    paymentmode:paymentmode,
                    posid:posid,
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){                   
                    let results=''
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td>"+parseInt(i+1)+"</td>"
                        results+="<td>"+data[i].posname+"</td>"
                        results+="<td>"+data[i].receiptno+"</td>"
                        results+="<td>"+data[i].date+"</td>"
                        results+="<td>"+data[i].customername+"</td>"
                        results+="<td>"+data[i].description+"</td>" 
                        results+="<td>"+data[i].reference+"</td>"
                        results+="<td class='text-right font-weight-bold'>"+$.number(data[i].amount,0)+"</td>"
                        results+="<td>"+data[i].status+"</td>"
                        results+="<td>"+data[i].addedby+"</td>"
                        results+="<td><a href='#' class='view' data-id="+data[i].receiptno+"'><span><i class='fas fa-eye fa-sm' ></i></span></a></td>"
                        results+="<td><a href='../printreceipt.php?receiptno="+data[i].receiptno+"' target='_blank' class='printreceipt' data-receiptno="+data[i].receiptno+"><span><i class='fas fa-print fa-sm' ></i></span></a></td>"
                        results+=`<td><a href='#' class='delete validation' data-id="${data[i].receiptno}" id='48'><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>` 
                        results+=`<td><a href='#' class='refund validation' data-id="${data[i].receiptno}" id='48'><span><i class='fas fa-money-bill fa-sm'></span></i></a></td>` 
                    }
                    makedatatable(possaleslisttable,results,15)
                    errordiv.html("")   
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
            if(startdatefield.hasClass("is-invalid")){
                startdatefield.focus()
            }else if(enddatefield.hasClass("is-invalid")){
                enddatefield.focus()
            }
        }
    })

    const refundmodal=$("#refundmodal"),
        refunditemstable=$("#refunditems"), 
        completerefundbutton=$("#completerefund"),
        refundreasonfield=$("#refundreason"),
        refundnotifications=$("#refundnotifications"),
        refundreceiptnofield=$("#refundreceiptno")

    // listen to view click event
    possaleslisttable.on("click",".refund",function(e){
        e.preventDefault()
        const receiptno = $(this).attr('data-id')
        refundnotifications.html("")
        // console.log(id)
        // parent = $(this).parent("td").parent("tr")
        // itemname=parent.find("td").eq(2).text()
        refundreceiptnofield.val(receiptno)
        // show the modal
        refundmodal.modal('show')

        // get receipt details and show on the modal
        $.getJSON(
            "../controllers/possalesoperations.php",
            {
                getreceiptdetails:true,
                receiptno
            }).done((data)=>{
                let results=""
                data.forEach((item,index)=>{
                    results+=`<tr>
                        <td>${index+1}</td>
                        <td><input type="checkbox" class="refunditem" data-itemcode="${item.itemcode}"></td>
                        <td>${item.itemname}</td>
                        <td class="text-right">${item.unitprice}</td>
                        <td class="text-right">${item.quantity}</td>
                        <td class="text-right font-weight-bold">${$.number(item.unitprice*item.quantity,0)}</td>
                    </tr>`
                })
                refunditemstable.find("tbody").html(results)
                }
            ).fail((response,status,error)=>{
               errordiv1.html(showAlert("danger",`Sorry an error occured. ${response.responseText}`))  

            })
    })

    // Complete refund 
    completerefundbutton.on("click",function(){
        const receiptno=refundreceiptnofield.val(),
            reason=refundreasonfield.val(),
            items=[]
        refunditemstable.find(".refunditem:checked").each(function(){
            const item=$(this)   
            items.push({"itemcode":item.data("itemcode"),"quantity":item.closest("tr").find("td").eq(4).text()})
        })

        refundnotifications.html(showAlert("processing","Processing refund. Please wait...",1))

        if(reason==""){
            refundnotifications.html(showAlert("info","Please provide refund reason"))
            refundreasonfield.focus()
        }else if(items.length==0){
            refundnotifications.html(showAlert("info","Please select items to refund"))
        }else{
            $.post(
                "../controllers/possalesoperations.php",
                {
                    completerefund:true,
                    receiptno,
                    reason,
                    items:JSON.stringify(items)
                },
                function(data){  
                    if(isJSON(data)){
                        data=JSON.parse(data)   
                         if(data.status=="success"){
                            refundnotifications.html(showAlert("success",`Refund completed successfully. Refund Receipt No: <strong>${data.receiptno}</strong>    `))
                            // refundmodal.modal("hide")
                        }
                    }else{
                        refundnotifications.html(showAlert("danger",data.toString()))
                    }
                }
            ).fail((response,status,error)=>{
                refundnotifications.html(showAlert("danger",`Sorry an error occured. ${response.responseText}`))
            })
        }
    })

    // listen to delete click event
    possaleslisttable.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        // console.log(id)
        parent = $(this).parent("td").parent("tr");
        itemname=parent.find("td").eq(2).text()
        receiptidfield.val(id)
        // check if user has privileges to cancel the receipt
        $.post(
            "../controllers/useroperations.php",
            {
              getuserprivilege:true,
              objectid: 48
            },
            function(data){
                var allowed=parseInt($.trim(data.toString()))
                if(allowed==0){
                    bootbox.alert({
                    message: "Sorry. Your are not authorized to perform this operation.",
                    })
                }else{
                    // remove the text in the modal text field
                    modalreason.val("")
                    // show the modal
                    cancelreceiptmodal.modal('show')
                    // change the heading of the modal
                    cancelreceiptmodal.find('modal-title').html("Confirm DELETE Receipt #: <strong>"+itemname+"</strong>")
                }
            }
        )
    })

    // report.on("click",".printreceipt",function(e){
    //     e.preventDefault()
    //     const receiptno=$(this).data("receiptno")
    //     console.log(receiptno)
    // })

    //listen to print receipt
    possaleslisttable.on("click",".printreceipt",function(e){
        e.preventDefault()
        var $this=$(this)
        var receiptno=$this.attr("data-receiptno")
        url="../controllers/printa4receipt.php?receiptno="+receiptno
            win=window.open(url,"_blank")
        // get receipt details and check status
        // $.getJSON(
        //     "/controllers/possalesoperations.php",
        //     {
        //         getpossalereceipt:true,
        //         receiptno
        //     },
        //     (data)=>{
        //         // url=data[0].printed==0?url="../printreceipt.php?receiptno="+receiptno:url="/printduplicatereceipt.php?receiptno="+receiptno
        //         //console.log(url)
        //         url="../printreceipt.php?receiptno="+receiptno
        //         var win=window.open(url,"_blank")
        //     }
        // )
    })

    // listen to click ok button on the modal
    modalokbutton.on("click",function(){
        var reason=modalreason.val(),
            id=receiptidfield.val()
        if(reason===""){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-sm fa-fw'></i> Please enter cancellation reason first.</p>"
            modalerrordiv.html(errors)
        }else{
            $.post(
                "../controllers/possalesoperations.php",
                {
                    cancelreceipt:true,
                    receiptno:id,
                    reason:reason
                },
                function(data){
                    //console.log(data)
                    if($.trim(data.toString())=="The receipt has been deleted successfully"){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-sm fa-fw'></i>"+data.toString()+"</p>"
                        parent.remove()
                        // close the modal
                        cancelreceiptmodal.modal('hide')
                    }else{
                        errors="<p class='alert alert-danger'><i class='fas fa-exclamation-triangle fa-sm fa-fw'></i>"+data.toString()+"</p>"
                    }
                    errordiv1.html(errors)
                }
            )
        }
    })

    
})