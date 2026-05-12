$(document).ready(function(){
    itemcodefield=$("#itemcode"),
    customerlist=$("#customer"),
    errordiv=$("#errors"),
    errors="",
    salesitems=$("#salesitems"),
    searchresults=$("#searchproducts"),
    overalltotal=$("#total"),
    savebutton=$("#save"),
    clearbutton=$("#clear")

    // get existing customers 
    $.getJSON(
        "../controllers/getcustomers.php",
        function(data){
            var results="<option value=''>&lt;Choose One&gt;</option>"
            for (var i = 0; i < data.length; i++) {
                results+="<option value='"+data[i].customerid+"'>"+data[i].customername+"</option>"
            } 
            $(results).appendTo(customerlist)
        }
    )

    // listen to itemcode keypress, when enter search the product by code
    itemcodefield.keypress(function(event){	
        var keycode = (event.keyCode ? event.keyCode : event.which);
        
        if(keycode == '13'){
           getProduct()
        } 
    })
    
    itemcodefield.on("change",function(){
        // reset all errors displayed in the error div
        errordiv.html("")
    })

    // listen to the click event of search term when clicked
    searchresults.on("click","li",function(){
        var itemcode=''
        itemcode=$(this).attr("id")
        itemcodefield.val(itemcode)
        getProduct()
        searchresults.hide()
    })

    // search the product
    function getProduct(){
        // display progress
        errordiv.html("")
        errors="<p>Fetching product deatils. Please wait ...</p>"
        $(errors).appendTo(errordiv)
        var productdetails=""

        $.getJSON(
            "../controllers/getproductdetails.php",
            {
                productcode:itemcodefield.val()
            },
            function(data){
                // check if JSON returned a blank object
                if (Object.keys(data).length===0){
                    errordiv.html("")
                    errors="<p class='alert alert-warning'>Sorry, no product with similar code found</p>"
                    $(errors).appendTo(errordiv)
                }else{
                    errordiv.html("")
                    productdetails+="<tr><td>"+data[0].itemcode+"</td>"
                    productdetails+="<td>"+data[0].itemname+"</td>"
                    productdetails+="<td>"+data[0].sellingprice+"</td>"
                    productdetails+="<td class='quantity'>1</td>"
                    productdetails+="<td class='linetotal'>"+data[0].sellingprice+"</td>"
                    productdetails+="<td><a href='javascript void(0)' class='deletedata' data-id='"+data[0].itemcode+"'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                    $(productdetails).appendTo(salesitems.find("tbody"))
                    // display overall total
                    overalltotal.val($.number(getItemsTotal()))
                    itemcodefield.val("")
                    itemcodefield.focus()
                    errordiv.html("")
                } 
            }
        )
    }

    // calculate totals
    function getItemsTotal(){
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function() {
            var value = $(this).text().replace(",","");
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    // generate data to be pushed to PHP
    function storeTblValues()
    {
        var TableData = new Array();

        $('#salesitems tr').each(function(row, tr){
            TableData[row]={
                "itemcode"  : $(tr).find('td:eq(0)').text(),
                "unitprice" : $(tr).find('td:eq(2)').text(),
                "quantity"  : $(tr).find('td:eq(3)').text()
            }    
        }); 
        TableData.shift()  // first row will be empty - so remove
        //TableData.pop()
        return TableData
    }

    // listen to save button click 
    savebutton.on("click",function(){
        // check if customer field is blank
        if(customerlist.val()==""){
            // display error
            errors="<p class='alert alert-warning'>Please select Customer</p>"
            errordiv.html("")
            $(errors).appendTo(errordiv)
        }else{
            var TableData,
                customerid=customerlist.val()
            TableData = JSON.stringify(storeTblValues())
            //console.log(TableData)
            // reset all errrors shown previously
            errordiv.html("")

            // Post the data for processing 
            $.post(
                "../controllers/creditnoteoperations.php",
                {
                    savecreditnote:"post",
                    customerid:customerid,
                    TableData:TableData
                },
                function(data){
                    errordiv.html("")
                    data=$.parseJSON(data)
                    errors="<p class='alert alert-info'>Credit Note created successfully. Reference #: <span class='lead font-weight-bold'>"+data[0].creditnotenumber+"</span></p>"
                    $(errors).appendTo(errordiv)
                    clearform()
                }
            )
        }
    })

    function clearform(){
        customerlist.val("")
        salesitems.find("tbody").html("")
        overalltotal.val("0.00")
        itemcodefield.focus()
    }

    clearbutton.on("click",function(){
        clearform()
        errordiv.html("")
    })

    itemcodefield.on("keyup",function(){
        var name=itemcodefield.val()
        if(name.length>2){
            $.getJSON(    
                "../controllers/productoperations.php",
                {
                    filterproductbyname:1,
                    name:name
                },
                function(data){
                    var results="<ul class='searchresults'>"
                    searchresults.html("")
                    if(data.length>0){
                        for(i=0;i<data.length;i++){
                            results+="<li id='"+data[i].itemcode+"'>"+data[i].itemname+"</li>"
                        }
                        results+="</ul>"
                        // console.log(results)
                        $(results).appendTo(searchresults)
                        searchresults.show()
                    }  else{

                    }
                }
            )
        }

        salesitems.on("click",".deletedata",function(e){
            e.preventDefault();
            var id = $(this).attr('data-id');
            var parent = $(this).parent("td").parent("tr");
            var itemname=parent.find("td").eq(1).text()
            bootbox.dialog({
            // title: "Confirm Item Removal!",
                message: "Are you sure you want to remove <strong>"+itemname+"</strong> from the list?",
                buttons: {
                    success: {
                        label: "No, Keep",
                        className: "btn-success",
                        callback: function() {
                            $('.bootbox').modal('hide');
                        }
                    },
                    danger: {
                        label: "Yes, Remove",
                        className: "btn-danger",
                        callback: function() {
                            //console.log(parent)
                            parent.remove()
                            overalltotal.val($.number(getItemsTotal()))
                            $('.bootbox').modal('hide');
                        }
                    }
                }
            })
        })
    })

    // listen to change quantity field
    salesitems.on("click",".quantity",function(){
        var parent = $(this).parent("tr");
        bootbox.prompt({
            title:"Enter New Quantity",
            size: 'small',
            message: "Enter quantity required",
            inputType: 'number',
            callback: function (result) {
                if(parseFloat(result)>0){
                    var unitprice= parent.find("td").eq(2).text(),
                        linetotal=parseFloat(result*unitprice)
                    parent.find("td").eq(3).text(result)
                    parent.find("td").eq(4).text($.number(linetotal))
                   /* overalltotal.html($.number(getItemsTotal(),2))
                    totalamountpayable.html($.number(getItemsTotal(),2))
                    computeTotalAmountPaid()*/
                    overalltotal.val($.number(getItemsTotal()))
                } 
            }
        });
    })
})