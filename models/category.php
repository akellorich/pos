<?php 

require_once('db.php');

class category extends db{

    public function checkCategory($id,$checkfield,$checkvalue){
        $sql="CALL spcheckcategory({$this->clientid},{$id},'{$checkfield}','{$checkvalue}')";
        //echo $sql."<br/>";
        $rst=$this->connect()->query($sql);
        return $rst->rowCount()?true:false;
    }

    public function saveCategory($id,$categoryname,$prefix,$currentno){
        if($this->checkCategory($id,'categoryname',$categoryname)){
           return ["status"=>"exists","message"=>"category name exists","category"=>"categoryname"];
        }else if($this->checkCategory($id,'prefix',$prefix))
            return ["status"=>"exists","message"=>"category prefix exists","category"=>"prefix"];
        else{
            $sql="CALL spsavecategory({$this->clientid},{$id},'{$categoryname}','{$prefix}',{$currentno},{$_SESSION['userid']})";
            //echo $sql;
            $rst=$this->connect()->query($sql);
            return ["status"=>"success","message"=>"category saved successfully"];
        } 
    }

    public function deleteCategory($categoryid){
        $sql="CALL spdeletecategory({$this->clientid},{$categoryid},{$_SESSION['userid']})";
        //echo $sql."<br/>";
        $rst=$this->connect()->query($sql);
        echo "The category has been deleted successfully.";
    }

    public function getCategories(){
        $sql="CALL spgetcategories({$this->clientid})";
        $rst=$this->connect()->query($sql);
        $data=$rst->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($data);
    }

    public function getCategoryDetails($id){
        $sql="CALL spgetcategorydetails({$this->clientid},{$id})";
        $rst=$this->connect()->query($sql);
        $data=$rst->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($data);
    }
}

?>