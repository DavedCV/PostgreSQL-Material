/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- HSTORE

    - The hstore module implements the hstore data type for storing key-value pairs in a single value.

    - The hstore data type is very useful in many cases, such as semi-structured data or rows with many attributes that
        are rarely queried. Notice that keys and values are just text strings only.

    - The data that we insert into the hstore column is a list of comma-separated key =>value pairs. Both keys and values
        are quoted using double quotes (“”).
*/

-- Enable PostgreSQL hstore extension
CREATE EXTENSION hstore;

-- Create a table with hstore data type
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR (255),
    attr HSTORE
);

-- Insert data into the table
INSERT INTO
    books (title, attr)
VALUES
    (
        'PostgreSQL Tutorial',
        '"paperback" => "243",
        "publisher" => "postgresqltutorial.com",
        "language"  => "English",
        "ISBN-13"   => "978-1449370000",
        "weight"    => "11.2 ounces"'
    );

INSERT INTO
    books (title, attr)
VALUES
    (
        'PostgreSQL Cheat Sheet',
        '"paperback" => "5",
        "publisher" => "postgresqltutorial.com",
        "language"  => "English",
        "ISBN-13"   => "978-1449370001",
        "weight"    => "1 ounces"'
    );

-- Query data from an hstore column
SELECT
    attr
FROM
    books;

-- Query value for a specific key
SELECT
    attr -> 'ISBN-13' AS isbn
FROM
    books;

-- Use value in the WHERE clause
SELECT
    title, attr -> 'weight' AS weight
FROM
    books
WHERE
    attr -> 'ISBN-13' = '978-1449370000';

-- Add key-value pairs to existing rows
UPDATE
    books
SET attr = attr || '"freeshipping"=>"yes"' :: hstore;

SELECT
    title,
    attr -> 'freeshipping' AS freeshipping
FROM
    books;

-- Update existing key-value pair
UPDATE
    books
SET attr = attr || '"freeshipping"=>"no"' :: hstore;

SELECT
    title,
    attr -> 'freeshipping' AS freeshipping
FROM
    books;

-- Remove existing key-value pair
UPDATE
    books
SET attr = delete(attr, 'freeshipping');

SELECT
    title,
    attr -> 'freeshipping' AS freeshipping
FROM
    books;

-- Check for a specific key in hstore column
-- You can check for a specific key in an hstore column using the ? operator in the WHERE clause.
SELECT
    title,
    attr->'publisher' as publisher,
    attr
FROM
    books
WHERE
    attr ? 'publisher';

-- Check for a key-value pair
-- You can query based on the hstore key-value pair using the @> operator.
SELECT
    title
FROM
    books
WHERE
    attr @> '"weight"=>"11.2 ounces"' :: hstore;

-- Query rows that contain multiple specified keys
-- You can query the rows whose hstore column contain multiple keys using ?& operator.
SELECT
    title
FROM
    books
WHERE
    attr ?& ARRAY [ 'language', 'weight' ];

-- Get all keys from an hstore column
-- To get all keys from an hstore column, you use the akeys() function as follows:
SELECT
    akeys (attr)
FROM
    books;
-- Or you can use the  skey() function if you want PostgreSQL to return the result as a set.
SELECT
    skeys (attr)
FROM
    books;

-- Get all values from an hstore column
-- Like keys, you can get all values from an hstore column using the  avals() function in the form of arrays.
SELECT
    avals (attr)
FROM
    books;
-- Or you can use the  svals() function if you want to get the result as a set.
SELECT
    svals (attr)
FROM
    books;

-- Convert hstore data to JSON
SELECT
    title,
    hstore_to_json(attr) AS json
FROM
    books;

-- CLEANUP
DROP TABLE books;