/*
    Author: David Castrillón
    Date: 2023
*/

-- HAVING

/*
    - The HAVING clause specifies a search condition for a group or an aggregate. The HAVING clause is often
        used with the GROUP BY clause to filter groups or aggregates based on a specified condition.
    - PostgreSQL evaluates the HAVING clause after the FROM, WHERE, GROUP BY, and before the SELECT, DISTINCT,
        ORDER BY and LIMIT clauses.
    - Since the HAVING clause is evaluated before the SELECT clause, you cannot use column aliases in the HAVING
        clause. Because at the time of evaluating the HAVING clause, the column aliases specified in the
        SELECT clause are not available.
    - The WHERE clause allows you to filter rows based on a specified condition. However, the HAVING clause
        allows you to filter groups of rows according to a specified condition.
*/

-- HAVING with SUM aggregate function
SELECT
    customer_id,
    SUM (amount)
FROM
    payment
GROUP BY
    customer_id
HAVING
    SUM(amount) > 200;

-- HAVING with COUNT aggregate function
SELECT
    store_id,
    COUNT(customer_id)
FROM
    customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;