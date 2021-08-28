--Understanding Data types

CREATE TABLE char_data_types (
    varchar_column varchar(10),
    char_column char(10),
    text_column text
)

CREATE TABLE number_data_types(
    numeric_column numeric(20,5),
    real_column real,
    double_column double precision
);

INSERT INTO number_data_types
VALUES
(.7, .7, .7),
(2.13579, 2.13579, 2.13579),
(2.1357987654, 2.1357987654, 2.1357987654);

SELECT * FROM number_data_types;

-- Float is not exact. If we want exact precisions, use numeric(precision,scale)
SELECT 
numeric_column * 10000000 AS "Fixed",
real_column * 10000000 AS "Float"
FROM number_data_types
WHERE numeric_column = 0.7

-- Dates and Times

CREATE TABLE data_time_types(
    timestamp_column timestamp with time zone,
    interval_column interval 
);

INSERT INTO data_time_types
VALUES
('2018-12-31 01:00 EST','2 days'),
('2018-12-31 01:00 -8','1 month'),
('2018-12-31 01:00 Australia/Melbourne','1 century'),
(now(),'1 week');

SELECT timestamp_column,
        interval_column,
        timestamp_column - interval_column as new_date
FROM data_time_types;

--Using CAST() function
SELECT timestamp_column,
CAST(timestamp_column as varchar(10))
FROM data_time_types;

SELECT * FROM number_data_types;

SELECT numeric_column, 
CAST(numeric_column AS integer),
CAST(numeric_column AS varchar(6))
FROM number_data_types;

--testing with date/time (Note that unless we change datestyle, Postgresql will always follow the ISO format YYYY/MM/DD)
DROP TABLE test
CREATE TABLE test(
	datestring varchar(15)
);
SELECT * FROM test;

INSERT INTO test
VALUES
('2017/4/13');

--we can use to_char to change how the output looks
SELECT datestring,
to_char(CAST (datestring AS timestamp),'DD/YYYY/MM')
FROM test

