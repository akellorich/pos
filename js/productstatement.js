$(document).ready(function(){
    var startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        itemsfield=$("#product"),
        alldates=$("#alldates"),
        filterbutton=$("#search"),
        errordiv=$("#errors"),
        report=$("#report");
    
    startdatefield.datepicker({maxDate: new Date(), dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({maxDate: new Date(), dateFormat: 'dd-M-yy'})

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    alldates.on("click",function(){
        if(alldates.prop("checked")){
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
            errordiv.html("");
            if ($.fn.DataTable.isDataTable(report)) {
                report.DataTable().destroy();
            }
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    getproductstatement:true,
                    itemcode,
                    startdate,
                    enddate
                },
                function(data){
                    errordiv.html("");
                    let runningbalance=Number(data[0].openingbalance), results=""
                    for(var i=0;i<data.length;i++){
                        results+=`<tr><td>${Number(i+1)}</td>`
                        results+=`<td>${data[i].date}</td>`
                        results+=`<td>${data[i].description}</td>`
                        if(i==0){
                            results+=`<td>&nbsp;</td>`
                            results+=`<td class="text-right">&nbsp;</td>`
                            results+=`<td class="text-right">&nbsp;</td>`
                        }else{
                            results+=`<td>${data[i].reference}</td>`
                            results+=`<td class="text-right">${Number(data[i].stockin) > 0 ? $.number(data[i].stockin, 2) : "-"}</td>`
                            results+=`<td class="text-right">${Number(data[i].stockout) > 0 ? $.number(data[i].stockout, 2) : "-"}</td>`
                        }
                        runningbalance+=Number(data[i].stockin)-Number(data[i].stockout)
                        console.log(runningbalance)
                        results+=`<td class="text-right">${$.number(runningbalance, 2)}</td></tr>`
                    }
                    report.find("tbody").html(results);
                    
                    report.DataTable({
                        responsive: true,
                        ordering: false,
                        dom: '<"dt-buttons-container mb-3"B><"dt-controls-container d-flex flex-column flex-sm-row justify-content-between align-items-sm-center mb-3"lf>rtip',
                        "lengthMenu": [[10, 15, 25, 50, 100, -1], [10, 15, 25, 50, 100, "All"]],
                        "pageLength": 15,
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                text: '<i class="fal fa-file-excel mr-1"></i> Excel',
                                className: 'btn btn-xs btn-success mr-2'
                            },
                            {
                                extend: 'csvHtml5',
                                text: '<i class="fal fa-file-csv mr-1"></i> CSV',
                                className: 'btn btn-xs btn-primary mr-2'
                            },
                            {
                                extend: 'pdfHtml5',
                                text: '<i class="fal fa-file-pdf mr-1"></i> PDF',
                                className: 'btn btn-xs btn-danger mr-2'
                            },
                            {
                                extend: 'print',
                                text: '<i class="fal fa-print mr-1"></i> Printer',
                                className: 'btn btn-xs btn-info'
                            }
                        ]
                    });
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