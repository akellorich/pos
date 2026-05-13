class ESCPOSEncoder {
  constructor(printerWidth = 48) {
    this.commands = [];
    this.printerWidth = printerWidth; // Default width in characters (depends on printer model)
  }

  initialize() {
    this.commands.push('\x1B\x40'); // ESC @: Initialize printer
    return this;
  }

  multiplelines(params){
    params.forEach((content)=>{
        this.commands.push(content);
        this.feed()
    })
    return this
  }

  text(content) {
    this.commands.push(content); // Add plain text
    return this;
  }

  bold(enable = true) {
    this.commands.push(enable ? '\x1B\x45\x01' : '\x1B\x45\x00'); // ESC E 1: Bold on, ESC E 0: Bold off
    return this;
  }

  doubleSize(enable = true) {
    this.commands.push(enable ? '\x1D\x21\x10' : '\x1D\x21\x00'); // GS ! 16: 1.5x width, GS ! 0: Reset
    return this;
  }


  newline(lines = 1) {
    for (let i = 0; i < lines; i++) {
      this.commands.push('\n'); // Add newline(s)
    }
    return this;
  }

  align(position) {
    const alignments = {
      left: '\x1B\x61\x00',    // ESC a 0: Align left
      center: '\x1B\x61\x01',  // ESC a 1: Align center
      right: '\x1B\x61\x02',   // ESC a 2: Align right
    };
    this.commands.push(alignments[position] || alignments.left);
    return this;
  }

  line(character = '-', repeat = null) {
    const repeatCount = repeat || this.printerWidth;
    const line = character.repeat(repeatCount).substring(0, this.printerWidth);
    this.commands.push(line);
    this.newline(); // Add a newline after the line
    return this;
  }

  cut() {
    this.commands.push('\x1D\x56\x41'); // ESC i: Full cut
    this.commands.push('\x1B\x64\x02'); // ESC d 2: Feed 2 lines (to flush the buffer)
    return this;
  }

  feed(lines = 1) {
    this.commands.push('\x1B\x64' + String.fromCharCode(lines)); // ESC d n: Feed n lines
    return this;
  }

  tableRows(rows, alignments) {
    rows.forEach(row => {
      this.tableRow(row, alignments); // Use the existing tableRow method
    });
    return this;
  }

  // Encode a table row
  tableRow(columns, alignments) {
    const columnWidths = this.calculateColumnWidths(columns.length);
    let row = '';

    for (let i = 0; i < columns.length; i++) {
      const col = columns[i];
      const width = columnWidths[i];
      const alignment = alignments[i] || 'left';

      // Align the text in the column
      row += this.formatText(col, width, alignment);
    }

    this.commands.push(row); // Add the formatted row to commands
    this.newline(); // Add a newline after each row
    return this;
  }

  barcode(data, type = 'CODE128', height = 150, width = 2, position = 'below') {
    // Set barcode height
    this.commands.push('\x1D\x68' + String.fromCharCode(height)); // GS h: Barcode height (1–255)

    // Set barcode width
    this.commands.push('\x1D\x77' + String.fromCharCode(width)); // GS w: Barcode width (2–6)

    // Set human-readable text position
    const textPositions = {
      none: '\x1D\x48\x00',    // No text
      above: '\x1D\x48\x01',   // Text above barcode
      below: '\x1D\x48\x02',   // Text below barcode
      both: '\x1D\x48\x03',    // Text above and below
    };
    this.commands.push(textPositions[position] || textPositions.below);

    // Select barcode type and add data
    const barcodeTypes = {
      UPC_A: '\x1D\x6B\x00',
      UPC_E: '\x1D\x6B\x01',
      EAN13: '\x1D\x6B\x02',
      EAN8: '\x1D\x6B\x03',
      CODE39: '\x1D\x6B\x04',
      ITF: '\x1D\x6B\x05',
      CODE128: '\x1D\x6B\x49', // GS k I: CODE128
    };

    const typeCommand = barcodeTypes[type.toUpperCase()] || barcodeTypes.CODE128;
    this.commands.push(typeCommand + String.fromCharCode(data.length) + data); // Add barcode type and data

    this.newline(); // Add a newline after the barcode
    return this;
  }

  // Calculate equal column widths based on the number of columns
  calculateColumnWidths(numColumns) {
    const totalWidth = this.printerWidth; // Total width of the printer
    return Array(numColumns).fill(Math.floor(totalWidth / numColumns));
  }

  // Format text for a single column
  formatText(text, width, alignment) {
    if (text.length > width) {
      text = text.substring(0, width); // Truncate text if it exceeds column width
    }

    switch (alignment) {
      case 'right':
        return text.padStart(width);
      case 'center':
        const padding = Math.floor((width - text.length) / 2);
        return ' '.repeat(padding) + text + ' '.repeat(width - text.length - padding);
      default: // 'left'
        return text.padEnd(width);
    }
  }

  encode() {
    return this.commands; // Return as an array of strings
  }
}

