$(document).ready(function(){
    const productslist=$("#product"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        searchbutton=$("#search"),
        alldates=$("#alldates"),
        errordiv=$("#errors"),
        report=$("#report"),
        productsalesreport=$("#productsalesreport")

    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    alldates.on("click",function(){
        if(alldates.prop("disabled")){
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }
    })
    
    // get all products
    $.getJSON(
        "../controllers/productoperations.php",
        {
            filterproductbyname:"get",
            name:''
        },
        function(data){
            var results="<option value=''>&lt;All Products &gt;</option>"
            for( var i=0;i<data.length;i++){
                results+="<option value='"+data[i].itemname+"'>"+data[i].itemname+"</option>"
            }
            $(results).appendTo(productslist)
        }
    )

    searchbutton.on("click",function(){
        var errors='',
            product=productslist.val()

        if(alldates.prop("checked")){
            startdate='01-Jan-2019'
            enddate='31-Dec-2100'
        }else{
            if(startdatefield.val()==""){
                errors="<p class='alert alert-danger'>Please enter start date</p>"
                errordiv.html(errors)
            }else if(enddatefield.val()==""){
                errors="<p class='alert alert-danger'>Please enter end date</p>"
                errordiv.html(errors)
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        }
       
       
        // check for blank fields
        if(errors==""){
            errordiv.html(showAlert("processing","Processing. Please wait ...",1))
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getproductsalessummary:"get",
                    startdate:startdate,
                    enddate:enddate,
                    product:product
                },
                function(data){
                   // console.log(json2table(data,"table table-striped"))    
                    if(data.length>0){
                        data.pop()
                        json2table(productsalesreport,data)  
                    }else{
                        report.html("Sorry, no data meeting filter criteria available")
                    }
                   
                   errordiv.html("")      
                }
            )
        }
    })
})