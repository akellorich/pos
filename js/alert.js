function showAlert(type,message,hideheading=0){
    var alert=""
    switch (type) {
        case "warning":
            alert="<div class='alert alert-warning alert-white rounded'>"
            alert+="<button type='button' data-dismiss='alert' aria-hidden='true' class='close'></button>"
            alert+="<div class='icon'>"
            alert+="<i class='fas fa-exclamation-triangle'></i>"   
            alert+="</div>"
            if(hideheading==0){
                alert+="<div class='alert-title'><strong>Warning!</strong></div>"
            }
            alert+="<div class='alert-message'>"+message+"</div></div> "
            break;
        case "info":
            alert="<div class='alert alert-info alert-white rounded'>"
            alert+="<button type='button' data-dismiss='alert' aria-hidden='true' class='close'></button>"
            alert+="<div class='icon'>"
            alert+="<i class='fa fa-info-circle'></i>"   
            alert+="</div>"
            if(hideheading==0){
                alert+="<div class='alert-title'><strong>Information!</strong></div>"
            }
            alert+="<div class='alert-message'>"+message+"</div></div> "
            break;
        case "error":
        case "danger":
            alert="<div class='alert alert-danger alert-white rounded'>"
            alert+="<button type='button' data-dismiss='alert' aria-hidden='true' class='close'></button>"
            alert+="<div class='icon'>"
            alert+="<i class='fa fa-times-circle'></i>"   
            alert+="</div>"
            if(hideheading==0){
                alert+="<div class='alert-title'><strong>Danger!</strong></div>"
            }
            alert+="<div class='alert-message'>"+message+"</div></div> "
            break;
        
        case "success":
            alert="<div class='alert alert-success alert-white rounded'>"
            alert+="<button type='button' data-dismiss='alert' aria-hidden='true' class='close'></button>"
            alert+="<div class='icon'>"
            alert+="<i class='fas fa-check-circle'></i>"   
            alert+="</div>"
            if(hideheading==0){
                alert+="<div class='alert-title'><strong>Success!</strong></div>"
            }
            alert+="<div class='alert-message'>"+message+"</div></div> "
            break;
        case "progress":
        case "processing":
                alert="<div class='alert alert-info alert-white rounded'>"
                alert+="<button type='button' data-dismiss='alert' aria-hidden='true' class='close'></button>"
                alert+="<div class='icon'>"
                alert+="<i class='fas fa-spin fa-spinner'></i>"   
                alert+="</div>"
                if(hideheading==0){
                    alert+="<div class='alert-title'><strong>Success!</strong></div>"
                }
                alert+="<div class='alert-message'>"+message+"</div></div> "
                break;
    }
    return alert

}