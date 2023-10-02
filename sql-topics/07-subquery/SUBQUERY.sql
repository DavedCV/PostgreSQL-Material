/*
    Author: David Castrillón
    Date: 2023
*/

-- SUBQUERY

/*
    - A subquery is a query nested inside another query such as SELECT, INSERT, DELETE and UPDATE. In this
        tutorial, we are focusing on the SELECT statement only.
    - To construct a subquery, we put the second query in brackets and use it in the WHERE clause as an expression.
    - The query inside the brackets is called a subquery or an inner query. The query that contains the subquery
        is known as an outer query.
    - PostgreSQL executes the query that contains a subquery in the following sequence:
        - First, executes the subquery.
        - Second, gets the result and passes it to the outer query.
        - Third, executes the outer query.
*/

-- WITHOUT SUBQUERY
SELECT
    AVG (rental_rate)
FROM
    film;

SELECT
    film_id,
    title,
    rental_rate
FROM
    film
WHERE
    rental_rate > 2.98;

-- SUBQUERY
SELECT
    film_id,
    title,
    rental_rate
FROM
    film
WHERE
    rental_rate > (
        SELECT
            AVG (rental_rate)
        FROM
            film
    );

-- SUBQUERY with IN operator

-- get films id of films that have the return_date in a range
SELECT
    inventory.film_id
FROM
    rental
INNER JOIN inventory USING (inventory_id)
WHERE
    return_date BETWEEN '2005-05-29' AND '2005-05-30';

-- use SUBQUERY to get the title of those films
SELECT
    film_id,
    title
FROM
    film
WHERE
    film_id IN (
        SELECT
            inventory.film_id
        FROM
            rental
                INNER JOIN inventory USING (inventory_id)
        WHERE
            return_date BETWEEN '2005-05-29' AND '2005-05-30'
    );

-- SUBQUERY with the EXISTS operator
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    EXISTS (
        SELECT
            1
        FROM
            payment
        WHERE
            payment.customer_id = customer.customer_id
    );