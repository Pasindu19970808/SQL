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

SELECT timestap_column,
        interval_column,
        timestamp_column - interval_column as new_date
FROM data_time_types;