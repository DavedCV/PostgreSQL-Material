/*
    Author: David Castrillón
    Date: 2023
*/

-- LIKE

/*
    - PostgreSQL LIKE and ILIKE operators to query data using pattern matchings.
    - You construct a pattern by combining literal values with wildcard characters and use the LIKE or NOT LIKE
        operator to find the matches. PostgreSQL provides you with two wildcards:
            - Percent sign ( %) matches any sequence of zero or more characters.
            - Underscore sign ( _)  matches any single character.
    - The expression returns true if the value matches the pattern.
    - To negate the LIKE operator, you use the NOT operator.
    - If the pattern does not contain any wildcard character, the LIKE operator behaves like the equal.
    - PostgreSQL supports the ILIKE operator that works like the LIKE operator. In addition, the ILIKE operator
        matches value case-insensitively.
*/

-- like operator
SELECT
    'foo' LIKE 'foo', -- true
    'foo' LIKE 'f%',  -- true
    'foo' LIKE '_o_', -- true
    'bar' LIKE 'b_';  -- false

-- % wildcard
-- first name with "er" pattern in it
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name LIKE '%er%'
ORDER BY
    first_name;

-- _ wildcard
-- first name with a single character followed by the string "er" and followed by any number of characters
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name LIKE '_her%'
ORDER BY
    first_name;

-- not like
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name NOT LIKE 'Jen%'
ORDER BY
    first_name

-- ilike
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name ILIKE 'BAR%';