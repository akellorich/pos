$(document).ready(function(){
    const addbutton=$("#addcategory"),
        backbutton=$("#goback"),
        categorylist=$("#categorylist"),
        categorytable=$("#categorytable"),
        categorydetailsmodal=$("#categorydetailsmodal"),
        categorydetailserrors=$("#categorydetailserrors"),
        categorynamefield=$("#categoryname"),
        savecategorybutton=$("#savecategory"),
        categoryidfield=$("#categoryid"),
        prefixfield=$("#prefix"),
        currentnofield=$("#currentno"),
        inputfield=$("input"),
        selectfield=$("select")

    let errordiv=$("#errors")
    
    inputfield.on("input",()=>{
        categorydetailserrors.html("")
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    addbutton.on("click",function(){
        //window.location.href="categorydetails.php"
        categorydetailsmodal.modal("show")
    })

    savecategorybutton.on("click",function(){
        // console.log("Clicked")
        const categoryname=categorynamefield.val(),
            categoryid=categoryidfield.val(),
            prefix=prefixfield.val(),
            currentno=currentnofield.val()

        let errors=""
        // check for blank fields
        if(categoryname==""){
            errors="Please enter category name"
            // categorydetailserrors.html(showAlert("info",errors))
            categorynamefield.focus()
        }else if(prefix==""){
            errors="Please provide item numbering prefix"
            prefixfield.focus()
        }else if(currentno==""){
            errors="Please provide item numbering current number"
            currentnofield.focus()
        }

        if(errors==""){
            // save the category
            $.post(
                "../controllers/categoryoperations.php",
                {
                    savecategory:true,
                    categoryid,
                    categoryname,
                    prefix,
                    currentno
                },
                function(data){
                    //data=$.trim(data)
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            errors="The category has been saved successfully"
                            categorynamefield.val("")
                            categoryidfield.val("0")
                            categorynamefield.focus() 
                            categorydetailserrors.html(showAlert("success",errors))
                            // refresh the categories list
                        }else if(data.status=="exists"){
                            if(data.category=="categoryname"){
                                errors="The category name is already in use."
                                categorynamefield.focus()
                            }else if(data.category=="prefix"){
                                errors="The category prefix is already in use."
                                prefixfield.focus()
                            }
                            categorydetailserrors.html(showAlert("info",errors))
                        }
                    }
                    else{
                        errors=`Sorry an error occured ${data}`
                        categorydetailserrors.html(showAlert("danger",errors))
                    }
                }
            )
        }else{
            // display errors
            categorydetailserrors.html(showAlert("info",errors))
        }
    })

    backbutton.on("click",function(){
        window.location.href="main.php"
    })

    $.getJSON(
        "../controllers/getcategories.php",
        function(data){
            //console.log(data)
            var results=''
            for (var i = 0; i < data.length; i++) {
                // data[i].categoryid
                results+="<tr><td>"+parseInt(i+1)+"</td>"
                results+="<td>"+data[i].categoryname+"</td>"
                results+="<td>"+data[i].prefix+"</td>"
                results+="<td>"+data[i].currentno+"</td>"
                results+="<td>"+data[i].dateadded+"</td>"
                results+="<td>"+data[i].addedbyname+"</td>"
                results+="<td><a href='categorydetails.php?id="+data[i].categoryid+"'><span><i class='fas fa-edit fa-sm' ></i></span></a></td>"
                results+="<td><a href='javascript void(0)' class='delete' data-id='"+data[i].categoryid+"'><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>" 
                results+="</tr>"
            } 
           
           // console.log(results)
            $(results).appendTo(categorylist)
            categorytable.DataTable({ 
                dom: 'Bfrtip',
                buttons: [
                'copy', 'csv', 'excel', 'pdf', 'print'
            ]})
        }
    )
    // listen to delete click event
    categorylist.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(1).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to DELETE <strong>"+itemname+"</strong>?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success",
                    callback: function() {
                        // parent.remove()
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/categoryoperations.php",
                            {
                                deletecategory:true,
                                categoryid:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The category has been deleted successfully."){
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
})