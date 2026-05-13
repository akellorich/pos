import re

# Read countries
with open(r'c:\xampp\htdocs\pos\scratch\countries_data.sql', 'r', encoding='utf-8') as f:
    countries_data = f.read()

# Improved regex to handle spaces and quotes
# ('Name', 'Code', ...
country_codes = set(re.findall(r"\('[^']+',\s*'([^']+)'", countries_data))

# Read cities setup
with open(r'c:\xampp\htdocs\pos\migrations\cities_setup.sql', 'r', encoding='utf-8') as f:
    cities_setup = f.read()
city_country_codes = set(re.findall(r"countrycode = '(\w+)'", cities_setup))

missing = city_country_codes - country_codes
print(f"Number of countries in table: {len(country_codes)}")
print(f"Number of country codes in cities: {len(city_country_codes)}")
print(f"Missing country codes: {missing}")
