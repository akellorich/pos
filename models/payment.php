<?php
    require_once("db.php");
    class payment extends db{

        public function checkvoucherno($id,$voucherno){
            $sql="CALL spcheckpaymentvoucherno({$this->clientid},{$id},'{$voucherno}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function savetemppaymentvoucherdetails($refno,$itemcode,$description,$quantity,$unitprice,$accountcharged,$invoicenumber){
            $sql="CALL spsavetepmpaymentvoucherdetails({$this->clientid},'{$refno}','{$itemcode}','{$description}',{$quantity},{$unitprice},{$accountcharged},'{$invoicenumber}')";
           // echo $sql.";<br/>";
            $rst=$this->connect()->query($sql);
        }

        public function savepaymentvoucher($refno,$id,$voucherdate,$voucherno,$pos,$supplier,$paymentmode,$cashbookaccount,$reference,$generatevoucherno,$pettycash,$craterefund){
            $voucherdate=$this->mySQLDate($voucherdate);
            if($generatevoucherno==0 && $this->checkvoucherno($id,$voucherno)){
                echo "voucher number exists";
            }else{
                $sql="CALL spsavepaymentvoucher({$this->clientid},'{$refno}',{$id},'{$voucherdate}','{$voucherno}',{$pos},{$supplier},{$paymentmode},{$cashbookaccount},'{$reference}',{$generatevoucherno},{$_SESSION['userid']},{$pettycash},{$craterefund})";
                //echo $sql."<br/>";
                $rst=$this->connect()->query($sql);
                if($rst->rowCount()>0){
                    $data=$rst->fetch(PDO::FETCH_ASSOC);
                    echo $data['voucherno'];
                 }
            }
        }

        public function getpaymentvouchers($supplierid,$posid, $stat,$paymentmode, $startdate,$enddate,$pettycashvouchers){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetpaymentvouchers({$this->clientid},{$supplierid},{$posid},'{$stat}',{$paymentmode}, '{$startdate}','{$enddate}',{$pettycashvouchers})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data);
        }

        public function getVoucherDetails($id){
            $sql="CALL spgetpaymentvoucherdetails({$this->clientid},'{$id}')";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data);  
        }

        public function getVoucherItems($id){
            $sql="CALL spgetvoucheritems({$this->clientid},'{$id}')";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data); 
        }

        public function approvePaymentVoucher($id){
            if(!$this->checkVoucherApproved($id)){
                $sql="CALL spapprovepaymentvoucher({$this->clientid},{$id},{$_SESSION['userid']})";
                $rst=$this->connect()->query($sql);
                echo "success";
            }else{
                echo "not pending";
            }  
        }

        public function deletePaymentVoucher($id,$reason){
            if(!$this->checkVoucherApproved($id)){
                $sql="CALL spcancelpaymentvoucher({$this->clientid},{$id},'{$reason}',{$_SESSION['userid']})";
                $rst=$this->connect()->query($sql);
                echo "success";
            }else{
                echo "not pending";
            }
        }

        public function checkVoucherApproved($id){
            $sql="CALL spgetpaymentvoucherdetails({$this->clientid},{$id})";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            if($rst->rowCount()>0){
                if($data['status']!='Pending'){
                    return true;
                }else{
                    return false;
                }
            }
        }

        public function getPaymentVoucherStatus($id){
            $sql="CALL spgetpaymentvoucherstatus({$this->clientid},{$id})";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            if($rst->rowCount()>0){
                echo json_encode ($data['status']);
            }else{
                echo json_encode("not exists");
            }
        }

        public function getPaymentVoucher($id){
            $sql="CALL spgetpaymentvoucher({$this->clientid},{$id})";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data);
        }
    }
?>