/*
	Import data from csv files to sales_inv.db
	run steps in sqlite CLI: 
	1. .read C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Scripts\import_data.sql
	
*/

.mode csv

.import C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\BegInv\BegInvFINAL12312016_v2.csv BegInvDec

.import C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\EndInv\EndInvFINAL12312016_v2.csv EndInvDec

.import C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\PurchasePrices\2017PurchasePricesDec_v2.csv PurchasePriceDec

.import C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Purchases\PurchasesFINAL12312016_v2.csv  PurchasesDec

.import C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Sales\SalesFINAL12312016_v2.csv SalesDec

.import C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\VendorInvoices\InvoicePurchases12312016_v2.csv VendorInvoicesDec