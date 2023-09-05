/*
    Autor: David Castrillon
    Fecha: 2023
*/

/*
    - One of the most common tasks, when you work with the database, is to query data
        from tables by using the SELECT statement.
    - The FROM clause is optional. If you do not query data from any table, you can omit the FROM clause
        in the SELECT statement.
    - PostgreSQL evaluates the FROM clause before the SELECT clause in the SELECT statement.
*/

-- SELECT

-- query from one column
SELECT first_name FROM customer;

-- query multiple columns
SELECT first_name, last_name, email FROM customer;

--query all columns
SELECT * FROM customer;

-- query with expression (string concatenation), and naming column
SELECT first_name || ' ' || last_name AS full_name FROM customer;
SELECT first_name || ' ' || last_name AS "full name" FROM customer;

-- query arbitrary expression
SELECT 5 * 3;
