<?php

    require_once("../models/product.php");
    $product=new product();

    if(isset($_GET['filterproductbyname'])){
        $posid=isset($_GET['posid'])?$_GET['posid']:0;
        $name=$_GET['name'];
        echo $product->getProductByName($name,$posid);
    }
    if(isset($_GET['getstocktransferitembalance'])){
        $sourcetype=$_GET['sourcetype'];
        $sourceid=$_GET['sourceid'];
        $itemcode=$_GET['itemcode'];
        echo $product->getStockTransferItembalance($sourcetype,$sourceid,$itemcode);
    }
    if(isset($_POST['savetransfer'])){
        // get post variables
        $sourcetype=$_POST['sourcetype'];
        $sourceid=$_POST['sourceid'];
        $destinationtype=$_POST['destinationtype'];
        $destinationid=$_POST['destinationid'];
        $issuedto=$_POST['issuedto'];
        $storecontroller=$_POST['storecontroller'];
        //generate a random reference number
        $refno=generate_random_no();

        // temp save the items
        $tableData = json_decode(stripcslashes($_POST['TableData']),TRUE);

        foreach($tableData as $transferitem){
            $itemcode=$transferitem['itemcode'];
            $quantity=$transferitem['quantity'];
            $unitprice=$transferitem['unitprice'];
            $serialno=$transferitem['serialno'];
            $product->saveTempStockTransferItems($refno,$itemcode,$quantity,$unitprice,$serialno);
        }
        // save the transfer
        $transferrefno=$product->saveStockTransfer($refno,$sourcetype,$sourceid,$destinationtype,$destinationid,$issuedto,$storecontroller);
        echo $transferrefno;
    }
    if(isset($_GET['getdiscountmatrix'])){
        $itemcode=$_GET['itemcode'];
        echo $product->getProductDiscountMatrix($itemcode);
    }
    if(isset($_POST['deleteproduct'])){
        $productid=$_POST['productid'];
        echo $product->deleteProduct($productid);
    }
    if(isset($_GET['getproductbycategory'])){
        $categoryid=$_GET['categoryid'];
        echo $product->getProductByCategory($categoryid);
    }
    if(isset($_POST['savesupplierproducts'])){
        $supplierid=$_POST['supplierid'];
        foreach($_POST['productname'] as $row){
            $productid=$row;
            $product->saveSupplierProducts($supplierid,$productid);
        }
        echo "success";
    }
    if(isset($_GET['getsupplierproducts'])){
        $supplierid=$_GET['supplierid'];
        echo $product->getSupplierProducts($supplierid);
    }
    if(isset($_POST['deletesupplierproduct'])){
        $id=$_POST['id'];
        echo $product->deleteSupplierProduct($id);
    }
    if(isset($_POST['getpurchaseorderdetails'])){
        $id=$_POST['id'];
        echo $product->getPurchaseOrderDetails($id);
    }
    if(isset($_POST['savestockreconciliation'])){
        $refno=generate_random_no();
        $narration=$_POST['narration'];
        $posid=$_POST['posid'];
        $category=$_POST['category'];
        $itemslist=json_decode(stripcslashes($_POST['itemslist']),true);

        // temp save the reconciled items 
        foreach($itemslist as $item){
            $itemid=$item['itemid'];
            $quantity=$item['quantity'];
            $unitprice=$item['unitprice'];
            $product->savetempreconciledstockbalance($refno,$itemid,$quantity,$unitprice);
        }

        // post the reconciled stock balances
        echo $product->savereconciledstockbalance($refno,$narration,$posid,$category);
    }
    if(isset($_POST['saveproduct'])){
        $id=$_POST['id'];
        $itemcode=$_POST['itemcode'];
        $itemname=$_POST['itemname'];
        $uom=$_POST['uom'];
        $categoryid=$_POST['categoryid'];
        $buyingprice=$_POST['buyingprice'];
        $sellingprice=$_POST['sellingprice'];
        $reorderlevel=$_POST['reorderlevel'];
        $generatecode=$_POST['generatecode'];
        $serializable=$_POST['serializable'];
        $bundleitem=$_POST['bundleitem'];
        $taxtype=$_POST['taxtype'];
        $length=$_POST['length'];
        $width=$_POST['width'];
        $height=$_POST['height'];
        $allownegativesales=$_POST['allownegativesales'];
        $saleby=$_POST['saleby'];
        $bundleproduct=$_POST['bundleproduct'];
        $allowreturnexchange=$_POST['allowreturnexchange'];
        
        // Decode the JSON array
        $tableData = json_decode(stripcslashes($_POST['TableData']),TRUE);
        
        // generate reference no
        $refno=generate_random_no();

        // save temporary
        foreach($tableData as $saleitem){

           $catid=$saleitem['catid'];
           $percentage=$saleitem['percentage'];
           $value=$saleitem['value'];
  
          $product->saveTempPriceMatrix($refno,$catid,$percentage,$value);
        
        }
        // save temp product price matrix
        echo $product->saveProduct($id,$itemcode,$itemname,$categoryid,$uom,$buyingprice,$sellingprice,$reorderlevel,$refno,
        $generatecode,$serializable,$bundleitem,$taxtype,$length,$width,$height,$allownegativesales,$saleby,$bundleproduct,$allowreturnexchange);
    }
    if(isset($_GET['getproductdetails'])){
        $storeid=isset($_GET['storeid'])?$_GET['storeid']:0;
        $productcode=$_GET['productcode'];
        $customerid=isset($_GET['customerid'])?$_GET['customerid']:0;
        echo $product->getProductDetails($productcode,$customerid,$storeid);

    }
    if(isset($_GET['getexistingproductserialnumbers'])){
        $productid=$_GET['productid'];
        echo $product->getavailableserialnumbers($productid);
    }
    if(isset($_GET['getbundleitems'])){
        echo $product->getbundleitems();
    }
    if(isset($_GET['getproductstatement'])){
        $itemcode=$_GET['itemcode'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        echo $product->getproductstatement($itemcode,$startdate,$enddate);
    }
    if(isset($_GET['getcratesummary'])){
        $asatdate=$_GET['asatdate'];
        echo $product->getcratesummary($asatdate);
    }
    if(isset($_GET['getwarehouseproductsummary'])){
        $warehouseid=$_GET['warehouseid'];
        $asat=$_GET['asat'];
        echo $product->getwarehousestockbalance($warehouseid,$asat);
    }

    if(isset($_GET['getreturnableproducts'])){
        echo $product->getreturnableproducts();
    }
?>