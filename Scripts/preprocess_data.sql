/*
	This script is meant to pre-process some data related to inventory
*/
	
/*
For each unique record-- ‘Brand’ (e.g. Product SKU) by ‘Store’-- in table EndInvDec, 
recalculate the ‘PurchasePrice’ assuming the costing method is moving-average cost.
*/

-- Create a CTE for the initial inventory 
WITH InitialInventory AS ( 
	SELECT 
		Brand, 
		Store, 
		onHand AS InitialQuantity, 
		Price AS InitialPrice 
	FROM BegInvDec 
	WHERE startDate = '2016-12-01'
)-- Process each transaction from the PurchasesDec and SalesDec relations/tables
, UpdatedInventory AS (
    SELECT
        Brand,
        Store,
        SUM(CASE 
                WHEN TransactionType = 'Purchase' THEN Quantity
                ELSE -Quantity
            END) OVER (PARTITION BY Brand, Store ORDER BY TransactionDate) AS CumQuantity,
        SUM(CASE 
                WHEN TransactionType = 'Purchase' THEN Quantity * PurchasePrice
                ELSE 0
            END) OVER (PARTITION BY Brand, Store ORDER BY TransactionDate) AS CumCost,
        TransactionDate,
        PurchasePrice,
        TransactionType
    FROM (
        SELECT 
            Brand,
            Store,
            Quantity,
            PurchasePrice,
            PODate AS TransactionDate,
            'Purchase' AS TransactionType
        FROM PurchasesDec
        UNION ALL
        SELECT 
            Brand,
            Store,
            SalesQuantity,
            NULL AS PurchasePrice,
            SalesDate AS TransactionDate,
            'Sale' AS TransactionType
        FROM SalesDec
    ) AS Transactions
), RecalculatedPrices AS ( 
	SELECT 
		Brand, 
		Store, 
		CumQuantity, 
		CumCost / CumQuantity AS RecalculatedPrice 
	FROM UpdatedInventory 
	WHERE CumQuantity > 0
)
-- Calculate the difference between original and recalculated prices 
CREATE TEMP TABLE temp_recalculate_prcies AS
SELECT 
	EI.Brand, 
	EI.Store, 
	EI.Price AS OriginalPrice, 
	RP.RecalculatedPrice, 
	RP.RecalculatedPrice - EI.Price AS PriceDifference 
FROM EndInvDec EI JOIN RecalculatedPrices RP 
	ON EI.Brand = RP.Brand AND EI.Store = RP.Store 
ORDER BY EI.Brand, EI.Store;


.once "C:\\Users\\Customer\\Documents\\Certificates&Notes\\Case_Study_2\\output\\recalculated_inv_pricing.csv"
WITH InitialInventory AS ( 
	SELECT 
		Brand, 
		Store, 
		onHand AS InitialQuantity, 
		Price AS InitialPrice 
	FROM BegInvDec 
	WHERE startDate = '2016-12-01'
), UpdatedInventory AS (
    SELECT
        Brand,
        Store,
        SUM(CASE 
                WHEN TransactionType = 'Purchase' THEN Quantity
                ELSE -Quantity
            END) OVER (PARTITION BY Brand, Store ORDER BY TransactionDate) AS CumQuantity,
        SUM(CASE 
                WHEN TransactionType = 'Purchase' THEN Quantity * PurchasePrice
                ELSE 0
            END) OVER (PARTITION BY Brand, Store ORDER BY TransactionDate) AS CumCost,
        TransactionDate,
        PurchasePrice,
        TransactionType
    FROM (
        SELECT 
            Brand,
            Store,
            Quantity,
            PurchasePrice,
            PODate AS TransactionDate,
            'Purchase' AS TransactionType
        FROM PurchasesDec
        UNION ALL
        SELECT 
            Brand,
            Store,
            SalesQuantity,
            NULL AS PurchasePrice,
            SalesDate AS TransactionDate,
            'Sale' AS TransactionType
        FROM SalesDec
    ) AS Transactions
), RecalculatedPrices AS ( 
	SELECT 
		Brand, 
		Store, 
		CumQuantity, 
		CumCost / CumQuantity AS RecalculatedPrice 
	FROM UpdatedInventory 
	WHERE CumQuantity > 0
)
SELECT 
	EI.Brand AS Brand, 
	EI.Store AS Store, 
	EI.Price AS OriginalPrice, 
	RP.RecalculatedPrice AS NewPrice, 
	RP.RecalculatedPrice - EI.Price AS PriceDifference 
FROM EndInvDec EI JOIN RecalculatedPrices RP 
	ON EI.Brand = RP.Brand AND EI.Store = RP.Store 
ORDER BY EI.Brand, EI.Store;