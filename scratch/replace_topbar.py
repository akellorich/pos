import os
import re

views_dir = r"c:\xampp\htdocs\pos\views"
topbar_include = '<?php $pagename = "{}"; require_once("topbar.php"); ?>'

pattern = re.compile(r'<(div|div\s+[^>]*?)\s+class="home-content"[^>]*?>\s*<i\s+class=[\'"]bx\s+bx-menu[\'"]\s*>\s*</i>\s*<span\s+class="text">([^<]+)</span>\s*</div>', re.DOTALL)

for filename in os.listdir(views_dir):
    if filename.endswith(".php"):
        filepath = os.path.join(views_dir, filename)
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        matches = list(pattern.finditer(content))
        if matches:
            new_content = content
            # Process in reverse to maintain indices
            for match in reversed(matches):
                tag_start = match.group(1)
                page_name = match.group(2).strip()
                replacement = topbar_include.format(page_name)
                new_content = new_content[:match.start()] + replacement + new_content[match.end():]
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filename}")
