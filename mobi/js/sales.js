$(document).ready(function(){
    // disable caching 
    $.ajaxSetup({cache: false})
    // get all outlets
    var outlet=$("#outlet"),
        customerslist=$("#customer"),
        homebutton=$("#salesdetailsmainmenu"),
        searchproduct=$("#addproduct"),
        backtosalesbutton=$("#backtosales"),
        productslist=$("#productslisted"),
        paymentbutton=$("#addpaymentmethod"),
        itemcodefield=$("#itemcode"),
        //generalerrorsanchor=$("#displaygeneralerrors"),
        productsearchmenu=$("#productsearchmenu"),
        unitpricefield=$("#unitprice"),
        discountfield=$("#discount"),
        itemnamefield=$("#itemname"),
        quantityfield=$("#quantity"),
        addtolistbutton=$("#addproducttolist"),
        closeerrordialogbutton=$("#dialogback"),
        purchaseditemslist=$("#purchaseditems"),
        totalfield=$("#totalsale"),
        removeitemnobutton=$("#removeitemno"),
        removeitemyesbutton=$("#removeitemyes"),
        paymentmethodsbackbutton=$("#paymentmethodsback"),
        //paymentmethodsbutton=$("#addpaymentmethod"),
        paymentmethods=$("#paymentmethodslist"),
        amountduefield=$(".amountdue"),
        amountpaidfield=$(".amountpaid"),
        balancefield=$(".balancedue"),
        savesalebutton=$("#savesale"),
        outletdiv=$("#outletdiv"),
        totalpricefield=$("#totalprice"),
        totalpricefields=$("#totalpricefields")

        let selecteditemforremoval=""
        //purchaseditemslist=$("#productslisted")
    let purchaseditemsarray=[],savedialogactive
    const printer = new WebBluetoothReceiptPrinter(),
        // notifications=$("#notifications"),
        connectprinter=$('#connectprinter')
        // printreceipt=$("#printReceipt")
    let printerstatus="notconnected"

    connectprinter.on('click', async () => {
        // notifications.html("Connecting. Please wait ...")
        try {
            await printer.connect();
            // notifications.html('Printer connected successfully!')
            printerstatus="connected"
            connectprinter.html("<i class='fal fa-print-slash fa-lg fa-fw'></i> Disconnect Printer")
        } catch (error) {
            // notifications.html(`Error connecting to printer: ${error}`)
        }
    })

    function printereceipt(receiptno){
        // else{
            // get company details
            let overalltotal=0
            try {
                let encoder = new ReceiptPrinterEncoder()
                // get receipt details 
                $.getJSON(
                    "../../controllers/possalesoperations.php",
                    {
                        getreceiptheader:true
                    },
                    (data)=>{
                        data=data[0]
                        const companydetails=`
                            ${data.name}
                            ${data.physicaladdress}
                            P.O Box ${data.postaladdress}
                            Tel: ${data.landline}
                            Email: ${data.email}
                            PIN #: ${data.pinno}
                            OFFICIAL RECEIPT
                        `
                        // get receipt details
                        const receiptfooter=data.receiptfooter 
                        // define table collumns
                        const itemssold=[
                                {width:16, align:'left'},
                                {width:15, align:'right'}
                            ],
                            paymentmethods=[
                                {width:9, align:'left'},  // mode name
                                {width:9, align:'right'}, // ref number
                                {width:13, align:'right'}  ],
                            vatanalysis=[
                                {width:7, align:'left'},  // code
                                {width:7, align:'right'}, // rate
                                {width:17, align:'right'}  // vat amount
                            ],

                            // to hold array of vales extracted
                            itemssolddetails=[],
                            paymentmethodsdetails=[],
                            vatanalysisdetails=[]

                        itemssolddetails.push(['Item','Value'])
                        paymentmethodsdetails.push(['Mode','Reference','Amount'])
                        vatanalysisdetails.push(['Code','Rate','VAT'])

                        $.getJSON(
                            "../../controllers/possalesoperations.php",
                            {
                                getreceiptdetails:true,
                                receiptno
                            },
                            (data)=>{
                                data1=data[0]
                                const receiptdetails=`
                                    Receipt #: ${data1.receiptno}
                                    Date: ${data1.receiptdate}
                                    Outlet: ${data1.posname}
                                    Customer: ${data1.customername}
                                `
                                const servedby=data1.servedby
                            
                                // Add table heading
                                data.forEach((item,i)=>{
                                    itemssolddetails.push([`${i+1}. ${item.itemcode}`,($.number(item.quantity*(item.unitprice-item.discount))).toString()])
                                    itemssolddetails.push([item.itemname,`${item.quantity} x ${$.number(item.unitprice-item.discount).toString()}`])

                                    overalltotal+=item.quantity*(item.unitprice-item.discount)
                                })
                                // Add items total
                                itemssolddetails.push(["TOTAL:",$.number(overalltotal).toString()])
                                // Get payment methods
                                $.getJSON(
                                    "../../controllers/possalesoperations.php",
                                    {
                                        getreceiptpaymentmethods:true,
                                        receiptno
                                    },
                                    (data)=>{
                                        data.forEach((paymentmethod,i)=>{
                                            paymentmethodsdetails.push([paymentmethod.paymentmethod,paymentmethod.reference,$.number(paymentmethod.amount).toString()])
                                        })

                                        $.getJSON(
                                            "../../controllers/possalesoperations.php",
                                            {
                                                getreceiptvatanalysis:true,
                                                receiptno
                                            },
                                            (data)=>{
                                                data.forEach((vat,i)=>{
                                                    vatanalysisdetails.push([vat.abbreviation,vat.taxrate,$.number(vat.vat)])
                                                })
                                            
                                                data=encoder
                                                    .initialize()
                                                    .align('left')
                                                    .line(companydetails)
                                                    .align('left')
                                                    .line(receiptdetails)
                                                    .line("-------------------------------")
                                                    .line("ITEMS PURCHASED")
                                                    .line("-------------------------------")
                                                    // add table for purchased items
                                                    .table(itemssold,itemssolddetails)
                                                    .line("===============================")
                                                    .line("PAYMENT METHODS")
                                                    .line("-------------------------------")
                                                    .table(paymentmethods,paymentmethodsdetails)
                                                    .line("===============================")
                                                    .line("VAT ANALYSIS")
                                                    .line("-------------------------------")
                                                    .table(vatanalysis,vatanalysisdetails)
                                                    .line("-------------------------------")
                                                    .line(`Served By: ${servedby}`)
                                                    .line("-------------------------------")
                                                    // .text(mydata)
                                                    .newline()
                                                    .align('left')
                                                    .line(receiptfooter) 
                                                    .newline(2)
                                                    .align('center')
                                                    .qrcode(receiptno)
                                                    .newline(3)
                                                    .encode();
                                                    printer.print(data);
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    } 
                )
            } catch (error) {
                console.error('Error printing receipt:', error)
            }
        // }
    }

    // get outlets
    $.getJSON(
        "../../controllers/posoperations.php",
        {
            getuseroutlets:true,
            userid:0
        },
        function(data){
            var results=''//="<option value='0'>&lt;Choose One&gt;</option>"
            for (var i = 0; i < data.length; i++) {
                results+=`<option value='${data[i].outletid}'>${data[i].posname}</option>`
            } 
            $(results).appendTo(outlet)
            //refresh list
            outlet.selectmenu("refresh", true)
            if(data.length==1){
                // hide the select button 
                outlet.val(data[0].outletid)
                // get customers belonging to the outlet
                getoutletcustomers(data[0].outletid)
                // get outlet products

                // outletdiv.hide()
            }else{
                // outletdiv.show()
            }
        }
    )
    
    // get payment methods
    $.getJSON(
        "../../controllers/getpaymentmethods.php",
        function(data){
            // var results="<option value=''>&lt;Choose One&gt;</option>"
            var results="<div class='ui-block-a paymentmode'>&nbsp;</div>"
            results+="<div class='ui-block-b amount'>Amount Paid</div>" //"<thead><tr class='d-flex'><th class='col-3' scope='row'>Pay Mode</th><th class='col-5'>Amount Paid</th><th class='col-4'>Reference #</th></tr></thead><tbody>"
            results+="<div class='ui-block-c reference'>Reference</div>"
            for (var i = 0; i < data.length; i++) {
                // results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                // <!-- <td><img src='"+data[i].image+"' class='thumbnail'></td> -->
                //results+=""
                results+="<div class='ui-block-a'>"+data[i].description+"</div>"
                results+="<div class='ui-block-b'><input type='number' id='"+data[i].id+"' class='amount "+data[i].description+"'></div>"
                if(data[i].requiresrefno==1) {
                    results+="<div class='ui-block-c'><input type='text' id='"+data[i].id+"_ref' >"
                    results+="</div>"  
                }else{ 
                    results+="<div class='ui-block-c'><input type='text' id='"+data[i].id+"_ref' disabled></div>" 
                }
            } 
            //results+="</tbody>"
            $(results).appendTo(paymentmethods) //.appendTo(paymentmethodslist)
            //console.log(results)
        }
    )

    getoutletcustomers() 

    outlet.on("click",function(){
        posid=outlet.val()
        getoutletcustomers(posid) 
    })

    //listen to search product button
    searchproduct.on("click",function(){ 
        // check if a customer has been selected
        const posid=outlet.val(),
            // product name 
            name=''
        var errors=""
        if(posid==""){
            errors="<p>Please select a <strong>Outlet</strong> first.</p>"
            displayError(errors)
        }else if (customerslist.val()==""){
            errors="<p>Please select a <strong>Customer</strong> first.</p>"
            displayError(errors)
        }else{
            var results=""
            // populate products 
            window.location.href="#productsearch" 
            // clear search field of the listview
            $('input[data-type="search"]').val("");
            // enable updating the list
            $('input[data-type="search"]').trigger("keyup");
            $.getJSON(
                "../../controllers/productoperations.php",
                {
                    filterproductbyname:true,
                    name,
                    posid
                },
                function(data){
                    for(var i=0;i<data.length;i++){
                        results+="<li id='"+data[i].itemcode+"'><a href='#'>"+data[i].itemname+"</a></li>"
                    }
                    //productslist.find("li").remove()
                    //$(results).appendTo(productslist) 
                    productslist.html(results)
                    productslist.listview("refresh",true)
                    // place the cursor on the search
                    $('input[data-type="search"]').focus()
                }
            )
        } 
    })

    homebutton.on("click",function(){ 
        window.location.href="main.php"
    })

    backtosalesbutton.on("click",function(){
        window.location.href="sales.php#salesitemsdetails"
    })

    paymentbutton.on("click",function(e){
        e.preventDefault()
        // check if at least an item has been added for saving
        if(purchaseditemsarray.length>0){
            //window.location.href="#generalerrors"
            window.location.href="#paymentmethods"
            amountduefield.html(totalfield.val())
            if(printerstatus!=="connected"){
                connectprinter.html("<i class='fal fa-print-search fa-lg fa-fw'></i> Connect Printer")
            }else{
                connectprinter.html("<i class='fal fa-print-slash fa-lg fa-fw'></i> Disconnect Printer")
            }
        }else{
            error="<p>Please add at least an Item in the list.</p>"
            displayError(error)
        } 
    })

    productslist.on("click", "li", function(){
        var itemcode=$(this).prop("id")
        window.location.href="#itemdetails"
        itemcodefield.val(itemcode)
        //console.log(itemcode)
        //get item details
        $.getJSON(
            "../../controllers/productoperations.php",
            {
                getproductdetails:true,
                productcode:itemcode,
                customerid:customerslist.val()
            },
            function(data){
                unitpricefield.val(data[0].sellingprice)
                discountfield.val(data[0].discount)
                itemnamefield.val(data[0].itemname)
                if(data[0].saleby=="quantity"){
                    quantityfield.focus()
                    quantityfield.prop("disabled",false)
                    totalpricefields.hide()
                }else{
                    totalpricefields.show()
                    quantityfield.prop("disabled",true)
                    totalpricefield.focus()
                } 
            } 
        )
    })

    totalpricefield.on("input",function(){
        if($(this).val()!==""){
            const total=$(this).val()
            quantity=Number((total/(unitpricefield.val()).replace(",","")).toFixed(4))
            quantityfield.val(quantity)
        }else{
            quantityfield.val("")
        }
        
    })

    function displayError(errorString){
		var generalerrorsanchor=$("#displaygeneralerrors")
		var generalerrorposition=$("#dataentryerror")

		generalerrorposition.find("p").remove()
		$(errorString).appendTo(generalerrorposition)
		generalerrorsanchor.click()
    }
    
    productsearchmenu.on("click",function(){
        window.location.href="#productsearch"
    })

    addtolistbutton.on("click",function(){
        var quantity=quantityfield.val(),
            error="",
            itemcode=itemcodefield.val(),
            quantity=quantityfield.val(),
            unitprice=unitpricefield.val(),
            discount=discountfield.val(),
            itemname=itemnamefield.val()
            listitem="",
            totalamount=parseFloat(totalfield.val().replace(',','')),
            randomno=randomId(),
            sellingprice=unitprice
        if(quantity==""){
            error="<p>Please provide quantity first.</p>"
            displayError(error)
        }else{
            listitem='<li id="'+randomno+'"><a href="#">'
            listitem+='<h2>'+itemname+'</h2>'
            listitem+='<p><strong>Quantity: '+quantity+'    , Unitprice: '+$.number(parseFloat(unitprice))+' </strong></p>'
            listitem+='<p>Item Code:    '+ itemcode+', Discount offered:    '+parseFloat(discount)+'.</p>'
            listitem+='<p class="ui-li-aside"><strong><span class="dataamount">'+$.number(parseFloat(quantity*(unitprice-discount)))+'</span></strong></p>'    
            listitem+='</a><a href="#" data-rel="popup" data-position-to="window" data-transition="pop" data-icon="minus" class="removeitem" id="'+randomno+'">Remove Item</a></li>'
            $(listitem).appendTo(purchaseditemslist)
            purchaseditemslist.listview('refresh',true)
            // compute total due
            totalamount+=parseFloat(quantity*(unitprice-discount))
            totalfield.val($.number(totalamount,2))
            // show the page with the items
            window.location.href="#salesitemsdetails"
            // empty quantity field
            quantityfield.val("")
            // add to array to be saved later
            purchaseditemsarray.push({id:randomno,itemcode:itemcode,unitprice:sellingprice,discount:discount,quantity:quantity,serialno:''})
            //console.log(purchaseditemsarray)
        }
    })

    closeerrordialogbutton.on("click",function(){
        savedialogactive==1?window.location.href="#salesitemsdetails":window.history.back()
    })

    purchaseditemslist.on("click",".removeitem", function(e){
        e.preventDefault()
        var message="Are you sure you want to remove the item from the list?"
        // display dialog
        $("#removeitemmessage").html(message)
        window.location.href="#confirmitemremoval"
        selecteditemforremoval=$(this).prop("id")
    })

    // listen to yes remove button selected
    removeitemyesbutton.on("click",function(){
        var item="#"+selecteditemforremoval
        // remove from the array first
        // console.log(purchaseditemsarray)
        for(var i=0;i<purchaseditemsarray.length;i++){
            console.log(purchaseditemsarray[i].id)
            if (purchaseditemsarray[i].id==selecteditemforremoval){
                purchaseditemsarray.splice(i,1)
            }
        }
        // console.log(purchaseditemsarray)
        $(item).remove()
        //refresh the list
        purchaseditemslist.listview("refresh",true)
        // perform totals
        getItemsTotal()
        //navigate to the location
        window.location.href="#salesitemsdetails"
    })
    
    // close when no button is clicked
    removeitemnobutton.on("click",function(){
        window.history.back()
    })

    function getItemsTotal(){
        var total=0,
            amount=0
        purchaseditemslist.find(".dataamount").each(function(){
            amount=parseFloat($(this).html().replace(",",""))
            if(!isNaN(amount) && amount.length != 0){
                total+=amount
            }
        })
        totalfield.val($.number(total,2))
    }

    paymentmethodsbackbutton.on("click",function(){
        window.location.href="#salesitemsdetails"
    })

    /*paymentmethodsbutton.on("click",function(){
        window.location.href="#paymentmethods"
    })*/

    paymentmethods.on("keyup",".amount",function(){
        amountpaidfield.html($.number( getAmountPaid())) 
        balance=parseFloat(amountpaidfield.html().replace(",",""))-parseFloat(amountduefield.html().replace(",",""))
        //console.log(balance)
        balancefield.html($.number(balance))
    })

    function getAmountPaid(){
        var sum=0
        $(".amount").each(function() {
            var value = $(this).val();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    // listen to save sales button
    savesalebutton.on("click",function(){
        var paymentmethods=[],
            amount,paymentmethod,refno, error

        $(".amount").each(function(){  
            amount=$(this).val()
            paymentmethod=$(this).attr("id")
            refnofield="#"+paymentmethod+"_ref"
            refno=$(refnofield).val()
            if(!isNaN(amount) && amount.length != 0){
                paymentmethods.push({amount:amount,referenceno:refno,modeid:paymentmethod})
            }
        })
        // check if no payment method was provided
        if(paymentmethods.length>0){
            var itemspurchased=JSON.stringify(purchaseditemsarray),
                modesofpayment=JSON.stringify(paymentmethods),
                posid=outlet.val(),
                customerid=customerslist.val()
            // save the data 
            $.post(
                "../../controllers/possalesoperations.php",
                {
                    savesale:"POST",
                    TableData: itemspurchased,
                    customerid:customerid,
                    pointofsale:posid,
                    paymentmethods:modesofpayment,
                    referenceno:"",
                    creditnoteno:""
                },
                function(data){
                    // generate receipt
                    str=$.trim(data.toString())
                    if(str.length<=12){
                        // console.log("Printing ....")
                        printereceipt(data)
                        // var url="../../printsmallreceipt.php?receiptno="+data.toString()+"&amountpaid="+amountpaidfield.val()
                        // var win = window.open(url, '_blank');
                        // win.focus();
                        //errordiv.html("")
                        clearForm()
                        error="<p class='alert alert-success'>Transaction completed successfully. ReceiptNo is : <strong>"+str+"</strong></p>"
                        // display the first page
                        savedialogactive=1
                        displayError(error)
                        // empty all amount fields
                        $(".amount").each(function(){  
                            const $this=$(this)
                            $this.val("")
                            // empty all reference fields
                            const paymentmethod=$this.attr("id")
                            refnofield="#"+paymentmethod+"_ref"
                            $(refnofield).val("")
                        })
                    }else{
                        // return value stored in msg variable
                        //errordiv.html("")
                        error ="<p  class='alert alert-danger'>"+str+"</p>"
                        displayError(error)
                    } 
                }
            )
        }else{
            // display error message
            error="<p>Please provide at least one payment method.<p>"
            displayError(error)
        }
    })

    function clearForm(){
        purchaseditemsarray=[]
        // paymentmethods=[]
        //outlet.val("")
        
        //customerslist.listview("refresh",true)
        amountpaidfield.html("0.00") 
        amountduefield.html("0.00")
        //console.log(balance)
        balancefield.html("0.00")
        purchaseditemslist.empty()
        totalfield.val('0.00')
        // customerslist.val("")
        // customerslist.selectmenu("refresh", true)
    }

    function getoutletcustomers(){
        $.getJSON(
            "../../controllers/customeroperations.php",
            {
                getcustomers:true,
                regularcustomers:1,
                onetimecustomers:1
                // posid:outletid
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+=`<option value='${data[i].customerid}' ${data[i].defaultcustomer==data[i].customerid?' selected':''}>${data[i].customername}</option>`
                } 
                customerslist.html(results)
                customerslist.selectmenu("refresh", true)
            }
        )
    }
})
