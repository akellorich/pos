$(document).ready(()=>{

    const addnewvehiclebutton=$("#addnewvehicle"),
        vehicledetailsmodal=$("#vehicledetailsmodal"),
        fueltypelist=$("#fueltype"),
        bodytypelist=$("#bodytype"),
        regnofield=$("#regno"),
        engineratingfield=$("#enginerating"),
        savevehiclebutton=$("#savevehicle"),
        vehicleidfield=$("#vehicleid"),
        savevehicleerrordiv=$("#savevehicleerrors"),
        vehicleslist=$("#vehicleslist"),
        inputfields=$("input"),
        selectfields=$("select")

    getfueltype()
    getbodytypes()
    getexistingvehicles()

    addnewvehiclebutton.on("click",()=>{
        clearvehicleform()
        vehicledetailsmodal.modal("show")
        regnofield.focus()
    })

    function getfueltype(){
        let dfd= new $.Deferred()
        $.getJSON(
            "../controllers/fleetoperations.php",
            {
                getfueltypes:true
            },
            (data)=>{
                let results=`<option value=''>&lt;Choose&gt;</option>`
                data.forEach(({id, description})=>{
                    results+=`<option value='${id}'>${description}</option>`
                })
                fueltypelist.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function getbodytypes(){
        let dfd= new $.Deferred()
        $.getJSON(
            "../controllers/fleetoperations.php",
            {
                getbodytypes:true
            },
            (data)=>{
                let results=`<option value=''>&lt;Choose&gt;</option>`
                data.forEach(({id, description})=>{
                    results+=`<option value='${id}'>${description}</option>`
                })
                bodytypelist.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    // save the vehicle
    savevehiclebutton.on("click",()=>{
        const vehicleid=vehicleidfield.val(), 
            bodytypeid=bodytypelist.val(), 
            fueltypeid=fueltypelist.val(), 
            regno=regnofield.val(), 
            enginerating=engineratingfield.val()
        let errors="",
            notifications=""
        // check for blank fields
        if(regno==""){
            errors="Please enter <strong>Registration Number</strong>"
            regnofield.focus()
        }else if(bodytypeid==""){
            errors="Please select <strong>Body Type</strong>"
            bodytypelist.focus()
        }else if(fueltypeid==""){
            errors="Please select <strong>Fuel Type</strong>"
            fueltypelist.focus()
        }else if(enginerating==""|| Number(enginerating)==0){
            errors="Please enter correct <strong>Engine Rating</strong>"
        }

        if(errors==""){
            $.post(
                "../controllers/fleetoperations.php",
                {
                    savevehicle:true,
                    vehicleid,
                    regno,
                    bodytypeid,
                    fueltypeid,
                    enginerating
                },
                (data)=>{
                    data=data.trim()
                    if(data=="success"){
                        notifications="The vehicle has been saved successfully."
                        savevehicleerrordiv.html(showAlert("success",notifications))
                        // clear the form
                        clearvehicleform()
                        regnofield.focus()
                        // refresh the list
                        getexistingvehicles()
                    }else if(data=="exists"){
                        notifications="The registration number is already in use."
                        savevehicleerrordiv.html(showAlert("info",notifications))
                    }else{
                        notifications=`Sorry an error occured.${data}`
                        savevehicleerrordiv.html(showAlert("danger",notifications))
                    }
                }
            )
        }else{
            savevehicleerrordiv.html(showAlert("info",errors))
        }
    })

    function clearvehicleform(){
        vehicleidfield.val("0")
        bodytypelist.val("")
        fueltypelist.val("")
        regnofield.val("")
        engineratingfield.val("")
    }

    function getexistingvehicles(){
        $.getJSON(
            "../controllers/fleetoperations.php",
            {
                getvehicles:true
            },
            (data)=>{
                let results="",
                    i=1
                if(data.length>0){
                    data.forEach((vehicle)=>{
                        results+=`<tr data-regno='${vehicle.regno}' data-bodytypeid='${vehicle.bodytypeid}' data-fueltypeid='${vehicle.fueltypeid}' data-enginerating='${vehicle.enginerating}'><td>${i}</td>`
                        results+=`<td>${vehicle.regno}</td>`
                        results+=`<td>${vehicle.bodytype}</td>`
                        results+=`<td>${vehicle.fueltype}</td>`
                        results+=`<td>${vehicle.enginerating}</td>`
                        results+=`<td>${vehicle.addedbyname}</td>`
                        results+=`<td><a href='javascript void(0)' class='editdata' data-id='${vehicle.vehicleid}'><span><i class='fas fa-edit fa-sm'></i></span></a></td>`
                        results+=`<td><a href='javascript void(0)' class='deletedata' data-id='${vehicle.vehicleid}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>`
                        i++
                    })
                }else{
                    results=`<tr><td colspan='8'>Sorry there are currently no vehicles in the system</td></tr>`
                }
                
                vehicleslist.find("tbody").html(results)
            }
        )
    }

    // listen to edit vehicle
    vehicleslist.on("click",".editdata", function(e){
        e.preventDefault()
        const $this=$(this)
            vehicleid=$this.attr("data-id"),
            parent=$this.parent("td").parent("tr"),
            bodytypeid=parent.attr("data-bodytypeid"),
            regno=parent.attr("data-regno"),
            fueltypeid=parent.attr("data-fueltypeid"),
            enginerating=parent.attr("data-enginerating")
        // populate the fields on the modal  
        getfueltype().done(()=>{
            getbodytypes().done(()=>{
                vehicleidfield.val(vehicleid)
                bodytypelist.val(bodytypeid)
                fueltypelist.val(fueltypeid)
                regnofield.val(regno)
                engineratingfield.val(enginerating)
            })
        })
        // show the modal
        vehicledetailsmodal.modal("show")
        // hide any errors or notifications previously shown
        savevehicleerrordiv.html("")
    })

    // hide errors when typing details for vehicle
    inputfields.on("input",()=>{
        savevehicleerrordiv.html("")
    })

    selectfields.on("change",()=>{
        savevehicleerrordiv.html("")
    })
})
