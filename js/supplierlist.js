$(document).ready(function(){
    var goback=$("#goback"),
    addsupplierbutton=$("#addsupplier"),
    supplierlist=$("#supplierlist"),
    suppliertable=$("#suppliertable"),
    errordiv=$("#errors")
    
    goback.on("click",function(){
        window.location.href="main.php"
    })

    addsupplierbutton.on("click",function(){
        window.location.href="supplierdetails.php"
    })

    $.getJSON(
        "../controllers/getsuppliers.php",
        function(data){
            //console.log(data)
            var results=''
            for (var i = 0; i < data.length; i++) {
                results+="<tr><td>"+parseInt(i+1)+"</td>"
                results+="<td>"+data[i].suppliername+"</td>"
                results+="<td>"+data[i].physicaladdress+"</td>"
                results+="<td>"+data[i].postaladdress+"</td>"
                results+="<td>"+data[i].mobile+"</td>"
                results+="<td>"+data[i].email+"</td>"
                results+="<td>"+data[i].dateadded+"</td>"
                results+="<td>"+data[i].addedbyname+"</td>"
                results+="<td><a href='supplierdetails.php?supplierid="+data[i].supplierid+"'><span><i class='fas fa-edit fa-sm' ></i></span></a></td>"
                results+="<td><a href='javascript void(0)' class='delete' data-id="+data[i].supplierid+"><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>" 
                results+="</tr>"
            } 
            
            // console.log(results)
            $(results).appendTo(supplierlist)
            suppliertable.DataTable()
        }
    )
    
    // listen to delete click event
    supplierlist.on("click",".delete",function(e){
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
                            "../controllers/supplieroperations.php",
                            {
                                deletesupplier:true,
                                supplierid:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The supplier has been deleted successfully."){
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