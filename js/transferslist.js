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
                        results+="<tr><td>"+parseFloat(i+1)+"</td>"
                        results+="<td>"+data[i].referenceno+"</td>"
                        results+="<td>"+data[i].dateadded+"</td>"
                        results+="<td>"+data[i].sourcename+"</td>"
                        results+="<td>"+data[i].destinationame+"</td>"
                        results+="<td>"+data[i].username+"</td>"
                        results+="<td><a href='javascript void(0)' class='print' data-id='"+data[i].referenceno+"'><span><i class='fas fa-print fa-sm mt-1'></i></span></a></td>"
                        results+="<td><a href='javascript void(0)' class='edit' data-id='"+data[i].referenceno+"'><span><i class='fas fa-edit fa-sm mt-1'></i></span></a></td>"
                        results+="<td><a href='javascript void(0)' class='delete' data-id='"+data[i].referenceno+"'><span><i class='fas fa-trash-alt fa-sm mt-1'></i></span></a></td></tr>"
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
})