<?php
    require_once("db.php");

    class pointOfSale extends db{

        public function checkPointOfSale($id, $description){
            $sql="CALL spcheckposname({$this->branchid},{$id},'{$description}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function savePointOfSale($id,$description,$postype,$printkot){
            if(!$this->checkPointOfSale($id,$description)){
                $sql="CALL spsavepos({$this->branchid},{$id},'{$description}','{$postype}',{$printkot},{$_SESSION['userid']})";
                $posid=$this->getData($sql)->fetch()['posid'];
                // echo "The point of sale has been saved successfully.";
                return ["status"=>"success","message"=>"point of sale saved successfully","posid"=>$posid];
            }else{
                return ["status"=>"exists","message"=>"point fo sale exists"];
            }
        }

        public function deletePointOfSale($id){
            $sql="CALL spdeletepos({$this->branchid},{$id},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            echo "The point of sale has been deleted successfully.";
        }

        public function getPointOfSales(){
            $sql="CALL spgetpos({$this->branchid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getposdetails($id){
            $sql="CALL spgetposdetails({$this->branchid},{$id})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function saveuseroutlet($userid,$outletid){
            $sql="CALL spsaveuseroutlet({$this->branchid},{$userid},{$outletid},{$_SESSION['userid']})";
            //echo $sql."<br />";
            $rst=$this->connect()->query($sql);
            return "success";
        }

        public function getuseroutlets($userid){
            $sql="CALL spgetuseroutlets({$this->branchid},{$userid})";
            echo $this->getJSON($sql);
        }

        public function deleteuseroutlet($id){
            $sql="CALL spdeleteoutlet({$this->branchid},{$id},{$_SESSION['userid']})";
            $rst=$this->getData($sql);
            echo "success";
        }

        public function getnonuseroutlets($userid){
            $sql="CALL spgetnonuseroutlets({$this->branchid},{$userid})";
            echo $this->getJSON($sql);
        }

        function getposproductcategories($posid){
            $sql="CALL `sp_getposproductcategories`({$this->branchid},{$posid})";
            return $this->getJSON($sql);
        }

        function saveposproductcategory($posid,$categoryid,$status){
            $sql="CALL `sp_saveposproductcategory`({$this->branchid},{$posid},{$categoryid},{$status},{$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"pos product category saved successfully"];
        }


        function checktable($tableid,$posid,$tablename){
            $sql="CALL `sp_checktable`({$this->branchid},{$tableid},{$posid},'{$tablename}')";
            return $this->getData($sql)->rowCount();
        }

        function savetable($tableid,$posid,$tablename){
            if($this->checktable($tableid,$posid,$tablename)){
                return ["status"=>"exists","message"=>"table exists in the point of sale"];
            }else{
                $sql="CALL `sp_savetable`({$this->branchid},{$tableid},{$posid},'{$tablename}',{$this->userid})";
                $this->getData($sql);
                return ["status"=>"success","message"=>"point of sale table save successfully"];
            }
        }

        function gettables($posid){
            $sql="CALL `sp_gettables`({$this->branchid},{$posid})";
            return $this->getJSON($sql);
        }

        function gettabledetails($tableid){
            $sql="CALL `sp_gettabledetails`({$this->branchid},{$tableid})";
            return $this->getJSON($sql);
        }

        function deletetable($tableid){
            $sql="CALL `sp_deletetable`({$this->branchid},{$tableid},{$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"point of sale table deleted successfully"];
        }
    }

?>