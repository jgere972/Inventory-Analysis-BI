/*
Case 1:
"Executive leadership is looking for dashboard reporting that would be useful to help identify and monitor vendor activity in order to focus efforts strategically on key supplier relationships.
	Create (1) an aggregate table that includes all critical vendor billings and their associated purchasing activity
	Create (2) separate tables to store key information, such as ‘top 10 vendors’ by quantity purchased. Name all tables you create ‘c1_Prep_[table_name]’"

Case 2:
"You notice that there is inventory that is purchased but sits on the shelf for a long period of time rather than being sold.  
As such, there is an opportunity to add value to the procurement process by identifying trends in the timing inventory purchased versus its corresponding sale."

Assumptions: 
	1. For simplicity' sake, data cleaning, cleansing and validation won't be performed just for this business task, since the data source seems to be trustworthy.
	Ideally cleaning and validating should always be done before any meaningful retrievals/queries.
	2. Meta-data is missing, which leaves it in my discretion to undertand the data
	3. Data provenance is absent: Cannot verify the data integrity...
*/


/*
This script contains:
	1. Various Queries to find relevant aggregate tables for vendors
	2. Output most results to csv files
*/

.header on
.mode csv
	-- Query 1
/*
-- All critical vendor billings and their associated purchasing activity
		Query is too Expensive and Slow to compute
SELECT 
	V.VendorName AS vendor_name,
	V.VendorNumber AS id,
	COUNT(V.VendorNumber) AS invoice_count,
	SUM(V.Dollars) AS total_owing,
	COUNT(S.VendorNo) AS sales_count,
	SUM(S.SalesDollars) AS total_sales,
	SUM(S.SalesQuantity) AS total_quantities
FROM VendorInvoicesDec V 
FULL OUTER JOIN SalesDec S ON V.VendorNumber = S.VendorNo
GROUP BY V.VendorName, V.VendorNumber
HAVING SUM(V.Dollars) >= 1000
ORDER BY total_sales DESC, invoice_count DESC, vendor_name ASC;
*/

	--Query 1 variation (more efficient)
-- All critical vendor billings and their associated purchasing activity
WITH criticalVendors AS (
    SELECT 
        VendorName AS vendor_name,
        VendorNumber AS id,
        COUNT(VendorNumber) AS invoice_count,
        SUM(Dollars) AS total_owing
    FROM VendorInvoicesDec
    GROUP BY VendorName, VendorNumber
    HAVING SUM(Dollars) >= 1000
)
SELECT 
    CV.vendor_name,
    CV.id,
    CV.invoice_count,
    CV.total_owing,
    COUNT(S.VendorNo) AS sales_count,
    SUM(S.SalesDollars) AS total_sales,
    SUM(S.SalesQuantity) AS total_quantities
FROM criticalVendors CV
LEFT JOIN SalesDec S ON CV.id = S.VendorNo
GROUP BY CV.vendor_name, CV.id, CV.invoice_count, CV.total_owing
ORDER BY total_sales DESC, invoice_count DESC, CV.vendor_name ASC;

--Output the next query to the following path
.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\critical_vendors.csv" 
WITH criticalVendors AS (
    SELECT 
        VendorName AS vendor_name,
        VendorNumber AS id,
        COUNT(VendorNumber) AS invoice_count,
        SUM(Dollars) AS total_owing
    FROM VendorInvoicesDec
    GROUP BY VendorName, VendorNumber
    HAVING SUM(Dollars) >= 1000
)
SELECT 
    CV.vendor_name,
    CV.id,
    CV.invoice_count,
    CV.total_owing,
    COUNT(S.VendorNo) AS sales_count,
    SUM(S.SalesDollars) AS total_sales,
    SUM(S.SalesQuantity) AS total_quantities
FROM criticalVendors CV
LEFT JOIN SalesDec S ON CV.id = S.VendorNo
GROUP BY CV.vendor_name, CV.id, CV.invoice_count, CV.total_owing
ORDER BY total_sales DESC, invoice_count DESC, CV.vendor_name ASC;

	
	-- Query 2
