<?php
require_once('db.php');

class product extends db
{

    public function checkProduct($id, $value, $field)
    {
        $sql = "CALL spcheckproduct({$this->clientid},{$id},'{$value}','{$field}')";
        $rst = $this->connect()->query($sql);
        return $rst->rowCount() ? true : false;
    }

    public function saveProduct(
        $id,
        $itemcode,
        $itemname,
        $categoryid,
        $uom,
        $buyingprice,
        $sellingprice,
        $reorderlevel,
        $refno,
        $generatecode,
        $serializable,
        $bundleitem,
        $taxtype,
        $length,
        $width,
        $height,
        $allownegativesales,
        $saleby,
        $bundleproduct,
        $allowreturnexchange,
        $rawmaterial,
        $itemtype,
        $disallowpurchasing,
        $disallowreceipt,
        $disallowsale
    ) {

        // Clean/sanitize numeric/boolean inputs to prevent SQL syntax errors on empty values
        $id = (!isset($id) || $id === '') ? 0 : $id;
        $categoryid = (!isset($categoryid) || $categoryid === '') ? 0 : $categoryid;
        $buyingprice = (!isset($buyingprice) || $buyingprice === '') ? 0.00 : $buyingprice;
        $sellingprice = (!isset($sellingprice) || $sellingprice === '') ? 0.00 : $sellingprice;
        $reorderlevel = (!isset($reorderlevel) || $reorderlevel === '') ? 0 : $reorderlevel;
        $generatecode = (!isset($generatecode) || $generatecode === '') ? 0 : $generatecode;
        $serializable = (!isset($serializable) || $serializable === '') ? 0 : $serializable;
        $bundleitem = (!isset($bundleitem) || $bundleitem === '') ? 0 : $bundleitem;
        $taxtype = (!isset($taxtype) || $taxtype === '') ? 0 : $taxtype;
        $length = (!isset($length) || $length === '') ? 0.00 : $length;
        $width = (!isset($width) || $width === '') ? 0.00 : $width;
        $height = (!isset($height) || $height === '') ? 0.00 : $height;
        $allownegativesales = (!isset($allownegativesales) || $allownegativesales === '') ? 0 : $allownegativesales;
        $bundleproduct = (!isset($bundleproduct) || $bundleproduct === '') ? 0 : $bundleproduct;
        $allowreturnexchange = (!isset($allowreturnexchange) || $allowreturnexchange === '') ? 0 : $allowreturnexchange;
        $rawmaterial = (!isset($rawmaterial) || $rawmaterial === '') ? 0 : $rawmaterial;
        $disallowpurchasing = (!isset($disallowpurchasing) || $disallowpurchasing === '') ? 0 : $disallowpurchasing;
        $disallowreceipt = (!isset($disallowreceipt) || $disallowreceipt === '') ? 0 : $disallowreceipt;
        $disallowsale = (!isset($disallowsale) || $disallowsale === '') ? 0 : $disallowsale;

        // check if code is in use
        if ($this->checkProduct($id, $itemcode, 'code') == true && $generatecode == 0) {
            return "code exists";
            // check if name is in use
        } else if ($this->checkProduct($id, $itemname, 'name') == true) {
            return "name exists";
        } else {
            // save the product
            $sql = "CALL spsaveproduct({$this->clientid},{$id},'{$itemcode}','{$itemname}',{$categoryid},'{$uom}',{$buyingprice},{$sellingprice},{$reorderlevel},
                 {$_SESSION['userid']},'{$refno}',{$generatecode},{$serializable},{$bundleitem},{$taxtype},{$length},{$width},{$height},
                 {$allownegativesales},'{$saleby}',{$bundleproduct},{$allowreturnexchange},
                 {$rawmaterial},'{$itemtype}',{$disallowpurchasing},{$disallowreceipt},{$disallowsale})";
            //echo $sql;
            $rst = $this->connect()->query($sql);
            return "success";
        }
    }

    public function getProductByName($name, $posid)
    {
        $sql = "CALL spfilterproductsbyname({$this->clientid},'{$name}',$posid)";
        // echo $sql."<br/>";
        $rst = $this->connect()->query($sql);
        // $data =$rst->fetchAll(PDO::FETCH_ASSOC);
        // return json_encode($data);
        return $this->getJSON($sql);
    }

    public function getProductDetails($productcode, $customerid, $storeid)
    {
        $sql = "CALL spgetproductdetails({$this->clientid},'{$productcode}',{$customerid},$storeid)";
        //echo $sql;
        // $rst=$this->connect()->query($sql);
        // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    public function deleteProduct($productid)
    {
        $sql = "CALL spdeleteproduct({$this->clientid},{$productid},{$_SESSION['userid']})";
        $rst = $this->connect()->query($sql);
        return "success";
    }

    public function hasTransactions($productid)
    {
        $sql = "CALL spcheckproducttransactions({$this->clientid}, {$productid})";
        $rst = $this->connect()->query($sql);
        $data = $rst->fetch(PDO::FETCH_ASSOC);
        return (int)$data['total_transactions'] > 0;
    }

    public function mergeAndDeleteProduct($source_id, $target_id)
    {
        $userid = (int)$_SESSION['userid'];
        $sql = "CALL spmergeanddeleteproduct({$this->clientid}, {$source_id}, {$target_id}, {$userid})";
        
        try {
            $this->connect()->query($sql);
            return "success";
        } catch (Exception $e) {
            return "error: " . $e->getMessage();
        }
    }

    public function saveTempPriceMatrix($refno, $catid, $percentage, $value)
    {
        $sql = "CALL spsavetemppricematrix({$this->clientid},'{$refno}',{$catid},{$percentage},{$value})";
        $rst = $this->connect()->query($sql);
    }

    public function getStockTransferItembalance($sourcetype, $sourceid, $itemcode)
    {
        $sql = "CALL spgetstocktransferbalance({$this->clientid},'{$sourcetype}',{$sourceid},'{$itemcode}')";
        // $rst=$this->connect()->query($sql);
        // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    public function saveTempStockTransferItems($refno, $itemcode, $quantity, $unitprice, $serialno)
    {
        $sql = "CALL spsavetempstocktransfer({$this->clientid},'{$refno}','{$itemcode}',{$unitprice},{$quantity},'{$serialno}')";
        //echo $sql."<br/>";
        $rst = $this->connect()->query($sql);
    }

    public function saveStockTransfer($refno, $sourcetype, $sourceid, $destinationtype, $destinationid, $issuedto, $storecontroller)
    {
        $sql = "CALL spsavestocktransfer({$this->branchid},'{$refno}','{$sourcetype}',{$sourceid},'{$destinationtype}',{$destinationid},{$_SESSION['userid']},{$issuedto},{$storecontroller})";
        $rst = $this->connect()->query($sql);
        $data = $rst->fetch(PDO::FETCH_ASSOC);
        return $data['transfercode'];
    }

    public function getProductDiscountMatrix($itemcode)
    {
        $sql = "CALL spgetproductdiscountmatrix({$this->clientid},'{$itemcode}')";
        // $rst=$this->connect()->query($sql);
        // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    public function getProductByCategory($categoryid, $posid)
    {
        $sql = "CALL spgetproductbycategory({$this->clientid},{$categoryid},{$posid})";
        // $rst=$this->connect()->query($sql);
        // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    public function saveSupplierProducts($supplierid, $productid)
    {
        $sql = "CALL spsavesupplierproduct({$this->clientid},{$supplierid},{$productid},{$_SESSION['userid']})";
        $rst = $this->connect()->query($sql);
    }

    public function getSupplierProducts($supplierid)
    {
        $sql = "CALL spgetsupplierproducts({$this->clientid},{$supplierid})";
        // $rst=$this->connect()->query($sql);
        // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    public function deleteSupplierProduct($id)
    {
        $sql = "CALL spdeletesupplierproduct({$this->clientid},{$id},{$_SESSION['userid']})";
        $rst = $this->connect()->query($sql);
        return "success";
    }

    public function savetempreconciledstockbalance($refno, $itemid, $quantity, $unitprice)
    {
        $sql = "CALL spsavetempreconcilebalancedetails({$this->clientid},'{$refno}',{$itemid},{$quantity},{$unitprice})";
        $this->getData($sql);
        return "success";
    }

    public function savereconciledstockbalance($refno, $narration, $posid, $category)
    {
        $sql = "CALL `spsavestockreconciledbalance`({$this->clientid},'{$refno}','{$narration}',$posid,'{$category}',{$_SESSION['userid']})";
        $this->getData($sql);
        return "success";
    }

    public function getavailableserialnumbers($productid)
    {
        $sql = "CALL spgetavailableproductserialnumbers({$this->clientid},{$productid})";
        //echo $sql."<br/>";
        return $this->getJSON($sql);
    }

    public function getbundleitems()
    {
        $sql = "CALL `spgetbundleitems`({$this->clientid})";
        return $this->getJSON($sql);
    }

    public function getproductstatement($itemcode, $startdate, $enddate)
    {
        $startdate = $this->mySQLDate($startdate);
        $enddate = $this->mySQLDate($enddate);
        $sql = "CALL `spgetitemstatement`({$this->clientid},'{$itemcode}','{$startdate}','{$enddate}')";

        return $this->getJSON($sql);
    }


    public function getcratesummary($asatdate)
    {
        $asatdate = $this->mySQLDate($asatdate);
        $sql = "CALL sp_getcratesummary({$this->clientid},'{$asatdate}')";
        return $this->getJSON($sql);
    }

    function getwarehousestockbalance($warehouseid, $asat)
    {
        $asat = $this->mySQLDate($asat);
        $sql = "CALL `sp_getwarehousestocksummaryasat`({$this->clientid},{$warehouseid},'{$asat}')";
        return $this->getJSON($sql);
    }

    function getreturnableproducts()
    {
        $sql = "CALL `sp_getreturnableproducts`({$this->clientid})";
        return $this->getJSON($sql);
    }

    public function getRawProducts($name)
    {
        $sql = "CALL spfilterrawproducts({$this->clientid}, '{$name}')";
        return $this->getJSON($sql);
    }

    public function saveProductRecipe($productid, $recipeitemid, $quantity)
    {
        $userid = (int)$_SESSION['userid'];
        $sql = "CALL spsaveproductrecipe({$this->clientid}, {$productid}, {$recipeitemid}, {$quantity}, {$userid})";
        $this->connect()->query($sql);
        return "success";
    }

    public function getProductRecipes($productid)
    {
        $sql = "CALL spgetproductrecipes({$this->clientid}, {$productid})";
        return $this->getJSON($sql);
    }

    public function deleteProductRecipe($recipeid)
    {
        $sql = "CALL spdeleteproductrecipe({$this->clientid}, {$recipeid})";
        $this->connect()->query($sql);
        return "success";
    }

    public function getProductSplitUnits($productid)
    {
        $sql = "CALL spgetproductsplitunits({$this->clientid}, {$productid})";
        return $this->getJSON($sql);
    }

    public function saveProductSplitUnit($id, $productid, $unitname, $unitsoftotal, $unitprice)
    {
        $id = (int)$id;
        $productid = (int)$productid;
        $unitsoftotal = (float)$unitsoftotal;
        $unitprice = (float)$unitprice;

        $sql = "CALL spsaveproductsplitunit({$id}, {$this->clientid}, {$productid}, '{$unitname}', {$unitsoftotal}, {$unitprice}, {$_SESSION['userid']})";
        $this->connect()->query($sql);
        return "success";
    }

    public function deleteProductSplitUnit($id)
    {
        $id = (int)$id;
        $sql = "CALL spdeleteproductsplitunit({$this->clientid}, {$id})";
        $this->connect()->query($sql);
        return "success";
    }

    public function getProductMovementHistory($productid, $startdate, $enddate) {
        $db = $this->connect();
        $productid = (int)$productid;
        $stmt = $db->query("SELECT itemcode FROM products WHERE productid = {$productid}");
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $itemcode = $row ? $row['itemcode'] : '';
        return $this->getproductstatement($itemcode, $startdate, $enddate);
    }

    public function getProductPricingHistory($productid, $price_type, $startdate, $enddate) {
        $startdate = $this->mySQLDate($startdate);
        $enddate = $this->mySQLDate($enddate);
        $productid = (int)$productid;
        $db = $this->connect();
        $price_type_quoted = $db->quote($price_type);

        $sql = "CALL spgetproductpricinghistory({$productid}, {$price_type_quoted}, '{$startdate}', '{$enddate}')";
        return $this->getJSON($sql);
    }

    public function getProductPurchaseHistory($productid, $startdate, $enddate) {
        $startdate = $this->mySQLDate($startdate);
        $enddate = $this->mySQLDate($enddate);
        $productid = (int)$productid;

        $sql = "CALL spgetproductpurchasehistory({$productid}, '{$startdate}', '{$enddate}')";
        return $this->getJSON($sql);
    }

    public function getProductSalesHistory($productid, $startdate, $enddate) {
        $startdate = $this->mySQLDate($startdate);
        $enddate = $this->mySQLDate($enddate);
        $productid = (int)$productid;

        $sql = "CALL spgetproductsaleshistory({$productid}, '{$startdate}', '{$enddate}')";
        return $this->getJSON($sql);
    }

    public function getProductTransfersHistory($productid, $source_type, $source_id, $dest_type, $dest_id, $startdate, $enddate) {
        $startdate = $this->mySQLDate($startdate);
        $enddate = $this->mySQLDate($enddate);
        $productid = (int)$productid;
        $source_id = (int)$source_id;
        $dest_id = (int)$dest_id;
        $db = $this->connect();
        $source_type_quoted = $db->quote($source_type);
        $dest_type_quoted = $db->quote($dest_type);

        $sql = "CALL spgetproducttransfershistory({$productid}, {$source_type_quoted}, {$source_id}, {$dest_type_quoted}, {$dest_id}, '{$startdate}', '{$enddate}')";
        return $this->getJSON($sql);
    }

    public function getProductSpoilageHistory($productid, $categoryid, $startdate, $enddate) {
        $startdate = $this->mySQLDate($startdate);
        $enddate = $this->mySQLDate($enddate);
        $productid = (int)$productid;
        $categoryid = (int)$categoryid;

        $sql = "CALL spgetproductspoilagehistory({$productid}, {$categoryid}, '{$startdate}', '{$enddate}')";
        return $this->getJSON($sql);
    }
}
?>