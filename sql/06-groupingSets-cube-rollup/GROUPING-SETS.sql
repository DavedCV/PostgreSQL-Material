/*
    Author: David Castrillón
    Date: 2023
*/

-- GROUPING SETS

/*
    - A grouping set is a set of columns by which you group by using the GROUP BY clause.
    - Suppose that you want to get different grouping sets from a  table by using a single query. To achieve
        this, you may use the UNION ALL to combine all the queries. Even though this works as you
        expected, it has two main problems: First, it is quite lengthy, Second, it has a performance issue
        because PostgreSQL has to scan the table separately for each query.
    - To make it more efficient, PostgreSQL provides the GROUPING SETS clause which is the
        subclause of the GROUP BY clause.
    - The GROUPING SETS allows you to define multiple grouping sets in the same query.
*/

-- GROUPING FUNCTION

/*
    - The GROUPING() function accepts an argument which can be a column name or an expression.
    - The column_name or expression must match with the one specified in the GROUP BY clause.
    - The GROUPING() function returns bit 0 if the argument is a member of the current grouping set and 1 otherwise.
*/

-- sample tables
CREATE TABLE sales (
    brand VARCHAR NOT NULL,
    segment VARCHAR NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (brand, segment)
);

INSERT INTO sales (brand, segment, quantity)
VALUES
    ('ABC', 'Premium', 100),
    ('ABC', 'Basic', 200),
    ('XYZ', 'Premium', 100),
    ('XYZ', 'Basic', 300);
SELECT * FROM sales;

-- UNION ALL
SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand,
    segment;

SELECT
    brand,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand;

SELECT
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    segment;

SELECT SUM (quantity) FROM sales;

SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand,
    segment

UNION ALL

SELECT
    brand,
    NULL,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand

UNION ALL

SELECT
    NULL,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    segment

UNION ALL

SELECT
    NULL,
    NULL,
    SUM (quantity)
FROM
    sales;


-- GROUPING SETS
SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    GROUPING SETS (
    (brand, segment),
    (brand),
    (segment),
    ()
    );

-- GROUPING FUNCTION

SELECT
    GROUPING(brand) grouping_brand,
    GROUPING(segment) grouping_segment,
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    GROUPING SETS (
    (brand),
    (segment),
    ()
    )
ORDER BY
    brand,
    segment;

SELECT
    GROUPING(brand) grouping_brand,
    GROUPING(segment) grouping_segment,
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    GROUPING SETS (
    (brand),
    (segment),
    ()
    )
HAVING GROUPING(brand) = 0
ORDER BY
    brand,
    segment;

-- cleanup
DROP TABLE sales;
