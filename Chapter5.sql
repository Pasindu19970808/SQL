--Basic Math and Stats with SQL

SELECT CONCAT(CAST((SELECT 11 / 6) AS text),'.',CAST((SELECT 11 % 6) AS text));

-- Concatenation syntax
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
