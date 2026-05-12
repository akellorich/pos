$(document).ready(function(){
    // get POS
    const poslist=$("#pos"),
        asatdatefield=$("#asatdate"),
        searchbutton=$("#search"),
        report=$("#report"),
        errordiv=$("#errors"),
        posstocklistreport=$("#posstocklistreport"),
        categoryfield=$("#category")

    getPointsOfSale(poslist,'choose')

    categoryfield.on("change",()=>{
        const category=categoryfield.val()
        // console.log(category)
        if(category=="outlet"){
            // get points of sale
            getPointsOfSale(poslist,'choose')
        }else{
            // get warehouses
            getwarehouses(poslist,'choose')
        }
    })

    // assign datepicker to date fields
    // asatdatefield.datepicker({dateFormat: 'dd-M-yy'})
    setDatePicker(asatdatefield)

    searchbutton.on("click",function(){
        const category=categoryfield.val()
        // console.log(category)
        let errors=""

        if(asatdatefield.val()==""){
            errors="Please select as at date first"
            // errordiv.html(errors)
        }else if(poslist.val()==""){
            errors=`Please a ${categoryfield.find("option:selected").text()} first`
            // errordiv.html(errors)
        }

        if(errors==""){
            //errordiv.html("<p class='alert alert-info'>Generating ...</p>")
            errordiv.html(showAlert("processing","Processing. Please wait ...",1))
            if(category=="outlet"){
                    $.getJSON(
                    "../controllers/reportoperations.php",
                    {
                        posstocksummary:true,
                        asatdate:asatdatefield.val(),
                        posid:poslist.val()
                    },
                    function(data){
                        if(data.length==0){
                            report.html(showAlert("info","Sorry. No data matching filter criteria. Please correct and try again."))
                        }else{
                            if(data.length>0){
                                // add totals for totalpurchasevalue and totalsalesvalue
                                data= data.map(item => ({
                                    ...item,
                                    Closing_Balance:(parseFloat(item.openingbalance)+parseFloat(item.transfersin)-parseFloat(item.transfersout)-parseFloat(item.sales)).toFixed(2),
                                    Total_Purchase: ((parseFloat(item.openingbalance)+parseFloat(item.transfersin)-parseFloat(item.transfersout)-parseFloat(item.sales)) * parseFloat(item.buyingprice)).toFixed(2),
                                    Total_Sales: ((parseFloat(item.openingbalance)+parseFloat(item.transfersin)-parseFloat(item.transfersout)-parseFloat(item.sales)) * parseFloat(item.sellingprice)).toFixed(2)
                                }))
                                // filter
                                data=data.filter(item=>parseFloat(item.Closing_Balance)>0)
                                json2table(posstocklistreport,data)  
                            }else{
                                posstocklistreport.html(showAlert("info",`Sorry no records matching filter options`))
                            }
                            errordiv.html("")  
                        }
    
                    }
                )
            }else{
                // get warehouse summaries
                const warehouseid=poslist.val(),
                    asat=sanitizestring(asatdatefield.val())
                    // console.log(warehouseid)
                    // console.log(asat)
                $.getJSON(
                    "../controllers/productoperations.php",
                    {
                        getwarehouseproductsummary:true,
                        warehouseid,
                        asat
                    },
                    (data)=>{
                        if(data.length>0){
                            // add Closing Balance
                            data=data.map( item=>({
                                ...item,
                                Closing :(parseFloat(item.openingbalance)+parseFloat(item.received)-parseFloat(item.issued)).toFixed(2)
                            }))

                            json2table(posstocklistreport,data)  
                        }else{
                            posstocklistreport.html(showAlert("info",`Sorry no records matching filter options`))
                        }
                       
                        errordiv.html("")  
                    }
                )
                // getwarehouseproductsummary
            }
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })

})