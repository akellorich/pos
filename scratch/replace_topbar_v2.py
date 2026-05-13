import os
import re

views_dir = r"c:\xampp\htdocs\pos\views"

# Pattern to match the opening div, icon, and span
# We want to replace this entire block with the include.
# The closing </div> of home-content might be far down.
pattern = re.compile(r'<(div|div\s+[^>]*?)\s+class="home-content"[^>]*?>\s*<i\s+class=[\'"]bx\s+bx-menu[\'"]\s*>\s*</i>\s*<span\s+class="text">([^<]+)</span>', re.DOTALL)

for filename in os.listdir(views_dir):
    if filename.endswith(".php"):
        filepath = os.path.join(views_dir, filename)
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            matches = list(pattern.finditer(content))
            if matches:
                new_content = content
                for match in reversed(matches):
                    page_name = match.group(2).strip()
                    # We replace the opening div and span with our topbar include.
                    # This effectively turns the "home-content" div into a container for the rest of the page,
                    # but since topbar.php is a full div, we might end up with nested divs or broken structure.
                    # A better way is to replace the whole home-content block if it's just a header,
                    # or just the inner part.
                    
                    # If we just replace the start, we need to make sure we don't have an extra </div> at the end.
                    # But most files have the structure:
                    # <div class="home-content">
                    #   ... header ...
                    #   <div class="container-fluid"> ... </div>
                    # </div>
                    
                    replacement = f'<?php $pagename = "{page_name}"; require_once("topbar.php"); ?>'
                    new_content = new_content[:match.start()] + replacement + new_content[match.end():]
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename}")
        except Exception as e:
            print(f"Error processing {filename}: {e}")
