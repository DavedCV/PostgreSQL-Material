/*
    Autor: David Castrillon
    Fecha: 2023
*/

/*
    - PostgreSQL LIMIT is an optional clause of the SELECT statement that constrains the number of rows returned
        by the query.
    - In case you want to skip a number of rows before returning the row_count rows, you use OFFSET clause placed
    after the LIMIT clause.
    - Because a table may store rows in an unspecified order, when you use the LIMIT clause, you should always
        use the ORDER BY clause to control the row order. If you don’t use the ORDER BY clause, you may get a
        result set with the unspecified order of rows.
*/

-- LIMIT

-- using limit to get the first five rows
SELECT
    film_id,
    title,
    release_year
FROM
    film
ORDER BY
    film_id
LIMIT 5;

-- using limit with offset
SELECT
    film_id,
    title,
    release_year
FROM
    film
ORDER BY
    film_id
LIMIT 5 OFFSET 3;

-- using limit offset to get top / bottom N rows
-- 10 most expensive films in terms of rental
SELECT
    film_id,
    title,
    rental_rate
FROM
    film
ORDER BY
    rental_rate DESC
LIMIT 10;