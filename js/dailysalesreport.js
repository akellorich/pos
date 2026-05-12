$(document).ready(function(){
    var poslist=$("#pos"),
        userslist=$("#user"),
        startdate=$("#startdate"),
        enddate=$("#enddate"),
        searchbutton=$("#search"),
        resultslist=$("#resultslist"),
        errordiv=$("#errors"),
        groupbyfield=$("#groupby")
        alldates=$("#alldates")

    alldates.prop('checked',true)
    startdate.prop("disabled",true)
    enddate.prop("disabled",true)
    

    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdate.prop("disabled",true)
            enddate.prop("disabled",true)
        }else{
            startdate.prop("disabled",false)
            enddate.prop("disabled",false)
        }
    })

    // get pos
    $.getJSON(
        "../controllers/getpointsofsale.php",
        function(data){
            var results="<option value='0'>&lt;All&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
                } 
                $(results).appendTo(poslist)
        }
    )

    searchbutton.on("click",function(){
        var errors=''
        // check for blank fields
        if(alldates.prop("checked")){
            startdateval='01-Jan-2019'
            enddateval='31-dec-2100'
        }else{
            if(startdate.val==""){
                errors="<p class='alert alert-danger'>Please provide start date</p>"
                errordiv.html(errors)
            }else if(enddate.val()==""){
                errors="<p class='alert alert-danger'>Please provide end date</p>"
                errordiv.html(errors)
            }else{
                startdateval=startdate.val()
                enddateval=enddate.val()
            }
        }
        
        if(errors==''){
            if(groupbyfield.val()=="customer"){
                errordiv.html(showAlert("processing","Processing.Please wait ...",1))
                $.getJSON(
                    "../controllers/possalesoperations.php",
                    {
                        customersalessummary:"get",
                        startdate:startdateval,
                        enddate:enddateval,
                        userid:userslist.val(),
                        posname:$("#pos option:selected").text()
                    },
                    function(data){
                        var olduser='',
                            userstotal=0,
                            overalltotal=0
                            results=""
                            olddate=''
                        // add the first row
                        olduser=data[0].pointofsale
                        results="<tr class='font-weight-bold'><td colspan='8'>"+olduser+"</td></tr>"
                        results+=`<tr>
                                <td>Date</td>
                                <td>User</td>
                                <td class='text-right'>Cash</td>
                                <td class='text-right'>MPESA</td>
                                <td class='text-right'>Cheque</td>
                                <td class='text-right'>Credit</td>
                                <td class='text-right'>Card</td>
                                <td class='text-right'>TOTAL</td>
                            </tr>`
                        for(var i=0;i<data.length;i++){
                            //console.log(olduser+":"+data[i].transactiondate)                        
                            if(data[i].pointofsale!=olduser){ 
                                // add previous users sub total
                                results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                // add the new user
                                results+="<tr class='font-weight-bold'><td>"+data[i].pointofsale+"</td></tr>"
                                results+=`<tr>
                                        <td>Date</td>
                                        <td>User</td>
                                        <td class='text-right'>Cash</td>
                                        <td class='text-right'>MPESA</td>
                                        <td class='text-right'>Cheque</td>
                                        <td class='text-right'>Credit</td>
                                        <td class='text-right'>Card</td>
                                        <td class='text-right'>TOTAL</td>
                                    </tr>`

                                //reset users total 
                                userstotal=0 
                                // initialize olduser to the current date
                                olduser=data[i].pointofsale
                                
                            }
                            // add row details
                            results+=`<tr>
                                    <td>${data[i].transactiondate}</td>
                                    <td>${data[i].customername}</td>
                                    <td class='text-right'>${$.number(data[i].Cash,2)}</td>
                                    <td class='text-right'>${$.number(data[i].Mpesa,2)}</td>
                                    <td class='text-right'>${$.number(data[i].Cheque,2)}</td>
                                    <td class='text-right'>${$.number(data[i].Credit,2)}</td>
                                    <td class='text-right'>${$.number(data[i].Card,2)}</td>
                                    <td class='text-right'>${$.number(data[i].Total,2)}</td>
                                </tr>`
                            //increment  the totals
                            userstotal+=parseFloat(data[i].Total)
                            overalltotal+=parseFloat(data[i].Total)
                        }    
                        // add the last user's total
                        results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                        // add overall total to the report
                        results+="<tr class='lead font-weight-bold text-right''><td colspan='7'>OVERALL TOTAL :</td><td>"+$.number(overalltotal,2)+"</td></tr>"
                        resultslist.html("")
                        //console.log(results)
                        $(results).appendTo(resultslist)
                        errordiv.html("")
                    }
                )
            }else{
                $.getJSON(
                    "../controllers/possalesoperations.php",
                    {
                        usersalessummary:"get",
                        startdate:startdateval,
                        enddate:enddateval,
                        userid:userslist.val(),
                        posname:$("#pos option:selected").text()
                    },
                    function(data){
                        var olduser='',
                            userstotal=0,
                            overalltotal=0
                            results=""
                            errordiv.html("<p class='alert alert-info'>Generating please wait ...</p>")
                            groupby=groupbyfield.val(),
                            olddate=''
                        if(data.length>0){
                            if(groupby=='user'){
                                // add the first row
                                olduser=data[0].userfullname
                                results="<tr class='font-weight-bold'><td colspan='8'>"+olduser+"</td></tr>"
                                results+=`<tr>
                                        <td>Date</td>
                                        <td>Point of Sale</td>
                                        <td class='text-right'>Cash</td>
                                        <td class='text-right'>MPESA</td>
                                        <td class='text-right'>Cheque</td>
                                        <td class='text-right'>Credit</td>
                                        <td class='text-right'>Card</td>
                                        <td class='text-right'>TOTAL</td>
                                    </tr>`
                                for(var i=0;i<data.length;i++){
                                    //console.log(olduser+":"+data[i].transactiondate)                        
                                    if(data[i].userfullname!=olduser){ 

                                        // add previous users sub total
                                        results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                        // add the new user
                                        results+="<tr class='font-weight-bold'><td>"+data[i].userfullname+"</td></tr>"
                                        results+=`<tr>
                                                <td>Date</td>
                                                <td>User</td>
                                                <td class='text-right'>Cash</td>
                                                <td class='text-right'>MPESA</td>
                                                <td class='text-right'>Cheque</td>
                                                <td class='text-right'>Credit</td>
                                                <td class='text-right'>Card</td>
                                                <td class='text-right'>TOTAL</td>
                                            </tr>`

                                        //reset users total 
                                        userstotal=0 
                                        // initialize olduser to the current date
                                        olduser=data[i].userfullname
                                        
                                    }
                                    // add row details
                                    results+=`<tr>
                                        <td>${data[i].transactiondate}</td>
                                        <td>${data[i].pointofsale}</td>
                                        <td class='text-right'>${$.number(data[i].Cash,2)}</td>
                                        <td class='text-right'>${$.number(data[i].Mpesa,2)}</td>
                                        <td class='text-right'>${$.number(data[i].Cheque,2)}</td>
                                        <td class='text-right'>${$.number(data[i].Credit,2)}</td>
                                        <td class='text-right'>${$.number(data[i].Card,2)}</td>
                                        <td class='text-right'>${$.number(data[i].Total,2)}</td>
                                    </tr>`
                                    //increment  the totals
                                    userstotal+=parseFloat(data[i].Total)
                                    overalltotal+=parseFloat(data[i].Total)
                                }    
                                // add the last user's total
                                results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                // add overall total to the report
                                results+="<tr class='lead font-weight-bold text-right''><td colspan='7'>OVERALL TOTAL :</td><td>"+$.number(overalltotal,2)+"</td></tr>"
                                resultslist.html("")
                                //console.log(results)
                                $(results).appendTo(resultslist)
                                errordiv.html("")
                            }else if(groupby=='date'){
                                // add the first row
                                olduser=data[0].transactiondate
                                results="<tr class='font-weight-bold'><td colspan='8'>"+olduser+"</td></tr>"
                                results+="<tr><td>User</td><td>Point of Sale</td><td class='text-right'>Cash</td><td class='text-right'>MPESA</td><td class='text-right'>Cheque</td><td class='text-right'>Credit</td><td class='text-right'>TOTAL</td></tr>"
                                for(var i=0;i<data.length;i++){
                                    //console.log(olduser+":"+data[i].transactiondate)                        
                                    if(data[i].transactiondate!=olduser){ 

                                        // add previous users sub total
                                        results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                        // add the new user
                                        results+="<tr class='font-weight-bold'><td>"+data[i].transactiondate+"</td></tr>"
                                        results+=`<tr>
                                                <td>User</td>
                                                <td>Point of Sale</td>
                                                <td class='text-right'>Cash</td>
                                                <td class='text-right'>MPESA</td>
                                                <td class='text-right'>Cheque</td>
                                                <td class='text-right'>Credit</td> 
                                                <td class='text-right'>Card</td> 
                                                <td class='text-right'>TOTAL</td>
                                            </tr>`

                                        //reset users total 
                                        userstotal=0 
                                        // initialize olduser to the current date
                                        olduser=data[i].transactiondate
                                        
                                    }
                                    // add row details
                                    results+=`<tr>
                                            <td>${data[i].userfullname}</td>
                                            <td>${data[i].pointofsale}</td>
                                            <td class='text-right'>${$.number(data[i].Cash,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Mpesa,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Cheque,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Credit,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Card,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Total,2)}</td>
                                        </tr>`
                                    //increment  the totals
                                    userstotal+=parseFloat(data[i].Total)
                                    overalltotal+=parseFloat(data[i].Total)
                                }    
                                // add the last user's total
                                results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                // add overall total to the report
                                results+="<tr class='lead font-weight-bold text-right''><td colspan='7'>OVERALL TOTAL :</td><td>"+$.number(overalltotal,2)+"</td></tr>"
                                resultslist.html("")
                                //console.log(results)
                                $(results).appendTo(resultslist)
                                errordiv.html("")
                            } else if(groupby=='pos'){
                                // add the first row
                                olduser=data[0].pointofsale
                                results="<tr class='font-weight-bold'><td colspan='8'>"+olduser+"</td></tr>"
                                results+=`<tr>
                                        <td>Date</td>
                                        <td>User</td>
                                        <td class='text-right'>Cash</td>
                                        <td class='text-right'>MPESA</td>
                                        <td class='text-right'>Cheque</td>
                                        <td class='text-right'>Credit</td>
                                        <td class='text-right'>Card</td>
                                        <td class='text-right'>TOTAL</td>
                                    </tr>`
                                for(var i=0;i<data.length;i++){
                                    //console.log(olduser+":"+data[i].transactiondate)                        
                                    if(data[i].pointofsale!=olduser){ 

                                        // add previous users sub total
                                        results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                        // add the new user
                                        results+="<tr class='font-weight-bold'><td>"+data[i].pointofsale+"</td></tr>"
                                        results+=`<tr>
                                                <td>Date</td>
                                                <td>User</td>
                                                <td class='text-right'>Cash</td>
                                                <td class='text-right'>MPESA</td>
                                                <td class='text-right'>Cheque</td>
                                                <td class='text-right'>Credit</td>
                                                <td class='text-right'>Card</td>
                                                <td class='text-right'>TOTAL</td>
                                            </tr>`
                                        //reset users total 
                                        userstotal=0 
                                        // initialize olduser to the current date
                                        olduser=data[i].pointofsale 
                                    }
                                    // add row details
                                    results+=`<tr>
                                            <td>${data[i].transactiondate}</td>
                                            <td>${data[i].userfullname}</td>
                                            <td class='text-right'>${$.number(data[i].Cash,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Mpesa,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Cheque,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Credit,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Card,2)}</td>
                                            <td class='text-right'>${$.number(data[i].Total,2)}</td>
                                        </tr>`
                                    //increment  the totals
                                    userstotal+=parseFloat(data[i].Total)
                                    overalltotal+=parseFloat(data[i].Total)
                                }    
                                // add the last user's total
                                results+="<tr class='font-weight-bold text-right''><td colspan='7'>"+olduser+" Total: </td><td>"+$.number(userstotal,2)+"</td></tr>"
                                // add overall total to the report
                                results+="<tr class='lead font-weight-bold text-right''><td colspan='7'>OVERALL TOTAL :</td><td>"+$.number(overalltotal,2)+"</td></tr>"
                                resultslist.html("")
                                //console.log(results)
                                $(results).appendTo(resultslist)
                                errordiv.html("")
                            }
                        }else{
                            resultslist.html("<tr><td colspan='5'>No results matching filter creiteria</td></tr>")
                            errordiv.html("")
                        }
                    }
                )
            }
        }
    })
    // get all users
    getAllUsers()

    // assign date controld datepickers
    startdate.datepicker({maxDate: new Date()})
    enddate.datepicker({maxDate: new Date()})
    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    function getAllUsers(){
        var names=''
        $.getJSON(
            "../controllers/getusers.php",
            function(data){
                var results="<option value='0'>&lt;All&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    names=data[i].firstname+' '+data[i].middlename+' ' +data[i].lastname
                    results+="<option value='"+data[i].id+"'>"+names+"</option>"
                } 
                $(results).appendTo(userslist)
            }
        )
    }
})