$(document).ready(function(){
    var scopefield=$("#scope"),
        supplierfield=$("#supplier"),
        supplierlabel=$("#supplierlabel")
        departmentfield=$("#department"),
        generaterequisitionno=$("#autogenerate"),
        requisitionnofield=$("#requisitionno"),
        requisitionnolabel=$("#requisitionlabel"),
        projectslist=$("#projectname"),
        activitylist=$("#activity"),
        searchmaterials=$("#searchmaterials"),
        materialnamefield=$("#itemname"),
        materialquantityfield=$("#quantity"),
        additemtolistbutton=$("#additem"),
        requisitionerrors=$("#requisitionerrors"),
        materialnarrationfield=$("#narration"),
        materialslist=$("#materialslist"),
        totalfield=$("#total"),
        inputfield=$("input"),
        selectfield=$("select"),
        materialusecasefield=$("#usecase"),
        refnofield=$("#refno"),
        saverequisitionbutton=$("#saverequisition"),
        idfield=$("#id"),
        narrationfield=$("#requisitionnarration"),  
        reqnodetails=$("#reqnodetails"),
        purchaserequisitionfield=$("#purchaserequisition"),
        supplierfields=$("#supplierfields"),
        activitymaterialsummarymodal=$("#activitymaterialsummary"),
        approvedlabel=$(".approved"),
        committedlabel=$(".committed"),
        issuedlabel=$(".issued"),
        availablelabel=$(".available")
        instock=$(".instock")

    // get url parameters
    const urlSearchParams = new URLSearchParams(window.location.search)
    const params = Object.fromEntries(urlSearchParams.entries())
    // const attachsitemodal=$("#attachsitemodal")
    // const attachsitebutton=$("#attachsite")
    const sitenmc=$("#sitenmc")
    const siteregion=$("#siteregion")
    const sitename=$("#sitename")
    const saverequisitionsite=$("#addsitetorequisition")
    const sitedetails=$("#sitedetails")

    // get requisition settings 
    getrequisitionsettings()

    // select non-purchase requisition by default
    purchaserequisitionfield.val("0")
    supplierfields.hide()
    getdefaultnonpurchasesupplier()

    // select default supplier

    let autoapproverequisitions, restrictfiltertoresourceallocation

    function getrequisitionsettings(){
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getrequisitionsettings:true
            },
            (data)=>{
                autoapproverequisitions=data[0].autoapprove
                restrictfiltertoresourceallocation=data[0].restrictfilteritemstoallocation
            }
        )
    }

    // show modal for selecting site
    attachsitebutton.on("click",()=>{
        attachsitemodal.modal("show")
    })

    // saverequisitionsite.on("click",()=>{
    //     const selectedoption=sitename.find("option:selected")
    //     const site=selectedoption.text()
    //     const sitecode=selectedoption.attr("data-sitecode")
    //     const results=`${sitecode} - ${site}`
    //     sitedetails.attr("data-siteid",sitename.val())
    //     sitedetails.html(results)
    //     attachsitemodal.modal("hide")
    //     attachsitebutton.html("Change")
    // })

    getcustomers(sitenmc,'choose')

    // sitenmc.on("change",()=>{
    //     nmcid=sitenmc.val()==""?0:sitenmc.val()
    //     getregions(nmcid,siteregion,'all')
    // })

    // siteregion.on("change",()=>{
    //     regionid=siteregion.val()
    //     getsites(regionid,sitename,'choose')
    // })

    // listen to selection of requisition if for purchase or just regular material requisition
    purchaserequisitionfield.on("change",function(){
        // hide the supplier selection fields
        const status=$(this).val()
        //console.log(status)
        if (status=="0"){
            supplierfields.hide()
            getdefaultnonpurchasesupplier()
        }else{
            // show the supplier fields
            supplierfields.show()
        }
    })

    // get default supplier for non-purchase requisition
    function getdefaultnonpurchasesupplier(){
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getnonpurchaserequisitiondefaultsupplier:true
            },
            (data)=>{
                data=Number(data)
                if(data==0){
                    // disable the save button
                    bootbox.alert({
                        message: `<i class="fal fa-info-circle fa-lg text-info"></i> Sorry, default supplier not set. Contact System Admin`,
                        buttons: {
                            ok: {
                                label: 'Got it',
                                className: 'btn-sm btn-danger'
                            }
                        }
                    })
                }else{
                    supplierfield.val(data) 
                }
            }
        )
    }
    // check if a requisition number has been provided and switch to Edit mode
    if(params.requisitionno!=""){
        let requisitionno=params.requisitionno
        // get requisitiondetails
        getsuppliers(supplierfield,'choose').then(function(){
            getdepartments(departmentfield,'choose').then(function(){
                getmaterialusecases(materialusecasefield, option='choose').then(function(){
                    $.getJSON(
                        "../controllers/materialoperations.php",
                        {
                            getmaterialrequisitiondetails:true,
                            requisitionno
                        },
                        function(data){
                            disablerequisitionfields()
                            idfield.val(data[0].id)
                            requisitionnofield.val(data[0].requisitionno)
                            materialusecasefield.val(data[0].materialusecase)
                            refnofield.val(data[0].reference)
                            supplierfield.val(data[0].supplierid)
                            departmentfield.val(data[0].departmentid)
                            getrequisitionitems(data[0].id) 
                            // select activity
                            getdepartmentprojects(data[0].departmentid).done(function(){
                                projectslist.val(data[0].projectid)
                                // get activities
                                getprojectactivities(data[0].projectid).done(function(){
                                    activitylist.val(data[0].activityid)
                                })
                            })
                        }
                    )
                })
            })
        })
    }
    
    if(typeof params.requisitionno=='undefined'){
        // hide requisition number details since it will be autogenerated
        reqnodetails.hide() 
        generaterequisitionno.prop("checked",true)
        disablerequisitionfields()
        // populate dropdown fields
        //getrequisitionscope(scopefield,'choose') 
        getsuppliers(supplierfield,'choose')
        getdepartments(departmentfield,'choose')
        // getmaterialusecases(materialusecasefield, option='choose')
        // add a blank selsetcion in the project and activity field
        // projectslist.html("<option value=''>&lt;Choose&gt;</option>")
        // activitylist.html("<option value=''>&lt;Choose&gt;</option>")
        // autogenerate requisition number by default
    }

    //toggle requisition number fields
    generaterequisitionno.on("click",function(){
        $(this).prop("checked")?disablerequisitionfields():enablerequisitionfields()
    })

    // toggle supplier fields status
    scopefield.on("change",()=>{
        scopefield.val()==1?disablesupplierfields():enablesupplierfields()
    })
    
    // get projects when a department is selected
    // departmentfield.on("change",function(){
    //     departmentid=departmentfield.val()
    //     if(departmentid==""){
    //         projectslist.html("<option value=''>&lt;Choose&gt;</option>")
    //     }else{
    //         getdepartmentprojects(departmentid)
    //     }
    // })

    // get project activities on selection of a project
    // projectslist.on("change",function(){
    //     projectid=projectslist.val()
    //     if(projectid==""){
    //         activitylist.html("<option value=''>&lt;Choose&gt;</option>")
    //     }else{
    //       getprojectactivities(projectid)  
    //     }
        
    // })

    // search materials or products by name
    materialnamefield.on("keyup",function(){
        const materialname=materialnamefield.val()
            // id=activitylist.val()

        if(materialname.length>2){
            $.getJSON(
                "../controllers/materialoperations.php",
                {
                    filteractivitymaterials:true,
                    materialname
                },
                (data)=>{ 
                    var results="<ul class='searchresults'>"
                    //for(var i=0;i<data.length;i++){
                        searchmaterials.html("")
                        if(data.length>0){
                            for(i=0;i<data.length;i++){
                                results+=`<li id='${data[i].itemcode}'  data-itemname='${data[i].itemname}' data-materialid='${data[i].id}'  data-unitprice='${data[i].unitprice}' data-uom=${data[i].uom}>${data[i].itemname}</li>`
                            }
                        }else{
                            results+=`<li><i class="fas fa-info-circle fa-lg"></i> No matching records found</li>`
                        }
                        results+="</ul>"
                        // console.log(results)
                        searchmaterials.html(results)
                        searchmaterials.show()
                    //}
                }
            )
            //searchmaterialsbyname(materialname,searchmaterials)
        }else{
            searchmaterials.hide()
        }
    })

    // get material details when selected from the search drop down
    searchmaterials.on("click","li",function(){
        if(restrictfiltertoresourceallocation==0){
            $this=$(this)
            materialnamefield.val($this.attr("data-itemname"))
            materialnamefield.attr("data-id",$this.attr("data-materialid"))
            materialnamefield.attr("data-uom",$this.attr("data-uom"))
            materialnamefield.attr("data-itemcode",$this.prop("id"))
            materialnamefield.attr("data-unitprice",$this.attr("data-unitprice"))
            materialquantityfield.focus()
        }else{
            var itemcode=''
            itemcode=$(this).attr("id")
            $.getJSON(
                "../controllers/materialoperations.php",
                {
                    getmaterialbycode:true,
                    itemcode
                },
                function(data){
                    materialnamefield.val(data[0].description)
                    materialnamefield.attr("data-id",data[0].id)
                    materialnamefield.attr("data-uom",data[0].unitofmeasure)
                    materialnamefield.attr("data-itemcode",data[0].itemcode)
                    materialnamefield.attr("data-unitprice",data[0].buyingprice)
                    materialquantityfield.focus()
                }
            )
        }
        searchmaterials.hide()
    })

    // add item to list
    additemtolistbutton.on("click",function(){
      
        const  itemid=materialnamefield.attr("data-id"),
            itemcode=materialnamefield.attr("data-itemcode"),
            itemname=materialnamefield.val(),
            quantity=materialquantityfield.val(),
            unitprice=materialnamefield.attr("data-unitprice"),
            uom=materialnamefield.attr("data-uom"), 
            narration=materialnarrationfield.val(),
            rows=materialslist.find("tbody tr").length,
            activityid=activitylist.val() 
        let errors="",itemadded=""
        // check for blank fields
        if(itemid==0){
            errors="Please select an item first"
            materialnamefield.focus()
        }else if(quantity=="" || Number(quantity)<=0){
            errors="Please provide correct quantity"
            materialquantityfield.focus()
        }
        if(errors==""){
            // add the item to the list
            // get items balances
            $.getJSON(
                "../controllers/materialoperations.php",
                {
                    getactivitymaterialsummary:true,
                    materialid:itemid
                },
                (data)=>{
                    let available=0
                    if(data.length>0){
                        available=data[0].approved-data[0].issued-data[0].commited
                    }
                       
                    let classvar=available<quantity && restrictfiltertoresourceallocation==1?"class='bg-danger'":'',
                        whitefont=classvar!=""? `class='text-white font-weight-bold'`:''
                        totalclass=classvar!=""? `class='text-white font-weight-bold total'`:`class='total'`

                    itemadded=`<tr data-id='${itemid}' ${classvar}><td ${whitefont}>${Number(rows+1)}</td>`
                    itemadded+=`<td ${whitefont}>${itemcode}</td>`
                    itemadded+=`<td ${whitefont}>${itemname}</td>`
                    itemadded+=`<td ${whitefont}>${narration}</td>`
                    itemadded+=`<td ${whitefont}>${uom}</td>`
                    itemadded+=`<td ${whitefont}>${unitprice}</td>`
                    itemadded+=`<td ${whitefont}>${quantity}</td>`
                    itemadded+=`<td ${totalclass}>${Number(quantity)*Number(unitprice)}</td>`
                    // add edit and delete buttons
                    itemadded+=`<td><a href='javascript void(0)' class='editdata' data-id='${itemid}'><span ${whitefont}><i class='far fa-edit fa-sm'></i></span></a></td>`
                    itemadded+=`<td><a href='javascript void(0)' class='deletedata' data-id='${itemid}'><span ${whitefont}><i class='far fa-trash-alt fa-sm'></i></span></a></td>`
                    itemadded+=`<td><a href='javascript void(0)' class='viewbalancesummary' data-id='${itemid}'><span ${whitefont}><i class='far fa-info-circle fa-sm'></i></span></a></td></tr>`

                    // change fornt colour for all td to white
                    if(classvar!=""){
                        itemadded=itemadded.replace("<td>","<td class='text-white font-weight-bold'>")
                    }
                    // append the item to the list
                    list=materialslist.find("tbody")
                    $(itemadded).appendTo(list)
                    // compute totals
                    computetotals()
                    // clear fields for a new entry
                    clearmaterialsfields()
                }
            )
        }else{
            //display errors
            requisitionerrors.html(showAlert("info",errors))
        }
    })

    // hide notifications or errors whenever there are changes in form fields
    inputfield.on("input",function(){
        requisitionerrors.html("")
    })

    selectfield.on("change",function(){
        requisitionerrors.html("")
    })

    // edit material details added on the list
    materialslist.on("click", ".editdata", function(e){
        e.preventDefault()
        var $this=$(this),
            parent=$this.parent("td").parent("tr"),
            row=parent.find("td"),
            id=parent.attr("data-id"),
            itemcode=row.eq(1).text(),
            itemname=row.eq(2).text(),
            narration=row.eq(3).text(),
            uom=row.eq(4).text(),
            unitprice=row.eq(5).text(),
            quantity=row.eq(6).text()

        materialnamefield.val(itemname)
        materialnamefield.attr("data-id",id) 
        materialnamefield.attr("data-itemcode",itemcode)
        materialnamefield.attr("data-unitprice",unitprice)
        materialnamefield.attr("data-uom",uom)
        materialquantityfield.val(quantity)
        materialnarrationfield.val(narration)
        // remove the parent form the list
        parent.remove()
        // perform totals
        computetotals()
        // renumber the fields
        renumberitemslist()
    })

    // delete or remove material added from the list
    materialslist.on("click",".deletedata",function(e){
        e.preventDefault()
        var parent=$(this).parent("td").parent("tr"),
            itemname=parent.find("td").eq(2).text()
        // show confirm delete dialog
        bootbox.dialog({
            // title: "Confirm Item Removal!",
             message: "Are you sure you want to remove <strong>"+itemname+"</strong> from the list?",
             buttons: {
                 success: {
                    label: "No, Keep",
                    className: "btn-success btn-sm",
                    callback: function() {
                        $('.bootbox').modal('hide')
                    }
                 },
                 danger: {
                    label: "Yes, Remove",
                    className: "btn-danger btn-sm",
                    callback: function() {  
                        // delete the item
                        parent.remove()
                        // renumber the list
                        renumberitemslist()
                        // hide the modal
                        $('.bootbox').modal('hide')
                    }
                }
            }
        })
    })

    // save requisition
    saverequisitionbutton.on("click",function(){
        var id=idfield.val(),
            // scopeid=scopefield.val(),
            materialuse=materialusecasefield.val(),
            refno=refnofield.val(),
            supplierid=supplierfield.val(),
            departmentid=departmentfield.val(),
            // activityid=activitylist.val(),
            narration=narrationfield.val(),
            purchaserequisition=purchaserequisitionfield.val()
            materials=[],
            errors="",
            notifications="",
            invalidrequestquantity=false
            siteid=sitedetails.html().trim().toString()===""?0:sitedetails.attr("data-siteid")
            materialslist.find("tbody tr").each(function(){
                $this=$(this)
                row=$this.find("td")
                itemid=$this.attr("data-id")
                materialnarration=row.eq(3).text()
                unitprice=row.eq(5).text()
                quantity=row.eq(6).text()
                materials.push({"itemid":itemid,"narration":materialnarration,"unitprice":unitprice,"quantity":quantity})
            })

            if(purchaserequisition==""){
                errors="Please specify if requisition is meant for purchasing"
                purchaserequisitionfield.focus()
            // }else if(materialuse==""){
            //     errors="Please select material use case"
            //     materialusecasefield.focus()
            }else if(supplierid==""){
                errors="Please select supplier"
                supplierfield.focus()
            }else if (departmentid==""){
                errors="Please select department"
                departmentfield.focus()
            // }else if(activityid==""){
            //     errors="Please select activity"
            //     activitylist.focus()
            }else if(materials.length<=0){
                errors="Please provide at least a requisition item"
            }else{
                // check if there is any item that has a highlight for request more than approved quantity
                materialslist.find("tbody tr").each(function(){
                    $this=$(this)
                    //console.log($this.find("td").eq(1).text())
                    if($this.hasClass("bg-danger")){
                        invalidrequestquantity=true,
                        errors="Please correct highlighted items. Requested quantity exceed available quantity"
                    }
                })
            }

            if(errors==""){
                // save the requisition
                requisitionerrors.html(showAlert("processing","Processing. Please wait ...",1))
                materials=JSON.stringify(materials)
                $.post(
                    "../controllers/materialoperations.php",
                    {
                        savematerialrequisition:true,
                        id,
                        departmentid,
                        scopeid:0,
                        supplierid,
                        refno,
                        activityid,
                        narration,
                        materials,
                        materialuse,
                        purchaserequisition,
                        siteid
                    },
                    function(data){
                        data=$.trim(data)
                        if(data.length==8){
                            if(id==0){
                                notifications=`Requisition saved successfully. Requisition # is:<strong> ${data}</strong>`
                            }else{
                                notifications=`Requisition details updated successfully.`
                            }
                            // clear fields for a new entry
                            clearrequisitionfields()
                            requisitionerrors.html(showAlert("success",notifications))
                        }else if(data=="exists"){
                            notifications=`Reference number provided already in use.`
                            requisitionerrors.html(showAlert("info",notifications))
                            refnofield.focus()
                        }else{
                            notifications=`Sorry an error occured. ${data}`
                            requisitionerrors.html(showAlert("danger",notifications,1))
                        }
                    }
                )
               
            }else{
                //display errors
                requisitionerrors.html(showAlert("info",errors))
            }
    })

    function clearrequisitionfields(){
        idfield.val("0")
        scopefield.val("")
        // materialusecasefield.val("")
        refnofield.val("")
        supplierfield.val("")
        departmentfield.val("")
        // activitylist.val("")
        narrationfield.val("")
        materialslist.find("tbody").html("")
        // projectslist.val("")
        totalfield.html("0.00")
        requisitionnofield.val("")
        disablerequisitionfields()
        // sitedetails.html("")
        // sitedetails.attr("data-siteid","")
        getdefaultnonpurchasesupplier()
    }

    function renumberitemslist(){
        row=0
        materialslist.find("tbody tr").each(function(){
            $(this).find("td").eq(0).text(Number(row+1))
            row++
        })
    }

    function clearmaterialsfields(){
        materialnamefield.attr("data-id","0")
        materialnamefield.attr("data-itemcode","")
        materialnamefield.val("")
        materialquantityfield.val("")
        materialnamefield.attr("data-unitprice","")
        materialnamefield.attr("data-uom","")
        materialnarrationfield.val("")
        materialnamefield.focus()
    }

    function computetotals(){
        var total=0
        materialslist.find("tbody .total").each(function(){
            total+=Number($(this).html())
        })
        totalfield.html($.number(total,2))
    }

    function enablerequisitionfields(){
        requisitionnofield.prop("disabled",false)
        requisitionnolabel.removeClass("text-muted")
    }

    function disablerequisitionfields(){
        requisitionnofield.prop("disabled",true)
        requisitionnolabel.addClass("text-muted")
    }

    function disablesupplierfields(){
        supplierfield.val("")
        supplierfield.prop("disabled",true)
        supplierlabel.addClass("text-muted")
    }

    function enablesupplierfields(){
        supplierfield.prop("disabled",false)
        supplierlabel.removeClass("text-muted")
    }
    
    function getdepartmentprojects(departmentid){
        var dfd=$.Deferred()
        $.getJSON(
            "../controllers/projectoperations.php",
            {
                getdepartmentprojects:true,
                departmentid
            },
            function(data){
                var results="<option value=''>&lt;Choose&gt;</option>"
                for(var i=0;i<data.length;i++){
                    results+=`<option value='${data[i].id}'>${data[i].projectname}</option>`
                }
                projectslist.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    // function getprojectactivities(projectid){
    //     var dfd=$.Deferred()
    //     $.getJSON(
    //         "../controllers/projectoperations.php",
    //         {
    //             getprojectactivities:true,
    //             projectid
    //         },
    //         function(data){
    //             var results="<option value=''>&lt;Choose&gt;</option>"
    //             for(var i=0;i<data.length;i++){
    //                 results+=`<option value='${data[i].id}'>${data[i].activityname}</option>`
    //             }
    //             activitylist.html(results)
    //             dfd.resolve()
    //         }
    //     )
    //     return dfd.promise()
    // }

    function getrequisitionitems(requisitionid){
        // get requisition items
        $.getJSON(
            "../controllers/materialoperations.php",
            {
                getmaterialrequisitionitems:true,
                requisitionid:idfield.val()
            },
            function(data){
                var itemadded=""
                for(var i=0;i<data.length;i++){
                    // add the item to the list
                    itemadded+=`<tr data-id='${data[i].id}'><td>${Number(i+1)}</td>`
                    itemadded+=`<td>${data[i].itemcode}</td>`
                    itemadded+=`<td>${data[i].itemname}</td>`
                    itemadded+=`<td>${data[i].narration}</td>`
                    itemadded+=`<td>${data[i].uom}</td>`
                    itemadded+=`<td>${data[i].unitprice}</td>`
                    itemadded+=`<td>${data[i].quantity}</td>`
                    itemadded+=`<td class='total'>${Number(data[i].quantity)*Number(data[i].unitprice)}</td>`
                    // add edit and delete buttons
                    itemadded+=`<td><a href='javascript void(0)' class='editdata' data-id='${data[i].id}'><span><i class='far fa-edit fa-sm'></i></span></a></td>`
                    itemadded+=`<td><a href='javascript void(0)' class='deletedata' data-id='${data[i].id}'><span><i class='far fa-trash-alt fa-sm'></i></span></a></td>`
                    itemadded+=`<td><a href='javascript void(0)' class='viewbalancesummary' data-id='${data[i].itemid}'><span><i class='far fa-info-circle fa-sm'></i></span></a></td></tr>`
                } 
                // append the item to the list
                list=materialslist.find("tbody")
                // $(itemadded).html(list)
                list.html(itemadded)
                // compute totals
                computetotals()
            }
        )
    }

    materialslist.on("click",".viewbalancesummary",function(e){
        e.preventDefault()
        var materialid=$(this).attr("data-id")
            // activityid=activitylist.val()
        // show modal with the summaries
        $.getJSON(
            "../controllers/materialoperations.php",
            {
                getactivitymaterialsummary:true,
                materialid
                // activityid
            },
            (data)=>{
                const available=data[0].approved-data[0].issued-data[0].commited
                approvedlabel.find("p").html($.number(data[0].approved))
                committedlabel.find("p").html($.number(data[0].commited))
                issuedlabel.find("p").html($.number(data[0].issued))
                availablelabel.find("p").html($.number(available))
                instock.find("p").html($.number(data[0].stockquantity))
            }
        )
        activitymaterialsummarymodal.modal("show")
    })
})