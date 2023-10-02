/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- CREATE TABLE AS

    - The CREATE TABLE AS statement creates a new table and fills it with the data returned by a query.

    - The columns of the new table will have the names and data types associated with the output columns of the SELECT
        clause. If you want the table columns to have different names, you can specify the new table columns after the new
        table name

    - In case you want to avoid an error by creating a new table that already exists, you can use the IF NOT EXISTS.

    - Note that the CREATE TABLE AS statement is similar to the SELECT INTO statement, but the CREATE TABLE AS statement
        is preferred
*/

-- The following statement creates a table that contains action films that belong to category one.

CREATE TABLE action_film AS
SELECT
    film_id,
    title,
    release_year,
    length,
    rating
FROM
    film
INNER JOIN film_category USING (film_id)
WHERE
    category_id = 1;

SELECT
    *
FROM
    action_film
ORDER BY title;

DROP TABLE action_film;

-- override columns names
CREATE TABLE IF NOT EXISTS film_rating (rating, film_count)
AS
SELECT
    rating,
    COUNT (film_id)
FROM
    film
GROUP BY
    rating;

SELECT * FROM film_rating;

DROP TABLE film_rating;
