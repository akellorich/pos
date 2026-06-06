<?php

    require_once("../models/product.php");
    $product=new product();

    if(isset($_GET['filterproductbyname'])){
        $posid=isset($_GET['posid'])?$_GET['posid']:0;
        $name=$_GET['name'];
        echo $product->getProductByName($name,$posid);
    }
    if(isset($_GET['getstocktransferitembalance'])){
        $sourcetype=$_GET['sourcetype'];
        $sourceid=$_GET['sourceid'];
        $itemcode=$_GET['itemcode'];
        echo $product->getStockTransferItembalance($sourcetype,$sourceid,$itemcode);
    }
    if(isset($_POST['savetransfer'])){
        // get post variables
        $sourcetype=$_POST['sourcetype'];
        $sourceid=$_POST['sourceid'];
        $destinationtype=$_POST['destinationtype'];
        $destinationid=$_POST['destinationid'];
        $issuedto=$_POST['issuedto'];
        $storecontroller=$_POST['storecontroller'];
        //generate a random reference number
        $refno=generate_random_no();

        // temp save the items
        $tableData = json_decode(stripcslashes($_POST['TableData']),TRUE);

        foreach($tableData as $transferitem){
            $itemcode=$transferitem['itemcode'];
            $quantity=$transferitem['quantity'];
            $unitprice=$transferitem['unitprice'];
            $serialno=$transferitem['serialno'];
            $product->saveTempStockTransferItems($refno,$itemcode,$quantity,$unitprice,$serialno);
        }
        // save the transfer
        $transferrefno=$product->saveStockTransfer($refno,$sourcetype,$sourceid,$destinationtype,$destinationid,$issuedto,$storecontroller);
        echo $transferrefno;
    }
    if(isset($_GET['getdiscountmatrix'])){
        $itemcode=$_GET['itemcode'];
        echo $product->getProductDiscountMatrix($itemcode);
    }
    if(isset($_POST['checktransactions'])){
        $productid=$_POST['productid'];
        if ($product->hasTransactions($productid)) {
            echo "has_transactions";
        } else {
            echo "no_transactions";
        }
    }
    if(isset($_POST['deleteproduct'])){
        $productid=$_POST['productid'];
        echo $product->deleteProduct($productid);
    }
    if(isset($_POST['mergeanddelete'])){
        $sourceid=$_POST['sourceid'];
        $targetid=$_POST['targetid'];
        echo $product->mergeAndDeleteProduct($sourceid, $targetid);
    }
    if(isset($_GET['getproductbycategory'])){
        $categoryid=$_GET['categoryid'];
        $posid=isset($_GET['posid'])?$_GET['posid']:0;
        echo $product->getProductByCategory($categoryid, $posid);
    }
    if(isset($_POST['savesupplierproducts'])){
        $supplierid=$_POST['supplierid'];
        foreach($_POST['productname'] as $row){
            $productid=$row;
            $product->saveSupplierProducts($supplierid,$productid);
        }
        echo "success";
    }
    if(isset($_GET['getsupplierproducts'])){
        $supplierid=$_GET['supplierid'];
        echo $product->getSupplierProducts($supplierid);
    }
    if(isset($_POST['deletesupplierproduct'])){
        $id=$_POST['id'];
        echo $product->deleteSupplierProduct($id);
    }
    if(isset($_POST['getpurchaseorderdetails'])){
        $id=$_POST['id'];
        echo $product->getPurchaseOrderDetails($id);
    }
    if(isset($_POST['savestockreconciliation'])){
        $refno=generate_random_no();
        $narration=$_POST['narration'];
        $posid=$_POST['posid'];
        $category=$_POST['category'];
        $itemslist=json_decode(stripcslashes($_POST['itemslist']),true);

        // temp save the reconciled items 
        foreach($itemslist as $item){
            $itemid=$item['itemid'];
            $quantity=$item['quantity'];
            $unitprice=$item['unitprice'];
            $product->savetempreconciledstockbalance($refno,$itemid,$quantity,$unitprice);
        }

        // post the reconciled stock balances
        echo $product->savereconciledstockbalance($refno,$narration,$posid,$category);
    }
    if(isset($_POST['saveproduct'])){
        $id=$_POST['id'];
        $itemcode=$_POST['itemcode'];
        $itemname=$_POST['itemname'];
        $uom=$_POST['uom'];
        $categoryid=$_POST['categoryid'];
        $buyingprice=$_POST['buyingprice'];
        $sellingprice=$_POST['sellingprice'];
        $reorderlevel=$_POST['reorderlevel'];
        $generatecode=$_POST['generatecode'];
        $serializable=$_POST['serializable'];
        $bundleitem=$_POST['bundleitem'];
        $taxtype=$_POST['taxtype'];
        $length=$_POST['length'];
        $width=$_POST['width'];
        $height=$_POST['height'];
        $allownegativesales=$_POST['allownegativesales'];
        $saleby=$_POST['saleby'];
        $bundleproduct=$_POST['bundleproduct'];
        $allowreturnexchange=$_POST['allowreturnexchange'];
        $rawmaterial=$_POST['rawmaterial'];
        $itemtype=$_POST['itemtype'];
        $disallowpurchasing=$_POST['disallowpurchasing'];
        $disallowreceipt=$_POST['disallowreceipt'];
        $disallowsale=$_POST['disallowsale'];
        
        // Decode the JSON array
        $tableData = json_decode(stripcslashes($_POST['TableData']),TRUE);
        
        // generate reference no
        $refno=generate_random_no();

        // save temporary
        foreach($tableData as $saleitem){

           $catid=$saleitem['catid'];
           $percentage=$saleitem['percentage'];
           $value=$saleitem['value'];
  
          $product->saveTempPriceMatrix($refno,$catid,$percentage,$value);
        
        }
        // save temp product price matrix
        echo $product->saveProduct($id,$itemcode,$itemname,$categoryid,$uom,$buyingprice,$sellingprice,$reorderlevel,$refno,
        $generatecode,$serializable,$bundleitem,$taxtype,$length,$width,$height,$allownegativesales,$saleby,$bundleproduct,$allowreturnexchange,
        $rawmaterial,$itemtype,$disallowpurchasing,$disallowreceipt,$disallowsale);
    }
    if(isset($_GET['getproductdetails'])){
        $storeid=isset($_GET['storeid'])?$_GET['storeid']:0;
        $productcode=$_GET['productcode'];
        $customerid=isset($_GET['customerid'])?$_GET['customerid']:0;
        echo $product->getProductDetails($productcode,$customerid,$storeid);

    }
    if(isset($_GET['getexistingproductserialnumbers'])){
        $productid=$_GET['productid'];
        echo $product->getavailableserialnumbers($productid);
    }
    if(isset($_GET['getbundleitems'])){
        echo $product->getbundleitems();
    }
    if(isset($_GET['getproductstatement'])){
        $itemcode=$_GET['itemcode'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        echo $product->getproductstatement($itemcode,$startdate,$enddate);
    }
    if(isset($_GET['getproducthistory'])){
        $tab = isset($_GET['tab']) ? $_GET['tab'] : '';
        $productid = isset($_GET['productid']) ? $_GET['productid'] : 0;
        $itemcode = isset($_GET['itemcode']) ? $_GET['itemcode'] : '';
        $startdate = isset($_GET['startdate']) ? $_GET['startdate'] : '';
        $enddate = isset($_GET['enddate']) ? $_GET['enddate'] : '';

        switch($tab){
            case 'movement':
                echo $product->getProductMovementHistory($productid, $startdate, $enddate);
                break;
            case 'pricing':
                $price_type = isset($_GET['price_type']) ? $_GET['price_type'] : '0';
                echo $product->getProductPricingHistory($productid, $price_type, $startdate, $enddate);
                break;
            case 'purchase':
                echo $product->getProductPurchaseHistory($productid, $startdate, $enddate);
                break;
            case 'sales':
                echo $product->getProductSalesHistory($productid, $startdate, $enddate);
                break;
            case 'transfers':
                $source_type = isset($_GET['source_type']) ? $_GET['source_type'] : '0';
                $source_id = isset($_GET['source_id']) ? $_GET['source_id'] : '0';
                $dest_type = isset($_GET['dest_type']) ? $_GET['dest_type'] : '0';
                $dest_id = isset($_GET['dest_id']) ? $_GET['dest_id'] : '0';
                echo $product->getProductTransfersHistory($productid, $source_type, $source_id, $dest_type, $dest_id, $startdate, $enddate);
                break;
            case 'spoilage':
                $categoryid = isset($_GET['spoilage_type']) ? $_GET['spoilage_type'] : '0';
                echo $product->getProductSpoilageHistory($productid, $categoryid, $startdate, $enddate);
                break;
        }
    }
    if(isset($_GET['getcratesummary'])){
        $asatdate=$_GET['asatdate'];
        echo $product->getcratesummary($asatdate);
    }
    if(isset($_GET['getwarehouseproductsummary'])){
        $warehouseid=$_GET['warehouseid'];
        $asat=$_GET['asat'];
        echo $product->getwarehousestockbalance($warehouseid,$asat);
    }

    if(isset($_GET['getreturnableproducts'])){
        echo $product->getreturnableproducts();
    }

    if(isset($_GET['filterrawproducts'])){
        $name=$_GET['name'];
        echo $product->getRawProducts($name);
    }
    if(isset($_POST['saveproductrecipe'])){
        $productid=$_POST['productid'];
        $recipeitemid=$_POST['recipeitemid'];
        $quantity=$_POST['quantity'];
        echo $product->saveProductRecipe($productid,$recipeitemid,$quantity);
    }
    if(isset($_GET['getproductrecipes'])){
        $productid=$_GET['productid'];
        echo $product->getProductRecipes($productid);
    }
    if(isset($_POST['deleteproductrecipe'])){
        $recipeid=$_POST['recipeid'];
        echo $product->deleteProductRecipe($recipeid);
    }

    if(isset($_GET['getproductsplitunits'])){
        $productid=$_GET['productid'];
        echo $product->getProductSplitUnits($productid);
    }
    if(isset($_POST['saveproductsplitunit'])){
        $id=$_POST['id'];
        $productid=$_POST['productid'];
        $unitname=$_POST['unitname'];
        $unitsoftotal=$_POST['unitsoftotal'];
        $unitprice=$_POST['unitprice'];
        echo $product->saveProductSplitUnit($id,$productid,$unitname,$unitsoftotal,$unitprice);
    }
    if(isset($_POST['deleteproductsplitunit'])){
        $id=$_POST['id'];
        echo $product->deleteProductSplitUnit($id);
    }

    if(isset($_POST['importproducts'])){
        $productsData = json_decode($_POST['products'], true);
        $categoryMode = isset($_POST['categoryMode']) ? $_POST['categoryMode'] : 'dynamic';
        $specificCategoryId = isset($_POST['specificCategoryId']) ? (int)$_POST['specificCategoryId'] : 0;
        $checkExists = isset($_POST['checkExists']) ? (int)$_POST['checkExists'] : 0;
        $generateCode = isset($_POST['generateCode']) ? (int)$_POST['generateCode'] : 0;
        
        $importOpeningBalance = isset($_POST['importOpeningBalance']) ? (int)$_POST['importOpeningBalance'] : 0;
        $balanceCategory = isset($_POST['balanceCategory']) ? $_POST['balanceCategory'] : '';
        $balanceLocation = isset($_POST['balanceLocation']) ? (int)$_POST['balanceLocation'] : 0;
        $autoReconcile = isset($_POST['autoReconcile']) ? (int)$_POST['autoReconcile'] : 0;

        require_once("../models/category.php");
        $catModel = new category();
        $db = $product->connect();

        // Find standard / first tax type id
        $defaultTaxTypeId = 1;
        try {
            $taxStmt = $db->query("SELECT id FROM taxtypes LIMIT 1");
            $firstTaxId = $taxStmt->fetchColumn();
            if ($firstTaxId) {
                $defaultTaxTypeId = (int)$firstTaxId;
            }
        } catch (Exception $e) {
            // fallback to 1
        }

        // Preload categories mapping for faster checks (case-insensitive)
        $categoriesMap = [];
        try {
            $catStmt = $db->prepare("SELECT categoryid, LOWER(TRIM(categoryname)) as catname FROM categories WHERE clientid = ?");
            $catStmt->execute([$product->clientid]);
            while($row = $catStmt->fetch(PDO::FETCH_ASSOC)) {
                $categoriesMap[$row['catname']] = (int)$row['categoryid'];
            }
            $catStmt->closeCursor();
        } catch (Exception $e) {
            // ignore
        }

        $importedCount = 0;
        $skippedCount = 0;
        $errorsList = [];
        $reconciliationItems = [];

        foreach($productsData as $index => $row) {
            $itemname = isset($row['Item Name']) ? trim($row['Item Name']) : '';
            if ($itemname === '') {
                $skippedCount++;
                $errorsList[] = "Row " . ($index + 1) . ": Item Name is empty.";
                continue;
            }

            $itemcode = isset($row['Item Code']) ? trim($row['Item Code']) : '';
            $catName = isset($row['Category Name']) ? trim($row['Category Name']) : '';
            $uom = isset($row['UOM']) ? trim($row['UOM']) : 'PCS';
            $buyingprice = isset($row['Buying Price']) ? (float)$row['Buying Price'] : 0.00;
            $sellingprice = isset($row['Retail Price']) ? (float)$row['Retail Price'] : 0.00;
            $reorderlevel = isset($row['Reorder Level']) ? (int)$row['Reorder Level'] : 0;

            // Resolve category id
            $categoryid = 0;
            if ($categoryMode === 'specific') {
                $categoryid = $specificCategoryId;
            } else {
                $catKey = strtolower(trim($catName));
                if ($catKey === '') {
                    $catKey = 'default';
                    $catName = 'Default';
                }

                if (isset($categoriesMap[$catKey])) {
                    $categoryid = $categoriesMap[$catKey];
                } else {
                    // Category does not exist, create it
                    $cleanName = preg_replace('/[^A-Za-z]/', '', $catName);
                    if (strlen($cleanName) < 3) {
                        $cleanName = str_pad($cleanName, 3, 'X');
                    }
                    $basePrefix = strtoupper(substr($cleanName, 0, 3));
                    $prefix = $basePrefix;
                    $suffix = 1;
                    
                    while ($catModel->checkCategory(0, 'prefix', $prefix)) {
                        $prefix = substr($basePrefix, 0, 2) . $suffix;
                        $suffix++;
                    }

                    $catResult = $catModel->saveCategory(0, $catName, $prefix, 1);
                    if ($catResult['status'] === 'success') {
                        // Retrieve the new category id
                        $getCatStmt = $db->prepare("SELECT categoryid FROM categories WHERE clientid = ? AND LOWER(categoryname) = LOWER(?) LIMIT 1");
                        $getCatStmt->execute([$product->clientid, $catName]);
                        $categoryid = (int)$getCatStmt->fetchColumn();
                        $getCatStmt->closeCursor();
                        
                        $categoriesMap[$catKey] = $categoryid;
                    } else {
                        $skippedCount++;
                        $errorsList[] = "Row " . ($index + 1) . ": Failed to create category '{$catName}'. Msg: " . $catResult['message'];
                        continue;
                    }
                }
            }

            // Let's call saveProduct
            $refno = generate_random_no();
            
            // Custom check exists
            if ($checkExists) {
                if ($generateCode == 0 && $itemcode !== '' && $product->checkProduct(0, $itemcode, 'code')) {
                    $skippedCount++;
                    continue;
                }
                if ($product->checkProduct(0, $itemname, 'name')) {
                    $skippedCount++;
                    continue;
                }
            }

            // Call saveProduct
            $saveResult = $product->saveProduct(
                0, // id (new item)
                $itemcode,
                $itemname,
                $categoryid,
                $uom,
                $buyingprice,
                $sellingprice,
                $reorderlevel,
                $refno,
                $generateCode,
                0, // serializable
                0, // bundleitem
                $defaultTaxTypeId,
                0, // length
                0, // width
                0, // height
                0, // allownegativesales
                'quantity', // saleby
                0, // bundleproduct
                0, // allowreturnexchange
                0, // rawmaterial
                'product', // itemtype
                0, // disallowpurchasing
                0, // disallowreceipt
                0  // disallowsale
            );

            if ($saveResult === "success") {
                $importedCount++;

                // If opening balance import is requested and quantity is greater than 0
                $opBal = isset($row['Opening Balance']) ? (float)$row['Opening Balance'] : 0.00;
                $unitCost = isset($row['Unit Cost']) ? (float)$row['Unit Cost'] : 0.00;
                if ($unitCost <= 0) {
                    $unitCost = $buyingprice;
                }

                if ($importOpeningBalance && $opBal > 0) {
                    // Fetch the newly inserted product's productid
                    $getProdIdStmt = $db->prepare("SELECT productid FROM products WHERE clientid = ? AND LOWER(itemname) = LOWER(?) ORDER BY productid DESC LIMIT 1");
                    $getProdIdStmt->execute([$product->clientid, $itemname]);
                    $newProductId = (int)$getProdIdStmt->fetchColumn();
                    $getProdIdStmt->closeCursor();

                    if ($newProductId > 0) {
                        $reconciliationItems[] = [
                            'productid' => $newProductId,
                            'quantity' => $opBal,
                            'unitprice' => $unitCost
                        ];
                    }
                }
            } else {
                $skippedCount++;
                $errorsList[] = "Row " . ($index + 1) . ": Product '{$itemname}' could not be saved. Reason: {$saveResult}";
            }
        }

        // Post opening stock balance if any and location is specified
        if ($importOpeningBalance && count($reconciliationItems) > 0 && $balanceLocation > 0 && $balanceCategory !== '') {
            $reconRef = generate_random_no();
            try {
                foreach($reconciliationItems as $item) {
                    $product->savetempreconciledstockbalance($reconRef, $item['productid'], $item['quantity'], $item['unitprice']);
                }
                
                if ($autoReconcile) {
                    $product->savereconciledstockbalance($reconRef, "Opening Balance Import via Bulk Import", $balanceLocation, $balanceCategory);
                }
            } catch (Exception $e) {
                $errorsList[] = "Stock Reconciliation Error: " . $e->getMessage();
            }
        }

        echo json_encode([
            "status" => "success",
            "imported" => $importedCount,
            "skipped" => $skippedCount,
            "errors" => $errorsList
        ]);
        exit;
    }
?>