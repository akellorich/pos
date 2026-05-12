$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        filterreturnsbutton=$("#filterreturniwards"),
        datepickercontrols=$(".datepicker")
        addreturninwardbutton=$("#addreturninwards"),
        returninwardsmodal=$("#returninwardsmodal"),
        getreceiptitemsbutton=$("#getreceiptitems"),
        receiptnumberfield=$("#receiptnumber"),
        returndetailserrordiv=$("#returndetailserrors"),
        returnitemsdropdown=$("#returnitem"),
        addreturnitemtolist=$("#addreturnitemtolist"),
        returneditemslist=$("#returneditemslist"),
        returneditemstotals=$("#total"),
        savereturninwards=$("#savereturninward"),
        existingreturnstable=$("#existingreturnstable"),
        filtererrors=$("#filtererrors"),
        resulterrors=$("#resultserrors"),
        narrationfield=$("#narration"),
        returncollectionmodal=$("#returncollectionmodal"),
        itemcollectedidfield=$("#collectionid"),
        itemcollectedcodefield=$("#colletionitemcode"),
        itemcollectenamefield=$("#collectionitemname"),
        itemcollectedrefnofield=$("#collectionrefeno"),
        itemcollectedserialnofield=$("#collectionserialno"),
        itemcollectedbyfield=$("#collectioncollectedby"),
        savecollecteditembutton=$("#savereturncollection"),
        collectionerrorfield=$("#returncollectionserrors")

    datepickercontrols.datepicker({dateFormat: 'dd-M-yy'})
    //enddatefield.datepicker({dateFormat: 'dd-M-yy'})

    addreturninwardbutton.on("click",function(){
        returninwardsmodal.modal("show")
        receiptnumberfield.focus()
    })

    // get receipt items
    getreceiptitemsbutton.on("click",function(){
        var receiptno=receiptnumberfield.val(),
            errors="",
            results=""

        if(receiptno!=""){
            getreceiptproducts(receiptno)
        }else{
            errors="Please provide the receipt number"
            receiptnumberfield.focus()
            returndetailserrordiv.html(showAlert("info",errors))
        }
    })

    receiptnumberfield.on("input",function(){
        returndetailserrordiv.html("")
    })

    receiptnumberfield.on("keyup", function(e){
        if(e.which==13){
            var receiptno=receiptnumberfield.val()
            if(receiptno!=""){
                 getreceiptproducts(receiptno)
            }else{
                errors="Please provide receipt number"
                returndetailserrordiv.html(showAlert("processing",errors,1))
            }
        }
    })

    function getreceiptproducts(receiptno){
        errors="Fetching products. Please wait ..."
        returndetailserrordiv.html(showAlert("processing",errors,1)),
        results="<option value=''>&lt;Choose One&gt</option>"
        $.getJSON(
            "../controllers/possalesoperations.php",
            {
                getreceiptitems:true,
                receiptno
            },
            function(data){
                if(data.length>0){
                    for(var i=0;i<data.length;i++){
                        results+=`<option value='${data[i].productid}'>${data[i].itemname}</option>`
                    }
                    returnitemsdropdown.html(results)
                    returndetailserrordiv.html("")
                }else{
                    errors="Sorry, receipt number not found in the system"
                    returndetailserrordiv.html(showAlert("info",errors))
                }
            },
           
        ) .fail(function(err){
            returndetailserrordiv.html(showAlert("danger",err['responseText'],1))
        })
    }

    // listen to add product to list button
    addreturnitemtolist.on("click",function(){
        var receiptno=receiptnumberfield.val(),
            productid=returnitemsdropdown.val(),
            errors="",
            results=""

        if(receiptno==""){
            errors="Please provide a receipt number"
            receiptnumberfield.focus()
        }else if(productid==""){
            errors="Please select a product to return first"
            returnitemsdropdown.focus()
        }
        if(errors==""){
            $.getJSON(
                "../controllers/possalesoperations.php",
                {
                    getreceiptitemdetails:true,
                    receiptno,
                    productid
                },
                function(data){
                    // get rows in the table
                    rows=returneditemslist.find("tbody tr").length
                    results+=`<tr data-productid='${data[0].productid}'><td>${Number(rows)+1}</td>`
                    results+=`<td>${data[0].itemcode}</td>`
                    results+=`<td>${data[0].itemname}</td>`
                    results+=`<td>${data[0].serialno}</td>`
                    results+=`<td>1</td>` // quantity to be returned
                    results+=`<td>${data[0].unitprice}</td>`
                    results+=`<td class='linetotal'>${$.number(data[0].unitprice,2)}</td>`
                    results+=`<td><a href='javascript void(0)' class='deletedata'><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>`
                    $(results).appendTo(returneditemslist.find("tbody"))
                    // compute totals
                    returneditemstotals.html($.number(computereturneditemstotal(),2))
                    // remove items from the list
                    $("#returnitem option[value='"+productid+"']").remove()
                }
            ).fail(function(err){
                returndetailserrordiv.html(showAlert("info",err['responseText']))
            })
        }else{
            returndetailserrordiv.html(showAlert("info",errors))
        }
        
    })

    // hide errors and notifications when an item is selected from the list
    returnitemsdropdown.on("change",function(){
        returndetailserrordiv.html("")
    })

    // compute totals
    function computereturneditemstotal(){
        var total=0
        returneditemslist.find(".linetotal").each(function(){
            var amount=$(this).html()
            total+=Number(amount.replace(",",""))
        })
        return total
    }

    // save the return inwards
    savereturninwards.on("click",function(){
        var returneditems=[],
            receiptno=receiptnumberfield.val(),
            errors="",
            narration=narrationfield.val()
        returneditemslist.find("tbody tr").each(function(){
            var $this=$(this),
                productid=$this.attr("data-productid"),
                serialno=$this.find("td").eq(3).text(),
                quantity=$this.find("td").eq(4).text()
                returneditems.push({"productid":productid,"serialno":serialno,"quantity":quantity})
        })
        // check for blank fields
        if(receiptno==""){
            errors="Please provide receipt number."
            receiptnumberfield.focus()
        }else if(returneditems.length==0){
            errors="Please select at least an item to return."
            returnitemsdropdown.focus()
        }else if(narration==""){
            errors="Please enter return reason"
            narrationfield.focus()
        }
        if(errors==""){
            returneditems=JSON.stringify(returneditems)
            $.post(
                "../controllers/returnoperations.php",
                {
                    savereturninwards:true,
                    receiptno,
                    returneditems,
                    narration
                },
                function(data){
                    // parse the json data
                    try{
                        data=JSON.parse(data)
                        errors=`Return inward completed successfully. Reference# <strong>${data.referenceno}</strong>`
                        returndetailserrordiv.html(showAlert("success",errors)) 
                        // clear fields
                        returneditemslist.find("tbody").html("")
                        receiptnumberfield.val("")
                        returnitemsdropdown.html("<option value=''>&lt;Choose One&gt;</option>")
                        receiptnumberfield.focus()
                        returneditemstotals.html("")
                    }catch(e){
                        returndetailserrordiv.html(showAlert("danger",data,1))
                    }
                }
            ).fail(function(err){
                console.log(err['responseText'])
                returndetailserrordiv.html(showAlert("danger",err['responseText'],1)) 
            })
        }else{
            returndetailserrordiv.html(showAlert("info",errors)) 
        }
    })

    // filter return inwards existing in the database
    filterreturnsbutton.on("click",function(){
        var startdate=startdatefield.val(),
            enddate=enddatefield.val(),
            errors=""
        // check for blank fields
        if(startdate==""){
            errors="Please select start date"
        }else if(enddate==""){
            errors="Please select end date "
        }
        if(errors==""){
            $.getJSON(
                "../controllers/returnoperations.php",
                {
                    getreturninwards:true,
                    startdate,
                    enddate
                },
                function(data){
                    var results=""
                    if(data.length>0){
                        for(var i=0;i<data.length;i++){
                            results+=`<tr data-id='${data[i].id}'><td>${Number(i)+1}</td>`
                            results+=`<td>${data[i].dateadded}</td>`
                            results+=`<td>${data[i].receiptno}</td>`
                            results+=`<td>${data[i].itemcode}</td>`
                            results+=`<td>${data[i].itemname}</td>`
                            results+=`<td>${data[i].serialno}</td>`
                            results+=`<td>${$.number(data[i].unitprice,2)}</td>`
                            results+=`<td>${$.number(data[i].quantity,2)}</td>`
                            results+=`<td>${$.number(data[i].total,2)}</td>`
                            results+=data[i].collected==1?`<td>&nbsp;</td>`:`<td><button  class='btn btn-xs btn-danger addcreditnote'><span><i class='fas fa-plus-circle fa-sm'></i></span> Credit Note</button></td>`
                            results+="<td><button class='btn btn-secondary btn-xs print' data-id='"+data[i].refno+"'><span><i class='fas fa-print fa-sm'></i></span> Print Form</button></td>"
                            results+=data[i].collected==1?`<td>&nbsp;</td>`:"<td><button class='btn btn-primary btn-xs collected' data-id='"+data[i].id+"'><span><i class='fas fa-people-carry fa-sm'></i></span> Item Collected</button></td></tr>"
                        }
                    }else{
                        results="<tr><td colspan='10'>Sorry. No records matching filter criteria found.</td></tr>"
                    }
                    // populate items in the list
                    existingreturnstable.find("tbody").html(results)
                }
            ).fail(function(err){
                resulterrors.html(showAlert("danger",err['responseText']))
            })
        }else{
            filtererrors.html(showAlert("info",errors))
        }
    })

    datepickercontrols.on("input",function(){
        resulterrors.html("")
        filtererrors.html("")
    })

    existingreturnstable.on("click",".print",function(e){
        e.preventDefault()
        var referenceno=$(this).attr("data-id"), url=""
        url="../returninwards.php?referenceno="+referenceno
        window.open(url, '_blank');
    })

    existingreturnstable.on("click", ".collected",function(){
        // get item collection details
        var $this=$(this),
            id=$this.attr("data-id"),
            receiptno=
            parent=$this.parent("td").parent("tr"),
            receiptno=parent.find("td").eq(2).text(),
            itemcode=parent.find("td").eq(3).text(),
            itemname=parent.find("td").eq(4).text(),
            serialno=parent.find("td").eq(5).text()

        itemcollectedidfield.val(id)
        itemcollectedcodefield.val(itemcode)
        itemcollectenamefield.val(itemname)
        itemcollectedrefnofield.val(receiptno)
        itemcollectedserialnofield.val(serialno)

        returncollectionmodal.modal("show")
    })

    savecollecteditembutton.on("click",function(){
        var collectedby=itemcollectedbyfield.val(),
            id= itemcollectedidfield.val()
            errors=""
        if(id==""){
            errors="There is no item selected for return, pick an item from the list first."
        }else if(collectedby==""){
            errors="Please provide the details of the collector"
            itemcollectedbyfield.focus()
        }

        if(errors==""){
            // save the return outward
            $.post(
                "../controllers/returnoperations.php",
                {
                    savereturninwardscollection:true,
                    id,
                    collectedby
                },
                function(data){
                    if(data=="success"){
                        errors="The item has been collected successfully"
                        collectionerrorfield.html(showAlert("success",errors))
                        // clear the fields
                        itemcollectedidfield.val("")
                        itemcollectedcodefield.val("")
                        itemcollectenamefield.val("")
                        itemcollectedrefnofield.val("")
                        itemcollectedserialnofield.val("")
                        itemcollectedbyfield.val("")
                    }else{
                        errors=`Sorry an error occured. ${data}`
                        collectionerrorfield.html(showAlert("danger",errors))
                    }
                }
            )
            // disable credit note and return buttons
            $this.prop("disabled",true)
        }else{
            // display errors
            collectionerrorfield.html(showAlert("info", errors))
        }
    })
})