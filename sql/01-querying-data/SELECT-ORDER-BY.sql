/*
    Autor: David Castrillon
    Fecha: 2023
*/

/*
    - When you query data from a table, the SELECT statement returns rows in an unspecified order. To sort the
        rows of the result set, you use the ORDER BY clause in the SELECT statement.
    - The ORDER BY clause allows you to sort rows returned by a SELECT clause in ascending or descending
    order based on a sort expression.
    - PostgreSQL evaluates the clauses in the SELECT statment in the following order: FROM, SELECT, and ORDER BY.
    - Due to the order of evaluation, if you have a column alias in the SELECT clause,
        you can use it in the ORDER BY clause.
*/


-- ORDER BY

-- order by one column in asc order
SELECT first_name, last_name FROM customer ORDER BY first_name ASC;

-- order by one column in desc order
SELECT first_name, last_name FROM customer ORDER BY first_name DESC;

-- order by multiple columns
SELECT first_name, last_name FROM customer ORDER BY first_name ASC, last_name DESC;

-- order by to sort rows by expressions
-- here we use the LENGTH() function that accepts a string an return its length
SELECT first_name, length(first_name) AS len FROM customer ORDER BY len;

-- order by and null values
CREATE TABLE sort_demo (
    num INT
);

INSERT INTO sort_demo(num)
VALUES (1), (2), (3), (NULL);

SELECT num FROM sort_demo ORDER BY num;             --nulls last auto
SELECT num FROM sort_demo ORDER BY num NULLS LAST;

SELECT num FROM sort_demo ORDER BY num DESC;        --nulls first autp
SELECT num FROM sort_demo ORDER BY num NULLS FIRST;

DROP TABLE sort_demo;