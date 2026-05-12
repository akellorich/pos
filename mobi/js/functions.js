var validationanchor=$(".validation")
 
// check if the user has been logged in otherwise redirect to the login page
$.getJSON(
  "../../controllers/useroperations.php",
  {
     getloggedinuserid:true
  },
  function(data){
     data=$.trim(data).toString()
     if(data==""){
       window.location.href="../../index.php"
     }
  }
)

function json2table(json, classes) {
   var cols = Object.keys(json[0]);
  
   var headerRow = '';
   var bodyRows = '';
   
   classes = classes || '';
 
   function capitalizeFirstLetter(string) {
     return string.charAt(0).toUpperCase() + string.slice(1);
   }
 
   cols.map(function(col) {
     headerRow += '<th>' + capitalizeFirstLetter(col) + '</th>';
   });
 
   json.map(function(row) {
     bodyRows += '<tr>';
 
     cols.map(function(colName) {
       bodyRows += '<td>' + row[colName] + '</td>';
     })
 
     bodyRows += '</tr>';
   });
 
   return '<table class="' +
          classes +
          '"><thead><tr>' +
          headerRow +
          '</tr></thead><tbody>' +
          bodyRows +
          '</tbody></table>';
}

//generate a random Id to be used to delete rdata from the list
function randomId(){
 return Math.floor((Math.random()*10000)+1)
}

function setLoggedInUserName(){
 //console.log("Fetching data...")
 var username=''
 $.getJSON(
   "../../controllers/useroperations.php",
   {
     getloggedinusername:true
   },
   function(data){
     username=$.trim(data.toString())
     //console.log(data.toString())
     $("#loggedinusername").html(username)
   }
 ).fail(function (jqxhr, status, error) { 
   console.log('error', status, error) }
 )}

function getProductCategories(selectname, opt){
 var deferred=new $.Deferred()
 // get all product categories
 $.getJSON(
   "../../controllers/getcategories.php",
   function(data){
     var results=''
     opt==="all"?results+='<option value="0">&lt;All&gt</option>':results+='<option value="0">&lt;Choose One&gt;</option>'
     for(var i=0;i<data.length;i++){
       results+="<option value='"+data[i].categoryid+"'>"+data[i].categoryname+"</option>"
     }
     //console.log(results)
     selectname.html(results)
     deferred.resolve()
   }
 )
 return  deferred.promise()
}

function getInstitutionDetails(){
 $.getJSON(
   "../../controllers/settingoperations.php",
   {
     getinstitutiondetails:true
   },
   function(data){
     $("#companyname").html(data[0].name)
     $(document).prop('title',data[0].name+" Management Information System")
     // console.log(data)
   }
 )
}

function getPointsOfSale(selectBox,option='all'){
 var dfd=new $.Deferred()
   $.getJSON(
   "../../controllers/posoperations.php",
   {
     getpointsofsale:true
   },
   function(data){
       var results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose One&gt;</option>"
       for( var i=0;i<data.length;i++){
           results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
       }
       $(results).appendTo(selectBox)
       dfd.resolve()
   })
   return dfd.promise()
 }

function getPaymentModes(selectBox,option='all'){
 $.getJSON(
   "../../controllers/settingoperations.php",
   {
     getpaymentmethods:true
   },
   function(data){
       var results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose One&gt;</option>"
       for (var i = 0; i < data.length; i++) {
           results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
       } 
       $(results).appendTo(selectBox)
   })
}

function getSuppliers(selectBox, option='all'){
 $.getJSON(
   "../../controllers/getsuppliers.php",
   function(data){
       var results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose One&gt;</option>"
       for (var i = 0; i < data.length; i++) {
           results+="<option value='"+data[i].supplierid+"'>"+data[i].suppliername+"</option>"
       } 
       $(results).appendTo(selectBox)
   })
}

function getCashbookAccounts(selectBox,option='all'){
 $.getJSON(
   "../../controllers/glaccountoperations.php",
   {
     getcashbookaccounts:true
   },
   function(data){
     var results=''
     option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose One&gt;</option>"
     for(var i=0;i<data.length;i++){
       results+="<option value='"+data[i].id+"'>"+data[i].accountname+"</option>"
     }
     selectBox.html(results)
   }
 )
}

function getGLAccounts(selectBox,groupid=0,option='all'){
 $.getJSON(
   "../../controllers/glaccountoperations.php",
   {
     getglaccounts:true,
     groupid:groupid
   },
   function(data){
     var results=""
     option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose One&gt;</option>"
     for(var i=0;i<data.length;i++){
       results+="<option value='"+data[i].id+"'>"+data[i].accountname+"</option>"
     }
     selectBox.html(results)
   }
 )
}

// check if we are on edit mode
function urlParam(name){
 var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
 if (results==null) {
     return null;
 }
 return decodeURI(results[1]) || 0;
}

setLoggedInUserName()
getInstitutionDetails()

// listen to validation anchor click event

validationanchor.on("click",function(e){
 var id=$(this).attr("id") 
 pagetonavigate=$(this).attr("href")
 //console.log(pagetonavigate)
 e.preventDefault()
 //console.log($(this).attr("href"))
 // check if this is a resticted menu and send as sms to the manager
 checkrestrictedmenu(id)
 $.post(
   "../../controllers/useroperations.php",
   {
     getuserprivilege:true,
     objectid: id
   },
   function(data){
     var allowed=parseInt($.trim(data.toString()))
     if(allowed==0){
       bootbox.alert({
         message: "Sorry. Your are not authorized to perform this operation.",
       })
     }else{
       window.location.href=pagetonavigate
     }
   }
 )
})

function checkrestrictedmenu(id){
 dfd=new $.Deferred()
 $.post(
   "../../models/sms.php",
   {
     sendmenuaccessmessage:true,
     menuid:id
   },
   function(data){
     dfd.resolve()
   }
 )
 return dfd.promise()
}

$.datepicker.setDefaults({
 dateFormat: 'dd-M-yy',
 maxDate: new Date()
});


var DateDiff = {

 inDays: function(d1, d2) {
     var t2 = d2.getTime();
     var t1 = d1.getTime();

     return parseInt((t2-t1)/(24*3600*1000));
 },

 inWeeks: function(d1, d2) {
     var t2 = d2.getTime();
     var t1 = d1.getTime();

     return parseInt((t2-t1)/(24*3600*1000*7));
 },

 inMonths: function(d1, d2) {
     var d1Y = d1.getFullYear();
     var d2Y = d2.getFullYear();
     var d1M = d1.getMonth();
     var d2M = d2.getMonth();

     return (d2M+12*d2Y)-(d1M+12*d1Y);
 },

 inYears: function(d1, d2) {
     return d2.getFullYear()-d1.getFullYear();
 }
}

jQuery.fn.center = function () {
   this.css("position","absolute");
   this.css("left", 
    Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + 
    $(window).scrollLeft()) + "px");
   return this;
}

function formatDate(date1){
  const date = new Date(date1);
  const formattedDate = date.toLocaleDateString('en-GB', {
    day: 'numeric', month: 'short', year: 'numeric'
  }).replace(/ /g, '-');
  return formattedDate
}

function toTitleCase(str) {
  return str.replace(/(?:^|\s)\w/g, function(match) {
    return match.toUpperCase();
  });
}


