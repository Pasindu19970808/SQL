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