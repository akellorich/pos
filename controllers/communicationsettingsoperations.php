<?php
    require_once("../models/settings.php");
    $setting = new settings();

    if (isset($_GET['getcommsettings'])) {
        echo $setting->getCommunicationSettings();
        exit();
    }

    if (isset($_POST['savecommsettings'])) {
        $type = $_POST['type'];
        $data = [];
        
        if ($type == 'email') {
            $data = [
                'emailaddress' => $_POST['emailaddress'],
                'password' => $_POST['password'],
                'smtpserver' => $_POST['smtpserver'],
                'usessl' => isset($_POST['usessl']) ? (int)$_POST['usessl'] : 0,
                'smtpport' => (int)$_POST['smtpport']
            ];
        } else if ($type == 'sms') {
            $data = [
                'apikey' => $_POST['apikey'],
                'senderid' => $_POST['senderid'],
                'partnerid' => $_POST['partnerid'],
                'url' => $_POST['url']
            ];
        } else if ($type == 'whatsapp') {
            $data = [
                'apikey' => $_POST['apikey'],
                'phone_number_id' => $_POST['phone_number_id'],
                'url' => $_POST['url']
            ];
        }
        
        echo $setting->saveCommunicationSettings($type, $data);
        exit();
    }

    if (isset($_POST['testcommsettings'])) {
        $type = $_POST['type'];
        $recipient = $_POST['recipient'];
        $data = [];
        
        if ($type == 'email') {
            $data = [
                'emailaddress' => $_POST['emailaddress'],
                'password' => $_POST['password'],
                'smtpserver' => $_POST['smtpserver'],
                'usessl' => isset($_POST['usessl']) ? (int)$_POST['usessl'] : 0,
                'smtpport' => (int)$_POST['smtpport']
            ];
        } else if ($type == 'sms') {
            $data = [
                'apikey' => $_POST['apikey'],
                'senderid' => $_POST['senderid'],
                'partnerid' => $_POST['partnerid'],
                'url' => $_POST['url']
            ];
        } else if ($type == 'whatsapp') {
            $data = [
                'apikey' => $_POST['apikey'],
                'phone_number_id' => $_POST['phone_number_id'],
                'url' => $_POST['url']
            ];
        }
        
        echo $setting->testCommunicationSettings($type, $data, $recipient);
        exit();
    }
?>
