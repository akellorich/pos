$(document).ready(function(){

    const itemcategoryfield=$("#itemcategory")
    const unitofmeasurefield=$("#unitofmeasure")
    const generateitemcodecontrol=$("#generatecode")
    const itemcodefield=$("#itemcode")
    const materiallist=$("#materiallist")
    const itemnamefield=$("#itemname")
    const unitpricefield=$("#unitprice")
    const itemnotifications=$("#itemnotifications")
    const savematerialbutton=$("#savematerial")
    const physicalproductfield=$("#physicalproduct")
    const materialidfield=$("#materialid")
    const inputcontrol=$("input")
    const selectcontrol=$("select")
    const checkcontrol=$(":checkbox")
    const clearbutton=$("#clearbutton")

    inputcontrol.on("input",()=>{
        itemnotifications.html("")
    })

    selectcontrol.on("change",()=>{
        inputcontrol.trigger("input")
    })

    savematerialbutton.on("click",()=>{
        const materialid=materialidfield.val()
        const itemcode=itemcodefield.val()
        const materialname=itemnamefield.val()
        const uom=unitofmeasurefield.val()
        const categoryid=itemcategoryfield.val()
        const unitprice=unitpricefield.val()
        const physicalproduct=physicalproductfield.prop("checked")?1:0
        const generateitemcode=generateitemcodecontrol.prop("checked")?1:0
        let errors='',
            notifications=''
        // check for blank fields
        if(categoryid==""){
            errors="Please select category first"
            itemcategoryfield.focus()
        }else if(materialname==""){
            errors="Please provide item name first"
            itemnamefield.focus()
        }else if(uom==""){
            errors="Please select unit of measure first"
            unitofmeasurefield.focus()
        }else if(Number(unitprice)<0){
            errors="Please enter correct unit price first"
            unitofmeasurefield.focus()
        }

        if(errors==""){
            itemnotifications.html(showAlert("processing","Processing. Please wait ...",1)) 
            $.post(
                "../controllers/rawmaterialsoperations.php",
                {
                    saverawmaterial:true,
                    materialid,
                    materialname,
                    categoryid,
                    uom,
                    unitprice,
                    itemcode,
                    physicalproduct,
                    generateitemcode
                },
                (data)=>{
                    if(data=="success"){
                        notifications=`The raw material has been saved successfully.`
                        itemnotifications.html(showAlert("success",notifications)) 
                        getrawmaterialslist()
                        clearbutton.on("click")
                    }else if(data=="exists"){
                        notifications=`The raw material already exists in the system.`
                        itemnotifications.html(showAlert("info",notifications)) 
                    }else{
                        notifications=`Sorry an error occured ${data}`
                        itemnotifications.html(showAlert("danger",notifications,1)) 
                    }
                }
            )
        }else{
            itemnotifications.html(showAlert("info",errors))
        }
    })

    getrawmaterialcategories(itemcategoryfield,'choose')
    getunitsofmeasure(unitofmeasurefield,'choose')
    getrawmaterialslist()
    
    generateitemcodecontrol.on("click",function(){
        state=$(this).prop("checked")
        itemcodefield.prop("disabled",state)
    })

    function getrawmaterialslist(){
        $.getJSON(
            "../controllers/rawmaterialsoperations.php",
            {
                getrawmaterials:true
            },
            (data)=>{
                let results=''
                data.forEach((material)=>{
                    results+=`<option value='${material.materialid}'>${material.materialname}</option>`
                })
                materiallist.html(results)
            }
        )
    }

    function clearform(){
        // inputcontrol.val("")
        itemcodefield.val()
        itemnamefield.val()
        unitpricefield.val()
        selectcontrol.val("")
        checkcontrol.prop("checked".false)
    }

    materiallist.on("click","option",function(){
        const materialid=$(this).val()
        $.getJSON(
            "../controllers/rawmaterialsoperations.php",
            {
                getrawmaterialdetails:true,
                materialid
            },
            (data)=>{
                data=data[0]
                materialidfield.val(data.materialid)
                itemcodefield.val(data.itemcode)
                itemnamefield.val(data.materialname)
                unitofmeasurefield.val(data.uom)
                itemcategoryfield.val(data.categoryid)
                unitpricefield.val(data.unitprice)
                physicalproductfield.prop("checked",data.physicalproduct==1?1:0)
                generateitemcodecontrol.prop("checked",0)
            }
        )
    })

    clearbutton.on("click",()=>{
        materialidfield.val("0")
        itemcodefield.val("")
        itemnamefield.val("")
        unitofmeasurefield.val("")
        itemcategoryfield.val("")
        unitpricefield.val("")
        physicalproductfield.prop("checked",0)
        generateitemcodecontrol.prop("checked",0)
        itemcategoryfield.focus()
    })
})