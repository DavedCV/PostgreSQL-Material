/*
    Author: David Castrillón
    Date: 2023
*/

-- ROLLUP

/*
    - The PostgreSQL ROLLUP is a subclause of the GROUP BY clause that offers a shorthand for defining multiple grouping sets.
    - Different from the CUBE subclause, ROLLUP does not generate all possible grouping sets based on the specified
        columns. It just makes a subset of those.
    - The ROLLUP assumes a hierarchy among the input columns and generates all grouping sets that make sense
        considering the hierarchy. This is the reason why ROLLUP is often used to generate the subtotals and the
        grand total for reports.
*/

-- sample table
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

-- ROLLUP
SELECT
    brand,
    segment,
    sum(quantity)
FROM
    sales
GROUP BY
    ROLLUP (brand, segment)
ORDER BY
    brand,
    segment;

-- ROLLUP but with GROUPING SETS
SELECT
    brand,
    segment,
    sum(quantity)
FROM
    sales
GROUP BY
    GROUPING SETS (
        (brand, segment),
        (brand),
        ()
    )
ORDER BY
    brand,
    segment;

-- ROLLUP changes in base of the order
SELECT
    segment,
    brand,
    SUM (quantity)
FROM
    sales
GROUP BY
    ROLLUP (segment, brand)
ORDER BY
    segment,
    brand;

-- PARTIAL ROLLUP
SELECT
    segment,
    brand,
    SUM (quantity)
FROM
    sales
GROUP BY
    segment,
    ROLLUP (brand)
ORDER BY
    segment,
    brand;

-- cleanup
DROP TABLE sales;

-- ROLLUP BY DATES
-- The following statement finds the number of rental per day, month, and year by using the ROLLUP
SELECT
    EXTRACT(YEAR FROM rental_date) y,
    EXTRACT(MONTH FROM rental_date) M,
    EXTRACT(DAY FROM rental_date) d,
    COUNT(rental_id)
FROM
    rental
GROUP BY
    ROLLUP (y, M, d);
