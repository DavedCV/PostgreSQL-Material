/*
    Author: David Castrillón
    Date: 2023
*/

-- COMMON TABLE EXPRESSIONS

/*
    - A common table expression is a temporary result set which you can reference within another SQL statement
        including SELECT, INSERT, UPDATE or DELETE.
    - Common Table Expressions are temporary in the sense that they only exist during the execution of the query.
    - Common Table Expressions or CTEs are typically used to simplify complex joins and subqueries in PostgreSQL.

    STRUCTURE:
    - First, specify the name of the CTE following by an optional column list.
    - Second, inside the body of the WITH clause, specify a query that returns a result set. If you do not explicitly
        specify the column list after the CTE name, the select list of the CTE_query_definition will become the column
        list of the CTE.
    - Third, use the CTE like a table or view in the statement which can be a SELECT, INSERT, UPDATE, or DELETE.

*/

-- CTE
WITH cte_film AS (
    SELECT
        film_id,
        title,
        (CASE
            WHEN length < 30 THEN 'Short'
            WHEN length < 90 THEN 'Medium'
            ELSE 'Long'
        END) AS length
    FROM
        film
)
SELECT
    film_id,
    title,
    length
FROM
    cte_film
WHERE
    length = 'Long'
ORDER BY title;

-- joining a CTE with a TABLE
WITH cte_rental AS (
    SELECT
        staff_id,
        COUNT(rental_id) rental_count
    FROM
        rental
    GROUP BY staff_id
)
SELECT
    s.staff_id,
    first_name,
    last_name,
    rental_count
FROM staff s
INNER JOIN cte_rental USING (staff_id);