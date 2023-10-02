/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- CHARACTER TYPES

    PostgreSQL provides three primary character types: CHARACTER(n) or CHAR(n), CHARACTER VARYING(n) or VARCHAR(n), and
    TEXT, where n is a positive integer.

    - Both CHAR(n) and VARCHAR(n)can store up to n characters. If you try to store a string that has more than n
    characters, PostgreSQL will issue an error.
    - However, one exception is that if the excessive characters are all spaces, PostgreSQL truncates the spaces to the
    maximum length (n) and stores the characters.
    - If a string explicitly casts to a CHAR(n) or VARCHAR(n), PostgreSQL will truncate the string to n characters
    before inserting it into the table.
    - The TEXT data type can store a string with unlimited length.
    - If you do not specify the n integer for the VARCHAR data type, it behaves like the TEXT datatype. The performance
    of the VARCHAR (without the size n) and TEXT are the same.
    - Unlike VARCHAR, The CHARACTER or CHAR without the length specifier (n) is the same as the CHARACTER(1) or CHAR(1).
*/

CREATE TABLE character_tests (
    id SERIAL PRIMARY KEY,
    x CHAR (1),
    y VARCHAR (10),
    z TEXT
);

-- insert data following constrains
INSERT INTO
    character_tests (x, y, z)
VALUES
    ('Y','Testing','This is a very long text for the PostgreSQL text column');

-- query

SELECT
    *
FROM
    character_tests;

-- CLEANUP
DROP TABLE character_tests;