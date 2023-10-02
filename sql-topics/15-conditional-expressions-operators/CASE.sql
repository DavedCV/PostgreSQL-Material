/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- CASE

    - The PostgreSQL CASE expression is the same as IF/ELSE statement in other programming languages. It allows you to
     add if-else logic to the query to form a powerful query.

    - Since CASE is an expression, you can use it in any places where an expression can be used e.g.,SELECT, WHERE,
        GROUP BY, and HAVING clause
*/

/*
    1) General PostgreSQL CASE expression

    CASE
      WHEN condition_1  THEN result_1
      WHEN condition_2  THEN result_2
      [WHEN ...]
      [ELSE else_result]
    END

    When a condition evaluates to false, the CASE expression evaluates the next condition from the top to bottom until
    it finds a condition that evaluates to true.

    n case all conditions evaluate to false, the CASE expression returns the result (else_result) that follows the ELSE
    keyword. If you omit the ELSE clause, the CASE expression returns NULL.
*/

-- CASE IN SELECT STATEMENT
SELECT
    title,
    length,
    CASE
        WHEN length > 0 AND length <= 50 THEN 'Short'
        WHEN length > 50 AND length <= 120 THEN 'Medium'
        WHEN length > 120 THEN 'Long'
    END AS duration
FROM
    film
ORDER BY title;

-- CASE WITH AN AGGREGATE FUNCTION
SELECT
    SUM(
        CASE
            WHEN rental_rate = 0.99 THEN 1
            ELSE 0
        END
    ) AS "Economy",
    SUM(
        CASE
            WHEN rental_rate = 2.99 THEN 1
            ELSE 0
        END
    ) AS "Mass",
    SUM(
        CASE
            WHEN rental_rate = 4.99 THEN 1
            ELSE 0
        END
    ) AS "Premium"
FROM
    film;

/*
    2) Simple PostgreSQL CASE expression

    CASE expression
        WHEN value_1 THEN result_1
        WHEN value_2 THEN result_2
        [WHEN ...]
    ELSE
        else_result
    END

    The CASE first evaluates the expression and compares the result with each value( value_1, value_2, …) in the WHEN
    clauses sequentially until it finds the match.

    If CASE does not find any matches, it returns the else_result in that follows the ELSE, or NULL value if the ELSE
    is not available.
*/

SELECT
    title,
    rating,
    CASE rating
        WHEN 'G' THEN 'General Audiences'
        WHEN 'PG' THEN 'Parental Guidance Suggested'
        WHEN 'PG-13' THEN 'Parents Strongly Cautioned'
        WHEN 'R' THEN 'Restricted'
        WHEN 'NC-17' THEN 'Adults Only'
    END AS rating_description
FROM
    film
ORDER BY title;

-- USING AGGREGATE FUNCTIONS
SELECT
    SUM(
        CASE rating
            WHEN 'G' THEN 1
            ELSE 0
        END
    ) "General Audiences",
    SUM(
        CASE rating
            WHEN 'PG' THEN 1
            ELSE 0
        END
    ) "Parental Guidance Suggested",
    SUM(
        CASE rating
            WHEN 'PG-13' THEN 1
            ELSE 0
        END
    ) "Parents Strongly Cautioned",
    SUM(
        CASE rating
            WHEN 'R' THEN 1
            ELSE 0
        END
    ) "Restricted",
    SUM(
        CASE rating
            WHEN 'NC-17' THEN 1
            ELSE 0
        END
    ) "Adults Only"
FROM film;