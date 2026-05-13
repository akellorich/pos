$(document).ready(()=>{
    const touchuitoggler=$("#touchscreen"),
        touchui=$("#touchui"),
        outletfield=$("#outlet"),
        tablefield=$("#table"),
        customerfield=$("#customer"),
        categorybuttonslist=$("#categorybuttons"),
        productlist=$("#productlist"),
        transactiondatefield=$("#orderdate"),
        ordernotifications=$("#ordernotifications"),
        ordertotalfield=$("#ordertotal"),
        orderitemstable=$("#orderitemstable"),
        savecustomerorderbutton=$("#savecustomerorder"),
        inputfield=$("input"),
        selectfield=$("select"),
        paymentoptions=$("#paymentoptions"),
        orderdetailsmodal=$("#orderdetailsmodal"),
        orderdetailstable=$("#orderdetailstable")

        // amountpaidfield=$("#amountpaid"),
        // balancefield=$("#balanceamount"),
        // overalltotal=$("#overalltotalamount")

    const printersettingsbutton=$("#printersettings"),
        printersettingsmodal=$("#printersettingsmodal"),
        deviceidcontrol=$("#deviceid"),
        printerconnectioncontrol=$("#printerconnection"),
        printernamecontrol=$("#printername"),
        saveprinterconfigbutton=$("#saveprinterconfig"),
        printernotifications=$("#printernotifications"),
        testprinterbutton=$("#testprinter")

    let deviceID,settings

    deviceID = getOrCreateDeviceID()
    settings = loadSettings(deviceID)

    if (settings) {
        printerconnectioncontrol.val(settings[0].connection)
        printername=settings[0].name
        printernamecontrol.html(`<option='${settings[0].name}'>${settings[0].name}</option>`)
    }

    printersettingsbutton.on("click",()=>{
        deviceID = getOrCreateDeviceID()
        settings = loadSettings(deviceID)
        getsystemprinters().done(()=>{
            deviceidcontrol.val(deviceID)
            if (settings) {
                // console.log('Loaded settings:', settings);
                // Apply settings to the application
                printerconnectioncontrol.val(settings[0].connection)
                printernamecontrol.val(settings[0].name)
                testprinterbutton.prop("disabled",false)
            } else {
                // deviceidcontrol.val("Device ID not configured")
                ordernotifications.html(showAlert("info",`Receipt printer not yet configured. Please complete this process first`,1))
                printerconnectioncontrol.val("")
                printernamecontrol.val("")
                testprinterbutton.prop("disabled",true)
            }  
            printersettingsmodal.modal('show')
        })

        
    })
    
    testprinterbutton.on("click",()=>{
        testposprinter()
    })

    //  load printers installed on the system
    function getsystemprinters() {
        let dfd = $.Deferred();
        connecttoprinter().then(()=>{
            qz.printers.find().then((printers) => {
                let results = printers.map(printer => `<option value='${printer}'>${printer}</option>`).join('');
                printernamecontrol.html(results);
                dfd.resolve();
            }).catch(err => {
                console.error("Error fetching printers:", err);
                dfd.reject(err)
            })
        })

        return dfd.promise();
    }
    
    saveprinterconfigbutton.on("click",function(){
        const printersettings=[],
            connection=printerconnectioncontrol.val(),
            printername=printernamecontrol.val()

        let errors=""

        if(connection=="" || connection==undefined){
            errors="Please select printer connection mode"
            printerconnectioncontrol.focus()
        }else if(printername=="" || printername==undefined){
            errors="Please select printer name"
            printernamecontrol.focus()
        }

        if(errors==""){
            printernotifications.html(showAlert("processing","Processing. Please wait ...",1))
            printersettings.push({"connection":connection,"name":printername})
            saveSettings(deviceID, printersettings)
            printernotifications.html(showAlert("success",`Printer configuration saved successfully`))
        }else{
            printernotifications.html(showAlert("info",errors))
        }   
    })


    setDatePicker(transactiondatefield)
    // get todays date and set on the field
    transactiondatefield.val(todaysDate()).prop("disabled",true)

    // trigger touchuitoggler to show the touch interface
    touchui.show()

    inputfield.on("input",()=>{
        filternotifications.html("")
        ordernotifications.html("")
        paymentdetailsnotifications.html("")
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    touchuitoggler.on("click",()=>{
        touchui.toggle()
    })

    getPointsOfSale(outletfield,'choose').done(()=>{
        const posid=outletfield.val()
        if(posid!==""){
            getpostables(tablefield,posid,'choose')
            getposproductcategories(posid)  
        }
    })

    getCustomers(customerfield,'choose')

    outletfield.on("change",function(){
        const posid=$(this).val()
        if(posid==""){
            tablefield.html("<option value=''>&lt;Choose&gt;</option>")
            categorybuttonslist.html("")
        }else{
            getpostables(tablefield,posid,'choose')
            getposproductcategories(posid)  
            productlist.html("")
        }
    })

    function getposproductcategories(posid){
        $.getJSON(
            "../controllers/posoperations.php",
            {
                getposproductcategories:true,
                posid
            },
            (data)=>{
                let results=""
                // remove all categories that don't apply for the current point of sale
                data=data.filter(category=>category.poscategoryid!==null)

                data.forEach((category)=>{
                    results+=`<button class="btn category-btn" id=${category.categoryid}>${category.categoryname}</button>`
                })
                categorybuttonslist.html(results)
            }
        )
    }

    categorybuttonslist.on("click",".category-btn",function(){
        const categoryid=$(this).prop("id")
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproductbycategory:true,
                categoryid
            },
            (data)=>{
                let results=''
                data.forEach(product=>{
                    results+=`
                    <div class="col-4 mb-3">                        
                        <div class="product-card btn" data-id=${product.productid} data-itemcode=${product.itemcode} class="product-btn">
                            <img src="../images/noimage.jpg" alt="Product Image">
                            <h5>${product.itemname}</h5>
                            <!-- <p>${product.itemcode}<p> -->
                            <p>Ksh.${$.number(product.sellingprice)}</p>
                        </div>
                    </div>`
                })
                productlist.html(results) 
            }
        )
    })
    
    productlist.on("click",".product-card",function(){
        const itemcode=$(this).data("itemcode")
        getproduct(itemcode)
    })


    function getproduct(productcode){
        const customerid=customerfield.val()
        const storeid=outletfield.val()
        $.getJSON(
            "../controllers/productoperations.php",
            {   
                getproductdetails:true,
                productcode,
                customerid,
                storeid
            },
            function(data){
                // check if JSON returned a blank object
                let productdetails=''
                if (Object.keys(data).length===0){
                    errors="No product with similar code found"
                    ordernotifications.html(showAlert("info",errors))
                }else{
                    ordernotifications.html("")
                    // check if there are quantities in stock for the item
                    if(Number(data[0].itembalance)<=0 && Number(data[0].allownegativesales)==0){
                        errors=`<strong>${data[0].itemname}</strong> has <strong>${data[0].itembalance}</strong> quantities in stock hence can't be sold.`
                        ordernotifications.html(showAlert("danger",errors))
                    }else{
                        let sellingprice=data[0].sellingprice,randomno=randomId()
                        const currentrow=orderitemstable.find("tbody tr").length+1
                        productdetails+=`<tr class='clickable-row' data-id='${randomno}' data-productid='${data[0].productid}' data-serializable='${data[0].serializable}' data-serial-nos='' data-allownegativesales=${data[0].allownegativesales}>`
                        productdetails+=`<td>${currentrow}</td>`
                        productdetails+=`<td>${data[0].itemcode}</td>`
                        productdetails+=`<td>${data[0].itemname}</td>`
                        productdetails+=`<td class='price'>${data[0].sellingprice}</td>`
                        productdetails+=`<td class='quantity'>1</td>`
                        productdetails+=`<td class='linetotal'>${sellingprice}</td>`
                        productdetails+=`<td><a href='#' class='delete' data-id='${randomId()}'><span><i class='fal fa-trash-alt fa-lg fa-fw'></i></span></a></td></tr>`
                        // console.log(productdetails)
                        $(productdetails).appendTo(orderitemstable.find("tbody"))
                        // display overall total
                        const total=getItemsTotal()
                        ordertotalfield.html($.number(total,2))
                    } 
                } 
            }
        )
    }

    function getItemsTotal(){
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function() {
            var value = $(this).text();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    orderitemstable.on("click",".delete",function(){
        const parent=$(this).closest("tr")
        const itemname=parent.find("td").eq(2).text()
        // confirm witn bootbox
        bootbox.dialog({
            // title: "Confirm Item Removal!",
             message: "Are you sure you want to remove <strong>"+itemname+"</strong> from the order list?",
             buttons: {
                 success: {
                     label: "No, Keep",
                     className: "btn-success btn-sm",
                     callback: function() {
                         $('.bootbox').modal('hide');
                     }
                 },
                 danger: {
                     label: "Yes, Remove",
                     className: "btn-danger btn-sm",
                     callback: function() {
                         parent.remove()
                         ordertotalfield.html($.number(getItemsTotal(),2))
                        //  computeTotalAmountPaid()
                         $('.bootbox').modal('hide')
                        //  totalamountpayable.html($.number(getItemsTotal(),2))
                     }
                 }
             }
         })
    })

    savecustomerorderbutton.on("click",function(){
        const posid=outletfield.val(),
            customerid=customerfield.val(),
            tableid=tablefield.val()
        let errors='', orderitems=[]
        orderitemstable.find("tbody tr").each(function(){
            // console.log($(this))
            const product=$(this),
                row=product.find("td"),
                productid=product.data("productid"),
                quantity=row.eq(4).text().replace(",",""),
                unitprice=row.eq(3).text().replace(",","")
            orderitems.push({"productid":productid,"quantity":quantity,"unitprice":unitprice})
        })

        // check for blank fields
        if(posid==""){
            errors="Please select point of sale"
            outletfield.focus()
        }else if(tableid==""){
            errors="Please select table"
            tablefield.focus()
        }else if(customerid==""){
            errors="Please select customer"
            customerfield.focus()
        }else if(orderitems.length==0){
            errors="Please provide at least an item first"
        }

        if(errors==""){
            ordernotifications.html(showAlert("processing","Processing. Please wait...",0))
            orderitems=JSON.stringify(orderitems)
            $.post(
                "../controllers/customerorderoperations.php",
                {
                    savecustomerorder:true,
                    posid,
                    customerid,
                    tableid,
                    orderitems
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            const orderno=data.orderno
                            ordernotifications.html(showAlert("success",`Customer order saved successfully. Order # : <strong>${orderno}</strong>`))
                            // Print Customer Bill and KOT where{} neccessary
                            printcustomerbill(orderno).done(function(){
                                printkot(orderno)
                                clearfields()
                            })
                        }
                    }else{
                        ordernotifications.html(showAlert("danger",`Sorry an error occurred! ${data}`))
                    }
                }
            )
        }else{
            ordernotifications.html(showAlert("info",errors))
        }
    })

    function clearfields(){
        orderitemstable.find("tbody tr").remove()
        tablefield.val("")
    }

    function printcustomerbill(orderno) {
        const dfd=$.Deferred()
        connecttoprinter().then(()=>{
            const encoder = new ESCPOSEncoder();
            getcustomerbilldetails('../controllers/customerorderoperations.php', orderno)
            .then(({orderheaders,orderdetails}) => {
                const header=orderheaders[0],
                    orderheader=orderdetails[0],
                    solditems=[],
                    receiptfooter=(header.receiptfooter).split("<br>")

                let receipttotal=0
                // populate sold items
                orderdetails.forEach((item,i)=>{
                    solditems.push([`${i+1}. ${item.itemcode}`,($.number(item.quantity*(item.unitprice))).toString()])
                    solditems.push([item.itemname,`${item.quantity} x ${$.number(item.unitprice).toString()}`])
                    receipttotal+=item.quantity*(item.unitprice)
                })
                
                receipttotal=$.number(receipttotal,2).toString()
                    
                const data = encoder
                    .initialize()
                    .align('center')
                    .text(header.name)
                    .feed()
                    .text(header.physicaladdress)
                    .feed()
                    .text('P.O BOX '+header.postaladdress)
                    .feed()
                    .text('TEL: '+header.landline)
                    .feed()
                    .text('Email: '+header.email)
                    .feed()
                    .text('CUSTOMER BILL')
                    .feed()
                    .barcode(orderno)
                    .feed()
                    .align('left')
                    .text('DATE: '+orderheader.orderdate)
                    .feed()
                    .text('OUTLET: '+orderheader.posname)
                    .feed()
                    .text('CUSTOMER: '+orderheader.customername)
                    .feed()
                    .text('WAITER: '+orderheader.waitername)
                    .feed()
                    .text('TABLE: '+orderheader.tablename)
                    .feed()
                    .line("-")
                    .align('left') // Align table to the left
                    .tableRow(['ITEM', 'TOTAL'], ['left', 'right']) // Header
                    .line("-")
                    .tableRows(solditems, ['left', 'right']) 
                    .line("-")
                    .tableRow(['TOTAL', receipttotal], ['left', 'right']) // Row 3
                    .line("=")
                    .feed()
                    .line("-")
                    .align('left')
                    .bold(true)
                    .doubleSize(true)
                    .multiplelines(receiptfooter)
                    .bold(false)
                    .doubleSize(false)
                    .line("-")
                    .text('Served By: '+orderheader.username)
                    .newline(2)
                    .cut()
                    .encode()
                qz.print(config, data)
                dfd.resolve()
            })
        })
        return dfd.promise()
    }

    async function getcustomerbilldetails(url, orderno) {
        const operations = [
            fetchData(url, { getreceiptheader: true }),
            fetchData(url, { getcustomerorderdetails: true,orderno:orderno }),
        ]
  
        // Wait for all promises to resolve
        const [orderheaders,orderdetails] = await Promise.all(operations)
  
        // Return an object containing the variables
        return { orderheaders,orderdetails }
    }

    function printkot(orderno){
        connecttoprinter().then(()=>{
            const encoder = new ESCPOSEncoder();
            getcustomerbilldetails('../controllers/customerorderoperations.php', orderno)
            .then(({orderheaders,orderdetails}) => {
                const header=orderheaders[0],
                    orderheader=orderdetails[0],
                    solditems=[]
                // populate sold items
                orderdetails.forEach((item,i)=>{
                    // solditems.push([`${i+1}. ${item.itemname}`,$.number(item.quantity).toString()])
                    solditems.push([`${i+1}. ${item.itemcode}`,($.number(item.quantity*(item.unitprice))).toString()])
                    solditems.push([item.itemname,`${item.quantity} x ${$.number(item.unitprice).toString()}`])
                })
                
                const data = encoder
                    .initialize()
                    .align('center')
                    .text(header.name)
                    .feed()
                    .text(header.physicaladdress)
                    .feed()
                    .text('P.O BOX '+header.postaladdress)
                    .feed()
                    .text('TEL: '+header.landline)
                    .feed()
                    .text('Email: '+header.email)
                    .feed()
                    .text('CAPTAIN ORDER')
                    .feed()
                    .barcode(orderno)
                    .feed()
                    .align('left')
                    .text('DATE: '+orderheader.orderdate)
                    .feed()
                    .text('OUTLET: '+orderheader.posname)
                    .feed()
                    .text('CUSTOMER: '+orderheader.customername)
                    .feed()
                    .text('WAITER: '+orderheader.waitername)
                    .feed()
                    .text('TABLE: '+orderheader.tablename)
                    .feed()
                    .line("-")
                    .align('left') // Align table to the left
                    .tableRow(['ITEM', 'TOTAL'], ['left', 'right']) // Header
                    .line("-")
                    .tableRows(solditems, ['left', 'right']) 
                    .line("-")
                    .align('left')
                    .feed()
                    .text('Generated By: '+orderheader.username)
                    .newline(2)
                    .cut()
                    .encode()
                qz.print(config, data)
                return "success"
            })
        })
       
    }

    const filterpointsofsales=$("#filterpos"),
        filtertables=$("#filtertable"),
        // filtercustomers=$("#filtercustomers"),
        filterstatus=$("#filterstatus"),
        filterwaiters=$("#filterwaiter"),
        filterbutton=$("#filterorderslist"),
        filterstartdate=$("#filterstartdate"),
        filterenddate=$("#filterenddate"),
        filterdaterange=$("#filterdaterange"),
        filternotifications=$("#filternotifications"),
        orderslisttable=$('#orderslisttable'),
        selectallorders=$("#selectallorders"),
        totalamountpayable=$("#totalamountpayable"),
        totalpaid=$("#totalpaid"),
        change=$("#change"),
        paymentdetailsnotifications=$("#paymentdetailsnotifications"),
        saveorderpayment=$("#saveorderpayment")

    setDatePicker(filterstartdate)
    setDatePicker(filterenddate)

    getPointsOfSale(filterpointsofsales,'all')

    // getCustomers(filtercustomers,'all')
    getsystemusers(filterwaiters,'all')

    // get payment methods
    listpaymentmethods()

    filterenddate.val(todaysDate()) 
    
    const yesterday=new Date()
    yesterday.setDate(yesterday.getDate()-1)
    filterstartdate.val(formatDate(yesterday))

    filterdaterange.prop("checked",false)
    filterstartdate.prop("disabled",false)
    filterenddate.prop("disabled",false)
    filterstatus.val("open")

    filterdaterange.on("click",function(){
        const status=$(this).prop("checked")
        filterstartdate.prop("disabled",status)
        filterenddate.prop("disabled",status) 
    })

    filterpointsofsales.on("change",function(){
        const posid=$(this).val()
        if(posid==""){
            filtertables.html("<option value='0'>&lt;All&gt;</option>")
        }else{
            getpostables(filtertables,posid,'all')
        }
    })

    filterbutton.on("click",function(){
        const posid=filterpointsofsales.val(),
            waiterid=filterwaiters.val(),
            tableid=filtertables.val(),
            orderstatus=filterstatus.val(),
            startdate=filterdaterange.prop("checked")?'01-Jan-2000':sanitizestring(filterstartdate.val()),
            enddate=filterdaterange.prop("checked")?'01-Jan-2100':sanitizestring(filterenddate.val())
        let errors=""

        // remove date errors
        filterstartdate.removeClass("is-invalid")
        filterenddate.removeClass("is-invalid")

        if(!filterdaterange.prop("checked")){
            if(startdate==""){
                errors="Please select order start date"
                filterstartdate.addClass("is-invalid text-danger")
            }else if(enddate==""){
                errors="Please select order end date"
                filterenddate.addClass("is-invalid text-danger")
            }
        }

        if(errors==""){
            checkuserprivilegewithcode('0x054').done((reprintbill)=>{
                checkuserprivilegewithcode('0x055').done((reprintkot)=>{
                    checkuserprivilegewithcode('0x056').done((cancelorder)=>{
                        $.getJSON(
                            "../controllers/customerorderoperations.php",
                            {
                                filtercustomerorders:true,
                                tableid,
                                posid,
                                waiterid,
                                orderstatus,
                                startdate,
                                enddate
                            },
                            (data)=>{
                                let results=""
                                // sort from most recent date
                                checkuserprivilegewithcode('0x057').done((viewallorders)=>{
                                    console.log(viewallorders)
                                    // filter is user is allowed only to view their bills
                                    if(!viewallorders){
                                        data=data.filter(order=>order.userid==userid)
                                    }

                                    // sort teh data by data from most recent
                                    data.sort((a,b)=>{
                                        date1=new Date(a.orderdate)
                                        date2=new Date(b.orderdate)
                                        return date2-date1
                                    })
                                    
                                    data.forEach((order,i)=>{
                                        const reprintbillicon=reprintbill?`<a href='#' class='printbill'><i class='fal fa-print fa-lg fa-fw fa-lg'></i></a>`:`<i class='fal fa-print fa-lg fa-fw text-secondary'></i>`,
                                            reprintkoticon=reprintkot?`<a href='#' class='printkot'><i class='fal fa-print fa-lg fa-fw fa-lg'></i></a>`:`<i class='fal fa-print fa-lg fa-fw text-secondary'></i>`,
                                            cancelordericon=cancelorder?`<a href='#' class='cancel'><i class='fal fa-minus-circle fa-lg fa-fw text-danger'></i></a>`:`<i class='fal fa-minus-circle fa-lg fa-fw text-secondary'></i>`
                                        results+=`<tr data-orderid='${order.orderid}' data-orderno='${order.orderno}'>`
                                        results+=`<td><input type='checkbox' id='${order.orderid}' class='orderitem'></td>`
                                        results+=`<td>${$.number(i+1)}</td>`
                                        results+=`<td>${order.orderdate}</td>`
                                        results+=`<td>${order.orderno}</td>`
                                        results+=`<td>${order.posname}</td>`
                                        results+=`<td>${order.customername}</td>`
                                        results+=`<td>${order.tablename}</td>`
                                        results+=`<td>${$.number(order.ordertotal)}</td>`
                                        results+=`<td>${order.waitername}</td>`
                                        results+=`<td>${titleCase(order.status)}</td>`
                                        results+=`<td><a href='#' class='view'><i class='fal fa-eye fa-lg fa-fw'></i></a></td>`
                                        results+=`<td>${reprintbillicon}</td>`
                                        results+=`<td>${reprintkoticon}</td>`
                                        results+=`<td>${cancelordericon}</td></tr>`
                                    })
                                    // console.log(results)
                                    makedatatable(orderslisttable,results,15)
                                })

                                
                            }
                        ) 
                    })
                    
                })
               
            })
           
        }else{
            filternotifications.html(showAlert("info",errors))
            if(filterstartdate.hasClass("is-invalid")){
                filterstartdate.focus()
            }else if(filterenddate.hasClass("is-invalid")){
                filterenddate.focus()
            }
        }
    })

    orderslisttable.on("click",".view",function(){
        const orderno=$(this).closest("tr").data("orderno")
        // get order details
        getcustomerbilldetails("../controllers/customerorderoperations.php", orderno).then(({receiptheader,orderdetails})=>{
            let results="", total=0, totaltext=""
            orderdetails.forEach((order,i)=>{
                total+=order.quantity*order.unitprice
                // console.log(total)
                results+=`<tr><td>${order.itemname}</td>`
                results+=`<td class='text-right'>${$.number(order.quantity,2)}</td>`
                results+=`<td class='text-right'>${$.number(order.unitprice,2)}</td>`
                results+=`<td class='text-right'>${$.number(order.quantity*order.unitprice,2)}</td></tr>`
            })
            totaltext=`<tr><th colspan='3'>TOTAL</th><th class='text-right'>${$.number(total,2)}</th></tr>`
            orderdetailstable.find("tbody").html(results)
            orderdetailstable.find("tfoot").html(totaltext)
            orderdetailsmodal.modal("show")
        }) 
    })

    orderslisttable.on("click",".printbill",function(){
        const order=$(this).closest("tr"),
            orderno=order.data("orderno"),
            status=order.find("td").eq(9).text()
        if(status=="Open"){
            // orderno=order.data("orderno")
            printcustomerbill(orderno)
        }else{
            filternotifications.html(showAlert("info",`Sorry order is <strong>${status}</strong> hence bill cannot be re-printed`))
        }
        
    })

    orderslisttable.on("click",".printkot",function(){
        // const orderno=$(this).closest("tr").data("orderno")
        const order=$(this).closest("tr"),
            orderno=order.data("orderno"),
            status=order.find("td").eq(9).text()
        if(status=="Open"){
            printkot(orderno)
        }else{
            filternotifications.html(showAlert("info",`Sorry order is <strong>${status}</strong> hence captain order cannot be re-printed`))
        }
        
    })

    orderslisttable.on("click",".cancel",function(){
        const order=$(this).closest("tr"),
            orderid=order.data("orderid"),
            status=order.find("td").eq(9).text(),
            orderno=order.find("td").eq(3).text()

        if(status=="Open"){
            bootbox.prompt("Please provide cancellation reason", function(result){ 
                // console.log(result)
                if(result){
                    if(result==""){
                        filternotifications.html(showAlert("info",`Please provide cancellation reason`))
                    }else{
                        results=sanitizestring(result)
                        $.post(
                            "../controllers/customerorderoperations.php",
                            {
                                cancelcustomerorder:true,
                                orderid,
                                reason:result
                            },
                            (data)=>{
                                if(isJSON(data)){
                                    data=JSON.parse(data)
                                    if(data.status=="success"){
                                        filternotifications.html(showAlert("success",`Customer order #: <strong>${orderno}</strong> was cancelled successfully`))
                                        filterbutton.trigger("click")
                                    }
                                }else{(
                                    filternotifications.html(showAlert("danger",`Sorry, an error occured ${data}`)))
                                }
                            }
                        )
                    }
                }
            })
        }else{
            filternotifications.html(showAlert("info",`The order's status is '<strong>${status}</strong> hence cannot be cancelled`))
        }
        
    })



    // select or deselect all  orders on the list
    selectallorders.on("click",function(){
        const status=$(this).prop("checked")
        orderslisttable.find(".orderitem").prop("checked",status)
    })

    const paymentsmodal=$("#payments"),
       settlebillbutton=$("#settlebills")

    // check if user is allowed to settle bills
    checkuserprivilegewithcode('0x053').done((status)=>{
        if(!status){
            settlebillbutton.removeClass("btn-success").addClass("btn-secondary")
        }else{
            settlebillbutton.removeClass("btn-secondary").addClass("btn-success")
        }
        settlebillbutton.prop("disabled",!status)
    })
   

    settlebillbutton.on("click",function(){
        // check if at least an order has been selected
        let selectedorders=[]
        // get order(s) total
        orderslisttable.find("tbody input:checked").each(function(){
            const status=$(this).closest("tr").find("td").eq(9).text()
            // console.log(status)
            if(status=="Open"){
                selectedorders.push($(this).prop("id"))
            }
        })

        if(selectedorders.length==0){
            filternotifications.html(showAlert("info","Please select at least an open order to settle"))
        }else{
            $.post(
                "../controllers/customerorderoperations.php",
                {
                    getorderstotal:true,
                    orders:JSON.stringify(selectedorders),
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)[0]
                        totalamountpayable.html($.number(data.orderstotal,2))
                        paymentsmodal.modal("show")
                    }else{
                        filternotifications.html(showAlert('danger',`Sorry an error occurred! ${data}`))
                    }
                }
            )
        } 
    })
 
    function listpaymentmethods(){
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getpaymentmethods:true
            },
            function(data){
                var results="<thead><tr class='d-flex'><th class='col-3' scope='row'>Pay Mode</th><th class='col-4'>Amount Paid</th><th class='col-5'>Reference #</th></tr></thead><tbody>"
                for (var i = 0; i < data.length; i++) {
                    results+="<tr class='d-flex'><td class='col-3' scope='row'>"+data[i].description+"</td>"
                    results+="<td class='col-4'><div class='form-group'><input type='number' id='"+data[i].id+"' class='amount form-control form-control-sm "+data[i].description+"'></td></div>"
                    // check if requires suppliers drop down
                    if(data[i].supplierslist==1){
                        results+=`<td class='col-5'><div class='form-group'><select id='${data[i].id}_ref' class='form-control form-control-sm customerslist'></select></td>`
                    }else{
                        if(data[i].requiresrefno==1) {
                            results+="<td class='col-5'><div class='form-group'><input type='text' id='"+data[i].id+"_ref' class='reference form-control form-control-sm'></div></td></tr>"  
                        }else{ 
                            results+="<td class='col-5'><div class='form-group'><input type='text' id='"+data[i].id+"_ref' class='form-control form-control-sm' disabled></td></tr>" 
                        }
                    }
                } 
                results+="</tbody>"
                $(results).appendTo(paymentoptions) 
            }
        )
    }

    paymentoptions.on("keyup",".amount", function(){
        const amountpaid=computeAmountPaid(),
        total=totalamountpayable.html().replace(",",""),
        changeamount=parseFloat(amountpaid-total)

        totalpaid.html($.number(amountpaid,2))
        change.html($.number(changeamount,2))

        paymentdetailsnotifications.html("")

    })

    
    function computeAmountPaid(){
        let totalamount=0
        $(".amount").each(function(){   
            if($(this).val()!=""){
                totalamount+=Number($(this).val())
            }
        })
        return totalamount
    }

    saveorderpayment.on("click",function(){
        let selectedorders=[],
            payments=[]
        const amountdue=Number(totalamountpayable.html().replace(",","")),
           amountpaid=Number(totalpaid.html().replace(",",""))
        if(amountdue>amountpaid){
            errors="Amount provided insufficient to ssettle selected Bills"
            paymentdetailsnotifications.html(showAlert("info",errors))
        }else{
            // get all checked orders
            orderslisttable.find("tbody input:checked").each(function(){
                selectedorders.push($(this).prop("id"))
            })

            // get provided payment methods
            $(".amount").each(function() {
                const id=$(this).attr("id"),
                    refno="#"+id+"_ref",
                    referenceno=$(refno).val(),
                    amount=Number($(this).val())
                if(amount>0){
                    payments.push({"modeid":id,"amount":amount,"referenceno":referenceno}) 
                }   
            })

            $.post(
                "../controllers/customerorderoperations.php",
                {
                    settlecustomeroders:true,
                    orders:JSON.stringify(selectedorders),
                    payments:JSON.stringify(payments)
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            const receiptno=data.receiptno
                            filternotifications.html(showAlert("success","Selected orders settled successfully"))
                            paymentsmodal.modal("hide")
                            filterbutton.trigger("click")
                            printcustomerreceipt(receiptno)
                        }
                    }else{
                        paymentdetailsnotifications.html(showAlert("danger",`Sorry an error occured! ${data}`))
                    }
                }
            )
        }
    })

    // Function to print receipt
    function printcustomerreceipt(receiptno) {
        connecttoprinter().then(()=>{
            const encoder = new ESCPOSEncoder();
            getReceiptData('../controllers/possalesoperations.php', receiptno)
            .then(({ receiptHeader, receiptDetails, paymentMethods, vatAnalysis }) => {
                const header=receiptHeader[0],
                    receiptheader=receiptDetails[0],
                    solditems=[],
                    paymentmodes=[],
                    vatanalysis=[],
                    receiptfooter=(header.receiptfooter).split("<br>")

                let receipttotal=0
                // populate sold items
                receiptDetails.forEach((item,i)=>{
                    solditems.push([`${i+1}. ${item.itemcode}`,($.number(item.quantity*(item.unitprice-item.discount))).toString()])
                    solditems.push([item.itemname,`${item.quantity} x ${$.number(item.unitprice-item.discount).toString()}`])
                    receipttotal+=item.quantity*(item.unitprice-item.discount)
                })

                paymentMethods.forEach((paymentmode)=>{
                    paymentmodes.push([paymentmode.paymentmethod,paymentmode.reference,$.number(paymentmode.amount).toString()])
                })

                vatAnalysis.forEach((vat)=>{
                    vatanalysis.push([vat.abbreviation,vat.taxrate,$.number(vat.vat)])
                })

                receipttotal=$.number(receipttotal,2).toString()
                
                const data = encoder
                    .initialize()
                    .align('center')
                    .text(header.name)
                    .feed()
                    .text(header.physicaladdress)
                    .feed()
                    .text('P.O BOX '+header.postaladdress)
                    .feed()
                    .text('TEL: '+header.landline)
                    .feed()
                    .text('Email: '+header.email)
                    .feed()
                    .text('PIN: '+header.pinno)
                    .feed()
                    .text('OFFICIAL RECEIPT')
                    .feed()
                    .barcode(receiptno)
                    .feed()
                    .align('left')
                    .text('Date: '+receiptheader.receiptdate)
                    .feed()
                    .text('Outlet: '+receiptheader.posname)
                    .feed()
                    .text('Customer: '+receiptheader.customername)
                    .feed()
                    .line("-")
                    .align('left') // Align table to the left
                    .tableRow(['ITEM', 'TOTAL'], ['left', 'right']) // Header
                    .line("-")
                    .tableRows(solditems, ['left', 'right']) 
                    .line("-")
                    .tableRow(['TOTAL', receipttotal], ['left', 'right']) // Row 3
                    .line("=")
                    .feed()
                    .text("PAYMENT METHODS")
                    .feed()
                    .line("-")
                    .tableRow(['MODE', 'REF #','AMOUNT'], ['left', 'left','right'])
                    .line("-")
                    .tableRows(paymentmodes, ['left', 'left','right']) 
                    .line("-")
                    .feed()
                    .text("VAT ANALYSIS")
                    .feed()
                    .line("-")
                    .tableRow(['CODE', 'RATE','AMOUNT'], ['left', 'right','right'])
                    .line("-")
                    .tableRows(vatanalysis, ['left', 'right','right']) 
                    .line("-")
                    .align('left')
                    .multiplelines(receiptfooter)
                    .line("-")
                    .text('Served By: '+receiptheader.servedby)
                    .newline(2)
                    .cut()
                    .encode()
                qz.print(config, data)
            })
        })
    }

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

    const switchtoretailbutton=$("#switchtoretail"),
        locksystembutton=$("#lockscreen")

    switchtoretailbutton.on("click",()=>{
        window.location.href="touchscreensale.php?switch=0"
    })

    locksystembutton.on("click",()=>{
        window.location.href="../index.html"
    })

    function testposprinter(){
        connecttoprinter().then(()=>{
            const encoder = new ESCPOSEncoder();
            const testitems=[
                "123456789","1,350.00",
                "Test Item 1", "2 x 675.00",
                "987654321","5000.00",
                "Another Item", "3 x 1667.67",
                "467534563","4,000.00",
                "Test Item 3", "1 x 4,000.00",
            ]
            const data = encoder
                .initialize()
                .align('center')
                .text('TEST PRINT')
                .feed()
                .text('This is a test for ESC/POS') 
                .feed()
                .barcode('BARCODE123')
                .feed()
                .align('left') // Align table to the left
                .tableRow(['ITEM', 'TOTAL'], ['left', 'right']) // Header
                .line("-")
                .tableRows(testitems, ['left', 'right']) 
                .line("-")
                .feed()
                .text('End of test print')
                .line("*")
                .newline(2)
                .cut()
                .encode()
            qz.print(config, data);
        })
    }

    const searchfield=$("#searchfield"),
        searchproductbutton=$("#searchproduct"),
        searchresultslist=$("#searchresultslist"),
        searchproductslist=$("#searchproductlist")

    searchproductbutton.on("click",()=>{
        const productname=sanitizestring(searchfield.val()),
            posid=outletfield.val()
            ordernotifications.html(showAlert("processing","Processing. Please wait ...",1))
        if(posid!==""){
            $.getJSON(    
                "../controllers/productoperations.php",
                {
                    filterproductbyname:1,
                    name:productname,
                    posid
                },
                function(data){
                    let results=""
                    searchproductslist.html("")
                    data.forEach((product)=>{
                        results+=`<li class='searchproduct-card' data-itemcode=${product.itemcode}>
                            <div class="searchproduct-info">
                                <div class="searchproduct-category">${product.categoryname}</div>
                                <div class="searchproduct-name">${product.itemname}</div>
                            </div>
                            <div class="searchproduct-price">${$.number(product.sellingprice,2)}</div>
                        </li>`
                    })
                    // console.log(results)
                    searchproductslist.html(results)
                    searchresultslist.show()
                    ordernotifications.html("")
                }
            )
        }else{
            ordernotifications.html(showAlert("info",`Please select <strong>Outlet</strong> first`))
            outletfield.focus()
        }
    })

    searchfield.on("keypress",function(e){
        if(e.which ==13){
            searchproductbutton.trigger("click")
        }
    })

    searchfield.on("input",function(){
        searchresultslist.hide()
    })

    searchproductslist.on("click","li",function(){
        const itemcode=$(this).data("itemcode")
        getproduct(itemcode)
        searchresultslist.hide()
        searchfield.val("").focus()
    })

})