$(document).ready(function(){
    var sourcename=$("#sourcename"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        alldates=$("#alldates"),
        sourcefield=$("#source"),
        destinationfield=$("#destination"),
        destinationname=$("#destinationname"),
        transferslist=$("#transferdetails"),
        searchtransfers=$("#findtransfers"),
        newtransferbutton=$("#newtransfer")
    // add datepickers
    startdatefield.datepicker()
    enddatefield.datepicker()

    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    alldates.on("click",function(){
        if(!alldates.prop("checked")){
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }else{
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }
    })

    function getWarehouses(selectBox){
        var results="<option value='all'>&lt;All&gt;</option>"
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
        var results="<option value='all'>&lt;All&gt;</option>"
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

    sourcefield.on("change",function(){
        if(sourcefield.val()=="warehouse"){
            getWarehouses(sourcename)
        }else if(sourcefield.val()=="outlet"){
            getPointsOfsale(sourcename)
        }
    })

    destinationfield.on("change",function(){
        if(destinationfield.val()=="warehouse"){
            getWarehouses(destinationname)
        }else{
            getPointsOfsale(destinationname)
        }
    })

    searchtransfers.on("click",function(){
        console.log("clicked")
        var startdate,enddate,
            source=sourcefield.val(),
            sourceid=sourcename.val(),
            destination=destinationfield.val(),
            destinationid=destinationname.val(), 
            errors=""
        if(alldates.prop("checked")==true){
            startdate='01-Jan-2019'
            enddate='31-dec-2100'
        }else{
            // check if start and end dates have been provided
            startdate=startdatefield.val()
            enddate=enddatefield.val()
            if(startdate==""){
                errors="<p class='alert alert-danger'>Please provide start date first</p>"
                startdatefield.focus()
            }else if(enddate==""){
                errors="<p class='alert alert-danger'>Please provide end date first</p>"
                enddatefield.focus()
            }
        }
        if(errors==""){
           if (source=="all"){
               sourceid=0
           }
           if(destination=="all"){
               destinationid=0
           }
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    gettransfers:true,
                    startdate:startdate,
                    enddate:enddate,
                    source:source,
                    sourceid:sourceid,
                    destination:destination,
                    destinationid:destinationid
                },
                function(data){
                    var results=""
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td><span class='row-details-toggle text-secondary' style='cursor: pointer;'><i class='fal fa-chevron-right' style='font-size: 8px !important;'></i></span></td>"
                        results+="<td>"+parseFloat(i+1)+"</td>"
                        results+="<td>"+data[i].referenceno+"</td>"
                        results+="<td class='d-none d-sm-table-cell'>"+data[i].dateadded+"</td>"
                        results+="<td class='d-none d-md-table-cell'>"+data[i].sourcename+"</td>"
                        results+="<td class='d-none d-md-table-cell'>"+data[i].destinationame+"</td>"
                        results+="<td class='d-none d-lg-table-cell'>"+data[i].username+"</td>"
                        results+=`<td class='text-center' style='white-space: nowrap;'>
                            <a class="print text-success mr-3" href="#" data-id="${data[i].referenceno}" title="Print" style="font-size: 1.05rem;"><i class="fal fa-print"></i></a>
                            <a class="edit text-primary mr-3" href="#" data-id="${data[i].referenceno}" title="Edit" style="font-size: 1.05rem;"><i class="fal fa-edit"></i></a>
                            <a class="delete text-danger" href="#" data-id="${data[i].referenceno}" title="Delete" style="font-size: 1.05rem;"><i class="fal fa-trash-alt"></i></a>
                        </td></tr>`
                    }
                    //console.log(results)
                    transferslist.find("tbody").html(results)
                }
            )
        }
    })

    transferslist.on("click",".print",function(e){
        e.preventDefault()
        var referenceno=$(this).attr("data-id"), url=""
        url="../printstocktransfer.php?referenceno="+referenceno
        var win = window.open(url, '_blank');
    })

    newtransferbutton.on("click",function(){
        window.location.href="transferitems.php"
    })



    // Responsive table details row toggle
    transferslist.on("click", ".row-details-toggle", function(e) {
        e.preventDefault();
        const btn = $(this);
        const icon = btn.find("i");
        const row = btn.closest("tr");
        
        if (row.next().hasClass("detail-row")) {
            row.next().remove();
            icon.removeClass("fa-chevron-down text-danger").addClass("fa-chevron-right text-secondary");
        } else {
            const date = row.find("td").eq(3).html();
            const source = row.find("td").eq(4).html();
            const dest = row.find("td").eq(5).html();
            const user = row.find("td").eq(6).html();
            
            const detailHtml = `
                <tr class="detail-row" style="background-color: #fcfdfd;">
                    <td colspan="8" class="p-2">
                        <div class="card shadow-none border-0 m-0" style="background-color: #f8fafc; border-radius: 6px; font-size: 0.74rem; border: 1px solid #e2e8f0 !important;">
                            <div class="card-body p-2">
                                <div class="row text-left" style="margin: 0 !important; padding: 0 !important;">
                                    <div class="col-6 mb-1 d-sm-none" style="padding: 0 4px !important;"><strong>Date:</strong> ${date}</div>
                                    <div class="col-6 mb-1 d-md-none" style="padding: 0 4px !important;"><strong>Source:</strong> ${source}</div>
                                    <div class="col-6 mb-1 d-md-none" style="padding: 0 4px !important;"><strong>Destination:</strong> ${dest}</div>
                                    <div class="col-6 mb-1 d-lg-none" style="padding: 0 4px !important;"><strong>User:</strong> ${user}</div>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            `;
            row.after(detailHtml);
            icon.removeClass("fa-chevron-right text-secondary").addClass("fa-chevron-down text-danger");
        }
    });
})