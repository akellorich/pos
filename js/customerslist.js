$(document).ready(function(){
    var goback=$("#goback"),
    addcustomerbutton=$("#addcustomer"),
    customerlist=$("#customerlist")
    customertable=$("#customertable")
    
    goback.on("click",function(){
        window.location.href="main.php"
    })

    addcustomerbutton.on("click",function(){
        window.location.href="customerdetails.php"
    })

    $.getJSON(
        "../controllers/getcustomers.php",
        function(data){
            //console.log(data)
            var results=''
            for (var i = 0; i < data.length; i++) {
                results+="<tr><td>"+data[i].categoryname+"</td>"
                results+="<td>"+data[i].customername+"</td>"
                results+="<td>"+data[i].physicaladdress+"</td>"
                results+="<td>"+data[i].postaladdress+"</td>"
                results+="<td>"+data[i].mobile+"</td>"
                results+="<td>"+data[i].email+"</td>"
                results+="<td>"+data[i].dateadded+"</td>"
                results+="<td>"+data[i].addedbyname+"</td>"
                results+="<td><a href='customerdetails.php?customerid="+data[i].customerid+"'><span><i class='fas fa-edit fa-sm' ></i></span></a></td>"
                results+="<td><a href='javascript void(0)' class='delete' data-id='"+data[i].customerid+"'><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>" 
                results+="</tr>"
            } 
            
            // console.log(results)
            $(results).appendTo(customerlist)
            customertable.DataTable()
        }
    )

    // listen to delete click event
    customerlist.on("click",".delete",function(e){
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
                            "../controllers/customeroperations.php",
                            {
                                deletecustomer:true,
                                customerid:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The customer has been deleted successfully."){
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