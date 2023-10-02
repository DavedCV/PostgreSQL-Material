/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- JSON

    - JSON stands for JavaScript Object Notation. JSON is an open standard format that consists of key-value pairs.

    - PostgreSQL supports native JSON data type since version 9.2. It provides many functions and operators for
        manipulating JSON data.

    - PostgreSQL provides two native operators -> and ->> to help you query JSON data.
        - The operator -> returns JSON object field by key.
        - The operator ->> returns JSON object field by text.
*/

CREATE TABLE orders (
    id serial NOT NULL PRIMARY KEY,
    info jsonb NOT NULL
);

-- Insert JSON data
INSERT INTO
    orders (info)
VALUES
    ('{ "customer": "John Doe", "items": {"product": "Beer","qty": 6}}');

INSERT INTO
    orders (info)
VALUES
    ('{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24}}'),
    ('{ "customer": "Josh William", "items": {"product": "Toy Car","qty": 1}}'),
    ('{ "customer": "Mary Clark", "items": {"product": "Toy Train","qty": 2}}');

-- Querying JSON data
SELECT
    info
FROM
    orders;

-- as jsonb
SELECT
    info -> 'customer' AS customer,
    pg_typeof(info -> 'customer') AS type
FROM
    orders;

-- as text
SELECT
    info ->> 'customer' AS customer,
    pg_typeof(info ->> 'customer') AS type
FROM
    orders;

-- chaining
SELECT
    info -> 'items' ->> 'product' as product
FROM
    orders
ORDER BY product;

-- Use JSON operator in WHERE clause
SELECT
    info ->> 'customer' AS customer
FROM
    orders
WHERE
    info -> 'items' ->> 'product' = 'Diaper';

SELECT
    info ->> 'customer' AS customer,
    info -> 'items' ->> 'product' AS product
FROM
    orders
WHERE
    CAST ( info -> 'items' ->> 'qty' AS INTEGER) = 2;

-- Apply aggregate functions to JSON data
SELECT
    MIN (CAST (info -> 'items' ->> 'qty' AS INTEGER)),
    MAX (CAST (info -> 'items' ->> 'qty' AS INTEGER)),
    SUM (CAST (info -> 'items' ->> 'qty' AS INTEGER)),
    AVG (CAST (info -> 'items' ->> 'qty' AS INTEGER))
FROM
    orders;

-- Ask if the json column contains a key/value pair
SELECT
    id, info ->> 'items'
FROM
    orders
WHERE
    info @> '{"customer": "Lily Bush"}';

-- We have an operator to check is a tag is present
SELECT
    COUNT(*)
FROM
    orders
WHERE
    info ? 'customer';

-- PostgreSQL JSON functions -------------------------------------------------------------------------------------------

-- jsonn_each function
-- The jsonb_each() function allows us to expand the outermost JSON object into a set of key-value pairs.
SELECT
    id, jsonb_each (info)
FROM
    orders;

SELECT
    id, jsonb_each_text(info)
FROM
    orders;

-- jsonb_object_keys function
-- To get a set of keys in the outermost JSON object, you use the json_object_keys() function.
SELECT
    id, jsonb_object_keys(info -> 'items')
FROM
    orders;

SELECT
    id, jsonb_object_keys(info)
FROM
    orders;

-- CLEANUP
DROP TABLE orders;