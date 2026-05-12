$(document).ready(function(){
    var numberfields=$(".number")
    // format all number fields with thousand separator
    var amount=0
    numberfields.each(function(){
        amount=$(this).text()
        // console.log($(this))
        // console.log(amount)
         $(this).html($.number(amount))  
    })
    
    window.print();
    setTimeout(function () { window.close(); }, 100);
})