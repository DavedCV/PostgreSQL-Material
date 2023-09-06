/*
    Author: David Castrillón
    Date: 2023
*/

-- CUBE

/*
    - PostgreSQL CUBE is a subclause of the GROUP BY clause. The CUBE allows you to generate multiple grouping sets.
    - The query generates all possible grouping sets based on the dimension columns specified in CUBE.
    - In general, if the number of columns specified in the CUBE is n, then you will    have 2^n combinations.
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

-- CUBE

SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    CUBE (brand, segment)
ORDER BY
    brand,
    segment;

-- CUBE but with GROUPING SETS

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
    )
ORDER BY
    brand,
    segment;

-- partial CUBE
SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand,
    CUBE (segment)
ORDER BY
    brand,
    segment;

-- partial CUBE with grouping sets
SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    GROUPING SETS (
        (brand, segment),
        (brand)
    )
ORDER BY
    brand,
    segment;

-- cleanup
DROP TABLE sales;