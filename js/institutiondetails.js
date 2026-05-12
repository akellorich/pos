$(document).ready(function(){
    const companynamefield=$("#companyname"),
        pinnofield  =$("#pinno"),
        mainbusinesstypefield=$("#mainbusinesstype"),
        physicaladdressfield=$("#physicaladdress"),
        postaladdressfield=$("#postaladdress"),
        townfield=$("#town"),
        postalcodefield=$("#postalcode"),   
        emailfield=$("#emailaddress"),
        mobilefield=$("#mobile"),
        landlinefield=$("#landline"),
        websitefield=$("#website"),
        taglinefield=$("#tagline"), 
        defaultcustomerfield=$("#defaultcustomer"),
        autoinvoicegrnfield=$("#autogrninvoice"),
        showwaiterloginfield=$("#showwaiterlogin"),
        receiptfooterfield=$("#receiptfooter"),
        savebutton=$("#saveinstitution"),
        notifications=$("#notifications"),
        logopreview=$("#logopreview"),
        loadlogobutton=$("#logo"),
        inputfield=$("input"),
        selectfield=$("select")

    let logochanged=true, savedlogo=''

    inputfield.on("input",()=>{
        notifications.html("") 
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    // preview logo
    loadlogobutton.on("change",function(){
        if (this.files && this.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                logopreview.attr('src', e.target.result);
                logochanged=true
            }
            reader.readAsDataURL(this.files[0]);
        }
    })

    savebutton.on("click",()=>{ 
        const pinno=sanitizestring(pinnofield.val()),
            companyname=sanitizestring(companynamefield.val()),
            mainbusinesstype=mainbusinesstypefield.val(),
            physicaladdress=sanitizestring(physicaladdressfield.val()),
            postaladdress=sanitizestring(postaladdressfield.val()),
            town=sanitizestring(townfield.val()),
            postalcode=sanitizestring(postalcodefield.val()),
            emailaddress=sanitizestring(emailfield.val()),
            mobile=sanitizestring(mobilefield.val()),
            landline=sanitizestring(landlinefield.val()),
            website=sanitizestring(websitefield.val()),
            tagline=sanitizestring(taglinefield.val()),
            defaultcustomer=defaultcustomerfield.val(),
            autoinvoicegrn=autoinvoicegrnfield.val(),
            showwaiterlogin=showwaiterloginfield.val(),
            receiptfooter=sanitizestring(receiptfooterfield.val()),
            fd = new FormData(),
            logo = $('#logo')[0].files[0]

        //   check for blank fields
        let errors=''
        if(companyname==""){
            errors="Please provide company name"
            companynamefield.focus()
        }else if(pinno==""){
            errors="Please provide PIN number"
            companynamefield.focus()
        }else if(mainbusinesstype==""){
            errors="Please select main business type"
            mainbusinesstypefield.focus()
        }else if(physicaladdress==""){
            errors="Please provide physical address"
            physicaladdressfield.focus()
        }else if(postaladdress==""){
            errors="Please provide postal address"
            postaladdressfield.focus()
        }else if(town==""){
            errors="Please provide town"
            townfield.focus()
        }else if(postalcode==""){
            errors="Please provide postal code"
            postalcodefield.focus()
        }else if(emailaddress==""|| !validatefielddata(emailaddress,'email')){
            errors="Please provide email address or check format"
            emailfield.focus()
        }else if(mobile=="" || !validatefielddata(mobile,'mobile')){
            errors="Please provide mobile number or check format"
            mobilefield.focus()
        }else if(defaultcustomer==""){
            errors="Please select default customer"
            defaultcustomerfield.focus()
        }else if(autoinvoicegrn==""){
            errors="Please provide auto invoicing during GRN status"
            autoinvoicegrnfield.focus()
        }else if(showwaiterlogin==""){
            errors="Please select shopw waiter login window status"
            showwaiterloginfield.focus()
        }else if(receiptfooter==""){
            errors="Please select receipt footer"
            receiptfooterfield.focus()
        }else if(typeof logo === 'undefined' && logochanged){
            errors="Please select logo"
            loadlogobutton.focus()
        }

        if(errors==""){
            notifications.html(showAlert("processing","Saving institution details. Please wait ...",1))

            if(loadlogobutton.val()!=""){
                fd.append('logo',logo)
            }else{
                fd.append("savedlogo",savedlogo)
            }

            fd.append('saveinstitutiondetails',true)
            fd.append('pinno',pinno)
            fd.append('companyname',companyname)
            fd.append('mainbusinesstype',mainbusinesstype)
            fd.append('physicaladdress',physicaladdress)
            fd.append('postaladdress',postaladdress)
            fd.append('town',town)
            fd.append('postalcode',postalcode)
            fd.append('emailaddress',emailaddress)
            fd.append('mobile',mobile)
            fd.append('landline',landline)  
            fd.append('website',website)    
            fd.append('tagline',tagline)    
            fd.append('defaultcustomer',defaultcustomer)    
            fd.append('autoinvoicegrn',autoinvoicegrn)  
            fd.append('showwaiterlogin',showwaiterlogin)    
            fd.append('receiptfooter',receiptfooter)  
            
            $.ajax({
                url:  "../controllers/settingoperations.php",
                type: 'post',
                data: fd,
                contentType: false,
                processData: false,
                success: function(response){
                    if(isJSON(response)){
                        response=JSON.parse(response)
                        if(response.status =="success"){
                            notifications.html(showAlert("success","Institution details successfully"))
                            // refresh the attachments list
                            loadlogobutton.val("")
                        }
                    }
                    else{
                        results=`Sorry an error occured. ${response}`
                        notifications.html(showAlert("danger",results))
                    }
                }
            })

        }else{
            notifications.html(showAlert("info",errors))
        }
    })

    // get institutional details
    $.getJSON(
        "../controllers/settingoperations.php",
        {
            getinstitutiondetails:true
        },
        function(data){
            if(data.length>0){
                const institution=data[0]
                logochanged=false
                // console.log(institution.autoaddinvoiceduringgrn)
                savedlogo=institution.logo
                companynamefield.val(institution.name)
                pinnofield.val(institution.pinno)
                mainbusinesstypefield.val(institution.mainbusinesstype)
                physicaladdressfield.val(institution.physicaladdress)
                postaladdressfield.val(institution.postaladdress)
                townfield.val(institution.town)
                postalcodefield.val(institution.postalcode)
                emailfield.val(institution.email)
                mobilefield.val(institution.mobile)
                landlinefield.val(institution.landline)
                websitefield.val(institution.website)
                taglinefield.val(institution.tagline)

                getCustomers(defaultcustomerfield).done(()=>{
                    defaultcustomerfield.val(institution.defaultcustomerid)
                })
                
                autoinvoicegrnfield.val(institution.autoaddinvoiceduringgrn)
                showwaiterloginfield.val(institution.showwaiterlogin)
                receiptfooterfield.val(institution.receiptfooter)

                if(institution.logo!="" && institution.logo!=null){
                    logopreview.attr('src', institution.logo)
                }
                
            }else{
                notifications.html(showAlert("info","No institution details found"))
            }
        }
    )

})