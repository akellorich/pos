$(document).ready(()=>{
    const startdatefield=$('#startdate'),
        enddatefield=$('#enddate'),
        searchbutton=$('#search'),
        inputoutputvatreporttable=$('#inputoutputvatreporttable'),
        reportnotifications=$('#reportnotifications'),
        selectalldatesfield=$("#selectalldates")

    // set date pickers
    setDatePicker(startdatefield)
    setDatePicker(enddatefield)

    selectalldatesfield.on("click",function(){
        console.log("clicked")
        if($(this).is(":checked")){
            // the dates will be disabled
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.removeAttr("disabled")
            enddatefield.removeAttr("disabled")
        }
    })

    searchbutton.on("click", function(){
        const startdate=selectalldatesfield.is(":checked")?'01-Jan-2025':sanitizestring(startdatefield.val()),
            enddate =selectalldatesfield.is(":checked")?'31-Dec-2100': sanitizestring(enddatefield.val())
        let errors=""
        // check for blank fields
        if(startdate==""){
            errors="Please select start date"
        }else if(enddate==""){
            errors="Please select end date"
        }

        if(errors==""){
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    getinputoutputvatreport:true,
                    startdate,
                    enddate
                },
                (data)=>{
                    let results=""
                    data.forEach((vat,i)=>{
                        results+=`<tr><td>${$.number(i+1)}</td>`
                        results+=`<td>${vat.itemcode}</td>`
                        results+=`<td>${vat.itemname}</td>`
                        results+=`<td>${$.number(vat.qtysold)}</td>`
                        results+=`<td>${$.number(vat.totalpurchase)}</td>`
                        results+=`<td>${$.number(vat.inputvat)}</td>`
                        results+=`<td>${$.number(vat.totalsales)}</td>`
                        results+=`<td>${$.number(vat.outputvat)}</td>`
                        results+=`<td>${$.number(vat.vatdifference)}</td></tr>`
                    })
                    makedatatable(inputoutputvatreporttable,results,15)
                }
            )
        }else{
            reportnotifications.html(showAlert("info",errors))
            if(startdatefield.hasClass("is-invalid")){
                startdatefield.focus()
            }else if(enddatefield.hasClass("is-invalid")){
                enddatefield.focus()
            }
        }
    })
})