<?php
    require_once("db.php");

    class quotation extends db{

        public function savetempquotationdetails($refno,$itemid,$description,$quantity,$unitprice,$length,$width,$height,$gsm,$weight,$plies,$jointallowance,
        $trimallowance,$profitmargin,$printing,$freight,$waste,$flutefactor){
            $sql="CALL `sp_savetempquotation`({$this->branchid},'{$refno}',{$itemid},'{$description}',{$quantity},{$unitprice},{$length},{$width},{$height},{$gsm},{$weight},{$plies},{$jointallowance},
            {$trimallowance},{$profitmargin},{$printing},{$freight},{$waste},{$flutefactor})";
            $this->getData($sql);
            return "success";
        }

        public function savequotation($id,$refno,$customerid,$terms,$category){
            $sql="CALL `sp_savequotation`({$this->branchid},{$id},'{$refno}',{$customerid},'{$terms}','{$category}',{$this->userid})";
            // echo $sql;
            return $this->getData($sql)->fetch()['quoteno'];
        }

        public function getquotationterms(){
            $sql="CALL `spgetquotationterms`({$this->branchid})";
            return $this->getJSON($sql);
        }

        public function filterquotation($customerid,$startdate,$enddate,$quotestatus){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `spfilterquotations`({$this->branchid},{$customerid},'{$startdate}','{$enddate}','{$quotestatus}')";
            // echo $sql."<br/>";
            return $this->getJSON($sql);
        }
    }

?>