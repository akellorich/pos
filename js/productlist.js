$(document).ready(function(){
    addproduct=$("#addproduct"),
    goback=$("#goback"),
    productlist=$("#productlist"),
    productstable=$("#productstable"),
    errordiv=$("#errors")

    $.getJSON(
        "../controllers/productoperations.php",
        {
            filterproductbyname:true,
            name:''
        },
        function(data){
            //console.log(data)
            var results=''
            for (var i = 0; i < data.length; i++) {
                results+=`<tr><td>${parseInt(i+1)}</td>`
                results+=`<td>${data[i].categoryname}</td>`
                results+=`<td>${data[i].itemcode}</td>`
                results+=`<td>${data[i].itemname}</td>`
                results+=`<td>${$.number(data[i].buyingprice)}</td>`
                results+=`<td>${$.number(data[i].sellingprice,2)}</td>`
                results+=`<td>${$.number(data[i].wholesaleprice,2)}</td>`
                results+=`<td>${data[i].dateadded}</td>`
                results+=`<td>${data[i].addedbyname}</td>`
                results+=`<td><a href='productdetails.php?itemcode=${data[i].itemcode}'><span><i class='fas fa-edit fa-sm' ></i></span></a></td>`
                results+=`<td><a href='javascript void(0)' class='delete' data-id=${data[i].productid}><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td> `
                results+=`</tr>`
            } 
            
            makedatatable(productstable,results,15)
            // console.log(results)
            // $(results).appendTo(productlist)

            // productstable.DataTable({
            //     dom: 'Bfrtip',
            //     lengthChange: true,
            //     buttons: [
            //         'pageLength','excel', 'pdf', 'print'
            //     ]
            // })
            // paginate the table 
            //productstable.pageMe({pagerSelector:'#productslist',showPrevNext:true,hidePageNumbers:false,perPage:15})
        }
    )

    addproduct.on("click",function(){
        window.location.href="productdetails.php"
    })

    goback.on("click",function(){
        window.location.href="main.php"
    })
    
    // listen to delete button
    productlist.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(3).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to DELETE <strong>"+itemname+"</strong>?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success btn-sm",
                    callback: function() {
                        // parent.remove()
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger btn-sm",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/productoperations.php",
                            {
                                deleteproduct:true,
                                productid:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The product has been deleted successfully."){
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