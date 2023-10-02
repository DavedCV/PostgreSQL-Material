/*
    Author: David Castrillón
    Date: 2023
*/

-- ANY

/*
    - The PostgreSQL ANY operator compares a value to a set of values returned by a subquery.
    - The subquery must return exactly one column.
    - The ANY operator must be preceded by one of the following comparison operator =, <=, >, <, > and <>
    - The ANY operator returns true if any value of the subquery meets the condition, otherwise, it returns false.
    - The = ANY is equivalent to IN operator.
*/

-- get the max length of film, grouped by category
SELECT
    MAX(length)
FROM
    film
INNER JOIN film_category USING (film_id)
GROUP BY
    category_id;

-- find the films whose length are greater than or equal to the maximum length of any film category
SELECT
    title
FROM
    film
WHERE
    length >= ANY(
        SELECT
            MAX(length)
        FROM
            film
                INNER JOIN film_category USING (film_id)
        GROUP BY
            category_id
    );

-- = ANY
SELECT
    category_id
FROM
    category
WHERE
    NAME = 'Action'
   OR NAME = 'Drama';

SELECT
    title,
    category_id
FROM
    film
INNER JOIN film_category USING(film_id)
WHERE
    category_id = ANY(
    SELECT
        category_id
    FROM
        category
    WHERE
        NAME = 'Action'
        OR NAME = 'Drama'
    );