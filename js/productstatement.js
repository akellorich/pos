$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        itemsfield=$("#product"),
        alldates=$("#alldates"),
        filterbutton=$("#search"),
        errordiv=$("#errors"),
        report=$("#report")
    // add datepickers
    
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
    getallproducts()

    // filter product statement
    filterbutton.on("click",function(){
        var startdate=startdatefield.val(),
            enddate=enddatefield.val(),
            itemcode=itemsfield.val(),
            errors=""
        // check for blank fields
        if(itemcode==""){
            errors="Please select the item for which to generate a statement"
            itemsfield.focus()
        }else {
            if(!alldates.prop("checked")){
                if(startdate==""){
                    errors="Please select the start date"
                    startdatefield.focus()
                }else if(enddate==""){
                    errors="Please select the end date"
                    enddatefield.focus()
                }
            }else{
                startdate="01-Jan-2021"
                enddate='31-Dec-2100'
            }
        }

        if(errors==""){
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    getproductstatement:true,
                    itemcode,
                    startdate,
                    enddate
                },
                function(data){
                    let runningbalance=Number(data[0].openingbalance), results=""
                    for(var i=0;i<data.length;i++){
                        results+=`<tr><td>${Number(i+1)}</td>`
                        results+=`<td>${data[i].date}</td>`
                        results+=`<td>${data[i].description}</td>`
                        if(i==0){
                            results+=`<td>&nbsp;</td>`
                            results+=`<td>&nbsp;</td>`
                            results+=`<td>&nbsp;</td>`
                        }else{
                            results+=`<td>${data[i].reference}</td>`
                            results+=`<td>${Number(data[i].stockin)}</td>`
                            results+=`<td>${Number(data[i].stockout)}</td>`
                        }
                        runningbalance+=Number(data[i].stockin)-Number(data[i].stockout)
                        console.log(runningbalance)
                        results+=`<td>${$.number(runningbalance)}</td></tr>`
                    }
                    report.find("tbody").html(results)
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })
    function getallproducts(){
        // get all products
        $.getJSON(
            "../controllers/productoperations.php",
            {
                filterproductbyname:true,
                name:''
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for( var i=0;i<data.length;i++){
                    results+="<option value='"+data[i].itemcode+"'>"+data[i].itemname+"</option>"
                }
                itemsfield.html(results)
            }
        )
    }
})