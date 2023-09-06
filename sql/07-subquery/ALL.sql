/*
    Author: David Castrillón
    Date: 2023
*/

-- ALL

/*
    - The PostgreSQL ALL operator allows you to query data by comparing a value with a list of values returned by a subquery.
    - The ALL operator must be preceded by a comparison operator such as equal (=), not equal (!=), greater than (>),
        greater than or equal to (>=), less than (<), and less than or equal to (<=).
    - The ALL operator must be followed by a subquery which also must be surrounded by the parentheses.
    - In case the subquery returns no row, then the ALL operator always evaluates to true.
*/

SELECT
    ROUND(AVG(length), 2) avg_length
FROM
    film
GROUP BY
    rating
ORDER BY avg_length DESC;

SELECT
    film_id,
    title,
    length
FROM
    film
WHERE
    length > ALL(
            SELECT
                ROUND(AVG(length), 2)
            FROM
                film
            GROUP BY
                rating
        )
ORDER BY length;