<?php
$directory = new RecursiveDirectoryIterator(__DIR__);
$iterator = new RecursiveIteratorIterator($directory);
$regex = new RegexIterator($iterator, '/\.(txt|pem|crt|key)$/i', RecursiveRegexIterator::GET_MATCH);

foreach ($regex as $file => $value) {
    // Skip vendors or cache or .git directories to be fast
    if (strpos($file, 'node_modules') !== false || 
        strpos($file, '.git') !== false || 
        strpos($file, 'graphify-out') !== false ||
        strpos($file, 'vendor') !== false) {
        continue;
    }
    
    $content = file_get_contents($file);
    if (strpos($content, 'BEGIN CERTIFICATE') !== false) {
        echo "Found Certificate file: $file\n";
        // Print first 5 lines
        $lines = explode("\n", $content);
        for ($i = 0; $i < min(5, count($lines)); $i++) {
            echo "  " . trim($lines[$i]) . "\n";
        }
    }
    if (strpos($content, 'BEGIN PRIVATE KEY') !== false || strpos($content, 'BEGIN RSA PRIVATE KEY') !== false) {
        echo "Found Private Key file: $file\n";
        $lines = explode("\n", $content);
        for ($i = 0; $i < min(2, count($lines)); $i++) {
            echo "  " . trim($lines[$i]) . "\n";
        }
    }
}
?>
