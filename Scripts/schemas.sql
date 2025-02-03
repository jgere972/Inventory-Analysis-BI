/*
	1. Creating all the tables for the dB sales_inv and importing the csv file into it.
	2. Create Index to optimize search
	
	3. Will Not create CONSTRAINTS just to keep it simple.
	
	Note: SQLite does not support some commands like DROP/CREATE DATABASE (Must find the dB file locally and del/rm/create it)
	run steps: 
	1. Navigate to the Case 2 dir to create the db there
	2. sqlite3.exe sales_inv_dec.db
	3. .read C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Scripts\schemas.sql
*/

DROP TABLE IF EXISTS BegInvDec;
DROP TABLE IF EXISTS EndInvDec;
DROP TABLE IF EXISTS PurchasePriceDec;
DROP TABLE IF EXISTS PurchasesDec;
DROP TABLE IF EXISTS SalesDec;
DROP TABLE IF EXISTS VendorInvoicesDec;

		-- TABLE Schemas
CREATE TABLE BegInvDec (
	InventoryId VARCHAR(50),
	Store INT,
	City  VARCHAR(20),
	Brand  VARCHAR(50),
	Description VARCHAR(200),
	Size VARCHAR(10),
	onHand INT,
	Price FLOAT,
	startDate DATE
);

CREATE INDEX "beg_inv_dec_indx" ON BegInvDec (InventoryId);

CREATE TABLE EndInvDec (
	InventoryId VARCHAR(50),
	Store INT,
	City  VARCHAR(20),
	Brand  VARCHAR(50),
	Description VARCHAR(200),
	Size VARCHAR(10),
	onHand INT,
	Price FLOAT,
	endDate DATE
);

CREATE INDEX "end_inv_dec_indx" ON EndInvDec (InventoryId);

CREATE TABLE PurchasePriceDec (
	Brand VARCHAR(50),
	Description VARCHAR(200),
	Price FLOAT,
	Size INT,
	Volume VARCHAR(10),
	Classification INT,
	PurchasePrice FLOAT,
	VendorNumber INT,
	VendorName VARCHAR(20)
);

/*
 Cannot create a good index on PurchasePriceDec since none of the domains are unique 
 Would need to:
 
 ALTER TABLE PurchasePriceDec 
 ADD Purchase_id INT AUTOINCREMENT;
 
 and then index that Purchase_id, but this could prevent the import_data script from importing properly
*/


CREATE TABLE PurchasesDec (
	InventoryId VARCHAR(50),
	Store INT,
	Brand  VARCHAR(50),
	Description VARCHAR(200),
	Size VARCHAR(10),
	VendorNumber INT,
	VendorName VARCHAR(20),
	PONumber INT,
	PODate DATE,
	ReceivingDate Date,
	InvoiceDate Date,
	PayDate Date,
	PurchasePrice FLOAT,
	Quantity INT,
	Dollars FLOAT,
	Classification INT
);


CREATE INDEX "purchases_dec_indx" ON PurchasesDec (InventoryId);


CREATE TABLE SalesDec (
	InventoryId VARCHAR(50),
	Store INT,
	Brand  VARCHAR(50),
	Description VARCHAR(200),
	Size VARCHAR(10),
	SalesQuantity INT,
	SalesDollars FLOAT,
	SalesPrice FLOAT,
	SalesDate Date,
	Volume VARCHAR(10),
	Classification INT,
	ExciseTax FLOAT,
	VendorNo INT,
	VendorName VARCHAR(20)
);

CREATE INDEX "sales_dec_inv_indx" ON SalesDec (InventoryId);
CREATE INDEX "sales_dec_vendor_no_indx" ON SalesDec (VendorNo);
CREATE INDEX "sales_dec_vendor_name_indx" ON SalesDec (VendorName);

CREATE TABLE VendorInvoicesDec (
	VendorNumber INT,
	VendorName VARCHAR(20),
	InvoiceDate Date,
	PONumber INT,
	PODate DATE,
	PayDate Date,
	Quantity INT,
	Dollars FLOAT,
	Freight FLOAT,
	Approval VARCHAR(10)
);

CREATE INDEX "vendor_dec_ponumber_indx" ON VendorInvoicesDec (PONumber);
CREATE INDEX "vendor_dec_vendor_num_indx" ON VendorInvoicesDec (VendorNumber);
CREATE INDEX "vendor_dec_vendor_name_indx" ON VendorInvoicesDec (VendorName);



