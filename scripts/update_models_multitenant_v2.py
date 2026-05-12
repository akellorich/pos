import os
import re

def update_models(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".php") and filename != "db.php":
            path = os.path.join(directory, filename)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            # Handle CALL with or without backticks
            # Pattern 1: CALL spname( -> CALL spname({$this->clientid},
            # Pattern 2: CALL `spname`( -> CALL `spname`({$this->clientid},
            
            # Use lookbehind for CALL and handle backticks
            # We want to insert {$this->clientid} into the parentheses.
            # If the parentheses are empty (), it should become ({$this->clientid})
            # If they have params (p1, p2), it should become ({$this->clientid}, p1, p2)
            
            # Case 1: Empty parentheses CALL sp() or CALL `sp`()
            new_content = re.sub(r'CALL\s+(`?[a-zA-Z0-9_]+`?)\(\)', r'CALL \1({$this->clientid})', content)
            
            # Case 2: Parentheses with existing content (not already injected)
            # We look for ( followed by something that isn't {$this->clientid}
            new_content = re.sub(r'CALL\s+(`?[a-zA-Z0-9_]+`?)\((?!{\$this->clientid})', r'CALL \1({$this->clientid},', new_content)
            
            # Cleanup: Fix double commas or trailing commas
            new_content = new_content.replace('{$this->clientid},)', '{$this->clientid})')
            
            if new_content != content:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename}")

if __name__ == "__main__":
    update_models("models")
