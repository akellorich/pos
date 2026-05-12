$(document).ready(()=>{

    const homebutton=$("#homebutton")
    const paymentsummarytable=$("#paymentsummarytable")
    const outlet=$("#outlet")

    homebutton.click(()=>{
        window.location.href="main.php"
    })

    getuseroutlets().done(function(){

        const startdate=formatDate(new Date())
        const enddate=formatDate(new Date())
        const posid=outlet.val()
        
        $.getJSON(
            "../../controllers/reportoperations.php",
            {
                getsalesbypaymentmode:true,
                posid,
                startdate,
                enddate
            },
            (data)=>{
                let results=''
                data.forEach((item) =>{
                    results+=`<tr>`
                    results+=`<td>${item.paymentmode}</td>`  
                    results+=`<td>&nbsp;</td>`
                    results+=`<td>${item.amount}</td></tr>`
                })
                paymentsummarytable.find("tbody").html(results)
            }
        )
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