const fetchData = async (url, params) => {
  const queryString = new URLSearchParams(params).toString()
  const response = await fetch(`${url}?${queryString}`)
  if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
  }
  return await response.json()
}


let validationanchor=$(".validation")
  fullscreen=false,
  defaultcustomerid=0,
  userid=0,
  printreceipt=0,
  showwaiterlogin=0

// check if the user has been logged in otherwise redirect to the login page
// getloggedinuser()

function getloggedinuser(homepage=0){
  const dfd=$.Deferred()
  const url= homepage==1? "controllers/useroperations.php" : "../controllers/useroperations.php";
  // console.log("Fetching logged in user data from: ", url)
  $.getJSON(
    url,
    {
      getloggedinuserid:true
    },
    function(data){
      if(data.status!=="loggedin"){
          window.location.href="../index.html"
      }else{
        const profilenamefield=$(".profile_name"),
        jobfield=$(".job")
        userid=data.userid
        // console.log(data)
        profilenamefield.html(data.firstname)
        jobfield.html(data.systemadmin==1?'System Admin':data.othernames)
      }
  })
}

// $(".btn").on("click",()=>{
//   getloggedinuser()
// })

// $("select").on("change",()=>{
//   getloggedinuser()
// })

function json2table(tablename, data,pagelength=15) {
  if (data.length > 0) {
      let headers = "", details = "", totals = ""
      let fieldnames = Object.keys(data[0])

      // Generate table headers
      headers += "<tr>"
      fieldnames.forEach((field) => {
          headers += `<th>${toTitleCase(field)}</th>`
      });
      headers += "</tr>"
      tablename.find("thead").html(headers)

      // Generate table body
      details = ""
      data.forEach((item) => {
          details += "<tr>"
          fieldnames.forEach((field) => {
              details += `<td>${item[field]}</td>`
          })
          details += "</tr>"
      })

      // Generate totals row inside <tfoot>
      totals = "<tr>";
      totals += `<td><strong>TOTALS:</strong></td>`; // First column as label
      fieldnames.slice(1).forEach((field) => {
          let total = 0
          if (!isNaN(parseFloat(data[0][field].replace(",", "")))) {
              data.forEach((itemtotal) => {
                  total += parseFloat(itemtotal[field].replace(",", ""))
              })
              totals += `<td><strong>${$.number(total, 2)}</strong></td>`
          } else {
              totals += `<td>-</td>`
          }
      });
      totals += "</tr>"

      // Append body content and totals row in <tfoot>
      tablename.find("tbody").html(details);
      tablename.find("tfoot").html(totals);

      // Destroy existing DataTable instance before reinitializing
      if ($.fn.DataTable.isDataTable(tablename)) {
          tablename.DataTable().destroy();
      }

      // Initialize DataTable with sorting but keep the totals row fixed at the bottom
      tablename.DataTable({
          dom:'<"top d-flex justify-content-between align-items-center"Blf>rtip', // Adds buttons to the interface
          "lengthMenu": [[10, 15, 25, 50, 100, -1], [10, 15,25, 50, 100, "All"]],
          "pageLength":pagelength,
          buttons: [
              {
                  extend: 'excelHtml5',
                  text: 'Export to Excel',
                  className: 'btn btn-sm btn-success mr-2'
              },
              {
                  extend: 'csvHtml5',
                  text: 'Export to CSV',
                  className: 'btn btn-sm btn-primary mr-2'
              },
              {
                  extend: 'pdfHtml5',
                  text: 'Export to PDF',
                  className: 'btn btn-sm btn-danger mr-2'
              },
              {
                  extend: 'print',
                  text: 'Send to Printer',
                  className: 'btn btn-sm btn-info'
              }
          ],
          orderCellsTop: true, // Ensures sorting applies only to the header
          drawCallback: function () {
              let api = this.api();
              let totalsRow = tablename.find("tfoot tr").detach();
              tablename.find("tfoot").append(totalsRow); // Reappend totals row after sorting
          }
      });
  }
}

