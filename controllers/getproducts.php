<?php
    require_once("../models/product.php");
    $product=new product();
    echo $product->getProductByName('');
?>