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

CREATE TABLE salesorderdetail(
	salesorderid integer REFERENCES salesorderheader (salesorderid),
	salesorderdetailid serial,
	orderqty int,
	productid integer REFERENCES products_table (productid),
	unitprice numeric(10,4),
	unitpricediscount numeric(4,3),
	linetotal numeric(20,5),
	rowguid varchar(100),
	Modified_date timestamp,
	CONSTRAINT salesorderdetailid_key PRIMARY KEY (salesorderdetailid)
);

COPY salesorderdetail
FROM 'C:\Users\ASUS\Desktop\Hands on ML\SQL\Product DB\SalesOrderDetail.csv'
WITH (FORMAT CSV, HEADER);


SELECT saleord.customer_id,
	   saledetB.productid,saledetB.salesorderdetailid,
	   saledetB.orderqty,saledetB.unitprice,saledetB.unitpricediscount,
	   saledetB.linetotal,saledetB.productname,saledetB.color,
	   saledetB.standardcost,saledetB.listprice
FROM salesorderheader as saleord JOIN(
SELECT saledet.salesorderID,prod.productid,saledet.salesorderdetailid,
	   saledet.orderqty,saledet.unitprice,saledet.unitpricediscount,
	   saledet.linetotal,prod.productname,prod.color,
	   prod.standardcost,prod.listprice
FROM salesorderdetail as saledet JOIN products_table as prod
ON saledet.productid = prod.productid
) as saledetB 
on saleord.salesorderID = saledetB.salesorderID



--Finding total spent by each customer
SELECT aggtable.customer_id,sum(aggtable.totalspentperproduct) as totalspent
FROM (SELECT saleord.customer_id,saledetB.orderqty,saledetB.unitprice,
	   (saledetB.orderqty * saledetB.unitprice) as TotalSpentPerProduct
FROM salesorderheader as saleord JOIN(
SELECT saledet.salesorderID,prod.productid,saledet.salesorderdetailid,
	   saledet.orderqty,saledet.unitprice,saledet.unitpricediscount,
	   saledet.linetotal,prod.productname,prod.color,
	   prod.standardcost,prod.listprice
FROM salesorderdetail as saledet JOIN products_table as prod
ON saledet.productid = prod.productid
) as saledetB 
ON saleord.salesorderID = saledetB.salesorderID) as aggtable
GROUP BY aggtable.customer_id
ORDER BY aggtable.customer_id

--Find a way to include productID with max qty
SELECT aggtable.customer_id,max(aggtable.orderqty),sum(aggtable.totalspentperproduct) as totalspent
FROM (SELECT saleord.customer_id,saledetB.orderqty,saledetB.unitprice,
	   (saledetB.orderqty * saledetB.unitprice) as TotalSpentPerProduct
FROM salesorderheader as saleord JOIN(
SELECT saledet.salesorderID,prod.productid,saledet.salesorderdetailid,
	   saledet.orderqty,saledet.unitprice,saledet.unitpricediscount,
	   saledet.linetotal,prod.productname,prod.color,
	   prod.standardcost,prod.listprice
FROM salesorderdetail as saledet JOIN products_table as prod
ON saledet.productid = prod.productid
) as saledetB 
ON saleord.salesorderID = saledetB.salesorderID) as aggtable
GROUP BY aggtable.customer_id
ORDER BY aggtable.customer_id

--Using HAVING
--HAVING only works on the aggregation result and it should be referred to original table names
SELECT aggtable.customer_id,sum(aggtable.totalspentperproduct) as totalspent
FROM (SELECT saleord.customer_id,saledetB.orderqty,saledetB.unitprice,
	   (saledetB.orderqty * saledetB.unitprice) as TotalSpentPerProduct
FROM salesorderheader as saleord JOIN(
SELECT saledet.salesorderID,prod.productid,saledet.salesorderdetailid,
	   saledet.orderqty,saledet.unitprice,saledet.unitpricediscount,
	   saledet.linetotal,prod.productname,prod.color,
	   prod.standardcost,prod.listprice
FROM salesorderdetail as saledet JOIN products_table as prod
ON saledet.productid = prod.productid
) as saledetB 
ON saleord.salesorderID = saledetB.salesorderID) as aggtable
GROUP BY aggtable.customer_id
HAVING sum(aggtable.totalspentperproduct) > 10000
ORDER BY aggtable.customer_id


--Finding the total spent on each product
SELECT saledetB.productid,sum(saledetB.unitprice * saledetB.orderqty)
FROM(
SELECT saledet.salesorderID,prod.productid,saledet.salesorderdetailid,
	   saledet.orderqty,saledet.unitprice,saledet.unitpricediscount,
	   saledet.linetotal,prod.productname,prod.color,
	   prod.standardcost,prod.listprice
FROM salesorderdetail as saledet JOIN products_table as prod
ON saledet.productid = prod.productid
) as saledetB
GROUP BY saledetB.productid


SELECT orderid.salesorderID,orderid.totalprice 
FROM(
SELECT salesord.salesorderID,
	   sum((salesord.orderqty * salesord.unitprice)
		  * (1 - salesord.unitpricediscount))
	   as totalprice
FROM salesorderdetail as salesord
GROUP BY salesord.salesorderID
) as orderid
WHERE orderid.totalprice > 10000;

SELECT salesord.salesorderID,
	   sum((salesord.orderqty * salesord.unitprice)
		  * (1 - salesord.unitpricediscount))
	   as totalprice
FROM salesorderdetail as salesord
GROUP BY salesord.salesorderID
HAVING sum((salesord.orderqty * salesord.unitprice)
		  * (1 - salesord.unitpricediscount)) > 10000

SELECT salesord.salesorderID,prod.productid,salesord.orderqty,
	   salesord.unitprice,salesord.unitpricediscount,prod.color
FROM salesorderdetail as salesord JOIN products_table as prod
ON salesord.productid = prod.productid 
WHERE prod.color = 'Black'

-- FOLLOWING QUERIES GIVE THE SAME RESULT
SELECT agg.salesorderID,agg.color,sum((agg.orderqty *
	   agg.unitprice)*(1 - agg.unitpricediscount)) as totalprice
FROM(
SELECT salesord.salesorderID,prod.productid,salesord.orderqty,
	   salesord.unitprice,salesord.unitpricediscount,prod.color
FROM salesorderdetail as salesord JOIN products_table as prod
ON salesord.productid = prod.productid 
WHERE prod.color = 'Black') as agg
GROUP BY agg.salesorderID,agg.color;

SELECT salesord.salesorderID,prod.color,sum((salesord.orderqty *
	   salesord.unitprice)*(1 - salesord.unitpricediscount)) as totalprice
FROM salesorderdetail as salesord JOIN products_table as prod
ON salesord.productid = prod.productid 
GROUP BY salesord.salesorderID,prod.color
HAVING prod.color = 'Black';
----

SELECT salesord.salesorderID,prod.color,sum((salesord.orderqty *
	   salesord.unitprice)*(1 - salesord.unitpricediscount)) as totalprice
FROM salesorderdetail as salesord JOIN products_table as prod
ON salesord.productid = prod.productid 
GROUP BY salesord.salesorderID,prod.color
HAVING prod.color = 'Black'	
AND  
sum((salesord.orderqty *
	 salesord.unitprice)*(1 - salesord.unitpricediscount)) > 10000