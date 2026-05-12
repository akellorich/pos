$(document).ready(()=>{
    const prodcutnamelist=$("#product")
    const categorynamelist=$("#category")
    const startdatefield=$("#startdate")
    const enddatefield=$("#enddate")
    const alldates=$("#alldates")
    const addspoilagemodal=$("#spoilagedetailsmodal")
    const addnewmodalbutton=$("#addnew")
    const addspoilagecategory=$("#detailscategory")
    const addspoilageproduct=$("#detailsproduct")
    const addspoilagequantity=$("#detailsquantity")
    const addspoilagenarration=$("#detailsnarrattion")
    const savespoilagebutton=$("#savespoilage")
    const notifications=$("#notifications")
    const clearfieldsbutton=$("#clearform")
    const selectfields=$("select")
    const filterspoilagebutton=$("#search")
    const filternotifications=$("#errors")
    const spoilagelist=$("#spoilagelist")

    const storecategoryfield=$("#storecategory"),
        storeidfield=$("#storeid")

    // get store categories and stores
    storecategoryfield.on("change",function(){  
        const category=$(this).val()
        if(category!=""){
            if (category=="warehouse"){
                getwarehouses(storeidfield,'choose')
            }else{
                getPointsOfSale(storeidfield,'choose')
            }
        }else{
            storeidfield.html(`<option value="">&lt;Choose&gt;</option>`)
        }
    })

    // Set appropriate date format for the date pickers
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})
    
    // disable date fields and select all dates by default
    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    // get existing spoilage categories and products
    getallproducts(prodcutnamelist)
    getspoilagecategories(categorynamelist)

    getallproducts(addspoilageproduct,'choose')
    getspoilagecategories(addspoilagecategory,'choose')

    // toggle disbale status for date fields
  
    
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

    // show add new spoilage modal
    addnewmodalbutton.on("click",()=>{
        addspoilagemodal.modal("show")
    })

    //save spoilage
    savespoilagebutton.on("click",()=>{
        const id=0
        const categoryid=addspoilagecategory.val()
        const productid=addspoilageproduct.val()
        const quantity=addspoilagequantity.val()
        const narration=addspoilagenarration.val()

        // Add store category and store id to the request if they are selected
        const storecategory=storecategoryfield.val(),
            storeid=storeidfield.val()

        let errors="", notification=""
        // check for blank fields
        if(storecategory!=""){
            errors="Please select store category"
            storecategoryfield.focus()
        }else if(storeid!=""){
            errors="Please select store"
            storeidfield.focus()
        }else if(categoryid==""){
            errors="Please select spolage category"
            addspoilagecategory.focus()
        }else if(productid==""){
            errors="Please select a product"
            addspoilageproduct.focus()
        }else if(quantity=="" || Number(quantity)==0){
            errors="Please provide correct quantity"
            addspoilagequantity.focus()
        }else if(narration==""){
            errors="Please enter spoilage narration"
            addspoilagenarration.focus()
        }

        if(errors==""){
            notifications.html(showAlert("processing","Processing. Please wait ...",1))
            $.post(
                "../controllers/spoilageoperations.php",
                {
                    savespoilage:true,
                    id,
                    storecategory,
                    storeid,
                    categoryid,
                    productid,
                    quantity,
                    narration
                },
                (data)=>{
                    data=data.trim()
                    if(data=="success"){
                        notification="The spoilage has been recorded successfully"
                        notifications.html(showAlert("success",notification))
                        // clear the form
                        clearform()
                    }else{
                        notification=`Sorry an error coocured. ${data}`
                        notifications.html(showAlert("danger",notification))
                    }
                }
            )
        }else{
            notifications.html(showAlert("info",errors))
        }
    })

    clearfieldsbutton.on("click",()=>{
        clearform()
    })

    // Clear form fields
    function clearform(){
        addspoilagecategory.val("")
        addspoilageproduct.val("")
        addspoilagequantity.val("")
        addspoilagenarration.val("")
        storecategoryfield.val("")
        storeidfield.val("")    
    }

    // hide notifcations on input chnages on the form
    selectfields.on("change",()=>{
        notifications.html("")
    })

    addspoilagequantity.on("input",()=>{
        notifications.html("")
    })

    addspoilagenarration.on("input",()=>{
        notifications.html("")
    })

    // filter existing spoilage
    filterspoilagebutton.on("click",()=>{
        let startdate,enddate,errors=""

        const categoryid=categorynamelist.val()
        const productid=prodcutnamelist.val()

        if(alldates.prop("checked")){
            startdate='01-Jan-2000'
            enddate='31-Dec-2100'
        }else{
            startdate=startdatefield.val()
            enddate=enddatefield.val()
            if(startdate==""){
                errors="Please select start date"
                startdatefield.focus()
            }else if(enddate==""){
                errors="Please select end date"
                enddatefield.focus()
            }
        }

        if(errors==""){
            filternotifications.html(showAlert("processing","Processing. Please wait ..."))
            $.getJSON(
                "../controllers/spoilageoperations.php",
                {
                    filterspoilage:true,
                    startdate,
                    enddate,
                    categoryid,
                    productid
                },
                (data)=>{
                    let results="",counter=0
                    data.forEach((spoilage)=>{
                        counter++
                        results+=`<tr><td>${counter}</td>`
                        results+=`<td>${spoilage.categoryname}</td>`
                        results+=`<td>${spoilage.itemname}</td>`
                        results+=`<td>${$.number(spoilage.quantity,2)}</td>`
                        results+=`<td>${spoilage.narration}</td>`
                        results+=`<td>${spoilage.dateadded}</td>`
                        results+=`<td>${spoilage.addedby}</td>`
                        // add edit and delete buttons
                        results+=`<td data-id=${spoilage.id} class="edit-spoilage text-primary "><span><i class='fas fa-edit fa-sm mt-1' ></i></span></td>`
                        results+=`<td data-id=${spoilage.id} class="delete-spoilage text-danger"><span><i class='fas fa-trash-alt fa-sm mt-1'></span></i></td></tr>`
                    })
                    console.log(results)
                    filternotifications.html("")
                    spoilagelist.find("tbody").html(results)
                }
            )
        }else{
            filternotifications.html(showAlert("info",errors))
        }
    })
})