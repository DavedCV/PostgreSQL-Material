/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- NUMERIC TYPE

    - The NUMERIC type can store numbers with a lot of digits. Typically, you use the NUMERIC type for numbers that
        require exactness such as monetary amounts or quantities.

    NUMERIC(precision, scale)

    - In this syntax, the precision is the total number of digits and the scale is the number of digits in the fraction
        part. For example, the number 1234.567 has the precision 7 and scale 3.
    - The NUMERIC type can hold a value up to 131,072 digits before the decimal point 16,383 digits after the decimal point.
    - If you omit both precision and scale, you can store any precision and scale up to the limit of the precision and
        scale mentioned above.
    - If precision is not required, you should not use the NUMERIC type because calculations on NUMERIC values are
        typically slower than integers, floats, and double precisions.
    - If you store a value with a scale greater than the declared scale of the NUMERIC column, PostgreSQL will round
        the value to a specified number of fractional digits.
    - In addition to holding numeric values, the NUMERIC type can also hold a special value called NaN which stands for
        not-a-number.
*/

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(5,2)
);

-- Because the scale of the price column is 2, PostgreSQL rounds the value 500.215 up to 500.22 and rounds the
-- value 500.214 down to 500.21
INSERT INTO
    products (name, price)
VALUES
    ('Phone',500.215),
    ('Tablet',500.214);

SELECT
    *
FROM
    products;

-- PRECISION ERROR
INSERT INTO
    products (name, price)
VALUES
    ('Phone',123456.21);

-- NaN
UPDATE
    products
SET
    price = 'NaN'
WHERE
    id = 1;

SELECT
    *
FROM
    products;

-- CLEANUP
DROP TABLE products;
