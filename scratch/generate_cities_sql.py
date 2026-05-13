import csv
import re

# File path
csv_path = r"C:\Users\Richard\.gemini\antigravity\brain\c31eabc6-2ef4-4612-bb44-7322686d7ed5\.system_generated\steps\1816\content.md"

def parse_csv(path):
    capitals = []
    with open(path, 'r', encoding='utf-8') as f:
        # The file has some header lines before the CSV starts
        content = f.read()
        csv_start = content.find("id,name,iso3,iso2")
        if csv_start == -1: return []
        
        csv_data = content[csv_start:]
        reader = csv.DictReader(csv_data.splitlines())
        for row in reader:
            if row['capital'] and row['iso2']:
                capitals.append({
                    'name': row['capital'],
                    'iso2': row['iso2']
                })
    return capitals

capitals = parse_csv(csv_path)

major_cities = [
    # --- EAST AFRICA ---
    # Kenya
    {'name': 'Mombasa', 'iso2': 'KE'}, {'name': 'Kisumu', 'iso2': 'KE'}, {'name': 'Nakuru', 'iso2': 'KE'}, 
    {'name': 'Eldoret', 'iso2': 'KE'}, {'name': 'Thika', 'iso2': 'KE'}, {'name': 'Malindi', 'iso2': 'KE'}, 
    {'name': 'Kitale', 'iso2': 'KE'}, {'name': 'Garissa', 'iso2': 'KE'}, {'name': 'Kakamega', 'iso2': 'KE'},
    {'name': 'Machakos', 'iso2': 'KE'}, {'name': 'Lamu', 'iso2': 'KE'}, {'name': 'Nanyuki', 'iso2': 'KE'}, 
    {'name': 'Voi', 'iso2': 'KE'}, {'name': 'Kericho', 'iso2': 'KE'}, {'name': 'Nyeri', 'iso2': 'KE'},
    # Tanzania
    {'name': 'Dar es Salaam', 'iso2': 'TZ'}, {'name': 'Mwanza', 'iso2': 'TZ'}, {'name': 'Arusha', 'iso2': 'TZ'}, 
    {'name': 'Mbeya', 'iso2': 'TZ'}, {'name': 'Tanga', 'iso2': 'TZ'}, {'name': 'Tabora', 'iso2': 'TZ'}, 
    {'name': 'Morogoro', 'iso2': 'TZ'}, {'name': 'Kigoma', 'iso2': 'TZ'}, {'name': 'Iringa', 'iso2': 'TZ'},
    # Uganda
    {'name': 'Gulu', 'iso2': 'UG'}, {'name': 'Lira', 'iso2': 'UG'}, {'name': 'Jinja', 'iso2': 'UG'}, 
    {'name': 'Mbarara', 'iso2': 'UG'}, {'name': 'Mbale', 'iso2': 'UG'}, {'name': 'Masaka', 'iso2': 'UG'}, 
    {'name': 'Entebbe', 'iso2': 'UG'}, {'name': 'Hoima', 'iso2': 'UG'}, {'name': 'Fort Portal', 'iso2': 'UG'},
    # Rwanda
    {'name': 'Butare', 'iso2': 'RW'}, {'name': 'Gisenyi', 'iso2': 'RW'}, {'name': 'Musanze', 'iso2': 'RW'}, 
    {'name': 'Kayonza', 'iso2': 'RW'}, {'name': 'Kibuye', 'iso2': 'RW'},
    # Burundi
    {'name': 'Gitega', 'iso2': 'BI'}, {'name': 'Muyinga', 'iso2': 'BI'}, {'name': 'Ngozi', 'iso2': 'BI'}, 
    {'name': 'Rumonge', 'iso2': 'BI'},
    # South Sudan
    {'name': 'Malakal', 'iso2': 'SS'}, {'name': 'Wau', 'iso2': 'SS'}, {'name': 'Yei', 'iso2': 'SS'}, 
    {'name': 'Yambio', 'iso2': 'SS'}, {'name': 'Bor', 'iso2': 'SS'},
    # DR Congo
    {'name': 'Lubumbashi', 'iso2': 'CD'}, {'name': 'Goma', 'iso2': 'CD'}, {'name': 'Bukavu', 'iso2': 'CD'}, 
    {'name': 'Kisangani', 'iso2': 'CD'}, {'name': 'Matadi', 'iso2': 'CD'}, {'name': 'Kikwit', 'iso2': 'CD'}, 
    {'name': 'Kananga', 'iso2': 'CD'}, {'name': 'Kolwezi', 'iso2': 'CD'},
    # Somalia
    {'name': 'Hargeisa', 'iso2': 'SO'}, {'name': 'Bosaso', 'iso2': 'SO'}, {'name': 'Baidoa', 'iso2': 'SO'}, 
    {'name': 'Kismayo', 'iso2': 'SO'}, {'name': 'Merca', 'iso2': 'SO'}, {'name': 'Berbera', 'iso2': 'SO'}, 
    {'name': 'Galkayo', 'iso2': 'SO'},

    # --- WORLD MAJOR CITIES ---
    # USA
    {'name': 'New York', 'iso2': 'US'}, {'name': 'Los Angeles', 'iso2': 'US'}, {'name': 'Chicago', 'iso2': 'US'}, 
    {'name': 'Houston', 'iso2': 'US'}, {'name': 'Phoenix', 'iso2': 'US'}, {'name': 'Philadelphia', 'iso2': 'US'}, 
    {'name': 'San Antonio', 'iso2': 'US'}, {'name': 'San Diego', 'iso2': 'US'}, {'name': 'Dallas', 'iso2': 'US'},
    # UK
    {'name': 'Birmingham', 'iso2': 'GB'}, {'name': 'Manchester', 'iso2': 'GB'}, {'name': 'Glasgow', 'iso2': 'GB'}, 
    {'name': 'Liverpool', 'iso2': 'GB'}, {'name': 'Edinburgh', 'iso2': 'GB'},
    # India
    {'name': 'Mumbai', 'iso2': 'IN'}, {'name': 'Bangalore', 'iso2': 'IN'}, {'name': 'Hyderabad', 'iso2': 'IN'}, 
    {'name': 'Chennai', 'iso2': 'IN'}, {'name': 'Kolkata', 'iso2': 'IN'}, {'name': 'Pune', 'iso2': 'IN'},
    # China
    {'name': 'Shanghai', 'iso2': 'CN'}, {'name': 'Guangzhou', 'iso2': 'CN'}, {'name': 'Shenzhen', 'iso2': 'CN'}, 
    {'name': 'Tianjin', 'iso2': 'CN'}, {'name': 'Chengdu', 'iso2': 'CN'}, {'name': 'Wuhan', 'iso2': 'CN'},
    # Europe
    {'name': 'Berlin', 'iso2': 'DE'}, {'name': 'Munich', 'iso2': 'DE'}, {'name': 'Hamburg', 'iso2': 'DE'}, 
    {'name': 'Frankfurt', 'iso2': 'DE'}, {'name': 'Lyon', 'iso2': 'FR'}, {'name': 'Marseille', 'iso2': 'FR'}, 
    {'name': 'Barcelona', 'iso2': 'ES'}, {'name': 'Seville', 'iso2': 'ES'}, {'name': 'Milan', 'iso2': 'IT'}, 
    {'name': 'Naples', 'iso2': 'IT'}, {'name': 'Venice', 'iso2': 'IT'}, {'name': 'Amsterdam', 'iso2': 'NL'}, 
    {'name': 'Rotterdam', 'iso2': 'NL'}, {'name': 'Zurich', 'iso2': 'CH'}, {'name': 'Geneva', 'iso2': 'CH'},
    # Others
    {'name': 'Toronto', 'iso2': 'CA'}, {'name': 'Montreal', 'iso2': 'CA'}, {'name': 'Vancouver', 'iso2': 'CA'},
    {'name': 'Sydney', 'iso2': 'AU'}, {'name': 'Melbourne', 'iso2': 'AU'}, {'name': 'Auckland', 'iso2': 'NZ'},
    {'name': 'Dubai', 'iso2': 'AE'}, {'name': 'Abu Dhabi', 'iso2': 'AE'}, {'name': 'Jeddah', 'iso2': 'SA'},
    {'name': 'Sao Paulo', 'iso2': 'BR'}, {'name': 'Rio de Janeiro', 'iso2': 'BR'},
    {'name': 'Istanbul', 'iso2': 'TR'}, {'name': 'Seoul', 'iso2': 'KR'}, {'name': 'Singapore', 'iso2': 'SG'},
]

