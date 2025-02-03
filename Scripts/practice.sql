/*
	This script is a simple practice script to try out sqlite3
	run using: .read  C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Scripts\practice.sql
*/


-- 5 VendorNumbers with the highest Freight costs with the Dollars amount > 100
-- and Quantity <= 1000
SELECT
	VendorNumber,
	SUM(Freight) AS Total_Freight_Cost
FROM InvoicePurchasesDEC
WHERE
	Dollars > 100 AND
	Quantity <= 1000
GROUP BY VendorNumber
ORDER BY Total_Freight_Cost DESC
LIMIT 5;
	
	
-- Create a temp table with left outer join for beginning and ending Inventory
DROP TABLE IF EXISTS TEMP.left_outer_join_inv;

CREATE TABLE TEMP.left_outer_join_inv AS
SELECT	e.*
FROM EndInvDEC e
LEFT OUTER JOIN BegInvDEC b
ON e.InventoryId = b.InventoryId;

-- Create a temp table with inner join for beginning and ending Inventory
DROP TABLE IF EXISTS TEMP.inner_join_inv;

CREATE TABLE TEMP.inner_join_inv AS
SELECT	e.*
FROM EndInvDEC e
INNER JOIN BegInvDEC b
ON e.InventoryId = b.InventoryId;

-- Count of Rows in EndInvDEC
SELECT count(*) FROM EndInvDEC;

-- Union Both temp tables
SELECT * FROM TEMP.left_outer_join_inv

UNION

SELECT * FROM TEMP.inner_join_inv;

	