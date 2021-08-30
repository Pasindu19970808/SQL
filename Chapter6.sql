--Joining Tables in A Relational Database

CREATE TABLE departments(
	dept_id bigserial,
	dept varchar(100),
	city varchar(100),
	CONSTRAINT dept_key PRIMARY KEY (dept_id),
	CONSTRAINT dept_city_unique UNIQUE (dept,city)
);

CREATE TABLE employees(
	emp_id bigserial,
	first_name varchar(100),
	last_name varchar(100),
	salary integer,
	dept_id integer REFERENCES departments (dept_id),
	CONSTRAINT emp_key PRIMARY KEY (emp_id),
	CONSTRAINT emp_dept_unique UNIQUE(emp_id,dept_id)
);

INSERT INTO departments(dept,city)
VALUES
('Tax', 'Atlanta'),
('IT', 'Boston');

INSERT INTO employees(first_name,last_name,salary,dept_id)
VALUES
('Nancy', 'Jones', 62500, 1),
('Lee', 'Smith', 59300, 1),
('Soo', 'Nguyen', 83000, 2),
('Janet', 'King', 95000, 2);

--Querying multiple tables using JOIN

SELECT * 
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id


--Different JOINs
CREATE TABLE schools_left(
    id bigserial
    left_school varchar(30)
    CONSTRAINT left_id_key PRIMARY KEY(id)
);

CREATE TABLE schools_right(
    id bigserial
    right_school varchar(30)
    CONSTRAINT right_id_key PRIMARY KEY(id)
);

INSERT INTO schools_left (id, left_school) VALUES
(1, 'Oak Street School'),
(2, 'Roosevelt High School'),
(5, 'Washington Middle School'),
(6, 'Jefferson High School');

INSERT INTO schools_right (id, right_school) VALUES
(1, 'Oak Street School'),
(2, 'Roosevelt High School'),
(3, 'Morrison Elementary'),
(4, 'Chase Magnet Academy'),
(6, 'Jefferson High School');

SELECT * 
FROM schools_left JOIN schools_right
ON schools_left.id = schools_right.id

SELECT *
FROM schools_left RIGHT JOIN schools_right
ON schools_left.id = schools_right.id;

SELECT *
FROM schools_left FULL OUTER JOIN schools_right
ON schools_left.id = schools_right.id;

SELECT *
FROM schools_left CROSS JOIN schools_right
ON schools_left.id = schools_right.id;

-- Using NULL to Find Rows with Missing Values

SELECT *
FROM schools_left LEFT JOIN schools_right 
ON schools_left.id = schools_right.id
WHERE schools_right.id IS NULL;

--Querying for multiple columns in tables
SELECT schools_left.id, schools_left.left_school, schools_right.right_school
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id;

--Doing JOIN with table_alias
SELECT lt.id,lt.left_school,rt.right_school
FROM schools_left as lt LEFT JOIN schools_right as rt
ON lt.id = rt.id;

--JOIN with many tables

SELECT lt.id,lt.left_school, en.enrollment,sg.grades
FROM schools_left AS lt LEFT JOIN schools_enrollment AS en
ON lt.id = en.id
LEFT JOIN schools_grades as sg
ON lt.id = sg.id;

CREATE TABLE us_counties_2000(
geo_name varchar(90),
state_us_abbreviation varchar(2),
state_fips varchar(2),
county_fips varchar(3),
p0010001 integer,
p0010002 integer,
p0010003 integer,
p0010004 integer,
p0010005 integer,
p0010006 integer,
p0010007 integer,
p0010008 integer,
p0010009 integer,
p0010010 integer,
p0020002 integer,
p0020003 integer
);


COPY us_counties_2000
FROM 'C:\Users\Public\Documents\Postgresfiles\us_counties_2000.csv'
WITH (FORMAT CSV,HEADER);

SELECT * FROM us_counties_2000

SELECT c2000.geo_name, 
c2000.state_us_abbreviation,c2000.p0010001 AS pop_2000,
c2010.p0010001 AS pop_2010,
(CAST(c2010.p0010001 AS numeric(8,1)) - 
CAST(c2000.p0010001 AS numeric(8,1)))/
CAST(c2000.p0010001 AS numeric(8,1)) AS Pct_Change
FROM us_counties_2000 AS c2000 INNER JOIN us_counties_2010 AS c2010
ON c2000.state_fips = c2010.state_fips;