$(document).ready(function(){
    const addbutton=$("#addcategory, #addcategory_fab"),
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
            var results=''
            for (var i = 0; i < data.length; i++) {
                var addedby = data[i].addedbyname || "System";
                results+="<tr><td>"+parseInt(i+1)+"</td>"
                results+="<td>"+data[i].categoryname+"</td>"
                results+="<td>"+data[i].prefix+"</td>"
                results+="<td>"+data[i].currentno+"</td>"
                results+="<td class='d-none d-md-table-cell'>"+data[i].dateadded+"</td>"
                results+="<td class='d-none d-lg-table-cell'>"+addedby+"</td>"
                 results+="<td class='text-right' style='padding-right: 20px;'>"
                 results+="<div class='dropdown'>"
                  results+="<a class='text-secondary px-2 dropdown-toggle dropdown-toggle-nocaret' href='#' role='button' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false' style='cursor: pointer; display: inline-block; padding: 4px 8px;'>"
                  results+="<i class='fal fa-ellipsis-v' style='font-size: 1.3rem;'></i>"
                  results+="</a>"
                 results+="<div class='dropdown-menu dropdown-menu-right shadow-sm'>"
                 results+="<a class='dropdown-item py-1' href='categorydetails.php?id="+data[i].categoryid+"' style='font-size:0.8rem;'><i class='fal fa-edit mr-2 text-primary' style='font-size: 0.78rem;'></i>Edit</a>"
                 results+="<a class='dropdown-item delete py-1' href='#' data-id='"+data[i].categoryid+"' style='font-size:0.8rem;'><i class='fal fa-trash-alt mr-2 text-danger' style='font-size: 0.78rem;'></i>Delete</a>"
                 results+="</div>"
                 results+="</div>"
                 results+="</td>"
                 results+="</tr>"
            } 
           
            $(results).appendTo(categorylist)
            categorytable.DataTable({ 
                dom: '<"dt-buttons-container mb-3"B><"dt-controls-container d-flex flex-column flex-sm-row justify-content-between align-items-sm-center mb-3"lf>rtip',
                buttons: [
                    {
                        extend: 'csvHtml5',
                        text: '<i class="fal fa-file-csv mr-1"></i> CSV',
                        className: 'btn btn-xs btn-primary mr-2'
                    },
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fal fa-file-excel mr-1"></i> Excel',
                        className: 'btn btn-xs btn-success mr-2'
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="fal fa-file-pdf mr-1"></i> PDF',
                        className: 'btn btn-xs btn-danger mr-2'
                    },
                    {
                        extend: 'print',
                        text: '<i class="fal fa-print mr-1"></i> Print',
                        className: 'btn btn-xs btn-info'
                    }
                ]
            })
        }
    )
    // listen to delete click event
    categorylist.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).closest("tr");
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