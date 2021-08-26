--Basic Math and Stats with SQL

-- Concatenation syntax

SELECT CONCAT(CAST((SELECT 11 / 6) AS text),'.',CAST((SELECT 11 % 6) AS text));

SELECT employee_id,first_name,last_name,
concat(first_name,' ',last_name) "Name of the Employee" 
FROM employees
WHERE department_id=100;

SELECT geo_name, state_us_abbreviation, p0010003, p0010004, 
p0010003 + p0010004 as 'Total White and Black'
FROM us_counties_2010;

SELECT geo_name, state_us_abbreviation,p0010001 AS "Total",
p0010003 + p0010004 + p0010005 + p0010006 + p0010007 + p0010008 + p0010009 AS "All Races",
(p0010003 + p0010004 + p0010005 + p0010006 + p0010007 + p0010008 + p0010009) - p0010001 AS "Difference"
FROM us_counties_2010
ORDER BY "Difference";

--CREATING new table and inserting from previous table while carrying out operations

DROP TABLE Pct_Asian;
CREATE TABLE Pct_Asian
(
	geo_name varchar(90),
	state_us_abbreviation varchar(2),
	pct numeric(8,1)

);

SELECT * FROM Pct_Asian;

INSERT INTO Pct_Asian(geo_name,state_us_abbreviation,pct)
SELECT geo_name,state_us_abbreviation,
(CAST(p0010006 AS numeric(8,1))/p0010001) * 100 AS "pct"
FROM us_counties_2010

SELECT * FROM Pct_Asian

--Tracking Percentage Change
CREATE TABLE percent_change (
 department varchar(20),
 spend_2014 numeric(10,2),
 spend_2017 numeric(10,2)
);

INSERT INTO percent_change
VALUES
('Building', 250000, 289000),
('Assessor', 178556, 179500),
('Library', 87777, 90001),
('Clerk', 451980, 650000),
('Police', 250000, 223000),
('Recreation', 199000, 195000);

SELECT * FROM percent_change;

SELECT department, 
round((((spend_2017 - spend_2014)/spend_2014)*100),2) as "pct_change"
FROM percent_change

SELECT sum(p0010001) AS "County Sum",
round(avg(p0010001), 0) AS "County Average"
FROM us_counties_2010;

SELECT * 
FROM percent_change
ORDER BY spend_2014;

SELECT
(percentile_cont(0.5)
WITHIN GROUP(ORDER BY spend_2014)),
percentile_disc(0.5)
WITHIN GROUP(ORDER BY spend_2014),
percentile_cont(0.5)
WITHIN GROUP(ORDER BY spend_2017),
percentile_disc(0.5)
WITHIN GROUP(ORDER BY spend_2017)
FROM percent_change

SELECT sum(p0010001) AS "County Sum",
round(avg(p0010001), 0) AS "County Average",
percentile_cont(0.5)WITHIN GROUP(ORDER BY p0010001) AS "Country Median"
FROM us_counties_2010;

SELECT 
percentile_cont(array [0.25,0.5,0.75])
WITHIN GROUP(ORDER BY p0010001) As "quartiles"
FROM us_counties_2010;

--creating JSON arrays with key:value pairs
SELECT 
json_object_agg(state_us_abbreviation,p0010001)
FROM us_counties_2010;


--Calculatin z scores by adding over() a column
SELECT geo_name,(p0010001 - 
avg((CAST(p0010001 AS numeric(8,1)))) over())/
stddev((CAST(p0010001 AS numeric(8,1)))) over()
FROM us_counties_2010

--over() is a windows function
-- A windows function is comparable to the type of calculations that can be done with a aggregate function, but it doesnt cause rows to be grouped into a single row.

--Calculating cumulative sum 
SELECT geo_name, sum(p0040007) OVER(ORDER BY p0040007)
FROM us_counties_2010