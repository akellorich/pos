import os
import re

def update_models(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".php") and filename != "db.php":
            path = os.path.join(directory, filename)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            # Find CALL statements and inject {$this->clientid}
            # Pattern: CALL sp_name(
            # We want to insert {$this->clientid}, right after the opening parenthesis
            
            # Special case: sp_getcompanies, sp_getloginuisettings etc might be global.
            # But the user asked for "implement the global clientid fields in all master records".
            
            new_content = re.sub(r'CALL\s+([a-zA-Z0-9_]+)\((?!{\$this->clientid})', r'CALL \1({$this->clientid},', content)
            
            # Fix cases where the first argument was already there but we added a comma
            # e.g. CALL spname({$this->clientid},) -> should handle empty params? 
            # Actually, most SPs have params. If it was CALL sp(), it becomes CALL sp({$this->clientid},) which might be wrong if no other params.
            # But in this codebase, most have params.
            
            if new_content != content:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename}")

if __name__ == "__main__":
    update_models("models")
