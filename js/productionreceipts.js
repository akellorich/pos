$(document).ready(()=>{

    const productionreceiptmodal=$("#productionreceiptmodal")
    const addnewproductionreceipt=$("#addnewreceiptbutton")
    const filteritemlist=$("#filterproduct")
    const receiptitemlist=$("#receiptproduct")
    const filterstartdate=$("#startdate")
    const filterenddate=$("#enddate")
    const alldates=$("#alldates")
    const receivedquantityfield=$("#receiptquantity")
    const generatedeliverynofield=$("#generatedeliveryno")
    const deliverynofield=$("#deliverynumber")
    const receiptnarrationfield=$("#")
    const savereceipt=$("#")

    alldates.prop("checked",true)
    filterstartdate.prop("disabled",true)
    filterenddate.prop("disabled",true)

    generatedeliverynofield.prop("checked",true)
    deliverynofield.prop("disabled",true)

    getallproducts(filteritemlist)
    getallproducts(receiptitemlist,'choose')
    setDatePicker(filterstartdate,false,false)
    setDatePicker(filterenddate,false,false)

    generatedeliverynofield.on("click",function(){
        state=$(this).prop("checked")
        deliverynofield.prop("disabled",state)
    })

    addnewproductionreceipt.on("click",()=>{
        productionreceiptmodal.modal("show")
    })

    alldates.on("click",function(){
        state=$(this).prop("checked")
        filterstartdate.prop("disabled",state)
        filterenddate.prop("disabled",state)
    })

})