<?php
    require_once("db.php");
    class sms extends db {
        private $apikey;
        private $senderid;
        private $clientid;
        private $url;

        public function __construct(){
            $this->apikey='ftrdghDvbi0mOntRQVsTLmEeEnG7XVrEs8XRHUDB5MM=';
            $this->senderid='ADRIANKE';
            $this->branchid='76102296-1a96-4f09-9c73-6353033321b7';
            $this->url='https://api.uwaziimobile.com/api/v2/SendSMS';
        }

        public function sendSMS($recipient,$message){
            // encode message to replace spaces with %20
            $message=urlencode($message);
            $redirecturl  =$this->url."?ApiKey=".$this->apikey;
            $redirecturl .="&ClientId=".$this->branchid;
            $redirecturl .="&SenderId=".$this->senderid;
            $redirecturl .="&Message=".$message;
            $redirecturl .="&MobileNumbers=".$recipient;

            $ch=curl_init();
            $headers=['Content-Type:application/json'];
            
            curl_setopt($ch, CURLOPT_URL, $redirecturl);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_HEADER, false);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

            $response=curl_exec($ch);
            $status= json_decode($response, true);
            //echo $response;
            curl_close($ch);
            // validate later on any returned error 
            return $status;
        }

        public function savesmslog($mobileno,$customerid,$message,$messageid,$messagestatus){
            $sql="CALL `spsavesmslog`({$this->branchid},'{$mobileno}','{$customerid}','{$message}','{$messageid}','{$messagestatus}')";
            $this->getData($sql);
        }

        public function getmenuname($menuid){
            $sql="CALL `spgetobjectdetails`({$this->branchid},{$menuid})";
            return $this->getData($sql)->fetch()['description'];
        }

        public function checkifmenuisrestricted($menuid){
            $sql="CALL `spgetobjectdetails`({$this->branchid},{$menuid})";
            return $this->getData($sql)->fetch()['restricted']==1?true:false;
        }
    }

    $sms=new sms();

    if(isset($_POST['sendmenuaccessmessage'])){
         $menuid=$_POST['menuid'];
        if($sms->checkifmenuisrestricted($menuid) && isset($_SESSION['username'])){
            $recipient='254720871576';
            $loggedinuser=$_SESSION['username'];
            $menuname=$sms->getmenuname($menuid);

            $message="Hello, ".$loggedinuser.' has just accessed '.$menuname. '. Thank you.';
            
            $response=$sms->sendSMS($recipient,$message);
            $status=$response['Data'][0]['MessageErrorDescription'];
            $messageid=$response['Data'][0]['MessageId'];
            // save the messages sent to the server
            $sms->savesmslog($recipient,$menuid,$message,$messageid,$status);
            
            echo $status;
        }else{
            if(!$sms->checkifmenuisrestricted($menuid)){
                echo "Menu unrestricted";
            }else{
                echo "User not logged in";
            }
        }
    }
?>