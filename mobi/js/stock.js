$(document).ready(()=>{
    const  homebutton=$("#homebutton")
    const outlet=$("#outlet")
    const stocktable=$("#stocktable")

    getuseroutlets().done(function(){
        const asatdate=formatDate(new Date())
        const posid=outlet.val()
        $.getJSON(
            "../../controllers/reportoperations.php",
            {
                posstocksummary:true,
                posid,
                asatdate
            },
            (data)=>{
                let results=''
                data.forEach((item,index) =>{
                    results+=`<tr>`// <td>${Number(index+1)}</td> 
                    results+=`<td>${item.itemname}</td>`  
                    results+=`<td>${item.sales}</td>`
                    results+=`<td>${item.openingbalance}</td>`
                    results+=`<td>${item.transfersin}</td>`
                    results+=`<td>${item.transfersout}</td>` 
                    results+=`<td>${item.closingbalance}</td></tr>`
                })
                stocktable.find("tbody").html(results)
            }
        )
    })

    homebutton.click(()=>{
        window.location.href="main.php"
    })


    function getuseroutlets(){
        dfd=$.Deferred()
        $.getJSON(
            "../../controllers/posoperations.php",
            {
                getuseroutlets:true,
                userid:0
            },
            function(data){
                let results=''
                data.forEach(outlet =>{
                     results+=`<option value='${outlet.outletid}'>${outlet.posname}</option>`
                })
                
                $(results).appendTo(outlet)
                //refresh list
                outlet.selectmenu("refresh", true)
                if(data.length==1){
                    outlet.val(data[0].outletid)
                    dfd.resolve()
                }
            }
        )
        return dfd.promise()
    }
})