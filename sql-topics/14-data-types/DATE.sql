/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- DATE TYPE

    - To store date values, you use the PostgreSQL DATE data type. PostgreSQL uses 4 bytes to store a date value.
        The lowest and highest values of the DATE data type are 4713 BC and 5874897 AD.
    - When storing a date value, PostgreSQL uses the  yyyy-mm-dd format e.g., 2000-12-31. It also uses this format
        for inserting data into a date column.
    - If you create a table that has a DATE column and you want to use the current date as the default value for
        the column, you can use the CURRENT_DATE after the DEFAULT keyword.
*/

CREATE TABLE documents (
    document_id serial PRIMARY KEY,
    header_text VARCHAR (255) NOT NULL,
    posting_date DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO
    documents (header_text)
VALUES
    ('Billing to customer XYZ');

SELECT * FROM documents;

-- DATE FUNCTIONS ------------------------------------------------------------------------------------------------------

CREATE TABLE employees (
    employee_id serial PRIMARY KEY,
    first_name VARCHAR (255),
    last_name VARCHAR (355),
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL
);

INSERT INTO employees
    (first_name, last_name, birth_date, hire_date)
VALUES
    ('Shannon','Freeman','1980-01-01','2005-01-01'),
    ('Sheila','Wells','1978-02-05','2003-01-01'),
    ('Ethel','Webb','1975-01-01','2001-01-01');

-- GET CURRENT DATE
SELECT NOW()::date;
SELECT CURRENT_DATE;

-- SPECIFIC FORMAT
SELECT TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy');
SELECT TO_CHAR(NOW() :: DATE, 'Mon dd, yyyy');

-- INTERVAL BETWEEN DATES

-- difference in days, hours, minutes, and seconds
SELECT
    first_name,
    last_name,
    now() - hire_date AS diff
FROM
    employees;

-- difference in years, months, days, hours, minutes, and seconds
-- AGE(end, start)
SELECT
    first_name,
    last_name,
    AGE(now(), hire_date) AS diff
FROM
    employees;

-- Calculate ages in years, months, and days
SELECT
    employee_id,
    first_name,
    last_name,
    AGE(birth_date)
FROM
    employees;

-- Extract year, quarter, month, week, day from a date value
SELECT
    employee_id,
    first_name,
    last_name,
    EXTRACT (YEAR FROM birth_date) AS YEAR,
    EXTRACT (MONTH FROM birth_date) AS MONTH,
    EXTRACT (DAY FROM birth_date) AS DAY
FROM
    employees;

-- CLEANUP
DROP TABLE documents;
DROP TABLE employees;