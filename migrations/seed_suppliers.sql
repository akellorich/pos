-- Seed suppliers for multi-tenant POS
INSERT INTO suppliers (clientid, suppliername, physicaladdress, town, mobile, email, dateadded, addedby, supplierpinno) VALUES
(1, 'TechWave Solutions', '123 Innovation Drive, Nairobi', 'Nairobi', '+254711000111', 'sales@techwave.co.ke', NOW(), 1, 'P051234567A'),
(1, 'Global Stationery Ltd', 'Stationery Plaza, Mombasa Road', 'Nairobi', '+254722000222', 'info@globalstationery.com', NOW(), 1, 'P051234568B'),
(1, 'EcoPackaging Africa', 'Industrial Area, Gate 4', 'Nairobi', '+254733000333', 'orders@ecopacking.co.ke', NOW(), 1, 'P051234569C'),
(1, 'Sunrise Distributors', 'Sunrise Mall, Ground Floor', 'Kisumu', '+254744000444', 'contact@sunrisedist.com', NOW(), 1, 'P051234570D'),
(1, 'Apex Office Supplies', 'Westlands Square, 3rd Floor', 'Nairobi', '+254755000555', 'support@apexoffice.ke', NOW(), 1, 'P051234571E');