--Top 10 Vendors by invoice counts
SELECT
	VendorNumber,
	COUNT(*) AS invoice_count
FROM VendorInvoicesDec
GROUP BY VendorNumber
ORDER BY invoice_count DESC
LIMIT 10;

.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\high_invoice_count.csv"
SELECT
	VendorNumber,
	COUNT(*) AS invoice_count
FROM VendorInvoicesDec
GROUP BY VendorNumber
ORDER BY invoice_count DESC
LIMIT 10;

	-- Query 3
-- Vendors with all their quantities purchased and the total sales.
SELECT 
	VendorNo, 
	SUM(SalesQuantity) AS quantity, 
	SUM(SalesDollars) AS sales
FROM SalesDEC
GROUP BY VendorNo
ORDER BY sales DESC;

.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\vendors_sales_quantities.csv"
SELECT 
	VendorNo, 
	SUM(SalesQuantity) AS quantity, 
	SUM(SalesDollars) AS sales
FROM SalesDEC
GROUP BY VendorNo
ORDER BY sales DESC;

	-- Query 4
-- Vendor total sales and quantities for each store
SELECT 
	Store,
	VendorNo, 
	SUM(SalesQuantity) AS quantity, 
	SUM(SalesDollars) AS sales
FROM SalesDEC
GROUP BY Store, VendorNo
ORDER BY Store ASC, sales DESC;

.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\vendor_store_sales.csv"
SELECT 
	Store,
	VendorNo, 
	SUM(SalesQuantity) AS quantity, 
	SUM(SalesDollars) AS sales
FROM SalesDEC
GROUP BY Store, VendorNo
ORDER BY Store ASC, sales DESC;

	-- Querie 5
-- Vendor monthly sales and quantities
SELECT 
	strftime('%m', SalesDate) AS month_int,
	CASE strftime('%m', SalesDate)
		WHEN '01' THEN 'January'
		WHEN '02' THEN 'February' 
		WHEN '03' THEN 'March' 
		WHEN '04' THEN 'April' 
		WHEN '05' THEN 'May' 
		WHEN '06' THEN 'June' 
		WHEN '07' THEN 'July' 
		WHEN '08' THEN 'August' 
		WHEN '09' THEN 'September' 
		WHEN '10' THEN 'October' 
		WHEN '11' THEN 'November' 
		WHEN '12' THEN 'December'
	END AS month,
	SUM(SalesQuantity) AS quantity,
	SUM(SalesDollars) AS sales
FROM SalesDEC	
GROUP BY month_int
ORDER BY month_int;

.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\monthly_sales.csv"
SELECT 
	strftime('%m', SalesDate) AS month_int,
	CASE strftime('%m', SalesDate)
		WHEN '01' THEN 'January'
		WHEN '02' THEN 'February' 
		WHEN '03' THEN 'March' 
		WHEN '04' THEN 'April' 
		WHEN '05' THEN 'May' 
		WHEN '06' THEN 'June' 
		WHEN '07' THEN 'July' 
		WHEN '08' THEN 'August' 
		WHEN '09' THEN 'September' 
		WHEN '10' THEN 'October' 
		WHEN '11' THEN 'November' 
		WHEN '12' THEN 'December'
	END AS month,
	SUM(SalesQuantity) AS quantity,
	SUM(SalesDollars) AS sales
FROM SalesDEC	
GROUP BY month_int
ORDER BY month_int;

	-- Query 6
-- Quarter sales
SELECT 
	quarter,
	SUM(SalesDollars) AS sales
FROM (
		SELECT 
			SalesDollars,
			CASE
				WHEN strftime('%m', SalesDate) BETWEEN '01' AND '03' THEN 'Q1'
				WHEN strftime('%m', SalesDate) BETWEEN '04' AND '06' THEN 'Q2' 
				WHEN strftime('%m', SalesDate) BETWEEN '07' AND '09' THEN 'Q3'  
				WHEN strftime('%m', SalesDate) BETWEEN '10' AND '12' THEN 'Q4'
			END AS quarter
		FROM SalesDEC	
	) AS SQ
