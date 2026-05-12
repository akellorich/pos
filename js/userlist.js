$(document).ready(function(){
    
    adduser=$("#adduser"),
    goback=$("#goback"),
    userlist=$("#userlist"),
    usertable=$("#usertable"),
    errordiv=$("#errors")

    adduser.on("click",function(){
        window.location.href="userdetails.php"
    })

    goback.on("click",function(){
        window.location.href="main.php"
    })

    $.getJSON(
        "../controllers/getusers.php",
        function(data){
            var results=''
            for (var i = 0; i < data.length; i++) {
                results+="<tr><td>"+parseInt(i+1)+"</td>"
                results+="<td>"+data[i].username+"</td>"
                results+="<td>"+data[i].firstname+" "+data[i].middlename+" "+data[i].lastname+"</td>"
                results+="<td>"+data[i].mobile+"</td>"
                results+="<td>"+data[i].email+"</td>"
                results+="<td>"+data[i].dateadded+"</td>"
                results+="<td>"+data[i].addedbyname+"</td>"
                results+="<td><a href='userdetails.php?userid="+data[i].id+"'><span><i class='fas fa-edit fa-sm' ></i></span></a></td>"
                results+="<td><a href='javascript void(0)' class='delete' data-id='"+data[i].id+"'><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>" 
                results+="</tr>"
            } 
            
            // console.log(results)
            $(results).appendTo(userlist)
            usertable.DataTable()
        }
    )

    $("#usertable").on( 'click', 'tbody td', function () {
        usertable.cell( this ).edit( 'bubble');
    } );

    // listen to delete button click event
    userlist.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(2).text()
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
                            "../controllers/useroperations.php",
                            {
                                deleteuser:true,
                                userid:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The user has been deleted successfully."){
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

