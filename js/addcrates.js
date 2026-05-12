$(document).ready(function(){
    var quantityfield=$("#quantity"),
        unitpricefield=$("#unitprice"),
        narrationfield=$("#narration"),
        referencefield=$("#reference"),
        errordiv=$("#errors"),
        savebutton=$("#save"),
        productid=0
    // get crate inventory set parameters
    $.getJSON(
        "../controllers/settingoperations.php",
        {
            getcrateadditionparameters:true
        },
        function(data){
            if(data.length>0){
                productid=data[0].productid,
                unitpricefield.val(data[0].price)
            }else{
                // display error that no parameter set for crate addition
                errors="<p class='alert alert-info'><i class='fas fa-info fa-lg fa-fw'></i></span> Crate inventory parameters not set</p>"
                errordiv.html(errors)
                // disable the save button
                savebutton.prop("disabled",true)
            }
        }
    )

    // listen to add button
    savebutton.on("click",function(){
        var quantity=quantityfield.val(),
            unitprice=unitpricefield.val(),
            narration=narrationfield.val(),
            reference=referencefield.val(),
            errors=""
        // check for blank fields
        if(quantity==""){
            errors="Please provide <strong>Quantity</strong> first."
            quantityfield.focus()
        }else if(narration==""){
            errors="Please provide <strong>Narration</strong> first."
            narrationfield.focus()
        }else if(reference==""){
            errors="Please provide <strong>Reference</strong> first."
            referencefield.focus()
        }
        if(errors==""){
            $.post(
                "../controllers/settingoperations.php",
                {
                    savecrateaddition:true,
                    productid:productid,
                    quantity:quantity,
                    unitprice:unitprice,
                    narration:narration,
                    reference:reference
                },
                function(data){
                    data=$.trim(data)
                    if(data=="exists"){
                        errors="<p class='alert alert-info'><i class='fas fa-exclamation-circle fa-lg fa-fw'></i></span> <strong>Reference Number</strong> already in use.</p>"
                        errordiv.html(errors)
                        reference.focus()
                    }else if(data=="success"){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i></span> Crates added successfully into the system</p>"
                        errordiv.html(errors)
                        // clear the form
                        clearForm()
                    }else{
                        errors="<p class='alert alert-danger'><i class='fas fa-exclamation-circle fa-lg fa-fw'></i></span> Sorry an error occured:<br/>"+data+"</p>"
                        errordiv.html(errors)
                    }
                }
            )
        }else{
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> "+errors+"</p>"
            errordiv.html(errors)
        }
    })

    function clearForm(){
        quantityfield.val("")
        narrationfield.val("")
        referencefield.val("")
        quantityfield.focus()
    }
})