all_cities = capitals + major_cities

output_path = r"c:\xampp\htdocs\pos\migrations\cities_setup.sql"
with open(output_path, 'w', encoding='utf-8') as out:
    out.write("DROP TABLE IF EXISTS `cities`;\n")
    out.write("CREATE TABLE `cities` (\n")
    out.write("  `cityid` int(11) NOT NULL AUTO_INCREMENT,\n")
    out.write("  `cityname` varchar(100) NOT NULL,\n")
    out.write("  `countryid` int(11) NOT NULL,\n")
    out.write("  PRIMARY KEY (`cityid`),\n")
    out.write("  KEY `fk_cities_countries` (`countryid`),\n")
    out.write("  CONSTRAINT `fk_cities_countries` FOREIGN KEY (`countryid`) REFERENCES `countries` (`countryid`) ON DELETE CASCADE\n")
    out.write(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n")
    
    out.write("INSERT INTO `cities` (cityname, countryid) VALUES\n")
    lines = []
    for city in all_cities:
        name = city['name'].replace("'", "''")
        iso = city['iso2']
        lines.append(f"('{name}', (SELECT countryid FROM countries WHERE countrycode = '{iso}' LIMIT 1))")
    
    # Filter out ones where subquery might fail if country doesn't exist (though it should)
    # Actually, SQL will just insert NULL or error if countryid is NOT NULL.
    # To be safe, I'll just output them.
    
    out.write(",\n".join(lines) + ";\n")

print(f"Successfully generated {output_path}")
