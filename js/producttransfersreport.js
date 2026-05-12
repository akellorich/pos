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
        // const store=storename.val()
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

                    data.forEach((item,index)=>{
                        let balance=item.transferin-item.transferout
                        results+=`<tr><td>${Number(index+1)}</td>`
                        results+=`<td>${item.itemcode}</td>`
                        results+=`<td>${item.itemname}</td>`
                        results+=`<td class='text-right'>${$.number(item.transferin)}</td>`
                        results+=`<td class='text-right'>${$.number(item.transferout)}</td>`
                        results+=`<td class='text-right'>${$.number(balance)}</td></tr>`
                    })

                    report.find("tbody").html(results)
                    notifications.html("")
                }
            )
        }else{
            notifications.html(showAlert("info",errors))
        }
    })
})