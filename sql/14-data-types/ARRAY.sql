/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- ARRAY

    - Array plays an important role in PostgreSQL. Every data type has its own companion array type e.g., integer has an
        integer[] array type, character has character[] array type, etc. In case you define your own data type, PostgreSQL
        creates a corresponding array type in the background for you.
    - PostgreSQL allows you to define a column to be an array of any valid data type including built-in type,
        user-defined type or enumerated type.
*/

CREATE TABLE contacts (
    id serial PRIMARY KEY,
    name VARCHAR (100),
    phones TEXT []
);

-- INSERTING VALUES
INSERT INTO
    contacts (name, phones)
VALUES
    ('John Doe',ARRAY [ '(408)-589-5846','(408)-589-5555' ]);

INSERT INTO
    contacts (name, phones)
VALUES
    ('Lily Bush','{"(408)-589-5841"}'),
    ('William Gate','{"(408)-589-5842","(408)-589-58423"}');

-- QUERY
SELECT
    name,
    phones
FROM
    contacts;

-- ACCESS ARRAY ELEMENTS
SELECT
    name,
    phones [1]
FROM
    contacts;

SELECT
    name
FROM
    contacts
WHERE
    phones [ 2 ] = '(408)-589-58423';

-- MODIFYING ARRAY
UPDATE
    contacts
SET
    phones [2] = '(408)-589-5843'
WHERE
    ID = 3;

SELECT
    id,
    name,
    phones [ 2 ]
FROM
    contacts
WHERE
    id = 3;

UPDATE
    contacts
SET
    phones = '{"(408)-589-5843"}'
WHERE
    id = 3;

SELECT
    name,
    phones
FROM
    contacts
WHERE
    id = 3;

-- SEARCH IN ARRAY
SELECT
    name,
    phones
FROM
    contacts
WHERE
    '(408)-589-5555' = ANY (phones);

-- EXPAND ARRAYS
-- PostgreSQL provides the unnest() function to expand an array to a list of rows.
SELECT
    name,
    unnest(phones)
FROM
    contacts;

-- CLEANUP
DROP TABLE contacts;