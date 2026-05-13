import re

# File paths
file1_path = r"C:\Users\Richard\.gemini\antigravity\brain\c31eabc6-2ef4-4612-bb44-7322686d7ed5\.system_generated\steps\1748\content.md"
file2_path = r"C:\Users\Richard\.gemini\antigravity\brain\c31eabc6-2ef4-4612-bb44-7322686d7ed5\.system_generated\steps\1754\content.md"

def parse_file1(path):
    countries = []
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
        # Regex to match: (id, 'Name', 'iso', 'iso3', 'dial', 'currency', 'currency_name')
        matches = re.findall(r"\((\d+),\s*'([^']+)',\s*'([^']+)',\s*'([^']+)',\s*'([^']+)',\s*(?:'([^']+)'|NULL),\s*(?:'([^']+)'|NULL)\)", content)
        for m in matches:
            countries.append({
                'id': m[0],
                'name': m[1],
                'iso': m[2],
                'iso3': m[3],
                'dial': m[4],
                'currency_code': m[5] if m[5] else '',
                'currency_name': m[6] if m[6] else ''
            })
    return countries

def parse_file2(path):
    symbols = {}
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
        # Regex to match: INSERT INTO currency (country, currency, code, symbol) VALUES ('Country', 'Currency', 'Code', 'Symbol');
        matches = re.findall(r"INSERT INTO currency \(country, currency, code, symbol\) VALUES \('([^']+)',\s*'([^']+)',\s*'([^']+)',\s*'([^']+)'\);", content)
        for m in matches:
            # Map by code and name
            code = m[2]
            symbol = m[3]
            symbols[code] = symbol
    return symbols

countries = parse_file1(file1_path)
symbols = parse_file2(file2_path)

# Manual overrides or additions for common ones
symbols['KES'] = 'KSh'
symbols['UGX'] = 'USh'
symbols['TZS'] = 'TSh'
symbols['RWF'] = 'RF'
symbols['BIF'] = 'FBu'
symbols['SSP'] = 'SSP'
symbols['ETB'] = 'Br'
symbols['SOS'] = 'Sh.So.'

lines = []
for c in countries:
    name = c['name'].replace("'", "''")
    code = c['iso']
    curr_name = c['currency_name'].replace("'", "''")
    curr_code = c['currency_code']
    dial = c['dial']
    symbol = symbols.get(curr_code, '').replace("'", "''")
    
    # Clean dial code (remove dashes etc)
    dial = "+" + dial.split('-')[0] if '-' in dial else "+" + dial
    if dial == "+": dial = ""
    
    is_default = 1 if code == 'KE' else 0
    
    lines.append(f"('{name}', '{code}', '{curr_name}', '{symbol}', '{dial}', {is_default})")

output_path = r"c:\xampp\htdocs\pos\scratch\countries_data.sql"
with open(output_path, 'w', encoding='utf-8') as out:
    out.write("INSERT INTO `countries` (countryname, countrycode, currency, currencysymbol, dialingcode, isdefault) VALUES\n")
    out.write(",\n".join(lines) + ";")

print(f"Successfully wrote data to {output_path}")
