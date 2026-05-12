$(document).ready(()=>{

    const customerslist=$("#customerslisted")
    const  homebutton=$("#homebutton")

    getcustomers()

    homebutton.on("click",function(){ 
        window.location.href="main.php"
    })

    function getcustomers(){
        $.getJSON(
            "../../controllers/customeroperations.php",
            {
                getcustomers:true,
                regularcustomers:1,
                onetimecustomers:1
            },
            (data)=>{
                let results=''
                data.forEach(customer => {
                    results+="<li id='"+customer.customerid+"'><a href='#'>"+customer.customername+"</a></li>"
                })
                customerslist.html(results)
                customerslist.listview("refresh",true)
            }
        )
    }

})