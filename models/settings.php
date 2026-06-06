<?php
    require_once('db.php');
    class settings extends db{

        function getUnitsOfMeasure(){
            $sql="CALL spgteunitsofmeasure({$this->branchid})";
            //$rst=$this->connect()->query($sql);
            //return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getPaymentMethods(){
            $sql="CALL spgetpaymentmethods({$this->clientid},{$this->branchid})";
            $rst=$this->getData($sql);
            // echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            $_page = array();
            foreach ($rst as $i => $status) {
                $requireseref=($status['requiresrefno']?1:0);
                $_page[] = array(
                    'id' => $status['id'],
                    'description' => $status['description'],
                    'image' => 'data:image/jpeg;base64,'.base64_encode($status['image']),
                    'requiresrefno' =>$requireseref, // $status['requiresrefno']
                    'supplierslist'=>$status['supplierslist'],
                    'default'=> $status['default'],
                );
            }
            //header ("Content-type: application/json");
            return json_encode($_page);
        }

        function getInstitutionDetails(){
            $sql="CALL spgetinstitutiondetails({$this->clientid})";
            return $this->getJSON($sql);
        }

        function getPrivileges($module){
            $sql="CALL spgetobjects({$this->branchid},'{$module}')";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getTodaysDate(){
            $sql="CALL spgettodaysdate({$this->branchid})";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetch(PDO::FETCH_ASSOC)); 
            return $this->getJSON($sql);
        }

        function getSalesSettings(){
            $sql="CALL spgetsalessettings({$this->branchid})";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetch(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getSystemModules(){
            $sql="CALL spgetsystemmodules({$this->branchid})";
            return $this->getJSON($sql);
        }

        function savecrateinventorysettings($productid,$customerid,$glaccountid,$costcenter,$paymentcenter,$paymentaccount){
            $sql="CALL spsavecrateinventorysettings({$this->branchid},{$productid},{$customerid},{$glaccountid},{$costcenter},{$paymentcenter},{$paymentaccount})";
            $this->getData($sql);
            return "success";
        }

        function getcrateinventorysettings(){
            $sql="CALL spgetcrateinventorysettings({$this->branchid})";
            return $this->getJSON($sql);
        }

        function getcrateadditionparameters(){
            $sql="CALL spgetcrateadditionparameters({$this->branchid})";
            return $this->getJSON($sql);
        }

        function savecrateaddition($productid,$quantity,$unitprice,$narration,$reference){
            if(!$this->checkcrateadditionreference($reference)){
                $sql="CALL spsavecrateaddition({$this->branchid},{$productid},{$quantity},{$unitprice},'{$narration}','{$reference}',{$_SESSION['userid']})";
                $this->getData($sql);
                return "success";
            }else{
                return "exists";
            }
        }

        function checkcrateadditionreference($reference){
            $sql="CALL spcheckcrateadditionreference({$this->branchid},'{$reference}')";
            return $this->getData($sql)->rowCount()?true:false;
        }

        function gettaxtypes(){
            $sql="CALL `spgettaxtypes`({$this->branchid})";
            return $this->getJSON($sql);
        }

        function getcurrencies(){
            $sql="CALL `sp_getcurrencies`({$this->branchid})";
            return $this->getJSON($sql);
        }

        function getdepartments(){
            $sql="CALL sp_getdepartments({$this->branchid})";
            return $this->getJSON($sql);
        }

        function gettaxdetails($taxid){
            $sql="CALL `sp_gettaxdetails`({$this->branchid},{$taxid})";
            return $this->getJSON($sql);
        }

        function getpapergrammage(){
            $sql="CALL `sp_getpapergrammage`({$this->branchid})";
            return $this->getJSON($sql);
        }

        function getdefaultterms(){
            $sql="CALL `sp_getdefaultterms`({$this->branchid})";
            return $this->getJSON($sql);
        }

        function saveinstitutiondetails($companyname,$physicaladdress,$postaladdress,$landline,$email,$mobile,$pinno,
        $autoinvoicegrn,$postalcode,$tagline,$website,$receiptfooter,$defaultcustomer,$mainbusinesstype,$logo,$town,
        $allowpricechange,$allownegativesalesglobally){
            $sql="CALL `sp_saveinstitutiondetails`({$this->clientid},'{$companyname}','{$physicaladdress}','{$postaladdress}','{$landline}','{$email}','{$mobile}','{$pinno}',
           {$autoinvoicegrn},'{$postalcode}','{$tagline}','{$website}','{$receiptfooter}',{$defaultcustomer},'{$mainbusinesstype}','{$logo}','{$town}',{$allowpricechange},{$allownegativesalesglobally})";
           $this->getData($sql);
           return ["status"=>"success","message"=>"institution details saved successfully"];
        }

        function getwarehouses(){
            $sql="CALL spgetwarehouses({$this->branchid})";
            return $this->getJSON($sql);
        }
        function getBranches(){
            $sql="CALL sp_getbranches({$this->clientid})";
            return $this->getJSON($sql);
        }

        function saveBranch($branchid, $branchname, $location){
            $sql="CALL sp_savebranch($branchid, '$branchname', '$location', {$this->clientid}, {$this->userid})";
            $this->getData($sql);
            return "success";
        }

        function deleteBranch($branchid){
            $sql="CALL sp_deletebranch($branchid, {$this->userid})";
            $this->getData($sql);
            return "success";
        }

        function checkBranch($branchid, $branchname){
            $sql="CALL sp_checkbranch($branchid, '$branchname', {$this->clientid})";
            return $this->getData($sql)->rowCount() ? "exists" : "available";
        }

        function getCountries(){
            $sql="CALL spgetcountries()";
            return $this->getJSON($sql);
        }

        function saveCountry($countryid, $countryname, $countrycode, $currency, $currencysymbol, $dialingcode, $isdefault){
            $sql="CALL spsavecountry($countryid, '$countryname', '$countrycode', '$currency', '$currencysymbol', '$dialingcode', $isdefault)";
            $this->getData($sql);
            return "success";
        }

        function getCommunicationSettings(){
            $pdo=$this->connect();
            
            // Email Configuration
            $email = null;
            $stmt = $pdo->prepare("SELECT * FROM `emailconfiguration` WHERE `clientid` = ?");
            $stmt->execute([$this->clientid]);
            if ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $email = $row;
            } else {
                $email = [
                    "emailaddress" => "",
                    "password" => "",
                    "smtpserver" => "",
                    "usessl" => 0,
                    "smtpport" => 587
                ];
            }
            
            // SMS Configuration
            $sms = null;
            $stmt = $pdo->prepare("SELECT * FROM `smsconfiguration` WHERE `clientid` = ?");
            $stmt->execute([$this->clientid]);
            if ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $sms = $row;
            } else {
                $sms = [
                    "apikey" => "",
                    "senderid" => "",
                    "partnerid" => "",
                    "url" => ""
                ];
            }
            
            // WhatsApp Configuration
            $whatsapp = null;
            $stmt = $pdo->prepare("SELECT * FROM `whatsappconfiguration` WHERE `clientid` = ?");
            $stmt->execute([$this->clientid]);
            if ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $whatsapp = $row;
            } else {
                $whatsapp = [
                    "apikey" => "",
                    "phone_number_id" => "",
                    "url" => ""
                ];
            }
            
            return json_encode([
                "email" => $email,
                "sms" => $sms,
                "whatsapp" => $whatsapp
            ]);
        }

        function saveCommunicationSettings($type, $data){
            $pdo=$this->connect();
            if ($type == 'email') {
                $stmt = $pdo->prepare("SELECT COUNT(*) FROM `emailconfiguration` WHERE `clientid` = ?");
                $stmt->execute([$this->clientid]);
                $exists = $stmt->fetchColumn() > 0;
                if ($exists) {
                    $stmt = $pdo->prepare("UPDATE `emailconfiguration` SET `emailaddress` = ?, `password` = ?, `smtpserver` = ?, `usessl` = ?, `smtpport` = ? WHERE `clientid` = ?");
                    $stmt->execute([$data['emailaddress'], $data['password'], $data['smtpserver'], $data['usessl'], $data['smtpport'], $this->clientid]);
                } else {
                    $stmt = $pdo->prepare("INSERT INTO `emailconfiguration` (`clientid`, `emailaddress`, `password`, `smtpserver`, `usessl`, `smtpport`) VALUES (?, ?, ?, ?, ?, ?)");
                    $stmt->execute([$this->clientid, $data['emailaddress'], $data['password'], $data['smtpserver'], $data['usessl'], $data['smtpport']]);
                }
                return "success";
            } else if ($type == 'sms') {
                $stmt = $pdo->prepare("SELECT COUNT(*) FROM `smsconfiguration` WHERE `clientid` = ?");
                $stmt->execute([$this->clientid]);
                $exists = $stmt->fetchColumn() > 0;
                if ($exists) {
                    $stmt = $pdo->prepare("UPDATE `smsconfiguration` SET `apikey` = ?, `senderid` = ?, `partnerid` = ?, `url` = ? WHERE `clientid` = ?");
                    $stmt->execute([$data['apikey'], $data['senderid'], $data['partnerid'], $data['url'], $this->clientid]);
                } else {
                    $stmt = $pdo->prepare("INSERT INTO `smsconfiguration` (`clientid`, `apikey`, `senderid`, `partnerid`, `url`) VALUES (?, ?, ?, ?, ?)");
                    $stmt->execute([$this->clientid, $data['apikey'], $data['senderid'], $data['partnerid'], $data['url']]);
                }
                return "success";
            } else if ($type == 'whatsapp') {
                $stmt = $pdo->prepare("SELECT COUNT(*) FROM `whatsappconfiguration` WHERE `clientid` = ?");
                $stmt->execute([$this->clientid]);
                $exists = $stmt->fetchColumn() > 0;
                if ($exists) {
                    $stmt = $pdo->prepare("UPDATE `whatsappconfiguration` SET `apikey` = ?, `phone_number_id` = ?, `url` = ? WHERE `clientid` = ?");
                    $stmt->execute([$data['apikey'], $data['phone_number_id'], $data['url'], $this->clientid]);
                } else {
                    $stmt = $pdo->prepare("INSERT INTO `whatsappconfiguration` (`clientid`, `apikey`, `phone_number_id`, `url`) VALUES (?, ?, ?, ?)");
                    $stmt->execute([$this->clientid, $data['apikey'], $data['phone_number_id'], $data['url']]);
                }
                return "success";
            }
            return "invalid_type";
        }

        function testCommunicationSettings($type, $data, $recipient){
            if ($type == 'email') {
                require_once(dirname(__DIR__,1) . "/phpmailer/PHPMailer.php");
                require_once(dirname(__DIR__,1) . "/phpmailer/SMTP.php");
                require_once(dirname(__DIR__,1) . "/phpmailer/Exception.php");
                
                $mail = new PHPMailer\PHPMailer\PHPMailer(true);
                try {
                    $mail->isSMTP();
                    $mail->Host = $data['smtpserver'];
                    $mail->SMTPAuth = true;
                    $mail->Username = $data['emailaddress'];
                    $mail->Password = $data['password'];
                    $mail->Port = $data['smtpport'];
                    $mail->SMTPSecure = $data['usessl'] == 1 ? 'ssl' : 'tls';
                    
                    $mail->isHTML(true);
                    $mail->SetFrom($data['emailaddress'], "SalesFlow API Test");
                    $mail->addAddress($recipient);
                    $mail->Subject = "SalesFlow Email API Connection Test";
                    $mail->Body = "<h3>Connection Test Successful</h3><p>Your SalesFlow SMTP email settings are configured correctly.</p>";
                    
                    if ($mail->send()) {
                        return "success";
                    } else {
                        return "Email failed to send: " . $mail->ErrorInfo;
                    }
                } catch (Exception $e) {
                    return "Error: " . $e->getMessage();
                }
            } else if ($type == 'sms') {
                $message = urlencode("SalesFlow SMS API Connection Test Successful!");
                $redirecturl = $data['url'] . "?ApiKey=" . urlencode($data['apikey']);
                $redirecturl .= "&ClientId=" . urlencode($data['partnerid']);
                $redirecturl .= "&SenderId=" . urlencode($data['senderid']);
                $redirecturl .= "&Message=" . $message;
                $redirecturl .= "&MobileNumbers=" . urlencode($recipient);
                
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $redirecturl);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_TIMEOUT, 10);
                
                $response = curl_exec($ch);
                $err = curl_error($ch);
                curl_close($ch);
                
                if ($err) {
                    return "SMS API Request Error: " . $err;
                }
                return "success. Response: " . substr($response, 0, 200);
            } else if ($type == 'whatsapp') {
                $url = $data['url'];
                if (empty($url)) {
                    $url = "https://graph.facebook.com/v16.0/" . $data['phone_number_id'] . "/messages";
                }
                
                $payload = json_encode([
                    "messaging_product" => "whatsapp",
                    "to" => $recipient,
                    "type" => "text",
                    "text" => [
                        "body" => "SalesFlow WhatsApp API Connection Test Successful!"
                    ]
                ]);
                
                $ch = curl_init($url);
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_TIMEOUT, 10);
                curl_setopt($ch, CURLOPT_HTTPHEADER, [
                    "Authorization: Bearer " . $data['apikey'],
                    "Content-Type: application/json"
                ]);
                
                $response = curl_exec($ch);
                $err = curl_error($ch);
                curl_close($ch);
                
                if ($err) {
                    return "WhatsApp API Request Error: " . $err;
                }
                return "success. Response: " . substr($response, 0, 200);
            }
            return "invalid_type";
        }
    }
?>