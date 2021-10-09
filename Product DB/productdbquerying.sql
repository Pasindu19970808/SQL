DROP TABLE Customer;

CREATE TABLE Customer(
	Customer_ID serial,
	NameStyle integer,
	Title varchar(10),
	FirstName varchar(100),
	MiddleName varchar(100),
	LastName varchar(100),
	Suffix varchar(10),
	CompanyName varchar(100),
	SalesPerson varchar(30),
	Email varchar(100),
	Phone varchar(20),
	PasswordHash varchar(100),
	PasswordSalt varchar(50),
	rowguid varchar(100),
	Modified_Date timestamp,
	CONSTRAINT Customer_ID_key PRIMARY KEY (Customer_ID)
);

CREATE TEMPORARY TABLE Customer_temp (LIKE Customer);

COPY Customer_temp (Customer_ID,NameStyle,Title,
			   FirstName,MiddleName,LastName,Suffix,
			  CompanyName,SalesPerson,Email,Phone,
			  PasswordHash,PasswordSalt,rowguid,Modified_Date)
FROM 'C:\Users\ASUS\Desktop\Hands on ML\SQL\Product DB\Customer.csv'
WITH (FORMAT CSV,HEADER);

INSERT INTO Customer(Customer_ID,NameStyle,Title,
			   FirstName,MiddleName,LastName,Suffix,
			  CompanyName,SalesPerson,Email,Phone,
			  PasswordHash,PasswordSalt,rowguid)
SELECT Customer_ID,NameStyle,Title,
			   FirstName,MiddleName,LastName,Suffix,
			  CompanyName,SalesPerson,Email,Phone,
			  PasswordHash,PasswordSalt,rowguid
FROM Customer_temp;

DROP TABLE Customer_temp;

-- Product Table
CREATE TABLE Products_table(
	productID serial,
	productname varchar(100),
	productnumber varchar(50),
	color varchar(20),
	standardcost numeric(10,4),
	listprice numeric(9,4),
	productsize varchar(5),
	weight varchar(10),
	productcategoryid int,
	productmodelid int,
	sellstartdate timestamp,
	sellenddate varchar(50),
	discontinueddate varchar(50),
	thumbnailphoto text,
	thumbnailname varchar(100),
	rowguid varchar(100),
	Modified_Date timestamp,
	CONSTRAINT productID_key PRIMARY KEY (productID)
);
--Default Postgres timestamp YYYY-MM-DD
COPY Products_table (productID,
	productname,
	productnumber,
	color,
	standardcost,
	listprice,
	productsize,
	weight,
	productcategoryid,
	productmodelid,
	sellstartdate,
	sellenddate,
	discontinueddate,
	thumbnailphoto,
	thumbnailname,
	rowguid,
	Modified_Date)
FROM 'C:\Users\ASUS\Desktop\Hands on ML\SQL\Product DB\Product.csv'
WITH (FORMAT CSV,HEADER);

SELECT * FROM Products_table
Limit 5

--SalesOrderHeader
CREATE TABLE SalesOrderHeader(
	salesorderID serial,
	revision_number int,
	orderdate timestamp,
	duedate timestamp,
	shipdate timestamp,
	status int,
	onlineorderflag int,
	salesordernumber varchar(20),
	purchaseorder_number varchar(50),
	account_number varchar(50),
	Customer_ID integer REFERENCES Customer (Customer_ID),
	shiptoaddressID int,
	billadressID int, 
	shipmethod varchar(50),
	creditcardapprovalcode varchar(10),
	subtotal numeric(20,5),
	taxamt numeric(20,5),
	freight numeric(20,5),
	totaldue numeric(20,5),
	sales_comment varchar(50),
	rowguid varchar(100),
	Modified_Date timestamp,
	CONSTRAINT salesorderID_key PRIMARY KEY (salesorderID)
);

COPY SalesOrderHeader
FROM 'C:\Users\ASUS\Desktop\Hands on ML\SQL\Product DB\SalesOrderHeader.csv'
WITH (FORMAT CSV,HEADER);

SELECT * FROM SalesOrderHeader
Limit 5









