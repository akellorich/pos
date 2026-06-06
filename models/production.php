<?php
    require_once("db.php");
    
    class production extends db {
        public function getProductions($alldates, $startdate, $enddate, $warehouseid, $productid)
        {
            $alldates = (int)$alldates;
            $warehouseid = (int)$warehouseid;
            $productid = (int)$productid;
            
            $sql = "CALL spgetproductions({$this->clientid}, {$alldates}, '{$startdate}', '{$enddate}', {$warehouseid}, {$productid})";
            return $this->getJSON($sql);
        }

        public function getProductsWithRecipes()
        {
            $sql = "CALL spgetproductswithrecipes({$this->clientid})";
            return $this->getJSON($sql);
        }

        public function saveProduction($id, $productiondate, $productid, $quantity, $warehouseid)
        {
            $id = (int)$id;
            $productid = (int)$productid;
            $quantity = (float)$quantity;
            $warehouseid = (int)$warehouseid;
            $userid = (int)$_SESSION['userid'];

            $sql = "CALL spsaveproduction({$id}, {$this->clientid}, '{$productiondate}', {$productid}, {$quantity}, {$warehouseid}, {$userid})";
            $this->connect()->query($sql);
            return "success";
        }

        public function deleteProduction($id)
        {
            $id = (int)$id;
            $userid = (int)$_SESSION['userid'];
            $sql = "CALL spdeleteproduction({$this->clientid}, {$id}, {$userid})";
            $this->connect()->query($sql);
            return "success";
        }
    }
?>
