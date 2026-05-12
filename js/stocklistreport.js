$(document).ready(function(){
    // get POS
    const startdatefield=$("#startdate"),
            searchbutton=$("#search"),
            report=$("#report"),
            errordiv=$("#errors"),
            stocklistreport=$("#stocklistreport")
    
            // stocklistreport.dataTable()
    // assign date picker to date fields
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})

    searchbutton.on("click",function(){
        var errors=''
        if(startdatefield.val()==""){
            errors="Please provide As At date"
            errordiv.html(showAlert("info",errors))
        }else{
            errordiv.html("")
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    asatdate:startdatefield.val(),
                    getstocksheet:true
                },
                function(data){
                    if(data.length>0){
                        json2table(stocklistreport,data)  
                    }else{
                        report.html("<div class='alert alert-info'>Sorry no records matching filter options found</div>")
                    }
                }
            )
        }
    })

    function extractKeys(obj) {
        // let keys = [];
        // for (let key in obj) {
        //     keys.push(key);
        //     if (typeof obj[key] === "object" && obj[key] !== null) {
        //         keys = keys.concat(extractKeys(obj[key]));
        //     }
        // }
        // return keys;
        return Object.keys(obj);
    }
   
})