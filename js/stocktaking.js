$(document).ready(function(){
    var addorder=$("#addorder, #mobileAddPurchaseFAB"),
        mainmenu=$("#goback"),
        orderlist=$("#orderlist"),
        ordertable=$("#ordertable"),
        customerlist=$("#customer"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate")
        alldates=$("#alldates")

    mainmenu.on("click",function(){
        window.location.href="main.php"
    })



    // get existing suppliers
    getCustomers(customerlist, option='all')

    // populate list with orders
    resfreshOrdersList()

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

    function resfreshOrdersList(){
        $.getJSON(
            "../controllers/purchaseorderoperations.php",
            {
               getpurchaseorders: "GET"
            },
   
           function(data){
               // Populate the data in the table
               var results=""
               // console.log(data.length)
               for(i=0 ; i<data.length; i++){
                   results+="<tr><td>"+data[i].id+"</td>"
                   results+="<td>"+data[i].purchaseorderno+"</td>"
                   results+="<td>"+data[i].suppliername+"</td>"
                   results+="<td>"+$.number(data[i].ordertotal)+"</td>"
                   results+="<td>"+data[i].status+"</td>"
                   results+="<td>"+data[i].date+"</td>"
                   results+="<td>"+data[i].addedby+"</td>"
                   results+="<td><a href='#' data-id="+data[i].id+" class='editpo'><span><i class='fas fa-edit fa-sm' ></i></span></a></td>"
                   results+="<td><a href='#'><span><i class='fas fa-print fa-sm'></span></i></a></td>" 
                   results+="<td><a href='#'><span><i class='fas fa-envelope fa-sm' ></i></span></a></td>"
                   results+="<td><a href='#'><span><i class='fas fa-times fa-sm'></span></i></a></td>" 
                   results+="<td><a href='#'><span><i class='fas fa-check-circle fa-sm' ></i></span></a></td>"
               }
               $(results).appendTo(orderlist)
               ordertable.DataTable()
           }
       )
    }

    // listen to delete data click event
    orderlist.on("click",".editpo",function(e){
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

    const stocktakedetailsmodal=$("#stocktakedetailsmodal")
    const stocktakecustomerfield=$("#stocktakecustomer")
    const stocktakedatefield=$("#stocktakedate")
    const stocktakeitemcodefield=$("#itemcode")
    const stocktakeerrordiv=$("#stocktakeerrors")
    const itemnamefield=$("#itemname")
    const quantityfield=$("#stockquantity")
    const addstocktakeitem=$("#additemquantity")
    const stocktakingtable=$("#stocktakingtable")

    addorder.on("click",function(){
        // window.location.href="purchasedetails.php"
        stocktakedetailsmodal.modal("show")
    })

    getCustomers(stocktakecustomerfield,'choose')
    setDatePicker(startdatefield)
    setDatePicker(enddatefield)
    setDatePicker(stocktakedatefield,false,true)

    stocktakeitemcodefield.on("keyup",function(e){
        if (e.which==13){
            const itemcode=$(this).val().trim()
            itemnamefield.val("")
            itemnamefield.attr("data-id","")
            itemnamefield.attr("data-itemcode","")
            if(itemcode!==""){
                // search the item from the database
                $.getJSON(
                    "../controllers/productoperations.php",
                    {   
                        getproductdetails:true,
                        productcode:itemcode,
                        // customerid:customerlist.val(),
                        // storeid
                    },
                    function(data){
                        // check if JSON returned a blank object
                        if (Object.keys(data).length===0){
                            errors="No product with similar code found"
                            stocktakeerrordiv.html(showAlert("info",errors))
                        }else{
                            stocktakeerrordiv.html("")
                            itemnamefield.val(data[0].itemname)
                            itemnamefield.attr("data-id",data[0].productid)
                            itemnamefield.attr("data-itemcode",data[0].itemcode)
                            quantityfield.focus()

                            // check if there are quantities in stock for the item
                            // if(Number(data[0].itembalance)<=0){
                            //     errors=`<strong>${data[0].itemname}</strong> has <strong>${data[0].itembalance}</strong> quantities in stock hence can't be sold.`
                            //     errordiv.html(showAlert("info",errors))
                            // }else{
                            //     let sellingprice=data[0].sellingprice-data[0].discount,
                            //         randomno=randomId()
                            //     productdetails+=`<tr class='clickable-row' data-id='${randomno}' data-productid='${data[0].productid}' data-serializable='${data[0].serializable}' data-serial-nos=''><td>${data[0].itemcode}</td>`
                            //     productdetails+=`<td>${data[0].itemname}</td>`
                            //     productdetails+=`<td class='price'>${data[0].sellingprice}</td>`
                            //     productdetails+=`<td>${data[0].discount}</td>`
                            //     productdetails+=`<td >${sellingprice}</td>`
                            //     productdetails+=`<td >${data[0].itembalance}</td>`
                            //     productdetails+=`<td class='quantity'>1</td>`
                            //     // Add serial number button if item is serializable
                            //     productdetails+=data[0].serializable==1?`<td><button class='btn btn-xs btn-primary addserials' data-id='${randomno}' data-name='${data[0].itemname}'><span><i class='fas fa-plus-circle fa-sm'></i> Add serials numbers</span></button></td>`:`<td>&nbsp</td>`
                            //     productdetails+=`<td class='linetotal'>${sellingprice}</td>`
                            //     productdetails+=`<td><a href='javascript void(0)' class='deletedata' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>`
                            //     //productdetails+="<td><button id='"+data[0].itemcode+"'  class='btn btn-danger btn-sm deleteitem' data-toggle='modal' data-target='#confirmdelete'>Remove</button></td></tr>"
                            //     /**/
                            //     $(productdetails).appendTo(salesitems.find("tbody"))
                            //     // display overall total
                            //     let total=getItemsTotal()
                            //     overalltotal.html($.number(total,2))
                            //     totalamountpayable.html($.number(total,2))
                            //     itemcodefield.val("")
                            //     itemcodefield.focus()
                            //     // compute totals and balance
                            //     computeTotalAmountPaid()
                            // }
                        } 
                    }
                )
            }else{
                stocktakeerrordiv.html(showAlert("info",`Please provide item code`))
                stocktakeitemcodefield.focus()
            }
        }
    })

    addstocktakeitem.on("click",()=>{
        const itemcode=itemnamefield.attr("data-itemcode")
        const itemid=itemnamefield.attr("data-id")
        const itemname=itemnamefield.val()
        const quantity=quantityfield.val()
        const row=stocktakingtable.find("tbody tr").length+1
        let errors=""
        
        if(itemid==""){
            errors="Please search an item first"
            itemnamefield.focus()
        }else if(Number(quantity)<=0){
            errors="Please provide correct item quantity first"
            quantityfield.focus()        
        }

        if(errors==""){
            let item=`<tr data-id='${itemid}'>`
            item+=`<td>${row}</td>`
            item+=`<td>${itemcode}</td>`
            item+=`<td>${itemname}</td>`
            item+=`<td>${$.number(quantity,2)}</td>`
            item+=`<td><a href='#' class='editdata'><i class='fas fa-edit fa-lg fa-fw mt-1'></i></a></td>`
            item+=`<td><a href='#' class='deletedata'><i class='fas fa-trash-alt fa-lg fa-fw mt-1'></i></a></td></tr>`
            $(item).appendTo(stocktakingtable.find("tbody"))
            // clear fields
            clearfields()
        }else{
            stocktakeerrordiv.html(showAlert("info",errors))
        }
    })

    function clearfields(){
        itemnamefield.val("")
        itemnamefield.attr("data-id","")
        itemnamefield.attr("data-itemcode","")
        stocktakeitemcodefield.val("")
        quantityfield.val("")
        stocktakeitemcodefield.focus()
    }

    stocktakingtable.on("click",".deletedata",function(){
        const parent=$(this).closest("tr")
        const itemname=parent.find("td").eq(1).text()
        bootbox.dialog({
            // title: "Confirm Item Removal!",
             message: "Are you sure you want to remove <strong>"+itemname+"</strong> from the list?",
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
                         //console.log(parent)
                         parent.remove()
                        //  overalltotal.html($.number(getItemsTotal(),2))
                        //  totalamountpayable.html($.number(getItemsTotal(),2))
                        //  computeTotalAmountPaid()
                         $('.bootbox').modal('hide');
                     }
                 }
             }
         })
    })
})