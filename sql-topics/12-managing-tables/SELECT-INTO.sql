/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- SELECT INTO

    The PostgreSQL SELECT INTO statement creates a new table and inserts data returned from a query into the table.

    The new table will have columns with the names the same as columns of the result set of the query. Unlike a regular
    SELECT statement, the SELECT INTO statement does not return a result to the client.
*/

-- The following statement creates a new table called film_r that contains films with the rating R and rental
-- duration 5 days from the film table.

SELECT
    film_id,
    title,
    rental_rate
INTO TABLE film_r
FROM
    film
WHERE
    rating = 'R'
    AND rental_duration = 5
ORDER BY
    title;

SELECT * FROM film_r;
DROP TABLE film_r;

/*
    --  creating a temporary table

    A temporary table, as its name implied, is a short-lived table that exists for the duration of a database
    session. PostgreSQL automatically drops the temporary tables at the end of a session or a transaction.
*/

-- The following statement creates a temporary table named short_film that contains the films whose lengths are under
-- 60 minutes.

SELECT
    film_id,
    title,
    length
INTO TEMPORARY TABLE short_film
FROM
    film
WHERE
    length < 60
ORDER BY
    title;

SELECT * FROM short_film;

