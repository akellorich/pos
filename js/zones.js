$(document).ready(()=>{

    const zonedetailsmodal=$("#zonedetailsmodal")
    const addnewzonecontrol=$("#addzone")
    const zonecategorycontrol=$("#zonecategory")
    const parentzonegroup=$("#zoneparentgroup")
    const parentzonecontrol=$("#parentzone")
    const savezonecontrol=$("#savezone")
    const zoneidcontrol=$("#zoneid")
    const zonenamecontrol=$("#zonename")
    const zonenotifications=$("#zonenotifications")
    const inputfields=$("input")
    const selectfield=$("select")
    const zoneslist=$("#zoneslist")

    getparentzones()
    getzones()


    inputfields.on("input",()=>{
        zonenotifications.html("")
    })

    selectfield.on("change",()=>{
        inputfields.trigger("input")
    })

    addnewzonecontrol.click(()=>{
        zonedetailsmodal.modal("show")
    })

    zonecategorycontrol.change(function(){
        if($(this).val()=="subzone"){
            parentzonegroup.show()
        }else{
            parentzonegroup.hide()
        }
    })

    // get parent zones
    function getparentzones(){
        $.getJSON(
            "../controllers/zoneoperations.php",
            {
                getparentzones:true
            },
            (data)=>{
                let results=`<option value=''>&lt;Choose&gt;</option>`
                data.forEach((zone)=>{
                    results+=`<option value='${zone.id}'>${zone.zonename}</option>`
                })
                parentzonecontrol.html(results)
            }
        )
    }

    savezonecontrol.click(()=>{
        console.log("Clicked")
        const id=zoneidcontrol.val()
        const zonename=zonenamecontrol.val() 
        const category=zonecategorycontrol.val()
        const parent=category=='mainzone'?0:parentzonecontrol.val()
        
        let errors=''
        let notifications=''

        if(category==""){
            errors="Please select zone category"
            zonecategorycontrol.focus()
        }else if(category=='subzone' && parent==''){
            errors="Please select sub zone parent"
            parentzonecontrol.focus()
        }else if(zonename==""){
            errors="Please provide zone name"
            zonenamecontrol.focus()
        }

        if(errors==""){
            zonenotifications.html(showAlert("processing","Processing. Please wait ..."))
            $.post(
                "../controllers/zoneoperations.php",
                {
                    savezone:true,
                    id,
                    zonename,
                    parent
                },
                (data)=>{
                    if(data=="success"){
                        notifications=`The zone was saved successfully`
                        zonenotifications.html(showAlert("success",notifications))
                        // refresh the list
                        getzones()
                        // clear fields
                        zoneidcontrol.val("0")
                        parentzonecontrol.val("")
                        zonenamecontrol.val("")
                        zonecategorycontrol.val("")
                    }else if(data=="exists"){
                        notifications=`Sorry <strong> ${zonename}</strong> already exists in the system`
                        zonenotifications.html(showAlert("info",notifications))
                    }else{
                        notifications=`Sorry an error occured ${data}`
                        zonenotifications.html(showAlert("danger",notifications,1))
                    }
                }
            )
        }else{
            zonenotifications.html(showAlert("info",errors))
        }
    })

    function getzones(){
        // get parent zones
        getparentzonesfortable().done(()=>{
            // get sub zones
            $.getJSON(
                "../controllers/zoneoperations.php",
                {
                    getsubzones:true
                },
                (data)=>{
                    data.forEach((subzone)=>{
                        let parentid=subzone.parent
                        let subzonedetails=`<tr data-id='${subzone.id}'><td>&nbsp;</td>`
                        subzonedetails+=`<td>${subzone.zonename}</td>`
                        subzonedetails+=`<td>${subzone.customers}</td>`
                        subzonedetails+=`<td>${subzone.dateadded}</td>`
                        subzonedetails+=`<td>${subzone.addedbyname}</td>`
                        // exit and delete buttons
                        subzonedetails+="<td><a href='javascript void(0)' class='edit'><span><i class='fal fa-edit fa-lg mt-1'></i></span></a></td>"
                        subzonedetails+="<td><a href='javascript void(0)' class='delete'><span><i class='fal fa-trash-alt fa-lg mt-1'></i></span></a></td></tr>"
                        console.log(subzonedetails)
                        zoneslist.find(`tr[data-id='${parentid}']`).after(subzonedetails)
                    })
                }
            )
        }) 
    }

    function getparentzonesfortable(){
        dfd=$.Deferred()
        $.getJSON(
            "../controllers/zoneoperations.php",
            {
                getparentzones:true
            },
            (data)=>{
                let results=``
                data.forEach((zone,index)=>{
                    results+=`<tr class='font-weight-bold' data-id='${zone.id}'><td>${Number(index+1)}</td>`
                    results+=`<td>${zone.zonename}</td>`
                    results+=`<td>${zone.customers}</td>`
                    results+=`<td>${zone.dateadded}</td>`
                    results+=`<td>${zone.addedbyname}</td>`
                    // exit and delete buttons
                    results+="<td><a href='javascript void(0)' class='edit'><span><i class='fal fa-edit fa-lg mt-1'></i></span></a></td>"
                    results+="<td><a href='javascript void(0)' class='delete'><span><i class='fal fa-trash-alt fa-lg mt-1'></i></span></a></td></tr>"
                })
                zoneslist.find("tbody").html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }
})