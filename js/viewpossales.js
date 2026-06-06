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

    // Helper to format date as dd-M-yy (e.g., 31-May-2026)
    function getFormattedDate(date) {
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var day = date.getDate();
        var month = months[date.getMonth()];
        var year = date.getFullYear();
        return (day < 10 ? '0' + day : day) + '-' + month + '-' + year;
    }

    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})
    
    // Default to the last 1 day (yesterday to today)
    var today = new Date();
    var yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);

    alldates.prop("checked", false)
    startdatefield.prop("disabled", false)
    enddatefield.prop("disabled", false)

    startdatefield.val(getFormattedDate(yesterday))
    enddatefield.val(getFormattedDate(today))
    
    getPointsOfSale(poslist).done(function(){
        // Auto-populate data on page load
        setTimeout(function(){
            searchbutton.click();
        }, 100);
    })
    getPaymentModes(paymentmodelist)
    
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
                        results+="<tr><td><span class='row-details-toggle text-secondary' style='cursor: pointer;'><i class='fal fa-chevron-right' style='font-size: 8px !important;'></i></span></td>"
                        results+="<td>"+parseInt(i+1)+"</td>"
                        results+="<td class='d-none d-lg-table-cell'>"+data[i].posname+"</td>"
                        results+="<td>"+data[i].receiptno+"</td>"
                        results+="<td class='d-none d-lg-table-cell'>"+data[i].date+"</td>"
                        results+="<td>"+data[i].customername+"</td>"
                        results+="<td class='d-none d-lg-table-cell'>"+data[i].description+"</td>" 
                        results+="<td class='d-none d-md-table-cell'>"+data[i].reference+"</td>"
                        results+="<td class='text-right font-weight-bold'>"+$.number(data[i].amount,0)+"</td>"
                        results+="<td class='d-none d-md-table-cell'>"+data[i].status+"</td>"
                        results+="<td class='d-none d-lg-table-cell'>"+data[i].addedby+"</td>"
                        results+=`<td class='text-center'>
                            <div class="dropdown">
                                <button class="btn btn-link btn-sm text-secondary p-0 border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="outline: none; box-shadow: none;">
                                    <i class="fal fa-ellipsis-v fa-lg"></i>
                                </button>
                                <div class="dropdown-menu dropdown-menu-right" style="font-size: 0.82rem; border-radius: 6px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); border: 1px solid rgba(0,0,0,0.08);">
                                    <a class="dropdown-item view" href="#" data-id="${data[i].receiptno}"><i class="fal fa-eye mr-2 text-primary fa-fw"></i> View Details</a>
                                    <a class="dropdown-item printreceipt" href="../printreceipt.php?receiptno=${data[i].receiptno}" target="_blank" data-receiptno="${data[i].receiptno}"><i class="fal fa-print mr-2 text-info fa-fw"></i> Print Receipt</a>
                                    <a class="dropdown-item refund validation" href="#" data-id="${data[i].receiptno}" id="48"><i class="fal fa-undo-alt mr-2 text-warning fa-fw"></i> Refund Sale</a>
                                    <a class="dropdown-item delete validation" href="#" data-id="${data[i].receiptno}" id="48"><i class="fal fa-times-circle mr-2 text-danger fa-fw"></i> Cancel Receipt</a>
                                </div>
                            </div>
                        </td></tr>`
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
        parent = $(this).closest("tr");
        itemname=parent.find("td").eq(3).text()
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

    // listen to print receipt
    possaleslisttable.on("click",".printreceipt",function(e){
        e.preventDefault()
        var receiptno=$(this).attr("data-receiptno")
        printReceiptAction(receiptno);
    })

    $("#modalprintreceipt").on("click", function(e){
        e.preventDefault()
        var receiptno=$(this).attr("data-receiptno")
        printReceiptAction(receiptno);
    })

    async function getReceiptData(url, receiptno) {
        const operations = [
            fetchData(url, { getreceiptheader: true }),
            fetchData(url, { getreceiptdetails: true, receiptno: receiptno }),
            fetchData(url, { getreceiptpaymentmethods: true, receiptno: receiptno }),
            fetchData(url, { getreceiptvatanalysis: true, receiptno: receiptno }),
        ];

        // Wait for all promises to resolve
        const [receiptHeader, receiptDetails, paymentMethods, vatAnalysis] = await Promise.all(operations);

        // Return an object containing the variables
        return { receiptHeader, receiptDetails, paymentMethods, vatAnalysis };
    }

    function printReceiptAction(receiptno) {
        if (!receiptno) return;

        // Initialize printer name from saved settings
        const deviceID = getOrCreateDeviceID();
        const settings = loadSettings(deviceID);
        if (settings && settings.length > 0) {
            printername = settings[0].name;
        }

        // Use thermal printer printing directly via QZ Tray
        connecttoprinter().then(() => {
            const encoder = new ESCPOSEncoder();
            getReceiptData('../controllers/possalesoperations.php', receiptno)
                .then(({ receiptHeader, receiptDetails, paymentMethods, vatAnalysis }) => {

                    const header = receiptHeader[0],
                        receiptheader = receiptDetails[0],
                        solditems = [],
                        paymentmodes = [],
                        vatanalysis = [],
                        receiptfooter = (header.receiptfooter).split("<br>")

                    // Helper to format: dd-mmm-yyyy hh:mm AM/PM (e.g. 25-May-2026 02:13 PM)
                    const formatReceiptDateTime = (dateStr) => {
                        if (!dateStr) return '';
                        const parts = dateStr.split(' ');
                        if (parts.length >= 2) {
                            const datePart = parts[0];
                            const timeParts = parts[1].split(':');
                            if (timeParts.length >= 2) {
                                let hours = parseInt(timeParts[0], 10);
                                const minutes = timeParts[1];
                                const ampm = hours >= 12 ? 'PM' : 'AM';
                                hours = hours % 12;
                                hours = hours ? hours : 12;
                                return `${datePart} ${String(hours).padStart(2, '0')}:${minutes} ${ampm}`;
                            }
                        }
                        return dateStr;
                    };

                    const formattedDate = formatReceiptDateTime(receiptheader.receiptdate);

                    let receipttotal = 0
                    // populate sold items
                    receiptDetails.forEach((item, i) => {
                        const uomStr = item.uom ? ` ${item.uom}` : '';
                        solditems.push([`${i + 1}. ${item.itemcode}`, ($.number(item.quantity * (item.unitprice - item.discount))).toString()])
                        solditems.push([item.itemname, `${item.quantity}${uomStr} x ${$.number(item.unitprice - item.discount).toString()}`])
                        receipttotal += item.quantity * (item.unitprice - item.discount)
                    })

                    paymentMethods.forEach((paymentmode) => {
                        paymentmodes.push([paymentmode.paymentmethod, paymentmode.reference, $.number(paymentmode.amount).toString()])
                    })

                    vatAnalysis.forEach((vat) => {
                        const taxRateLabel = parseFloat(vat.taxrate) + "%";
                        vatanalysis.push([vat.abbreviation, taxRateLabel, $.number(vat.vat, 2)])
                    })

                    receipttotal = $.number(receipttotal, 2).toString()

                    const data = encoder
                        .initialize()
                        .align('center')
                        .text(header.name)
                        .feed()
                        .text(header.physicaladdress)
                        .feed()
                        .text('P.O BOX ' + header.postaladdress)
                        .feed()
                        .text('TEL: ' + header.landline)
                        .feed()
                        .text('Email: ' + header.email)
                        .feed()
                        .text('PIN: ' + header.pinno)
                        .feed()
                        .text('OFFICIAL RECEIPT')
                        .feed()
                        .barcode(receiptno)
                        .feed()
                        .align('left')
                        .text('Date: ' + formattedDate)
                        .feed()
                        .text('Outlet: ' + receiptheader.posname)
                        .feed()
                        .text('Customer: ' + receiptheader.customername)
                        .feed()
                        .line("-")
                        .align('left')
                        .tableRow(['ITEM', 'TOTAL'], ['left', 'right'])
                        .line("-")
                        .tableRows(solditems, ['left', 'right'])
                        .line("-")
                        .tableRow(['TOTAL', receipttotal], ['left', 'right'])
                        .line("=")
                        .feed()
                        .text("PAYMENT METHODS")
                        .feed()
                        .line("-")
                        .tableRow(['MODE', 'REF #', 'AMOUNT'], ['left', 'left', 'right'])
                        .line("-")
                        .tableRows(paymentmodes, ['left', 'left', 'right'])
                        .line("-")
                        .feed()
                        .text("VAT ANALYSIS")
                        .feed()
                        .line("-")
                        .tableRow(['CODE', 'RATE', 'AMOUNT'], ['left', 'right', 'right'])
                        .line("-")
                        .tableRows(vatanalysis, ['left', 'right', 'right'])
                        .line("-")
                        .align('left')
                        .multiplelines(receiptfooter)
                        .line("-")
                        .text('Served By: ' + receiptheader.servedby)
                        .newline(2)
                        .cut()
                        .encode()

                    qz.print(config, data);
                })
                .catch(error => {
                    console.error('Error fetching receipt data:', error);
                });
        }).catch(err => {
            console.error('QZ connection failed, falling back to window.open:', err);
            var url = "../printreceipt.php?receiptno=" + receiptno;
            window.open(url, '_blank');
        });
    }

    // listen to view details click event
    possaleslisttable.on("click", ".view", function(e) {
        e.preventDefault();
        const receiptno = $(this).attr("data-id");
        
        const viewmodal = $("#viewreceiptmodal");
        const modalcontent = $("#receipt-modal-content");
        const printbtn = $("#modalprintreceipt");
        
        printbtn.attr("data-receiptno", receiptno);
        modalcontent.html('<div class="text-center py-4"><i class="fal fa-spinner fa-spin fa-2x text-muted"></i></div>');
        viewmodal.modal("show");
        
        // Fetch all details concurrently via $.when
        $.when(
            $.getJSON("../controllers/possalesoperations.php", { getinstitutiondetails: true }),
            $.getJSON("../controllers/possalesoperations.php", { getreceiptdetails: true, receiptno: receiptno }),
            $.getJSON("../controllers/possalesoperations.php", { getreceiptpaymentmethods: true, receiptno: receiptno }),
            $.getJSON("../controllers/possalesoperations.php", { getreceiptvatanalysis: true, receiptno: receiptno })
        ).done(function(companyRes, detailsRes, paymentsRes, vatRes) {
            const company = companyRes[0];
            const details = detailsRes[0];
            const payments = paymentsRes[0];
            const vat = vatRes[0];
            
            if (!details || details.length === 0) {
                modalcontent.html('<div class="alert alert-danger p-2 text-center">No details found for this receipt.</div>');
                return;
            }
            
            const firstItem = details[0];
            const servedby = firstItem.servedby || "";
            
            let itemsHtml = "";
            let overalltotal = 0;
            details.forEach(item => {
                const unitprice = parseFloat(item.unitprice) - parseFloat(item.discount || 0);
                const qty = parseFloat(item.quantity);
                const itemTotal = unitprice * qty;
                overalltotal += itemTotal;
                
                itemsHtml += `
                    <tr>
                        <td class="text-left font-weight-bold" style="padding: 2px 0;">${item.itemname}</td>
                        <td class="text-right font-weight-bold" style="padding: 2px 0;">${$.number(itemTotal)}</td>
                    </tr>
                    <tr>
                        <td class="text-left text-muted" style="padding: 0 0 6px 0; font-size: 0.72rem;">Code: ${item.itemcode}</td>
                        <td class="text-right text-muted" style="padding: 0 0 6px 0; font-size: 0.72rem;">${qty} x ${$.number(unitprice)}</td>
                    </tr>
                `;
            });
            
            let paymentsHtml = "";
            let amountpaid = 0;
            if (payments && payments.length > 0) {
                payments.forEach(pm => {
                    const amt = parseFloat(pm.amount);
                    amountpaid += amt;
                    paymentsHtml += `
                        <tr>
                            <td class="text-left" style="padding: 2px 0;">${pm.paymentmethod}</td>
                            <td class="text-center" style="padding: 2px 0;">${pm.reference || ""}</td>
                            <td class="text-right" style="padding: 2px 0;">${$.number(amt)}</td>
                        </tr>
                    `;
                });
            }
            
            const balance = amountpaid - overalltotal;
            
            let vatHtml = "";
            if (vat && vat.length > 0) {
                vat.forEach(v => {
                    const total = parseFloat(v.total);
                    const rate = parseFloat(v.taxrate);
                    const taxAmount = (rate * total) / (100 + rate);
                    vatHtml += `
                        <tr>
                            <td class="text-left" style="padding: 2px 0;">${v.abbreviation} - ${rate}%</td>
                            <td class="text-right" style="padding: 2px 0;">${$.number(total)}</td>
                            <td class="text-right" style="padding: 2px 0;">${$.number(taxAmount, 2)}</td>
                        </tr>
                    `;
                });
            }
            
            let html = `
                <div class="text-center font-weight-bold" style="font-size: 0.88rem; letter-spacing: 0.5px; color: #111;">${company.name.toUpperCase()}</div>
                <div class="text-center text-muted" style="font-size: 0.72rem;">${company.physicaladdress || ""}</div>
                <div class="text-center text-muted" style="font-size: 0.72rem;">P.O Box ${company.postaladdress || ""}</div>
                <div class="text-center text-muted" style="font-size: 0.72rem;">Tel: ${company.landline || company.mobile || ""}</div>
                <div class="text-center text-muted" style="font-size: 0.72rem;">${company.email || ""}</div>
                <div class="text-center text-muted font-weight-bold" style="font-size: 0.72rem;">PIN: ${company.pinno || ""}</div>
                <hr style="border-top: 1px dashed #bbb; margin: 8px 0;">
                
                <table style="width: 100%; font-size: 0.74rem; margin-bottom: 6px;">
                    <tr><td style="width: 80px; color: #666; padding: 1px 0;">POS:</td><td class="font-weight-bold" style="padding: 1px 0;">${firstItem.posname || ""}</td></tr>
                    <tr><td style="color: #666; padding: 1px 0;">Receipt #:</td><td class="font-weight-bold" style="padding: 1px 0;">${firstItem.receiptno}</td></tr>
                    <tr><td style="color: #666; padding: 1px 0;">Date:</td><td class="font-weight-bold" style="padding: 1px 0;">${firstItem.receiptdate}</td></tr>
                    <tr><td style="color: #666; padding: 1px 0;">Client:</td><td class="font-weight-bold" style="padding: 1px 0;">${firstItem.customername || "WALKIN CUSTOMER"}</td></tr>
                </table>
                <hr style="border-top: 1px dashed #bbb; margin: 8px 0;">
                
                <table style="width: 100%; font-size: 0.74rem;">
                    <thead>
                        <tr style="border-bottom: 1px dashed #ccc; font-weight: bold;">
                            <th class="text-left" style="padding-bottom: 4px;">Item</th>
                            <th class="text-right" style="padding-bottom: 4px;">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${itemsHtml}
                    </tbody>
                </table>
                <hr style="border-top: 1px dashed #bbb; margin: 6px 0;">
                
                <table style="width: 100%; font-size: 0.76rem;">
                    <tr class="font-weight-bold" style="font-size: 0.8rem; color: #000;">
                        <td class="text-left">TOTAL DUE:</td>
                        <td class="text-right">${$.number(overalltotal)}</td>
                    </tr>
                </table>
                <hr style="border-top: 1px dashed #bbb; margin: 6px 0;">
                
                <table style="width: 100%; font-size: 0.72rem; margin-bottom: 4px;">
                    <thead>
                        <tr class="font-weight-bold text-muted">
                            <td class="text-left" style="padding-bottom: 4px;">Payment</td>
                            <td class="text-center" style="padding-bottom: 4px;">Ref#</td>
                            <td class="text-right" style="padding-bottom: 4px;">Amount</td>
                        </tr>
                    </thead>
                    <tbody>
                        ${paymentsHtml}
                        <tr style="border-top: 1px dashed #ddd; font-weight: bold; color: #111;">
                            <td class="text-left" colspan="2" style="padding-top: 4px;">TOTAL PAID:</td>
                            <td class="text-right" style="padding-top: 4px;">${$.number(amountpaid)}</td>
                        </tr>
                        <tr class="font-weight-bold" style="color: #111;">
                            <td class="text-left" colspan="2">BALANCE:</td>
                            <td class="text-right">${$.number(balance)}</td>
                        </tr>
                    </tbody>
                </table>
                <hr style="border-top: 1px dashed #bbb; margin: 6px 0;">
                
                <table style="width: 100%; font-size: 0.7rem; color: #555;">
                    <thead>
                        <tr class="font-weight-bold" style="border-bottom: 1px dashed #eee;">
                            <th class="text-left" style="padding-bottom: 2px;">VAT (%)</th>
                            <th class="text-right" style="padding-bottom: 2px;">Amount</th>
                            <th class="text-right" style="padding-bottom: 2px;">Tax</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${vatHtml}
                    </tbody>
                </table>
                <hr style="border-top: 1px dashed #bbb; margin: 8px 0;">
                
                <div class="text-center font-weight-bold text-dark mb-1" style="font-size: 0.72rem;">MPESA TILL Number: 4653064</div>
                <div class="text-center text-muted" style="font-size: 0.68rem; line-height: 1.3;">Thanks for shopping with us. Please come again. Goods once sold are not returnable or refundable.</div>
                <hr style="border-top: 1px dashed #bbb; margin: 8px 0;">
                
                <div style="font-size: 0.72rem; color: #111;">
                    <strong>Served By:</strong> ${servedby}
                </div>
            `;
            modalcontent.html(html);
        }).fail(function() {
            modalcontent.html('<div class="alert alert-danger p-2 text-center">Error loading receipt details. Please try again.</div>');
        });
    });

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

    // Toggle Sidebar Settings collapsible panel text & icons on mobile
    $('#step1FilterCollapse').on('show.bs.collapse', function () {
        $('#toggleSidebarBtn span').text('Close Filters');
        $('#toggleSidebarBtn i').removeClass('fa-filter').addClass('fa-times');
    });
    $('#step1FilterCollapse').on('hide.bs.collapse', function () {
        $('#toggleSidebarBtn span').text('Filters');
        $('#toggleSidebarBtn i').removeClass('fa-times').addClass('fa-filter');
    });

    // Responsive table details row toggle
    possaleslisttable.on("click", ".row-details-toggle", function(e) {
        e.preventDefault();
        const btn = $(this);
        const icon = btn.find("i");
        const row = btn.closest("tr");
        
        if (row.next().hasClass("detail-row")) {
            row.next().remove();
            icon.removeClass("fa-chevron-down text-danger").addClass("fa-chevron-right text-secondary");
        } else {
            const pos = row.find("td").eq(2).html();
            const date = row.find("td").eq(4).html();
            const paymode = row.find("td").eq(6).html();
            const ref = row.find("td").eq(7).html();
            const status = row.find("td").eq(9).html();
            const addedby = row.find("td").eq(10).html();
            
            const detailHtml = `
                <tr class="detail-row" style="background-color: #fcfdfd;">
                    <td colspan="12" class="p-2">
                        <div class="card shadow-none border-0 m-0" style="background-color: #f8fafc; border-radius: 6px; font-size: 0.74rem; border: 1px solid #e2e8f0 !important;">
                            <div class="card-body p-2">
                                <div class="row text-left" style="margin: 0 !important; padding: 0 !important;">
                                    <div class="col-6 mb-1 d-lg-none" style="padding: 0 4px !important;"><strong>POS:</strong> ${pos}</div>
                                    <div class="col-6 mb-1 d-lg-none" style="padding: 0 4px !important;"><strong>Date:</strong> ${date}</div>
                                    <div class="col-6 mb-1 d-lg-none" style="padding: 0 4px !important;"><strong>Payment Mode:</strong> ${paymode}</div>
                                    <div class="col-6 mb-1 d-md-none" style="padding: 0 4px !important;"><strong>Reference#:</strong> ${ref}</div>
                                    <div class="col-6 mb-1 d-md-none" style="padding: 0 4px !important;"><strong>Status:</strong> ${status}</div>
                                    <div class="col-6 mb-1 d-lg-none" style="padding: 0 4px !important;"><strong>Added By:</strong> ${addedby}</div>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            `;
            row.after(detailHtml);
            icon.removeClass("fa-chevron-right text-secondary").addClass("fa-chevron-down text-danger");
        }
    });
})