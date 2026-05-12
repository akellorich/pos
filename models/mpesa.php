<?php
    class MPesa {
        private $consumerKey ;
        private $consumerSecret ; 
        private $shortCode;
        private $Passkey;
        private $confirmationurl;
        private $mpesaonlineshortcode;
        private $onlinepaymenturl;
        private $c2burl;
        private $c2bshortcode;
        private $c2bmsisdn;
        private $registerurl;
        private $environment;
        private $tokenurl;
        private $stkurl; 
        public $accessToken;
      
        function __construct(){
            // get mpesa configuration settings
            $rst=$this->getmpesaconfigurationasobject();
            $row=$rst->fetch(PDO::FETCH_ASSOC);
            $this->environment="sandbox";
            $this->consumerKey=$row['consumerkey'];
            $this->consumerSecret=$row['consumersecret'];
            $this->shortCode=$row['paybillnumber'];
            $this->passKey=$row['passkey'];
            $this->confirmationurl=$row['confirmationurl'];
            $this->mpesaonlineshortcode=$row['mpesaonlineshortcode'];
            $this->onlinepaymenturl=$row['onlinepaymenturl'];
            $this->c2burl=$row['c2burl'];
            $this->c2bshortcode=$row['c2bshortcode'];
            $this->c2bmsisdn=$row['c2bmsisdn'];
            $this->getToken();
            if($this->env="sandbox"){
                $this->registerurl='https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl';
                $this->tokenurl='https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
                $this->stkurl='https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
            }else{
                $this->registerurl='https://api.safaricom.co.ke/mpesa/c2b/v1/registerurl';
                $this->tokenurl='https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
                $this->stkurl='https://api.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
            }
        }

        public function getToken(){
	        $headers = ['Content-Type:application/json'];
            //  charset=utf8
            $url = $this->tokenurl;

            $curl = curl_init($url);
            curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);
            curl_setopt($curl, CURLOPT_HEADER, FALSE);
            curl_setopt($curl, CURLOPT_USERPWD, $this->consumerKey.':'. $this->consumerSecret);
            $result = curl_exec($curl);
            $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
            $result = json_decode($result);
            $this->accessToken = $result->access_token;
            curl_close($curl);
        }

        public function registerURL($confirmationUrl,$validationUrl){
            //$this->getToken();
            $url = $this->registerurl;

            $access_token = ''; // check the mpesa_accesstoken.php file for this. No need to writing a new file here, just combine the code as in the tutorial.
                    
            // get the token
            $access_token=$this->accessToken;
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $url);
            curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json','Authorization:Bearer '.$access_token)); //setting custom header
        
        
            $curl_post_data = array(
              //Fill in the request parameters with valid values
              'ShortCode' => $this->shortCode,
              'ResponseType' => 'Confirmed',
              'ConfirmationURL' => $confirmationUrl,
              'ValidationURL' => $validationUrl
            );
        
            $data_string = json_encode($curl_post_data);
            
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_POST, true);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $data_string);
        
            $curl_response = curl_exec($curl);
           // print_r($curl_response);

            return $curl_response;
        }

        public function initiatestk($mobilenumber,$referenceno,$amount,$description){
            //echo $this->accessToken."<br/>";
            $Timestamp = date('YmdHis'); 
            //echo  $Timestamp."<br/>";
            $Password = base64_encode($this->mpesaonlineshortcode.$this->passKey.$Timestamp);
            //echo $Password."<br/>";
            $headers = ['Content-Type:application/json; charset=utf8'];
            $initiate_url = $this->stkurl;
            $CallBackURL = $this->onlinepaymenturl;  
            # header for stk push
            $stkheader = ['Content-Type:application/json','Authorization:Bearer '.$this->accessToken];
            # initiating the transaction
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $initiate_url);
            curl_setopt($curl, CURLOPT_HTTPHEADER, $stkheader); //setting custom header
            $curl_post_data = array(
                //Fill in the request parameters with valid values
                'BusinessShortCode' => $this->mpesaonlineshortcode,
                'Password' => $Password,
                'Timestamp' => $Timestamp,
                'TransactionType' => 'CustomerPayBillOnline',
                'Amount' => $amount,
                'PartyA' => $mobilenumber,
                'PartyB' => $this->mpesaonlineshortcode,
                'PhoneNumber' => $mobilenumber,
                'CallBackURL' => $CallBackURL,
                'AccountReference' => $referenceno,
                'TransactionDesc' => $description
            );

            $data_string = json_encode($curl_post_data);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_POST, true);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $data_string);
            $curl_response = curl_exec($curl);
            //print_r($curl_response);
            return $curl_response;

        }

        public function simulatec2b($mobile,$amount,$reference){
            $this->getToken();
            // get c2b parameters
            $access_token = ''; 
            // get the token
            $access_token=$this->accessToken;
            $c2bheader= ['Content-Type:application/json','Authorization:Bearer '.$access_token];
            $url = $this->c2burl;//'https://sandbox.safaricom.co.ke/mpesa/c2b/v1/simulate';
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $url);
            curl_setopt($curl, CURLOPT_HTTPHEADER, $c2bheader); //setting custom header
            
        
            $curl_post_data = array(
                    //Fill in the request parameters with valid values
                'ShortCode' => $this->c2bshortcode,
                'CommandID' => 'CustomerPayBillOnline',
                'Amount' => $amount,
                'Msisdn' => $mobile,
                'BillRefNumber' => $reference
            );
        
            $data_string = json_encode($curl_post_data);
        
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_POST, true);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $data_string);
        
            $curl_response = curl_exec($curl);
            // print_r($curl_response);
            return $curl_response;
        }

        public function savempesaconfiguration($consumerkey,$consumersecret,$validationurl,$confirmationurl,$paybillnumber){
            $sql="CALL spsavempesaconfiguration({$this->clientid},'{$consumerkey}','{$consumersecret}','{$validationurl}','{$confirmationurl}',{$paybillnumber})";
            $this->getData($sql);
            return "success";
        }

        public function getmpesaconfiguration(){
            $sql="CALL spgetmpesaconfiguration({$this->clientid})";
            return $this->getJSON($sql);
        }
    
        public function getmpesaconfigurationasobject(){
            $sql="CALL spgetmpesaconfiguration({$this->clientid})";
            return $this->getData($sql);
        }
    }
?>