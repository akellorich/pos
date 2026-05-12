$(document).ready(function(){
    var posnamefield=$("#posname"),
        idfield=$("#id"),
        savebutton=$("#savepos"),
        errordiv=$("#errors"),
        errors="",
        gotolist=$("#gotolist")

    savebutton.on("click",function(){
        
       const  posname=posnamefield.val(),
            id=Number(idfield.val())
        let poscategories=[]
        posproductcategories.find("input").each(function(){
            const checkbox=$(this),
                categoryid=checkbox.prop("id"),
                status=checkbox.prop("checked")
            poscategories.push({"categoryid":categoryid,"status":status?1:0})
        })

        if(posname==""){
            errordiv.html("")
            errors="Please provide the POS name"
            // $(errors).appendTo(errordiv)
            errordiv.html(showAlert("info",errors))
        }else{
            poscategories=JSON.stringify(poscategories)
            errordiv.html(showAlert("processing","Processing. Please wait ...",1))
            $.post(
                "../controllers/posoperations.php",
                {
                    savepos:"POST",
                    id,
                    posname,
                    poscategories
                },
                function(data){
                    // errordiv.html("")
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            // errors="<p class='alert alert-info'>"+data+"</p>"
                            posnamefield.val("")
                            posnamefield.focus()
                            // $(errors).appendTo(errordiv)
                            errordiv.html(showAlert("success",`The point of sale has been saved successfully`))
                        }else if(data.status=="exists"){
                            errordiv.html(showAlert("info",`Point of sale name exists`))
                        }
                    }else{
                        errordiv.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }
                }
            )
        }
    })

    gotolist.on("click",function(){
        window.location.href="poslist.php"
    })

    // check if on editt mode
    // console.log(idfield.val())

    if(parseInt(idfield.val())>0){
        // get the pos details and show them on the screen
        $.getJSON(
           "../controllers/posoperations.php",
           {
               getposdetails:true,
               id:idfield.val()
           },
           function(data){
            //    console.log(data[0].posname)
               posnamefield.val(data[0].posname)
           }

        )
    }

    const posid=idfield.val()!=""?idfield.val():0,
        posproductcategories=$("#posproductcategories")
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
            results+="</table> </div> </div>"
            posproductcategories.html(results)
        }
    )
})