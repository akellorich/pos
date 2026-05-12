<?php
    require_once("db.php");
    use PHPMailer\PHPMailer\PHPMailer;
    require_once("../phpmailer/PHPMailer.php");
    require_once("../phpmailer/SMTP.php");
    require_once("../phpmailer/Exception.php");

    class mail extends db{
        private $smtpserver;
        private $smtpport;
        private $smtpsecurity;
        private $username;
        private $password;

        public function __construct(){
            // fetch email settings
            $sql="CALL sp_getemailconfiguration()";
            $row=$this->getData($sql)->fetch(PDO::FETCH_ASSOC);
            $this->smtpserver=$row['smtpserver'];
            $this->smtpport=$row['smtpport'];
            $this->username=$row['emailaddress'];
            $this->password=$row['password'];
            $this->smtpsecurity=$row['usessl']==1?'ssl':'tls';
        }

        public function sendEmail($recipient,$subject,$message,$sender,$attachment='',$stringattachment='',$filename=''){
            $mail= new PHPMailer();

            $mail->isSMTP();
            $mail->Host=$this->smtpserver;
            $mail->SMTPAuth=true;
            $mail->Username=$this->username;
            $mail->Password=$this->password;
            $mail->Port=$this->smtpport;
            $mail->SMTPSecure=$this->smtpsecurity;

            $mail->isHTML(true);
            $mail->SetFrom($this->username,$sender);
            $mail->addAddress($recipient);
            $mail->Subject=$subject;
            $mail->Body=$message;
            
            if($attachment!=""){
                $mail->AddAttachment($attachment);
            }

            if($stringattachment!=""){
                $mail->addStringAttachment($stringattachment,$filename);
            }

            if($mail->send()){
                return "success";
            }else{
                return $mail->ErrorInfo;
            }
        }

        public function getemailparameters(){
            $sql="CALL sp_getemailconfiguration()";
            return $this->getJSON($sql);
        }

        public function saveemailparameters($emailaddress,$emailpassword,$smtpserver,$smtpport,$usessl){
            $sql="CALL `sp_saveemailconfiguration`('{$emailaddress}','{$emailpassword}','{$smtpserver}',{$smtpport},{$usessl})";
            $this->getData($sql);
            return "success";
        }
    }
?>