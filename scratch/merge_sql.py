# Even More Robust Merge Script
import re

with open(r'c:\xampp\htdocs\pos\scratch\countries_data.sql', 'r', encoding='utf-8') as f:
    countries_data = f.read()

with open(r'c:\xampp\htdocs\pos\migrations\cities_setup.sql', 'r', encoding='utf-8') as f:
    cities_setup = f.read()

# Get available country codes
country_codes = set(re.findall(r"\('[^']+',\s*'([^']+)'", countries_data))

# Extract cities and filter
# Cities look like: ('City', (SELECT countryid FROM countries WHERE countrycode = 'CC' LIMIT 1))
city_matches = re.findall(r"\('([^']+)',\s*\(SELECT countryid FROM countries WHERE countrycode = '(\w+)' LIMIT 1\)\)", cities_setup)

filtered_cities = []
for city_name, country_code in city_matches:
    if country_code in country_codes:
        city_name_escaped = city_name.replace("'", "''")
        filtered_cities.append(f"('{city_name_escaped}', (SELECT countryid FROM countries WHERE countrycode = '{country_code}' LIMIT 1))")

cities_values = ",\n".join(filtered_cities)

combined_sql = f"""-- Geography Database Update Script
-- Combined Countries and Cities Data

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `cities`;
DROP TABLE IF EXISTS `countries`;
SET FOREIGN_KEY_CHECKS = 1;

-- Create countries table
CREATE TABLE `countries` (
  `countryid` int(11) NOT NULL AUTO_INCREMENT,
  `countryname` varchar(100) NOT NULL,
  `countrycode` varchar(10) DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `currencysymbol` varchar(10) DEFAULT NULL,
  `dialingcode` varchar(10) DEFAULT NULL,
  `isdefault` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`countryid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Populate countries
{countries_data}

-- Create cities table
CREATE TABLE `cities` (
  `cityid` int(11) NOT NULL AUTO_INCREMENT,
  `cityname` varchar(100) NOT NULL,
  `countryid` int(11) NOT NULL,
  PRIMARY KEY (`cityid`),
  KEY `fk_cities_countries` (`countryid`),
  CONSTRAINT `fk_cities_countries` FOREIGN KEY (`countryid`) REFERENCES `countries` (`countryid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Populate cities (Capitals and Major Hubs)
INSERT INTO `cities` (cityname, countryid) VALUES
{cities_values};

-- CRUD Stored Procedures
DELIMITER $$

DROP PROCEDURE IF EXISTS `spgetcountries` $$
CREATE PROCEDURE `spgetcountries`()
BEGIN
    SELECT * FROM countries 
    ORDER BY isdefault DESC, countryname ASC;
END $$

DROP PROCEDURE IF EXISTS `spsavecountry` $$
CREATE PROCEDURE `spsavecountry`(
    IN $countryid INT,
    IN $countryname VARCHAR(100),
    IN $countrycode VARCHAR(10),
    IN $currency VARCHAR(50),
    IN $currencysymbol VARCHAR(10),
    IN $dialingcode VARCHAR(10),
    IN $isdefault TINYINT
)
BEGIN
    -- If setting as default, unset others
    IF $isdefault = 1 THEN
        UPDATE countries SET isdefault = 0;
    END IF;

    IF $countryid = 0 THEN
        INSERT INTO countries (countryname, countrycode, currency, currencysymbol, dialingcode, isdefault)
        VALUES ($countryname, $countrycode, $currency, $currencysymbol, $dialingcode, $isdefault);
    ELSE
        UPDATE countries SET 
            countryname = $countryname,
            countrycode = $countrycode,
            currency = $currency,
            currencysymbol = $currencysymbol,
            dialingcode = $dialingcode,
            isdefault = $isdefault
        WHERE countryid = $countryid;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spdeletecountry` $$
CREATE PROCEDURE `spdeletecountry`(IN $countryid INT)
BEGIN
    DELETE FROM countries WHERE countryid = $countryid;
END $$

-- City Procedures
DROP PROCEDURE IF EXISTS `spgetcities` $$
CREATE PROCEDURE `spgetcities`(IN $countryid INT)
BEGIN
    IF $countryid = 0 THEN
        SELECT c.*, co.countryname 
        FROM cities c
        JOIN countries co ON c.countryid = co.countryid
        ORDER BY co.countryname ASC, c.cityname ASC;
    ELSE
        SELECT * FROM cities 
        WHERE countryid = $countryid
        ORDER BY cityname ASC;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spsavecity` $$
CREATE PROCEDURE `spsavecity`(
    IN $cityid INT,
    IN $cityname VARCHAR(100),
    IN $countryid INT
)
BEGIN
    IF $cityid = 0 THEN
        INSERT INTO cities (cityname, countryid)
        VALUES ($cityname, $countryid);
    ELSE
        UPDATE cities SET 
            cityname = $cityname,
            countryid = $countryid
        WHERE cityid = $cityid;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spdeletecity` $$
CREATE PROCEDURE `spdeletecity`(IN $cityid INT)
BEGIN
    DELETE FROM cities WHERE cityid = $cityid;
END $$

DELIMITER ;
"""

with open(r'c:\xampp\htdocs\pos\migrations\complete_geography_update.sql', 'w', encoding='utf-8') as f:
    f.write(combined_sql)

print("Successfully merged SQL files and filtered invalid country codes.")
