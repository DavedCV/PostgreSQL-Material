/*
    Author: David Castrillón
    Date: 2023
*/

/*
    - You use IN operator in the WHERE clause to check if a value matches any value in a list of values.
    - The IN operator returns true if the value matches any value in the list i.e., value1 , value2, ...
    - The list of values can be a list of literal values such as numbers, strings or a result of a SELECT statement.
*/

-- IN

-- in operator
SELECT
    customer_id,
    rental_id,
    return_date
FROM
    rental
WHERE
    customer_id IN (1, 2)
ORDER BY
    return_date DESC;

-- same query but using or and operators
SELECT
    customer_id,
    rental_id,
    return_date
FROM
    rental
WHERE
        customer_id = 1 OR customer_id = 2
ORDER BY
    return_date DESC;

-- not in operator
SELECT
    customer_id,
    rental_id,
    return_date
FROM
    rental
WHERE
    customer_id NOT IN (1, 2);

-- same query but with operators
SELECT
    customer_id,
    rental_id,
    return_date
FROM
    rental
WHERE
    customer_id != 1 AND
    customer_id != 2;

-- in operator with subquery

-- first create a query that return a list if values
SELECT customer_id
FROM rental
WHERE return_date::DATE = '2005-05-27'
ORDER BY customer_id;

-- use the output of the subquery as an input 
SELECT
    customer_id,
    first_name,
    last_name
FROM
    customer
WHERE
    customer_id IN
    (
        SELECT customer_id
        FROM rental
        WHERE return_date::DATE = '2005-05-27'
        ORDER BY customer_id
    )
ORDER BY
    customer_id;