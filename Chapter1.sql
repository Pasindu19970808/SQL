--Creating a Database analysis

CREATE DATABASE analysis;

--Creating a Table

CREATE TABLE teachers (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- Inserting rows into a table

INSERT INTO teachers (first_name,last_name,school,hire_date,salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);

--Exploring data

SELECT * FROM teachers

--Querying only a subset of the columns

SELECT last_name,first_name,salary FROM teachers;

--DISTINCT keyword

SELECT DISTINCT school 
FROM teachers;

SELECT DISTINCT school,salary 
FROM teachers;

SELECT first_name,last_name,salary
FROM teachers 
ORDER BY salary DESC;

SELECT first_name,last_name
FROM teachers
WHERE salary > 55000;

SELECT first_name,last_name
FROM teachers
WHERE school = 'Myers Middle School';

--ILIKE is case insensitive,and we use % on either side when trying to match an inbetween the word phrase.

SELECT first_name
FROM teachers
WHERE first_name ILIKE '%am%'

-- AND OR Operators

SELECT * 
FROM teachers
WHERE school = "Myers Middle School"
AND salary < 40000

SELECT * 
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
AND (salary < 38000 OR salary > 40000)

--Exercise Queries
SELECT *
FROM teachers 
ORDER BY school ASC, last_name ASC

SELECT *
FROM teachers 
WHERE first_name LIKE 'S%'
AND salary > 40000

SELECT *
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC

--Chapter 1/2 Completed.