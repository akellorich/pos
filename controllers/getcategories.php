<?php

require_once("../models/category.php");

$category=new category();

echo $category->getCategories();

?>