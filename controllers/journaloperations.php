<?php
    require_once("../models/journal.php");
    $journal=new journal();
    if(isset($_POST['savejournal'])){
        $referenceno=$_POST['referenceno'];
        $description=$_POST['description'];
        // Unescape the string values in the JSON array
        $tableData = stripcslashes($_POST['TableData']);
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=mt_rand(10000,99999);  
        // save temporary journal details
        foreach($tableData as $journalitem){
           $glaccount=$journalitem['glaccount'];
           $narration=$journalitem['narration'];
           $debit=$journalitem['debit'];
           $credit=$journalitem['credit']; 
           $journal->saveTempJournalDetails($refno,$glaccount,$narration,$debit,$credit);
        }
        // save permanent journal details
        $response=$journal->saveJournal($refno,$referenceno,$description);
        if(is_numeric($response)){
            echo "success";
        }else{
            echo $response;
        }
    }
?>