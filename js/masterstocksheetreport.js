$(document).ready(function(){
    const startdatefield=$("#startdate"),
        searchbutton=$("#search"),
        report=$("#report"),
        masterstocksheetreport=$("#masterstocksheetreport"),
        errordiv=$("#errors"),
        returnoutwardssummary=$("#returnoutwardssummary"),
        returninwardssummary=$("#returninwardssummary")

    // assign date picker to date fields
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    
    // listen to search button click
    searchbutton.on("click",function(){
        var startdate=startdatefield.val(),
            errors=''

        if(startdate==""){
            errors="<p class='alert alert-danger'>Please provide start date</p>"
            errordiv.html(errors)
        }

        if(errors==''){
            errors="<p calss='alert alert-info'>Generating ...</p>"
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getmasterstocksheet:"get",
                    enddate:startdate
                   
                },
                function(data){
                    if(data.length>0){
                       json2table(masterstocksheetreport,data)  
                    }else{
                        report.html("<div class='alert alert-info'>Sorry, There are no records with similar criteria provided</div>")
                    }
                }
            )

            // get return outwards report summary
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getreturnoutwardssummary:true,
                    asatdate:startdate
                },
                function(data){
                    results=""
                    for(var i=0;i<data.length;i++){
                        results+=`<tr><td>${Number(i)+1}</td>`
                        results+=`<td>${data[i].dateadded}</td>`
                        results+=`<td>${data[i].itemcode}</td>`
                        results+=`<td>${data[i].itemname}</td>`
                        results+=`<td>${data[i].quantity}</td>`
                        results+=`<td>${data[i].serialno}</td>`
                        results+=`<td>${data[i].refno}</td>`
                        results+=`<td>${data[i].narration}</td></tr>`
                    }
                    returnoutwardssummary.find("tbody").html(results)
                }
            )

            // get return inwards report summary
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getreturninwardssummary:true,
                    asatdate:startdate
                },
                function(data){
                    results=""
                    for(var i=0;i<data.length;i++){
                        results+=`<tr><td>${Number(i)+1}</td>`
                        results+=`<td>${data[i].dateadded}</td>`
                        results+=`<td>${data[i].itemcode}</td>`
                        results+=`<td>${data[i].itemname}</td>`
                        results+=`<td>${data[i].quantity}</td>`
                        results+=`<td>${data[i].serialno}</td>`
                        results+=`<td>${data[i].refno}</td>`
                        results+=`<td>${data[i].narration}</td></tr>`
                    }
                    returninwardssummary.find("tbody").html(results)
                }
            )
        }
    })
})