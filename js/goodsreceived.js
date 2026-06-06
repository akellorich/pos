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

    // set date fields 
    startdatefield.datepicker({dateFormat: 'dd-M-yy',maxDate:  new Date()})
    enddatefield.datepicker({dateFormat: 'dd-M-yy',maxDate:  new Date()})

    // Set default dates to last 7 days (unchecked by default)
    alldates.prop("checked",false)
    enabledatefields()
    
    const today = new Date();
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(today.getDate() - 7);

    startdatefield.datepicker("setDate", sevenDaysAgo);
    enddatefield.datepicker("setDate", today);

    // listen to check all dates checkbox on click
    alldates.on("click",function(){
        alldates.prop("checked")?disabledatefields(): enabledatefields()
    })
    
    getSuppliers(sourcenamefield).done(function() {
        // Trigger initial filter on load after suppliers are fully loaded
        filtergoodsreceivedbutton.trigger("click");
    });

    // show window for adding a new GRN
    addnewgrn.on("click",function(){
        window.location.href="receiveitems.php"
    })

    // filter grns
    filtergoodsreceivedbutton.on("click",function(){
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
                            results+=`<td class="d-none d-lg-table-cell">${data[i].deliverynono}</td>`
                            results+=`<td>${data[i].datereceived}</td>`
                            results+=`<td class="d-none d-lg-table-cell">${data[i].warehousename}</td>`
                            results+=`<td>${data[i].suppliername}</td>`
                            results+=`<td class="d-none d-lg-table-cell">${data[i].receivedbyname}</td>`
                            results+=`<td class="d-none d-lg-table-cell">${data[i].inspectedbyname}</td>`
                            results+=`<td>${$.number(data[i].total,2)}</td>`
                            // print button
                            results+=`<td><a href='javascript void(0)' class='printdata text-primary' data-grnno='${data[i].grnno}'><span><i class='fal fa-print fa-lg fa-fw'></i></span></a></td></tr>`
                        }
                    }else{
                        results=`<tr><td colspan='8'>${showAlert("info","Sorry, no records found matching filter criterion selected",1)}</td></tr>`
                    }
                    makedatatable(grnlist,results,15)
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

    // Fixed FAB click handler to trigger Add New GRN
    $("#mobileAddGrnFAB").on("click", function() {
        $("#addnewgrn").trigger("click");
    });

    // Toggle Filters collapsible panel text & icons
    $('#filterCollapse').on('show.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Close');
        $('#toggleFiltersBtn i').removeClass('fa-filter').addClass('fa-times');
    });
    $('#filterCollapse').on('hide.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Filters');
        $('#toggleFiltersBtn i').removeClass('fa-times').addClass('fa-filter');
    });

})