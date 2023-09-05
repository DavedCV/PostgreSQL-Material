/*
    Autor: David Castrillon
    Fecha: 2023
 */

/*
    - The WHERE clause appears right after the FROM clause of the SELECT statement.  The WHERE clause uses the
        condition to filter the rows returned from the SELECT clause.
    - PostgreSQL evaluates the WHERE clause after the FROM clause and before the SELECT and ORDER BY clause.
    - If you use column aliases in the SELECT clause, you cannot use them in the WHERE clause.
    - Besides the SELECT statement, you can use the WHERE clause in the UPDATE and DELETE statement to specify rows
        to be updated or deleted.
    - To form the condition in the WHERE clause, you use comparison and logical operators.
*/

-- WHERE

-- where with "equality" operator
SELECT
    last_name,
    first_name
FROM
    customer
WHERE
    first_name = 'Jamie';

-- where with the "and" operator
SELECT last_name,
       first_name
FROM
    customer
WHERE
    first_name = 'Jamie' AND
    last_name = 'Rice';

-- where with the "or" operator
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    last_name = 'Rodriguez' OR
    first_name = 'Adam';

-- where with the "in" operator
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name IN ('Ann', 'Anne', 'Annie');

-- where with the "like" operator
-- find a string that matches pattern "%" is a wildcard
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name LIKE 'Ann%';

-- where with the "between" operator
-- The BETWEEN operator returns true if a value is in a range of values.
SELECT
    first_name,
    length(first_name) AS name_length
FROM
    customer
WHERE
    first_name LIKE 'A%' AND
    length(first_name) BETWEEN 3 AND 5
ORDER BY
    name_length;

-- where with the not equal operator
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name LIKE 'Bra%' AND
    last_name != 'Motley';