/*
    Author: David Castrillón
    Date: 2023
*/

-- EXISTS

/*
    - The EXISTS operator is a boolean operator that tests for existence of rows in a subquery.
    - The EXISTS accepts an argument which is a subquery.
    - If the subquery returns at least one row, the result of EXISTS is true. In case the subquery returns no row,
        the result is of EXISTS is false.
    - The EXISTS operator is often used with the correlated query.
    - The result of EXISTS operator depends on whether any row returned by the subquery, and not on the row
        contents. Therefore, columns that appear on the SELECT clause of the subquery are not important.
    - The NOT operator negates the result of the EXISTS operator. The NOT EXISTS is opposite to EXISTS. It means
        that if the subquery returns no row, the NOT EXISTS returns true. If the subquery returns one or more rows, the NOT EXISTS returns false.
    - if the subquery returns NULL, the result of EXISTS is true.

*/

-- EXISTS
-- find customers who have at least one payment whose amount is greater than 11
SELECT
    first_name,
    last_name
FROM
    customer c
WHERE
    EXISTS(
        SELECT
            1
        FROM payment p
        WHERE p.customer_id = c.customer_id
          AND amount > 11
    )
ORDER BY first_name, last_name;

-- NOT EXISTS
SELECT
    first_name,
    last_name
FROM
    customer c
WHERE
    NOT EXISTS(
        SELECT
            1
        FROM payment p
        WHERE p.customer_id = c.customer_id
          AND amount > 11
    )
ORDER BY first_name,
         last_name;

-- EXISTS AND NULL
-- the subquery returned NULL, therefore, the query returned all rows from the customer table.
SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    EXISTS( SELECT NULL )
ORDER BY
    first_name,
    last_name;