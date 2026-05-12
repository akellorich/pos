<?php 
    require_once('db.php');

    class product extends db{

        public function checkProduct($id, $value,$field){
            $sql="CALL spcheckproduct({$this->clientid},{$id},'{$value}','{$field}')";
            $rst=$this->connect()->query($sql);
            return $rst->rowCount()?true:false;
        }

        public function saveProduct($id,$itemcode,$itemname,$categoryid,$uom,$buyingprice,$sellingprice,$reorderlevel,$refno,$generatecode,
            $serializable,$bundleitem,$taxtype,$length,$width,$height,$allownegativesales,$saleby,$bundleproduct,$allowreturnexchange){
            // check if code is in use
            if($this->checkProduct($id,$itemcode,'code')== true && $generatecode==0){
                return "code exists"; 
            // check if name is in use
            }else if ($this->checkProduct($id,$itemname,'name')== true){  
                return "name exists";
            }else{
                 // save the product
                 $sql="CALL spsaveproduct({$this->clientid},{$id},'{$itemcode}','{$itemname}',{$categoryid},'{$uom}',{$buyingprice},{$sellingprice},{$reorderlevel},
                 {$_SESSION['userid']},'{$refno}',{$generatecode},{$serializable},{$bundleitem},{$taxtype},{$length},{$width},{$height},
                 {$allownegativesales},'{$saleby}',{$bundleproduct},{$allowreturnexchange})";
                 //echo $sql;
                 $rst=$this->connect()->query($sql);
                 return "success";
            }
        }

        public function getProductByName($name,$posid){
            $sql="CALL spfilterproductsbyname({$this->clientid},'{$name}',$posid)";
            // echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            // $data =$rst->fetchAll(PDO::FETCH_ASSOC);
            // return json_encode($data);
            return $this->getJSON($sql);
        }

        public function getProductDetails($productcode,$customerid,$storeid){
            $sql="CALL spgetproductdetails({$this->clientid},'{$productcode}',{$customerid},$storeid)";
            //echo $sql;
            // $rst=$this->connect()->query($sql);
            // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }   

        public function deleteProduct($productid){
            $sql="CALL spdeleteproduct({$this->clientid},{$productid},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            return "success";
        }

        public function saveTempPriceMatrix($refno,$catid,$percentage,$value){
            $sql="CALL spsavetemppricematrix({$this->clientid},'{$refno}',{$catid},{$percentage},{$value})";
            $rst=$this->connect()->query($sql);
        }

        public function getStockTransferItembalance($sourcetype,$sourceid,$itemcode){
            $sql="CALL spgetstocktransferbalance({$this->clientid},'{$sourcetype}',{$sourceid},'{$itemcode}')";
            // $rst=$this->connect()->query($sql);
            // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        public function saveTempStockTransferItems($refno,$itemcode,$quantity,$unitprice,$serialno){
            $sql="CALL spsavetempstocktransfer({$this->clientid},'{$refno}','{$itemcode}',{$unitprice},{$quantity},'{$serialno}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
        }
        
        public function saveStockTransfer($refno,$sourcetype,$sourceid,$destinationtype,$destinationid,$issuedto,$storecontroller){
            $sql="CALL spsavestocktransfer({$this->clientid},'{$refno}','{$sourcetype}',{$sourceid},'{$destinationtype}',{$destinationid},{$_SESSION['userid']},{$issuedto},{$storecontroller})";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            return $data['transfercode'];
        }

        public function getProductDiscountMatrix($itemcode){
            $sql="CALL spgetproductdiscountmatrix({$this->clientid},'{$itemcode}')";
            // $rst=$this->connect()->query($sql);
            // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        public function getProductByCategory($categoryid){
            $sql="CALL spgetproductbycategory({$this->clientid},{$categoryid})";
            // $rst=$this->connect()->query($sql);
            // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        public function saveSupplierProducts($supplierid,$productid){
            $sql="CALL spsavesupplierproduct({$this->clientid},{$supplierid},{$productid},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
        }

        public function getSupplierProducts($supplierid){
            $sql="CALL spgetsupplierproducts({$this->clientid},{$supplierid})";
            // $rst=$this->connect()->query($sql);
            // return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        public function deleteSupplierProduct($id){
            $sql="CALL spdeletesupplierproduct({$this->clientid},{$id},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            return "success";
        }

        public function savetempreconciledstockbalance($refno,$itemid,$quantity,$unitprice){
            $sql="CALL spsavetempreconcilebalancedetails({$this->clientid},'{$refno}',{$itemid},{$quantity},{$unitprice})";
            $this->getData($sql);
            return "success";
        }

        public function savereconciledstockbalance($refno,$narration,$posid,$category){
            $sql="CALL `spsavestockreconciledbalance`({$this->clientid},'{$refno}','{$narration}',$posid,'{$category}',{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }

        public function getavailableserialnumbers($productid){
            $sql="CALL spgetavailableproductserialnumbers({$this->clientid},{$productid})";
            //echo $sql."<br/>";
            return $this->getJSON($sql);
        }

        public function getbundleitems(){
            $sql="CALL `spgetbundleitems`({$this->clientid})";
            return $this->getJSON($sql);
        }

        public function getproductstatement($itemcode,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `spgetitemstatement`({$this->clientid},'{$itemcode}','{$startdate}','{$enddate}')";
            
            return $this->getJSON($sql);
        }

        
        public function getcratesummary($asatdate){
            $asatdate=$this->mySQLDate($asatdate);
            $sql="CALL sp_getcratesummary({$this->clientid},'{$asatdate}')";
            return $this->getJSON($sql);
        }

        function getwarehousestockbalance($warehouseid,$asat){
            $asat=$this->mySQLDate($asat);
            $sql="CALL `sp_getwarehousestocksummaryasat`({$this->clientid},{$warehouseid},'{$asat}')";
            return $this->getJSON($sql);
        }

        function getreturnableproducts(){
            $sql="CALL `sp_getreturnableproducts`({$this->clientid})";
            return $this->getJSON($sql);
        }
    }
?>