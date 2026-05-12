$(document).ready(function(){
    const startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        searchbutton=$("#search"),
        report=$("#report"),
        errordiv=$("#errors"),
        alldates=$("#alldates"),
        discountresport=$("#discountreport")

    

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
            errors="<p calss='alert alert-info'>Generating ...</p>"
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getdiscountreport:"get",
                    startdate:startdate,
                    enddate:enddate
                },
                function(data){                    
                    if(data.length>0){
                        data.pop()
                        json2table(discountresport,data)  
                    }else{
                        report.html(showAlert("info","Sorry, There are no records with similar criteria provided"))
                    }
                    
                    errordiv.html("")   
                }
            )
        }
    })
})