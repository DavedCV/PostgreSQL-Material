/*
    Author: David Castrillón
    Date: 2023
*/

-- GROUP BY

/*
    - The GROUP BY clause divides the rows returned from the SELECT statement into groups. For each group, you
        can apply an aggregate function e.g.,  SUM() to calculate the sum of items or COUNT() to get the
        number of items in the groups.
    - The statement clause divides the rows by the values of the columns specified in the GROUP BY clause
        and calculates a value for each group.
    - PostgreSQL evaluates the GROUP BY clause after the FROM and WHERE clauses and before
        the HAVING, SELECT, DISTINCT, ORDER BY and LIMIT clauses.
*/

-- GROUP BY without an aggregrate function
SELECT
    customer_id
FROM
    payment
GROUP BY
    customer_id;

-- GROUP BY with the SUM aggregate function
SELECT
    customer_id,
    SUM(amount)
FROM
    payment
GROUP BY
    customer_id;

-- using ORDER BY with GROUP BY
-- we can use alias of columns cause the group by is evaluated after the select statement
SELECT
    customer_id,
    SUM(amount) as sum_amount
FROM
    payment
GROUP BY
    customer_id
ORDER BY sum_amount;

-- GROUP BY with the JOIN clause
SELECT
    first_name || ' ' || last_name full_name,
    SUM(amount) amount
FROM
    payment
INNER JOIN customer USING(customer_id)
GROUP BY
    customer_id
ORDER BY amount DESC;

-- GROUP BY with the COUNT aggregate function
SELECT
    staff_id,
    COUNT(payment_id)
FROM
    payment
GROUP BY staff_id;

-- GROUP BY with multiple columns
SELECT
    customer_id,
    staff_id,
    SUM(amount)
FROM
    payment
GROUP BY
    staff_id,
    customer_id
ORDER BY
    customer_id;

-- GROUP BY with a date columns
SELECT
    DATE(payment_date) paid_date,
    SUM(amount) sum
FROM
    payment
GROUP BY
    DATE(payment_date);