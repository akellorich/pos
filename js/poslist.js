$(document).ready(function(){
    const addpos=$("#addpos"),
        goback=$("#goback"),
        // poslist=$("#poslist"),
        postable=$("#postable"),
        errordiv=$("#errors"), 
        posdetailsmodal=$("#posdetailsmodal"),
        posidfield=$("#posid"),
        posnamefield=$("#posname"),
        postypefield=$("#postype"),
        printkotfield=$("#printkot"),
        posdetailsnotification=$("#posdetailsnotification"),
        saveposbutton=$("#savepos"),
        posproductcategories=$("#posproductcategories"),
        idfield=$("#posid"),
        inputfield=$("input"),
        selectfield=$("select"),
        posdetailsdiv=$("#posdetails"),
        postablediv=$("#tabledetails"),
        posdetailstabletogglebutton=$("#posdetailstableselection"),
        savepostablebutton=$("#savepostable"),
        postablenamefield=$("#tablename"),
        postablestable=$("#postablestable")
       
    // get existing pos
    getposastable()

    posdetailstabletogglebutton.on("click",function(){
        if($(this).prop("checked")){
           postablediv.hide()
            posdetailsdiv.show() 
            saveposbutton.prop("disabled",false)
        }else{
            postablediv.show()
            posdetailsdiv.hide()
            saveposbutton.prop("disabled",true)
        }
    })

    inputfield.on("input",()=>{
        posdetailsnotification.html("")
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    savepostablebutton.on("click",function(){
        const tablename=sanitizestring(postablenamefield.val()),
            tableid=postablenamefield.data("tableid"),
            posid=posidfield.val()

        let errors=""
        // check for blank fields
        if(tablename==""){
            errors="Please provide table name"
            posdetailsnotification.html(showAlert("info",errors))
            postablenamefield.focus()
        }else{
            $.post(
                "../controllers/posoperations.php",
                {
                    savetable:true,
                    tableid,
                    posid,
                    tablename
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            posdetailsnotification.html(showAlert("success",`Outlet table save successfully`))
                            // clear outlet fields
                            postablenamefield.val("").data("tableid","0")
                            // refresh outlet list
                            getpostablesastable()
                        }
                    }else{
                        posdetailsnotification.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }
                }
            )
        }
    })

    function getpostablesastable(){
        const posid=posidfield.val()
        $.getJSON(
            "../controllers/posoperations.php",
            {
                getpostables:true,
                posid
            },
            (data)=>{
                let results=""
                data.forEach((table,i)=>{
                    results+=`<tr data-id=${table.tableid}>`
                    results+=`<td>${$.number(i+1)}</td>`
                    results+=`<td>${table.tablename}</td>`
                    results+=`<td>${formatDate(table.dateadded)}</td>`
                    results+=`<td>${table.addedbyname}</td>`
                    results+=`<td><a href='#' class='edit'><i class='fal fa-edit fa-lg fa-fw'></i></a></td>`
                    results+=`<td><a href='#' class='delete'><i class='fal fa-trash-alt fa-lg fa-fw'></i></a></td></tr>`
                })
                postablestable.find("tbody").html(results)
            }
        )
    }

    postablestable.on("click",".edit",function(){
        const table=$(this).closest("tr"),
            tableid=table.data("id"),
            tablename=table.find("td").eq(1).text()
        postablenamefield.data("tableid",tableid).val(tablename)
    })

    postablestable.on("click",".delete",function(){
        const table=$(this).closest("tr"),
            tableid=table.data("id"),
            tablename=table.find("td").eq(1).text()
        // confirm with bootbox
        bootbox.dialog({
            // title: "Confirm Item Removal!",
             message: "Are you sure you want to DELETE <strong>"+tablename+"</strong>?",
             buttons: {
                 success: {
                     label: "No, Keep",
                     className: "btn-success",
                     callback: function() {
                         //parent.remove()
                         $('.bootbox').modal('hide');
                     }
                 },
                 danger: {
                     label: "Yes, Remove",
                     className: "btn-danger",
                     callback: function() {
                         //console.log(parent)
                        $.post(
                             "../controllers/posoperations.php",
                            {
                                deletetable:true,
                                tableid
                            },
                            function(data){
                                if(isJSON(data)){
                                    data=JSON.parse(data)
                                    if(data.status=="success"){
                                        posdetailsnotification.html(showAlert("success",`Outlet table saved successfully`))
                                        getpostablesastable()
                                    }
                                }else{
                                    posdetailsnotification.html(showAlert("danger",`Sorry an error occured ${data}`))
                                }
                            }
                        )
                        $('.bootbox').modal('hide');
                     }
                 }
             }
        })
    })

    addpos.on("click",function(){
        // window.location.href="pointofsaledetails.php"
        const posid=idfield.val()!=""?idfield.val():0
        getposcategories(posid)
        posproductcategories.html("")
        posdetailsnotification.html("")
        posdetailsdiv.show()
        postablediv.hide()
        posdetailsmodal.modal("show")
        posdetailstabletogglebutton.prop("checked",true).prop("disbaled",true)
    })

    function getposcategories(posid){
         $.getJSON(
            "../controllers/posoperations.php",
            {
                getposproductcategories:true,
                posid
            },
            (data)=>{
                let results=`<div class='card containergroup mt-2 mb-2'><div class='card-header'><h5>Accessible Product Categories</h5></div><div class='card-body scrollableprivilege'><table class='table table-sm table-borderless'>`
                data.forEach((category,i)=>{
                    results+=`<tr data-categoryid='${category.categoryid}'>
                        <td>
                            <input type='checkbox' id='${category.categoryid}' class='checkoption' ${category.poscategoryid!=null?' checked':''}>&nbsp;&nbsp;${category.categoryname}
                        </td>
                    </tr>`
                }) 
                results+=`</table></div>`
                // Select All placed outside the scrollable area in card-footer
                results+=`<div class='card-footer py-2 bg-white border-top'>
                    <input type='checkbox' id='chkSelectAllCategories'>&nbsp;&nbsp;<label for='chkSelectAllCategories' class='mb-0 font-weight-bold text-secondary' style='cursor:pointer; font-size:0.82rem;'>Select All / Deselect All</label>
                </div></div>`
                posproductcategories.html(results)

                // Sync the Select All checkbox state on load
                syncSelectAllState()

                // When Select All is toggled, check/uncheck all category boxes
                posproductcategories.find("#chkSelectAllCategories").on("change", function(){
                    const checked = $(this).prop("checked")
                    posproductcategories.find(".checkoption").prop("checked", checked)
                })

                // When any individual checkbox changes, sync the Select All state
                posproductcategories.on("change", ".checkoption", function(){
                    syncSelectAllState()
                })
            }
        )
    }

    function syncSelectAllState(){
        const all   = posproductcategories.find(".checkoption")
        const checked = posproductcategories.find(".checkoption:checked")
        const $selectAll = posproductcategories.find("#chkSelectAllCategories")

        if (checked.length === 0) {
            $selectAll.prop("checked", false).prop("indeterminate", false)
        } else if (checked.length === all.length) {
            $selectAll.prop("checked", true).prop("indeterminate", false)
        } else {
            $selectAll.prop("checked", false).prop("indeterminate", true)
        }
    }

    
    saveposbutton.on("click",()=>{
        const posid=posidfield.val(),
            posname=sanitizestring(posnamefield.val()),
            postype=postypefield.val(),
            printkot=printkotfield.val()
            
        let errors="",poscategories=[]

        posproductcategories.find("input").each(function(){
            const checkbox=$(this),
                categoryid=checkbox.prop("id"),
                status=checkbox.prop("checked")
            poscategories.push({"categoryid":categoryid,"status":status?1:0})
        })

        if(posname==""){
            errors="Please provide outlet name"
            posnamefield.focus()
        }else if(postype==""){
            errors="Please select outlet type"
            postypefield.focus
        }else if(printkot==""){
            errors="Please select KOT print status"
            printkotfield.focus()
        }

        if(errors==""){
            poscategories=JSON.stringify(poscategories)
            $.post(
                "../controllers/posoperations.php",
                {
                    savepos:true,
                    id:posid,
                    posname,
                    postype,
                    printkot,
                    poscategories
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            posdetailsnotification.html(showAlert("success",`Outlet was saved successfully`))
                            clearoutletdetailsform()
                            // refresh the POS list
                            getposastable()
                        }else if(data.status=="exists"){
                            posdetailsnotification.html(showAlert("info",`Outlet name already in use`))
                        }
                    }else{
                        posdetailsnotification.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }
                }
            )
        }else{
            posdetailsnotification.html(showAlert("info",errors))
        }
    })

    function clearoutletdetailsform(){
        posidfield.val("0")
        posnamefield.val("")
        postypefield.val(""),
        printkotfield.val("")
        posnamefield.focus()
    }

    goback.on("click",function(){
        window.location.href="main.php"
    })

    function getposastable(){
        $.getJSON(
            "../controllers/getpointsofsale.php",
            function(data){
                var results=''
                for (var i = 0; i < data.length; i++) {
                    // console.log(data[i].id)
                    id=data[i].id
                    results+=`<tr data-id=${id}><td>${parseInt(i+1)}</td>`
                    results+="<td>"+data[i].posname+"</td>"
                    results+="<td>"+titleCase(data[i].postype)+"</td>"
                    results+=`<td>${data[i].printkitchenorders==1?"Yes":"No"}</td>`
                    results+="<td>"+data[i].dateadded+"</td>"
                    results+="<td>"+data[i].addedbyname+"</td>"
                    results+="<td><a href='#' class='edit'><span><i class='fal fa-edit fa-lg fa-fw'></i></span></a></td>"
                    results+="<td><a href='#' data-id='"+id+"' class='delete'><span><i class='fal fa-trash-alt fa-lg fa-fw'></span></i></a></td>" 
                    results+="</tr>"
                } 
                
                // console.log(results)
                // $(results).appendTo(poslist)
                // postable.DataTable()
                makedatatable(postable,results,15)
            }
        )
    }
    

    // listen to delete button click
    postable.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(1).text()
        // console.log(id)
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to DELETE <strong>"+itemname+"</strong>?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success",
                    callback: function() {
                        //parent.remove()
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/posoperations.php",
                            {
                                deletepos:true,
                                id:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The point of sale has been deleted successfully."){
                                    errors="<p class='alert alert-success'>"+data.toString()+"</p>"
                                    parent.remove()
                                }else{
                                    errors="<p class='alert alert-danger'>"+data.toString()+"</p>"
                                }
                                
                                errordiv.html(errors)
                            }
                        )
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })
    

    // listen to edit button
    postable.on("click",".edit",function(){
        const id=$(this).closest("tr").data("id")
        posdetailstabletogglebutton.prop("checked",true).prop("disbaled",false)
        // get outlet details
        $.getJSON(
            "../controllers/posoperations.php",
            {
                getposdetails:true,
                id
            },
            (data)=>{
                data=data[0]
                //    console.log(data[0].posname)
                posidfield.val(data.id)
                posnamefield.val(data.posname)
                postypefield.val(data.postype)
                printkotfield.val(data.printkitchenorders)
                getposcategories(data.id)
                getpostablesastable()
                posdetailsmodal.modal("show")
            }
 
         )
    })
})