GROUP BY quarter
ORDER BY quarter;

.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\quarter_sales.csv"
SELECT 
	quarter,
	SUM(SalesDollars) AS sales
FROM (
		SELECT 
			SalesDollars,
			CASE
				WHEN strftime('%m', SalesDate) BETWEEN '01' AND '03' THEN 'Q1'
				WHEN strftime('%m', SalesDate) BETWEEN '04' AND '06' THEN 'Q2' 
				WHEN strftime('%m', SalesDate) BETWEEN '07' AND '09' THEN 'Q3'  
				WHEN strftime('%m', SalesDate) BETWEEN '10' AND '12' THEN 'Q4'
			END AS quarter
		FROM SalesDEC	
	) AS SQ
GROUP BY quarter
ORDER BY quarter;

	--- Query 7
--Time lapsed (idle_time in months) between PODate and SalesDate and the count of inventories within each category of idle_time_inv_months
/*
-- Inefficient and Slow
SELECT	
	CASE
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 30 THEN '1'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 90 THEN '2'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 120 THEN '3'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 150 THEN '4'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 180 THEN '5'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 210 THEN '6'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 240 THEN '7'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 270 THEN '8'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 300 THEN '9'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 330 THEN '10'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 360 THEN '11'
		WHEN (julianDay(SalesDate) - julianday(PODate)) <= 390 THEN '12'
		ELSE '12+'
	END AS idle_time_inv_months,
	COUNT(*) AS idle_time_inv_months_count 
FROM PurchasesDec JOIN SalesDec 
ON PurchasesDec.InventoryId = SalesDec.InventoryId
GROUP BY idle_time_inv_months
ORDER BY idle_time_inv_months;
*/

-- Query 7 (More efficient)
WITH IdleTimeCTE AS (
	SELECT	
		CASE
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 0 THEN '0'	-- Data integrity issue* discussed later in the script
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 30 THEN '1'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 90 THEN '2'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 120 THEN '3'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 150 THEN '4'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 180 THEN '5'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 210 THEN '6'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 240 THEN '7'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 270 THEN '8'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 300 THEN '9'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 330 THEN '10'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 360 THEN '11'
			WHEN (julianDay(SalesDate) - julianday(PODate)) <= 390 THEN '12'
			ELSE '12+'
		END AS idle_time_inv_months
	FROM PurchasesDec JOIN SalesDec 
		ON PurchasesDec.InventoryId = SalesDec.InventoryId
)
SELECT 
	idle_time_inv_months,
	COUNT(*) AS idle_time_inv_months_count 
FROM IdleTimeCTE
GROUP BY idle_time_inv_months
ORDER BY 
	CASE
		WHEN idle_time_inv_months = '12+' THEN 13
		ELSE CAST(idle_time_inv_months AS INTEGER)
	END ASC;
	-- There are 42843455 entries where SalesDate happens earlier than PODate (Refer to the Data integrity issue*)
	-- CANNOT meaningfully rely on Query 7
	
	-- Testing Q7 by finding the count of idle time days within 1 month (<= 30)
SELECT 
	(julianDay(SalesDate) - julianday(PODate)) AS idle_time_days,
	COUNT(*) AS idle_time_days_count
FROM PurchasesDec JOIN SalesDec 
	ON PurchasesDec.InventoryId = SalesDec.InventoryId
WHERE (julianDay(SalesDate) - julianday(PODate)) <= 30
GROUP BY idle_time_days
ORDER BY idle_time_days;


