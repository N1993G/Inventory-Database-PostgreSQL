-- INSPECT FIRST 10 ROWS OF PARTS
SELECT 
  * 
FROM 
  parts 
LIMIT 
  10;
-- ALTER THE CODE COLUMN SO THAT EACH VALUE INSERTED IS UNIQUE AND NOT EMPTY
ALTER TABLE 
  parts ALTER COLUMN code 
SET 
  NOT NULL;
ALTER TABLE 
  parts 
ADD 
  UNIQUE(code);
-- ALTER TABLE SO THAT ALL ROWS HAVE A VALUE FOR DESCRIPTION
UPDATE 
  parts 
SET 
  description = 'None Available' 
WHERE 
  description IS NULL;
CREATE TABLE part_descriptions (
  id int PRIMARY KEY, description text
);
INSERT INTO part_descriptions 
VALUES 
  (1, '5V resistor'), 
  (2, '3V resistor');
UPDATE 
  parts 
SET 
  description = part_descriptions.description 
from 
  part_descriptions 
where 
  part_descriptions.id = parts.id 
  and parts.description IS NULL;
-- ADD CONSTRAINT  THAT ENSURES ALL VALUES IN DESCRIPTION ARE FILLED AND NON-EMPTY
ALTER TABLE 
  parts ALTER COLUMN description 
SET 
  NOT NULL;
-- TEST THE CONSTRAINT
INSERT INTO parts (
  id, description, code, manufacturer_id
) 
VALUES 
  (54, 'Key switch', 'V1-009', 9);
-- ADD CONSTRAINTS THAT ENSURE PRICE_USD AND QUANTITY ARE NOT NULL
ALTER TABLE 
  reorder_options ALTER COLUMN price_usd 
SET 
  NOT NULL;
-- ADD CONSTRAINTS THAT ENSURE PRICE_USD AND QUANTITY ARE POSITIVE
ALTER TABLE 
  reorder_options 
ADD 
  CHECK (
    price_usd > 0 
    AND quantity > 0
  );
-- ADD CONSTRAINT THAT LIMIS PRICE PER UNIT WITHIN A RANGE 
ALTER TABLE 
  reorder_options 
ADD 
  CHECK (
    price_usd / quantity > 0.02 
    AND price_usd / quantity < 25.00
  );
-- ADD CONSTRAINT TO ENSURE THAT WE DONT HAVE PRICING INFORMATION ON PARTS THAT ARENT ALREADY TRACKED IN THE DB SCHEMA
ALTER TABLE 
  parts 
ADD 
  PRIMARY KEY (id);
ALTER TABLE 
  reorder_options 
ADD 
  FOREIGN KEY (part_id) REFERENCES parts (id);
-- ADD CONSTRAINT THAT ENSURES EACH VALUE IN QTY IS GREATER THAN 0
ALTER TABLE 
  locations 
ADD 
  CHECK (qty > 0);
-- ADD UNIQUE CONSTRAINTTHAT ENSURE LOCATIONS RECORDS ONLY ONE ROW FOR EACH COMBINATION AND PART
ALTER TABLE 
  locations 
ADD 
  UNIQUE (part_id, location);
-- ADD CONSTRAINT THAT FOR A PART TO BE STORED IN LOCATION IT MUST ALREADY BE REGISTERED IN PARTS
ALTER TABLE 
  locations 
ADD 
  FOREIGN KEY (part_id) REFERENCES parts (id);
-- ENSURE ALL PARTS IN PARTS HAVE A VALID MANUFACTURER
ALTER TABLE 
  parts 
ADD 
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id);
-- TEST CONSTRAINT
INSERT INTO manufacturers (id, name) 
VALUES 
  (11, 'Pip-NNC Industrial');
SELECT 
  * 
FROM 
  manufacturers;
-- UPDATE THE OLD MANUFACTURERS PARTS IN 'PARTS' TO REFERENCE THE NEW COMPANY JUST ADDED TO 'MANUFACTURERS'
UPDATE 
  parts 
SET 
  manufacturer_id = 11 
WHERE 
  manufacturer_id = 1;
UPDATE 
  parts 
SET 
  manufacturer_id = 11 
WHERE 
  manufacturer_id = 2;