function todaysDate() {
  const today = new Date();
  const options = { day: '2-digit', month: 'short', year: 'numeric' };
  return today.toLocaleDateString('en-GB', options).replace(',', '').replace(/ /g, '-');
}

//generate a random Id to be used to delete rdata from the list
function randomId(){
 return Math.floor((Math.random()*10000)+1)
}

function setLoggedInUserName(){
 //console.log("Fetching data...")
 var username=''
 $.getJSON(
   "../controllers/useroperations.php",
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
   "../controllers/getcategories.php",
   function(data){
     var results=''
     opt==="all"?results+='<option value="0">&lt;All&gt</option>':results+='<option value="0">&lt;Choose&gt;</option>'
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

function getInstitutionDetails(homepage=0){
  const dfd=$.Deferred()
  const url=homepage==0?"../controllers/settingoperations.php":"controllers/settingoperations.php"
  console.log("Fetching institution details from: ", url)
  $.getJSON(
    url,
    {
      getinstitutiondetails:true
    },
    (data)=>{
      data=data[0]
      console.log("Institution details: ", data)
      $("#companyname").html(data.name)
      showwaiterlogin=data.showwaiterlogin
      printreceipt=data.printreceipt
      $(document).prop('title',data.name+" Management Information System")
      dfd.resolve(data)
      // console.log(data)
    }
  )
  return dfd.promise()
}

function getPointsOfSale(selectBox,option='all'){
 var dfd=new $.Deferred()
   $.getJSON(
   "../controllers/posoperations.php",
   {
      getuseroutlets:true,
      userid:0
   },
   function(data){
       let results,
          singleoutlet=data.length==1?'selected':''
        option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
        for( var i=0;i<data.length;i++){
            results+=`<option value='${data[i].outletid}' ${singleoutlet}>${data[i].posname}</option>"`
        }
        selectBox.html(results)
        dfd.resolve()
   })
   return dfd.promise()
}

function getPaymentModes(selectBox,option='all'){
 $.getJSON(
   "../controllers/settingoperations.php",
   {
     getpaymentmethods:true
   },
   function(data){
       let results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
       for (var i = 0; i < data.length; i++) {
           results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
       } 
       selectBox.html(results)
      //  $(results).appendTo()
   })
}

function getSuppliers(selectBox, option='all'){
 $.getJSON(
   "../controllers/getsuppliers.php",
   function(data){
       var results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
       for (var i = 0; i < data.length; i++) {
           results+="<option value='"+data[i].supplierid+"'>"+data[i].suppliername+"</option>"
       } 
       $(results).appendTo(selectBox)
   })
}

function getCashbookAccounts(selectBox,option='all'){
 $.getJSON(
   "../controllers/glaccountoperations.php",
   {
     getcashbookaccounts:true
   },
   function(data){
     var results=''
     option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
     for(var i=0;i<data.length;i++){
       results+="<option value='"+data[i].id+"'>"+data[i].accountname+"</option>"
     }
     selectBox.html(results)
   }
 )
}

function getGLAccounts(selectBox,groupid=0,option='all'){
 $.getJSON(
   "../controllers/glaccountoperations.php",
   {
     getglaccounts:true,
     groupid:groupid
   },
   function(data){
     var results=""
     option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
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

function getloginuisettings(){
  const dfd=$.Deferred()
  $.getJSON(
    "controllers/settingoperations.php",
    {
      getloginuisettings:true
    },
    (data)=>{
      data=data[0]
      dfd.resolve(data)
    }
  )
  return dfd.promise()
}

// listen to validation anchor click event
function validateuserprivilege(id){
  const dfd=$.Deferred()
  $.post(
    "../controllers/useroperations.php",
    {
      getuserprivilege:true,
      objectid: id
    },
    function(data){
      dfd.resolve(data.trim()==1?true:false) 
    }
  )
  return dfd.promise()
}

validationanchor.on("click",function(e){
 var id=$(this).attr("id") 
 pagetonavigate=$(this).attr("href")
 //console.log(pagetonavigate)
 e.preventDefault()
 //console.log($(this).attr("href"))
 // check if this is a resticted menu and send as sms to the manager
 checkrestrictedmenu(id)
 $.post(
   "../controllers/useroperations.php",
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
   "../models/sms.php",
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

// $.datepicker.setDefaults({
//  dateFormat: 'dd-M-yy',
//  maxDate: new Date()
// });


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
   this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + 
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

function getCustomers (selectBox,option='all', regularcustomers=1,onetimecustomers=0){
  const dfd=$.Deferred()
 $.getJSON(
   "../controllers/customeroperations.php",
   {
     getcustomers:true,
     regularcustomers,
     onetimecustomers
   },
   function(data){
     if(data.length > 0){
       defaultcustomerid=data[0].defaultcustomerid
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
       for(var i=0;i<data.length;i++){
         results+="<option value='"+data[i].customerid+"'>"+data[i].customername+"</option>"
       }
       selectBox.html(results)
       selectBox.val(defaultcustomerid)
     }else{
        option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
        selectBox.html(results)
     }
     dfd.resolve()
   }
 )
 return dfd.promise()
}

function getvehicles(selectBox,option='all'){
 const dfd=new $.Deferred()
   $.getJSON(
   "../controllers/fleetoperations.php",
   {
     getvehicles:true
   },
   function(data){
       let results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
       for( var i=0;i<data.length;i++){
           results+="<option value='"+data[i].vehicleid+"'>"+data[i].regno+"</option>"
       }
       $(results).appendTo(selectBox)
       dfd.resolve()
   })
   return dfd.promise()
}

function getsystemusers(selectBox,option='all'){
 const dfd=new $.Deferred()
   $.getJSON(
   "../controllers/useroperations.php",
   {
     getuserslist:true
   },
   function(data){
       var results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
       for( var i=0;i<data.length;i++){
           results+=`<option value='${data[i].id}'>${data[i].firstname} ${data[i].middlename} ${data[i].lastname}</option>`
       }
       selectBox.html(results)
      //  $(results).appendTo(selectBox)
       dfd.resolve()
   })
   return dfd.promise()
}

function getallproducts(selectBox, option='all'){
 var dfd=new $.Deferred()
 $.getJSON(
   "../controllers/productoperations.php",
   {
       filterproductbyname:true,
       name:''
   },
   function(data){
       var results
       option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
       for( var i=0;i<data.length;i++){
           results+="<option value='"+data[i].productid+"'>"+data[i].itemname+"</option>"
       }
       $(results).appendTo(selectBox)
       dfd.resolve()
   })
   return dfd.promise()
}

function getspoilagecategories(selectBox, option='all'){
  $.getJSON(
    "../controllers/spoilageoperations.php",
    {
      getspoilagecategories:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((spoilagecategory)=>{
        results+=`<option value='${spoilagecategory.id}'>${spoilagecategory.categoryname}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}

function getscurrencies(selectBox, option='all'){
  $.getJSON(
    "../controllers/settingoperations.php",
    {
      getcurrencies:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((currency)=>{
        results+=`<option value='${currency.id}' ${currency.default==1?'data-default=1':'data-default=0'} ${currency.default==1?'selected':''}>${currency.currencyname}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}


const maximizebutton=$("#maximizebutton")
/* Get the documentElement (<html>) to display the page in fullscreen */
const  elem = document.documentElement;

/* View in fullscreen */
function openFullscreen() {
  if (elem.requestFullscreen) {
    elem.requestFullscreen();
  } else if (elem.webkitRequestFullscreen) { /* Safari */
    elem.webkitRequestFullscreen();
  } else if (elem.msRequestFullscreen) { /* IE11 */
    elem.msRequestFullscreen();
  }
  fullscreen=true
}

function closeFullscreen() {
  if (document.exitFullscreen) {
    document.exitFullscreen();
  } else if (document.webkitExitFullscreen) { /* Safari */
    document.webkitExitFullscreen();
  } else if (document.msExitFullscreen) { /* IE11 */
    document.msExitFullscreen();
  }
  fullscreen=false
}

maximizebutton.on("click",function(e){
  e.preventDefault()
  const $this=$(this)
  $this.hasClass("fullscreen")?closeFullscreen():openFullscreen() 
  $this.toggleClass("fullscreen")
})

$("body").on("load",()=>{
  if(fullscreen){
    openFullscreen()
  }
})

function setDatePicker(controlname,maxdate=true, mindate=false){
  if(maxdate){
      controlname.datepicker({ 
          yearRange: "c-70:c+0",
          dateFormat: 'dd-M-yy',
          changeMonth:true,
          changeYear:true,
          maxDate: new Date()
      })
  }else if(mindate){
      controlname.datepicker({ 
          yearRange: "c-0:c+20",
          dateFormat: 'dd-M-yy',
          changeMonth:true,
          changeYear:true,
          minDate: new Date()
      })
  }else{
      controlname.datepicker({ 
          yearRange: "c-70:c+20",
          dateFormat: 'dd-M-yy',
          changeMonth:true,
          changeYear:true
      })
  }
}

function getrawmaterialcategories(selectBox, option='all'){
  $.getJSON(
    "../controllers/rawmaterialsoperations.php",
    {
      getrawmaterialcategories:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((category)=>{
        results+=`<option value='${category.categoryid}'>${category.categoryname}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}

function getunitsofmeasure(selectBox, option='all'){
  $.getJSON(
    "../controllers/settingoperations.php",
    {
      getunistofmeasure:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((uom)=>{
        results+=`<option value='${uom.description}'>${uom.description}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}

function getdepartments(selectBox, option='all'){
  $.getJSON(
    "../controllers/settingoperations.php",
    {
      getdepartments:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((department)=>{
        results+=`<option value='${department.id}'>${department.departmentname}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}

function gettaxtypes(selectBox, option='all'){
  $.getJSON(
    "../controllers/settingoperations.php",
    {
      gettaxtypes:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((tax)=>{
        results+=`<option value='${tax.id}'>${tax.taxname}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}

function getrequisitionstatus(obj,option='all'){
  const requisitionstatus=[{"value":'pending',"status":"Pending"},{"value":'approved',"status":"Approved"},{"value":'cancelled',"status":"Cancelled"}]
  let   results=option=='all'?"<option value='0'>&lt;All&gt;</option>":"<option value=''>&lt;Choose&gt;</option>"
  
    for(let i in requisitionstatus){
      results+=`<option value=${requisitionstatus[i].value}>${requisitionstatus[i].status}</option>`
    }

  obj.html(results)
}

function getpapergrammage(selectBox,option='all'){
  $.getJSON(
    "../controllers/settingoperations.php",
    {
      getpapergrammage:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((paper)=>{
        results+=`<option value='${paper.id}'>${paper.grammage}</option>`
      })
      $(results).appendTo(selectBox)
    }
  )
}

function getOrCreateDeviceID() {
  let deviceID = localStorage.getItem('deviceID');  
  if (!deviceID) {
    // Generate a UUID
    deviceID = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
    
    // Save to localStorage
    localStorage.setItem('deviceID', deviceID);
  }  
  return deviceID;
}

function saveSettings(deviceID, settings) {
  const allSettings = JSON.parse(localStorage.getItem('deviceSettings')) || {};
  allSettings[deviceID] = settings;
  localStorage.setItem('deviceSettings', JSON.stringify(allSettings));
}

function loadSettings(deviceID) {
  const allSettings = JSON.parse(localStorage.getItem('deviceSettings')) || {};
  return allSettings[deviceID] || null;
}

function isJSON(str) {
  try {
      return (JSON.parse(str) && !!str);
  } catch (e) {
      return false;
  }
}

function makedatatable(tableobj,results,pagelength=10,tfoot=''){
  // destroy datatable bfore re-initialization
  if ($.fn.dataTable.isDataTable(tableobj)) {
     tableobj.DataTable().clear().destroy();
  }

  // update content
  tableobj.find("tbody").html(results)
  if(tfoot!=""){
    tableobj.find("tfoot").html(results)
  }
  // reinitializedatatable
  tableobj.DataTable({
      dom: '<"top d-flex justify-content-between align-items-center"lBf>rtip',
      "autoWidth": false,
      "lengthMenu": [[10, 15, 25, 50, 100, -1], [10, 15,25, 50, 100, "All"]],
      "pageLength":pagelength,
      dom:'<"top d-flex justify-content-between align-items-center"Blf>rtip', // Adds buttons to the interface B- Buttons l - Length f-Filter,f-Search
          buttons: [
              {
                  extend: 'excelHtml5',
                  text: '<i class="fal fa-file-excel fa-lg" ></i> Excel',
                  className: 'btn btn-sm btn-success mr-2'
              },
              {
                  extend: 'csvHtml5',
                  text: '<i class="fal fa-file-csv fa-lg"></i> CSV',
                  className: 'btn btn-sm btn-primary mr-2'
              },
              {
                  extend: 'pdfHtml5',
                  text: '<i class="fal fa-file-pdf fa-lg "></i> PDF',
                  className: 'btn btn-sm btn-danger mr-2'
              },
              {
                  extend: 'print',
                  text: '<i class="fal fa-print fa-lg"></i> Printer',
                  className: 'btn btn-sm btn-info'
              }
          ]
      // "paging": true,
      // "searching": true,
      // "ordering": true,
      // "info": true
      // Additional options can be added here
  }).columns.adjust().draw()
}

function isNumeric(value) {
  return !isNaN(value) && !isNaN(parseFloat(value));
}

function sanitizestring(str){
  return str.replace("'","").trim()
}

function titleCase(str) {
  str = str.toLowerCase().split(' ');
  for (var i = 0; i < str.length; i++) {
      str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1); 
  }
  return str.join(' ');
}

function getpostables(obj,posid,option='all'){
  $.getJSON(
    "../controllers/posoperations.php",
    {
      getpostables:true,
      posid
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((table)=>{
        results+=`<option value='${table.tableid}'>${table.tablename}</option>`
      })
      obj.html(results)
      // $(results).appendTo(obj)
    }
  )
}

function getUrlParams() {
  var params = {};
  var queryString = window.location.search.substring(1);
  var pairs = queryString.split('&');
  
  for (var i = 0; i < pairs.length; i++) {
    var pair = pairs[i].split('=');
    params[pair[0]] = decodeURIComponent(pair[1] || '');
  }
  
  return params;
}

// variables for setting up POS printer
let printername

// Connect to POS printer
async function connecttoprinter(){
  qz.security.setCertificatePromise(function(resolve, reject) {
    //Preferred method - from server
    fetch("http://localhost/qztray/digital-certificate.txt", {cache: 'no-store', headers: {'Content-Type': 'text/plain'}})
        .then(function(data) { data.ok ? resolve(data.text()) : reject(data.text())
    })
  })
  
  qz.security.setSignatureAlgorithm("SHA512")

  qz.security.setSignaturePromise(function(toSign) {
    return function(resolve, reject) {
        //Preferred method - from server
        fetch("http://localhost/qztray/sign-message.php?request=" + toSign, {cache: 'no-store', headers: {'Content-Type': 'text/plain'}})
            .then(function(data) { data.ok ? resolve(data.text()) : reject(data.text())
        })
    }
  })

  qz.security.setCertificatePromise(function(resolve, reject) {
    //Preferred method - from server
    fetch("http://localhost/qztray/digital-certificate.txt", {cache: 'no-store', headers: {'Content-Type': 'text/plain'}})
        .then(function(data) { data.ok ? resolve(data.text()) : reject(data.text()); 
    })
  })

  if(!qz.websocket.isActive()){
      await qz.websocket.connect();
  }  
  // console.log(printername)
  if(printername!==undefined){
      printer = await qz.printers.find(printername);
      config = qz.configs.create(printer);
  }
}

function checkuserprivilegewithcode(code){
  const dfd=$.Deferred()
  $.getJSON(
    "../controllers/useroperations.php",
    {
      checkuserprivilegewithcode:true,
      code
    },
    (data)=>{
      dfd.resolve(data.status) 
    }
  )
  return dfd.promise()
}



const patterns={
  mobile:/^\d{10,12}$/,
  name:/^\[a-zA-z]+$/,
  password:/^[\w@-]{5,20}$/,
  email:/^[a-z\d\.-]+@[a-z\d]+\.[a-z]{2,8}(\.[a-z]{2,8})?$/
}

// validationanchor.on("click",function(e){
//   const id=$(this).attr("data-id") 
//   let pagetonavigate=$(this).attr("href")
//   e.preventDefault()
//   $.post(
//     "../controllers/useroperations.php",
//     {
//       getuserprivilege:true,
//       objectid: id
//     },
//     function(data){
//       const allowed=parseInt($.trim(data.toString()))
//       if(allowed==0){
//         bootbox.alert({
//           message: "Sorry. Your are not authorized to perform this operation.",
//         })
//       }else{
//         window.location.href=pagetonavigate
//       }
//     }
//   )
//  })

function validatefielddata(validatevalue,format){
  return patterns[format].test(validatevalue)?true:false
}


function getwarehouses(obj,option='all'){
  $.getJSON(
    "../controllers/settingoperations.php",
    {
      getwarehouses:true
    },
    (data)=>{
      let results=""
      option=='all'?results="<option value='0'>&lt;All&gt;</option>":results="<option value=''>&lt;Choose&gt;</option>"
      data.forEach((warehouse)=>{
        results+=`<option value='${warehouse.id}'>${warehouse.description}</option>`
      })
      obj.html(results)
    }
  )
}

// Keep the session active by sending a request every 1 minute
setInterval(getInstitutionDetails, 60000); 
