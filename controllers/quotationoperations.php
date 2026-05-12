<?php
    require_once("../models/quotation.php");

    $quotation=new quotation();

    if(isset($_POST['savequotation'])){
        $refno=mt_rand(10000,99999);
        $items=json_decode(stripcslashes($_POST['quotationitems']),true);
        $customerid=$_POST['customerid'];
        $terms=$_POST['quotationterms'];
        $category=$_POST['category'];
        $id=$_POST['id'];
        // save temp quotation items 
        forEach($items as $item){
            $itemid=$item['productid'];
            $description=$item['description'];
            $quantity=$item['quantity'];
            $unitprice=$item['unitprice'];
            $length=isset($item['length'])?$item['length']:0;
            $width=isset($item['width'])?$item['width']:0;
            $height=isset($item['height'])?$item['height']:0;
            $gsm=isset($item['gsm'])?$item['gsm']:0;
            $weight=isset($item['weight'])?$item['weight']:0;
            $plies=isset($item['plies'])?$item['plies']:0;
            $jointallowance=isset($item['jointallowance'])?$item['jointallowance']:0;
            $trimallowance=isset($item['trimallowance'])?$item['trimallowance']:0;
            $profitmargin=isset($item['profitmargin'])?$item['profitmargin']:0;
            $printing=isset($item['printing'])?$item['printing']:0;
            $freight=isset($item['freight'])?$item['freight']:0;
            $waste=isset($item['waste'])?$item['waste']:0;
            $flutefactor=isset($item['flutefactor'])?$item['flutefactor']:0;
            $quotation->savetempquotationdetails($refno,$itemid,$description,$quantity,$unitprice,$length,$width,$height,$gsm,$weight,$plies,$jointallowance,
            $trimallowance,$profitmargin,$printing,$freight,$waste,$flutefactor);
        }
        // save quotation
        echo $quotation->savequotation($id,$refno,$customerid,$terms,$category);
    }

    if(isset($_GET['getquotationterms'])){
        echo $quotation->getquotationterms();
    }

    if(isset($_GET['filterquotations'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $customerid=$_GET['customerid'];
        $quotestatus=$_GET['quotestatus'];
        echo $quotation->filterquotation($customerid,$startdate,$enddate,$quotestatus);
    }

?>