/*
*Data integrity issue: The "Testing Q7" query outputs (-203) - 30 idle_time_days
which suggests that there are entries:
	1. In SalesDec where the SalesDate happens earlier than the PODate in the PurhcasesDec table (-203)-0 days(abnormal)
	2. In SalesDec where the SalesDate happens after the PODate in the PurhcasesDec table 0-30 days(normal)
as confirmed by a quick comparison of the relevant dates in both of the following queries:
 SELECT
	S.* 
 FROM SalesDec S JOIN PurchasesDec P 
	ON S.InventoryId = P.InventoryId 
 WHERE (julianDay(SalesDate) - julianday(PODate)) <= 0 
 LIMIT 10;
 &
 SELECT
	P.* 
 FROM SalesDec S JOIN PurchasesDec P 
	ON S.InventoryId = P.InventoryId 
 WHERE (julianDay(SalesDate) - julianday(PODate)) <= 0 
 LIMIT 10;
*/

/*
Alternate Query 7: Attempting to fix the inconsistency with earlier PODates.
*/
WITH IdleTimeCTE AS (
	SELECT	
		CASE
			WHEN (julianDay(SalesDate) - julianday(PODate)) < 0 THEN (julianDay(PODate) - julianday(SalesDate))
			ELSE (julianDay(SalesDate) - julianday(PODate))
		END AS idle_time_days
	FROM PurchasesDec JOIN SalesDec 
		ON PurchasesDec.InventoryId = SalesDec.InventoryId
)
SELECT
	CASE
		WHEN idle_time_days <= 30 THEN '1'
		WHEN idle_time_days <= 90 THEN '2'
		WHEN idle_time_days <= 120 THEN '3'
		WHEN idle_time_days <= 150 THEN '4'
		WHEN idle_time_days <= 180 THEN '5'
		WHEN idle_time_days <= 210 THEN '6'
		WHEN idle_time_days <= 240 THEN '7'
		WHEN idle_time_days <= 270 THEN '8'
		WHEN idle_time_days <= 300 THEN '9'
		WHEN idle_time_days <= 330 THEN '10'
		WHEN idle_time_days <= 360 THEN '11'
		WHEN idle_time_days <= 390 THEN '12'
		ELSE '12+'
	END AS idle_time_inv_months,
	COUNT(*) AS idle_time_inv_months_count 
FROM IdleTimeCTE
GROUP BY idle_time_inv_months
ORDER BY 
	CASE
		WHEN idle_time_inv_months = '12+' THEN 13
		ELSE CAST(idle_time_inv_months AS INTEGER)
	END ASC;

.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\inv_idle_time.csv"
WITH IdleTimeCTE AS (
	SELECT	
		CASE
			WHEN (julianDay(SalesDate) - julianday(PODate)) < 0 THEN (julianDay(PODate) - julianday(SalesDate))
			ELSE (julianDay(SalesDate) - julianday(PODate))
		END AS idle_time_days
	FROM PurchasesDec JOIN SalesDec 
		ON PurchasesDec.InventoryId = SalesDec.InventoryId
)
SELECT
	CASE
		WHEN idle_time_days <= 30 THEN '1'
		WHEN idle_time_days <= 90 THEN '2'
		WHEN idle_time_days <= 120 THEN '3'
		WHEN idle_time_days <= 150 THEN '4'
		WHEN idle_time_days <= 180 THEN '5'
		WHEN idle_time_days <= 210 THEN '6'
		WHEN idle_time_days <= 240 THEN '7'
		WHEN idle_time_days <= 270 THEN '8'
		WHEN idle_time_days <= 300 THEN '9'
		WHEN idle_time_days <= 330 THEN '10'
		WHEN idle_time_days <= 360 THEN '11'
		WHEN idle_time_days <= 390 THEN '12'
		ELSE '12+'
	END AS idle_time_inv_months,
	COUNT(*) AS idle_time_inv_months_count 
FROM IdleTimeCTE
GROUP BY idle_time_inv_months
ORDER BY 
	CASE
		WHEN idle_time_inv_months = '12+' THEN 13
		ELSE CAST(idle_time_inv_months AS INTEGER)
	END ASC;

