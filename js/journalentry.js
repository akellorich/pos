$(document).ready(function(){
    var glaccountlist=$("#glaccount"),
        addtolistbutton=$("#add"),
        narrationfield=$("#narration"),
        debitfield=$("#debit"),
        creditfield=$("#credit"),
        journalentries=$("#journalentries").find("tbody"),
        errordiv=$("#errors"),
        journaldescriptionfield=$("#journaldescription"),
        journalreferencefield=$("#referenceno"),
        clearform=$("#clear"),
        totaldebitsfield=$("#debits"),
        totalcreditsfield=$("#credits"),
        differencefield=$("#difference"),
        savebutton=$("#save")

    // get all gl accounts
    getGLAccounts(glaccountlist,0,'one')
    // listen to add button click event
    addtolistbutton.on("click",function(){
        var glaccount=glaccountlist.val(),
            narration=narrationfield.val(),
            debit=debitfield.val(),
            credit=creditfield.val(),
            errors=""
        // check for blank fields
        if(glaccount==""){
            errors="Please select GL account first."
            glaccountlist.focus()
        }else if(narration==""){
            errors="Please provide narration first."
            narrationfield.focus()
        }else if(debit=="" && credit==""){
            errors="Please provide either debit or credit value first."
        }
        if(errors==""){
            // add to the list and perform totals
            var item="",i
            i=journalentries.find("tr").length+1
            
            $(item).appendTo(journalentries)+1
            item+="<tr><td data-id='"+glaccount+"'>"+i+"</td>"
            item+="<td >"+glaccountlist.children(':selected').text()+"</td>"
            item+="<td>"+narration+"</td>"
            item+="<td class='debit'>"+debit+"</td>"
            item+="<td class='credit'>"+credit+"</td>"
            item+="<td><a href='javascript void(0)' class='edit' data-id='"+glaccount+"'><span><i class='mt-1 far fa-edit fa-lg fa-fw'></i></span></a></td>"
            item+="<td><a href='javascript void(0)' class='delete' data-id='"+randomId()+"'><i class='mt-1 fas fa-trash fa-lg fa-fw'></i></span></a></td></tr>"
            $(item).appendTo(journalentries)
            clearJournalDetails()
            //perform totals
            getTotals()
        }else{
            // display the error
            errors="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-fw fa-lg'></i> "+errors+"</div>"
            errordiv.html(errors)
        }
    })

    debitfield.on("input",function(){
        creditfield.val(0)
    })

    creditfield.on("input",function(){
        debitfield.val(0)
    })

    // listen to edit button clicks
    journalentries.on("click",'.edit',function(e){
        e.preventDefault();
        var id = $(this).attr('data-id'),
            parent = $(this).parent("td").parent("tr"),
            narration=parent.find("td").eq(2).text(),
            debit=parent.find("td").eq(3).text(),
            credit=parent.find("td").eq(4).text()
            parent.remove()
            // show items on edit controls
            glaccountlist.val(id),
            narrationfield.val(narration),
            debitfield.val(debit),
            creditfield.val(credit)
            // perform totals
            getTotals()
    })

    // listen to delete button clicks
    journalentries.on("click",'.delete',function(e){
        e.preventDefault();
        var id = $(this).attr('data-id'),
            parent = $(this).parent("td").parent("tr")
            // perform totals

            bootbox.dialog({
            title: "Confirm journal entry removal!",
            message: "Remove journal entry from the list?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success",
                    callback: function() {
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger",
                    callback: function() {
                        parent.remove()
                        $('.bootbox').modal('hide');
                        // perform total
                    }
                }
            }
        })
    })

    // perform totals
    function getTotals(){
        var totaldebits=0,
            totalcredits=0,
            difference=0
        $(".debit").each(function(){
            var value = $(this).text();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                totaldebits += parseFloat(value);
            }
        })

        $(".credit").each(function(){
            var value = $(this).text();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                totalcredits += parseFloat(value);
            }
        })

        totaldebitsfield.text($.number(totaldebits,2))
        totalcreditsfield.text($.number(totalcredits,2))
        if(totaldebits>totalcredits){
            difference=totaldebits-totalcredits
            differencefield.html("<span class='text-danger'><i class='fas fa-exclamation-triangle fa-lg fa-fw'></i> Difference: "+$.number(difference)+" (DR)</span>")
        }else if(totalcredits>totaldebits){
            difference=totalcredits-totaldebits
            differencefield.html("<span class='text-danger'><i class='fas fa-exclamation-triangle fa-lg fa-fw'></i> Difference: "+$.number(difference)+" (CR)</span>")
        }else{
            differencefield.text("0.00")
        }
    }

    // clear all errors on change events of any inputs
    $("input").on("input",function(){
        errordiv.html("")
    })

    clearform.on('click',function(){
        // confirm to clear
        clearForm()
    })

    function clearForm(){
        clearJournalDetails()
        journalentries.html("")
        journaldescriptionfield.val("")
        journalreferencefield.val("")
        journaldescriptionfield.focus()
    }

    function clearJournalDetails(){
        glaccountlist.val("")
        narrationfield.val("")
        debitfield.val("")
        creditfield.val("")
        totaldebitsfield.text("")
        totalcreditsfield.text("")
        differencefield.text("")
    }

    //listen to save button
    savebutton.on("click",function(){
        // check for blank fields
        var description=journaldescriptionfield.val(),
            reference=journalreferencefield.val(),
            data=[],
            errors=""
        if(description==""){
            errors="Please provide description for the journal entry."
            journaldescriptionfield.focus()
        }else if(reference==""){
            errors="Please provide Reference No for the journal entry."
            journalreferencefield.focus()
        }else if(journalentries.find("tr").length<1){
            // check if at least 2 entries in the list
            errors="Please provide at least 2 ledger entries first."
        }else if(differencefield.text()!="0.00"){
            errors="Please ensure both Debits and Credits match first."
        }
        if(errors==""){
            // get the ledger entries
            journalentries.find("tr").each(function(){
                var tds = $(this).find('td')
                if(tds.length != 0) {
                    //console.log(tds.eq(0).attr("data-id"))
                    glaccount = tds.eq(0).attr("data-id")
                    narration = tds.eq(2).text()
                    debit = tds.eq(3).text()
                    credit = tds.eq(4).text()
                    data.push({glaccount: glaccount,narration: narration,debit: debit, credit: credit})
                }
            })
            var TableData=JSON.stringify(data)
            console.log(reference)
            $.post(
                "../controllers/journaloperations.php",
                {
                    savejournal:true,
                    TableData:TableData,
                    referenceno:reference,
                    description:description
                },
                function(data){
                    data=$.trim(data)
                    if(data=="success"){
                        results="<div class='alert alert-success' role='alert'><i class='fas fa-check-circle fa-lg fa-fw'></i> Journal added to the system successfully.</div>"
                        // clear fields
                        clearForm()
                    }else{
                        results="<div class='alert alert-danger' role='alert'><i class='fas fa-times-circle fa-lg fa-fw'></i> "+data+"</div>"
                    }

                    errordiv.html(results)
                }
            )
        }else{
            errors="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg fa-fw'></i> "+errors+"</div>"
            errordiv.html(errors)
        } 
    })

})