$(document).ready(()=>{
    const sessionnotifications=$("#sessionnotifications"),
        sessionstatusbutton=$("#sessionstatus"),
        sessionstable=$("#sessionstable"),
        sessiondetailsmodal=$("#sessiondetailsmodal"),
        sessioncollectiontable=$("#sessioncollectiontable")

    getactivesession()
    getsessions()

    // check sesion status
    function getactivesession(){
        $.getJSON(
            "../controllers/sessionoperations.php",
            {
                getactivesession:true
            },
            (data)=>{
                if(data.length>0){
                    sessionstatusbutton.data("role",'close')
                    sessionstatusbutton.html("<i class='fal fa-lightbulb fa-lg fa-fw'></i> Close Active Session")
                }else{
                    sessionstatusbutton.data("role",'activate')
                    sessionstatusbutton.html("<i class='fal fa-lightbulb-on fa-lg fa-fw'></i> Activate New Session")
                }  
            }
        )
    }
   

    sessionstatusbutton.on("click",function(){
        if($(this).data("role")=="activate"){
            sessionnotifications.html("")
            //  request for opening float
            bootbox.prompt({
                title: "Please provide <strong>FLOAT</strong> amount",
                inputType: 'number',
                callback: function (result) {
                    if(result==""){
                        sessionnotifications.html(showAlert("info",`Please provide float amount first`))
                    }else{
                        sessionnotifications.html(showAlert("processing","Processing. Please wait ...",1))
                        $.post(
                            "../controllers/sessionoperations.php",
                            {
                                activatesession:true,
                                float:result
                            },
                            (data)=>{
                                if(isJSON(data)){
                                    data=JSON.parse(data)
                                    if(data.status=="success"){
                                        sessionnotifications.html(showAlert("success",`New Session activated successffully`))
                                        // refresh sessions list
                                        getsessions()
                                        // getactive session
                                        getactivesession()
                                    }
                                }else{
                                    sessionnotifications.html(showAlert("danger",`Sorry an error occured ${data}`))
                                }
                            }
                        )
                    }
                }
            });
        }else{
            // confirm closure
            bootbox.dialog({
                // title: "Confirm Item Removal!",
                 message: "Are you sure you want to close <strong>Active Session</strong>?",
                 buttons: {
                     success: {
                         label: "No, Leave Open",
                         className: "btn-success btn-sm",
                         callback: function() {
                             $('.bootbox').modal('hide');
                         }
                     },
                     danger: {
                         label: "Yes, Close Session",
                         className: "btn-danger btn-sm",
                         callback: function() {
                             //console.log(parent)
                             $.post(
                                "../controllers/sessionoperations.php",
                                {
                                    closesession:true
                                },
                                (data)=>{
                                    if(isJSON(data)){
                                        data=JSON.parse(data)
                                        if(data.status=="success"){
                                            sessionnotifications.html(showAlert("success",`Active Session closed successfully`))
                                            // refresh sessions list
                                            getsessions()
                                            // get active session
                                            getactivesession()
                                        }
                                    }else{
                                        sessionnotifications.html(showAlert("danger",`Sorry an error occured ${data}`))
                                    }
                                }
                             )
                             $('.bootbox').modal('hide');
                         }
                     }
                 }
             })
        }
    })

    // function get sessions
    function getsessions(){
        $.getJSON(
            "../controllers/sessionoperations.php",
            {
                getsessions:true
            },
            (data)=>{
                let results=''
                data.forEach((session,i)=>{
                    results+=`<tr data-id='${session.sessionid}'>`
                    results+=`<td>${$.number(i+1)}</td>`
                    results+=`<td>${session.sessionid}</td>`
                    results+=`<td>${session.starttime}</td>` 
                    results+=`<td>${session.openedby}</td>`
                    results+=`<td>${session.dateclosed==null?'-':session.dateclosed}</td>`
                    results+=`<td>${session.closedby}</td>`
                    results+=`<td>${toTitleCase(session.status)}</td>`
                    results+=`<td><a href='#' class='btn btn-sm btn-outline-secondary sessionsummary'><i class='fal fa-chart-line fa-lg fa-fw'></></a></td></tr>` 
                })
                makedatatable(sessionstable,results,15)
                // sessionstable.find("tbody").html(results)
            }
        )
    }

    sessionstable.on("click",".sessionsummary",function(){
        const sessionid=$(this).closest("tr").data("id")
        sessiondetailsmodal.modal("show")
        $.getJSON(
            "../controllers/sessionoperations.php",
            {
                getsessioncollection:true,
                sessionid
            },
            (data)=>{
                let results='', total=0
                data.forEach((payment,i)=>{
                    results+=`<tr><td>${i+1}</td>`
                    results+=`<td>${payment.paymentmode}</td>`
                    results+=`<td>${$.number(payment.amount)}</td>`
                    results+=`<td><a href="#"><i class='fal fa-info fa-lg fa-fw'></i></a></td></tr>`
                    total+=Number(payment.amount)
                })
                results+=`<tr><td colspan='2'>Total:</td>`
                results+=`<td colspan='2'>${$.number(total,2)}</td><tr/>`
                sessioncollectiontable.find("tbody").html(results)
            }
        )
    })
})