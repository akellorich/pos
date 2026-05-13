<?php 
    require_once("db.php");
    class journal extends db{

        public function checkJournalReferenceNo($referenceno){
            $sql="CALL spcheckjournalrefereceno({$this->branchid},'{$referenceno}')";
            $rst=$this->getData($sql);
            if($rst->rowCount()){
                return true;
            }else{
                return false;
            }
        }

        public function saveTempJournalDetails($refno,$glaccount,$narration,$debit,$credit){
            $sql="CALL spsavetempjournaldetails({$this->branchid},{$refno},{$glaccount},'{$narration}',{$debit},{$credit})";
            $this->getData($sql);
        }

        public function saveJournal($refno,$referenceno,$description){
            if(!$this->checkJournalReferenceNo($referenceno)){
                $sql="CALL spsavejournaltransaction({$this->branchid},'{$refno}','{$referenceno}','{$description}',{$_SESSION['userid']},1)";
                $rst=$this->getData($sql);
                $data=$rst->fetch(PDO::FETCH_ASSOC);
                return $data['journalid'];
            }else{
                return "The Journal Reference Number specified is already in use.";
            }
        }

        public function getJournals($startdate,$enddate){

        }

        public function getJournalDetails($journalid){

        }
    }