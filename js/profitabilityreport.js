$(document).ready(function(){
    const poslist=$("#pos"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        searchbutton=$("#search"),
        report=$("#report"),
        errordiv=$("#errors"),
        alldates=$("#alldates"),
        profitabilityreport=$("#profitabilityreport")

    // get a list of all points of sale
    $.getJSON(
        "../controllers/getpointsofsale.php",
        function(data){
            var results="<option value='0'>&lt;All&gt;</option>"
            for( var i=0;i<data.length;i++){
                results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
            }
            $(results).appendTo(poslist)
        }
    )

    // assign date picker to date fields
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})

    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    alldates.on("click",function(){
       if(alldates.prop("checked")) {
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
       }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
       }
    })

    // listen to search button click
    searchbutton.on("click",function(){
        var startdate=startdatefield.val(),
            enddate=enddatefield.val(),
            posid=poslist.val(),
            errors=''

        if(alldates.prop("checked")){
            startdate="01-Jan-2019"
            enddate='31-Dec-2100'
        }else{
            if(startdate==""){
                errors="<p class='alert alert-danger'>Please provide start date</p>"
                errordiv.html(errors)
            }else if(enddate==""){
                errors="<p class='alert alert-danger'>Please provide end date</p>"
                errordiv.html(errors)
            }
        }
        if(errors==''){
            errordiv.html(showAlert("processing","Processing. Please wait ...",1)) 
            report.html("")
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    profitabilityreport:"get",
                    startdate:startdate,
                    enddate:enddate,
                    posid:posid
                },
                function(data){
                    if(data.length>0){
                        data.pop()
                       json2table(profitabilityreport,data)  
                    }else{
                        report.html(showAlert("info","Sorry, There are no records with similar criteria provided"))
                    }                    
                    errordiv.html("")   
                }
            )
        }
    })
})