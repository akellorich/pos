$(document).ready(function(){
    var categoryidfield= $("#id"),
        categorynamefield=$("#categoryname"),
        savebutton=$("#savecategory"),
        errordiv=$("#errors"),
        errors="",
        backtolist=$("#backtolist")

        savebutton.on("click", function(){
            // check for blank field
            if(categorynamefield.val!=""){
                $.post(
                    "../controllers/savecategory.php",
                    {
                        id:categoryidfield.val(),
                        categoryname:categorynamefield.val(),
                        saveactegory:"POST"
                    },
                    function(data){
                        if($.trim(data.toString())=="The category has been saved successfully."){
                            errors="<p class='alert alert-success'>"+data.toString()+"</p>"
                        }else{
                            errors="<p class='alert alert-danger'>"+data.toString()+"</p>"
                        }
    
                        errordiv.html(errors)
                       // $(errors).appendTo(errordiv)
                    }
                )
            }else{

            }
        })

        backtolist.on("click",function(){
            window.location.href="categorylist.php"
        })

        // check if on edit mode
        if(categoryidfield.val()>0){
            // get catregory details
            $.getJSON(
                "../controllers/categoryoperations.php",
                {
                    getcategorydetails:true,
                    id:categoryidfield.val()
                },
                function(data){
                    categorynamefield.val(data[0].categoryname)
                }
            )
        }

})