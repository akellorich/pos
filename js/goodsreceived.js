$(document).ready(function(){
    const startdatelabel=$("#startdatelabel"),
        startdatefield=$("#startdate"),
        enddatelabel=$("#enddatelabel"),
        enddatefield=$("#enddate"),
        alldates=$("#alldates"),
        // sourcefield=$("#source"),
        // sourcelabel=$("#sourcelabel"),
        sourcenamefield=$("#sourcename"),
        addnewgrn=$("#addnewgrn"),
        filtergoodsreceivedbutton=$("#filtergrn"),
        grnnofield=$("#grnno"),
        deliverynotenofield=$("#deliveryno"),
        errordiv=$("#errors"),
        grnlist=$("#grnlist")

    // check all dates by default and disable date fields
    alldates.prop("checked",true)
    disabledatefields()

    // set date fields 
    startdatefield.datepicker({dateFormat: 'dd-M-yy',maxDate:  new Date()})
    enddatefield.datepicker({dateFormat: 'dd-M-yy',maxDate:  new Date()})

    // listen to check all dates checkbox on click
    alldates.on("click",function(){
        alldates.prop("checked")?disabledatefields(): enabledatefields()
    })

    // search customers or suppliers based on option selected on souce delivery category drop down
    // sourcefield.on("change", function(){
    //     if(sourcefield.val()=="all"){
    //         sourcelabel.html("Source")
    //         sourcenamefield.html("<option value='all'>&lt;All&gt;</option>")
    //     }else{
    //         var source=sourcefield.find("option:selected").text()
    //         sourcelabel.html(source)
    //         // get all customers or suppliers
    //         if(source=="Customer"){
    //             getcustomers(sourcenamefield)
    //         }else{
               
    //         }
    //     }
    // }) 
    
    getSuppliers(sourcenamefield)

    // show window for adding a new GRN
    addnewgrn.on("click",function(){
        window.location.href="receiveitems.php"
    })

    // filter grns
    filtergoodsreceivedbutton.on("click",function(){
        // source=sourcefield.val(),
        //     sourceid=sourcenamefield.val(),
        const grnno=grnnofield.val(),
            deliverynoteno=deliverynotenofield.val(),
            supplierid=sourcenamefield.val()

        let startdate="",
            enddate="",
            errors=""

        if(alldates.prop("checked")){
            startdate='01-Jan-2021'
            enddate='31-Dec-2100'
        }else{
            startdate=startdatefield.val()
            enddate=enddatefield.val()
        }

        // check for blank fields
        if(startdate==""){
            errors="Please select the start date first"
            startdatefield.focus()
        }else if(enddate==""){
            errors="Please select the end date first"
            enddatefield.focus()
        }
       if(errors==""){
           // filter grns
           errordiv.html(showAlert("info","Processing ...",1))
           $.getJSON(
               "../controllers/rawmaterialsoperations.php",
               {
                    filtergoodsreceived:true,
                    supplierid,
                    startdate,
                    enddate,
                    grnno,
                    deliverynoteno
               },
               function(data){
                   var results=""
                   if(data.length>0){
                        for(var i=0;i<data.length;i++){
                            results+=`<tr><td>${Number(i+1)}</td>`
                            results+=`<td>${data[i].grnno}</td>`
                            results+=`<td>${data[i].deliverynono}</td>`
                            results+=`<td>${data[i].datereceived}</td>`
                            results+=`<td>${data[i].warehousename}</td>`
                            results+=`<td>${data[i].suppliername}</td>`
                            results+=`<td>${data[i].receivedbyname}</td>`
                            results+=`<td>${data[i].inspectedbyname}</td>`
                            results+=`<td>${$.number(data[i].total,2)}</td>`
                            // print button
                            results+=`<td><a href='javascript void(0)' class='printdata text-primary' data-grnno='${data[i].grnno}'><span><i class='fal fa-print fa-lg fa-fw'></i></span></a></td></tr>`
                        }
                    }else{
                        results=`<tr><td colspan='8'>${showAlert("info","Sorry, no records found matching filter criterion selected",1)}</td></tr>`
                    }
                    makedatatable(grnlist,results,15)
                    //    grnlist.find("tbody").html(results)
                   errordiv.html("")
               }
           )
       }else{
           errordiv.html(showAlert("info",errors))
       }
    })

    // generate grn on print icon click
    grnlist.on("click",".printdata",function(e){
        e.preventDefault()
        var grnno=$(this).attr("data-grnno"),
            url="../controllers/generategrn.php?grnno="+grnno
        // generate the GRN in a blank window
        window.open(url,"_blank")
    })

    function disabledatefields(){
        startdatefield.prop("disabled",true)
        enddatefield.prop("disabled",true)
        startdatelabel.addClass("text-muted")
        enddatelabel.addClass("text-muted")
    }

    function enabledatefields(){
        startdatefield.prop("disabled",false)
        enddatefield.prop("disabled",false)
        startdatelabel.removeClass("text-muted")
        enddatelabel.removeClass("text-muted")
    }
})