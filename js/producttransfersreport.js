$(document).ready(()=>{

    const storetype=$("#storetype")
    const storename=$("#storename")
    const startdate=$("#startdate")
    const enddate=$("#enddate")
    const alldates=$("#alldates")
    const generatereport=$("#generatereport")
    const report=$("#report")
    const notifications=$("#errors")

    alldates.prop("checked",true)
    startdate.prop("disabled",true)
    enddate.prop("disabled",true)

    startdate.datepicker()
    enddate.datepicker()

    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    alldates.on("click",function(){
        state=$(this).prop("checked")
        startdate.prop("disabled",state)
        enddate.prop("disabled",state)
    })

    function getWarehouses(selectBox){
        var results="<option value=''>&lt;Choose&gt;</option>"
        $.getJSON(
            "../controllers/warehouseoperations.php",
            {
               getwarehouses:"GET"
            },
            function(data){                   
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                }
                selectBox.html(results)
            }
        )
    }

    function getPointsOfsale(selectBox){ 
        var results="<option value=''>&lt;Choose&gt;</option>"
        $.getJSON(
            "../controllers/getpointsofsale.php",
            function(data){                   
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
                }
                selectBox.html(results)
            }
        ) 
    }

    storetype.on("change",function(){
        const typename=$(this).val()
        if(typename!==""){
            if(typename=="warehouse"){
                getWarehouses(storename)
            }else{
                getPointsOfsale(storename)
            }
        }else{
            storename.html("<option value=''>&lt;Choose&gt;</option>")
        }
    })

    generatereport.on("click",()=>{
        let errors=''

        const cat=storetype.val()
        const id=storename.val()
        let datefrom,dateto

        if(cat==''){
            errors="Please select store type"
            storetype.focus()
        }else if(id==''){
            errors="Please select store name"
            storename.focus()
        }else if(alldates.prop("checked")){
            datefrom='01-Jan-2022'
            dateto='31-Dec-2100'
        }else{
            datefrom=startdate.val()
            dateto=enddate.val()
            if(datefrom==''){
                errors='Please select start date'
                startdate.focus()
            }else if(dateto==''){
                errors='Please select end date'
                enddate.focus()
            }
        }

        if(errors==""){
            notifications.html(showAlert("processing","Processing. Please wait ...",1))
            if ($.fn.DataTable.isDataTable(report)) {
                report.DataTable().destroy();
            }
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    gettransferitemsreport:true,
                    cat,
                    id,
                    datefrom,
                    dateto
                },
                (data)=>{

                    let results=''
                    let headers=''

                    if(cat==='pos'){
                        headers=`
                            <tr>
                                <th data-priority="8">#</th>
                                <th data-priority="7">Product Code</th>
                                <th data-priority="1">Product Name</th>
                                <th data-priority="2" class="text-right"><span class="d-none d-sm-inline">Opening Balance</span><span class="d-inline d-sm-none">O/B</span></th>
                                <th data-priority="4" class="text-right"><span class="d-none d-sm-inline">Transfers In</span><span class="d-inline d-sm-none">In</span></th>
                                <th data-priority="5" class="text-right"><span class="d-none d-sm-inline">Transfers Out</span><span class="d-inline d-sm-none">Out</span></th>
                                <th data-priority="3" class="text-right"><span class="d-none d-sm-inline">Sold</span><span class="d-inline d-sm-none">S</span></th>
                                <th data-priority="6" class="text-right">Balance</th>
                            </tr>
                        `;
                        data.forEach((item,index)=>{
                            let balance=Number(item.openingstock)+Number(item.transferin)-Number(item.transferout)-Number(item.sold)
                            results+=`<tr><td>${Number(index+1)}</td>`
                            results+=`<td>${item.itemcode}</td>`
                            results+=`<td>${item.itemname}</td>`
                            results+=`<td class='text-right'>${$.number(item.openingstock, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(item.transferin, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(item.transferout, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(item.sold, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(balance, 0)}</td></tr>`
                        })
                    } else {
                        headers=`
                            <tr>
                                <th data-priority="8">#</th>
                                <th data-priority="7">Product Code</th>
                                <th data-priority="1">Product Name</th>
                                <th data-priority="2" class="text-right"><span class="d-none d-sm-inline">Opening Balance</span><span class="d-inline d-sm-none">O/B</span></th>
                                <th data-priority="3" class="text-right"><span class="d-none d-sm-inline">Purchases</span><span class="d-inline d-sm-none">P</span></th>
                                <th data-priority="4" class="text-right"><span class="d-none d-sm-inline">Transfers In</span><span class="d-inline d-sm-none">In</span></th>
                                <th data-priority="5" class="text-right"><span class="d-none d-sm-inline">Transfers Out</span><span class="d-inline d-sm-none">Out</span></th>
                                <th data-priority="6" class="text-right">Balance</th>
                            </tr>
                        `;
                        data.forEach((item,index)=>{
                            let balance=Number(item.openingstock)+Number(item.purchases)+Number(item.transferin)-Number(item.transferout)
                            results+=`<tr><td>${Number(index+1)}</td>`
                            results+=`<td>${item.itemcode}</td>`
                            results+=`<td>${item.itemname}</td>`
                            results+=`<td class='text-right'>${$.number(item.openingstock, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(item.purchases, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(item.transferin, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(item.transferout, 0)}</td>`
                            results+=`<td class='text-right'>${$.number(balance, 0)}</td></tr>`
                        })
                    }

                    report.find("thead").html(headers)
                    report.find("tbody").html(results)
                    notifications.html("")

                    report.DataTable({
                        responsive: true,
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
                                className: 'btn btn-xs btn-info mr-2'
                            },
                            {
                                extend: 'pdfHtml5',
                                text: '<i class="fal fa-file-pdf mr-1"></i> PDF',
                                className: 'btn btn-xs btn-danger mr-2'
                            },
                            {
                                extend: 'print',
                                text: '<i class="fal fa-print mr-1"></i> Print',
                                className: 'btn btn-xs btn-secondary'
                            }
                        ]
                    });
                }
            )
        }else{
            notifications.html(showAlert("info",errors))
        }
    })
})