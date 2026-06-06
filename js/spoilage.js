$(document).ready(()=>{
    const prodcutnamelist=$("#product")
    const categorynamelist=$("#category")
    const startdatefield=$("#startdate")
    const enddatefield=$("#enddate")
    const alldates=$("#alldates")
    const addspoilagemodal=$("#spoilagedetailsmodal")
    const addnewmodalbutton=$("#addnew, #mobileAddSpoilageFAB")
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
                        results+=`<tr>`
                        results+=`<td class="d-none d-md-table-cell">${counter}</td>`
                        results+=`<td>${spoilage.categoryname}</td>`
                        results+=`<td>${spoilage.itemname}</td>`
                        results+=`<td>${$.number(spoilage.quantity,2)}</td>`
                        results+=`<td class="d-none d-md-table-cell">${spoilage.narration}</td>`
                        results+=`<td class="d-none d-md-table-cell">${spoilage.dateadded}</td>`
                        results+=`<td class="d-none d-md-table-cell">${spoilage.addedby}</td>`
                        
                        // Action dropdown
                        results+=`<td class="text-center">
                            <div class="dropdown">
                                <a class="btn btn-sm btn-link text-secondary p-0" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-size: 1.2rem; text-decoration: none;">
                                    <i class="fal fa-ellipsis-v"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right shadow border-0" style="border-radius: 8px; font-size: 0.85rem; z-index: 1050 !important;">
                                    <a class="dropdown-item edit-spoilage" href="#" data-id="${spoilage.id}">
                                        <i class="fal fa-edit fa-fw mr-2" style="color: #6c757d; font-size: 0.72rem;"></i> Edit
                                    </a>
                                    <a class="dropdown-item delete-spoilage" href="#" data-id="${spoilage.id}">
                                        <i class="fal fa-trash-alt fa-fw mr-2" style="color: red; font-size: 0.72rem;"></i> Delete
                                    </a>
                                </div>
                            </div>
                        </td></tr>`
                    })
                    filternotifications.html("")
                    makedatatable(spoilagelist, results, 15)
                }
            )
        }else{
            filternotifications.html(showAlert("info",errors))
        }
    })

    // Toggle Filters collapsible panel text & icons
    $('#filterCollapse').on('show.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Close');
        $('#toggleFiltersBtn i').removeClass('fa-filter').addClass('fa-times');
    });
    $('#filterCollapse').on('hide.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Filters');
        $('#toggleFiltersBtn i').removeClass('fa-times').addClass('fa-filter');
    });
})