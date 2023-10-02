/*
    Author: David Castrillón
    Date: 2023
*/

-- JOIN

/*
    - PostgreSQL join is used to combine columns from one (self-join) or more tables based on the values of the common
        columns between related tables. The common columns are typically the primary key columns of the first table
        and foreign key columns of the second table.
    - PostgreSQL supports inner join, left join, right join, full outer join, cross join, natural join, and
        a special kind of join called self-join.

    - The INNER JOIN examines each row in the first table. It compares the value in first table column
        with the value in the column of each row in the second table. If these values are equal, the inner join creates
        a new row that contains columns from both tables and adds this new row the result set.
    - The LEFT JOIN starts selecting data from the left table. It compares values in the first table column with the
        values in the second table column. If these values are equal, the left join creates a new row that contains
        columns of both tables and adds this new row to the result set. In case the values do not equal, the left join
        also creates a new row that contains columns from both tables and adds it to the result set. However, it fills
        the columns of the right table with null.
    - The RIGHT JOIN is a reversed version of the left join.
    - The FULL OUTER JOIN or full join returns a result set that contains all rows from both left and right tables,
        with the matching rows from both sides if available. In case there is no match, the columns of the table will
        be filled with NULL.
*/

-- create sample tables
CREATE  TABLE basket_a(
    a INT PRIMARY KEY,
    fruit_a VARCHAR(100) NOT NULL
);

INSERT INTO basket_a (a, fruit_a)
VALUES
    (1, 'Apple'),
    (2, 'Orange'),
    (3, 'Banana'),
    (4, 'Cucumber');

CREATE TABLE  basket_b (
    b INT PRIMARY KEY,
    fruit_b VARCHAR(100) NOT NULL
);

INSERT INTO basket_b (b, fruit_b)
VALUES
    (1, 'Orange'),
    (2, 'Apple'),
    (3, 'Watermelon'),
    (4, 'Pear');

-- INNER JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
INNER JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b;

-- LEFT JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b;

-- LEFT JOIN but only keep the rows that have no matching value with the right table
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b
WHERE b IS NULL;

-- RIGHT JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
RIGHT JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b;

-- RIGHT JOIN but only keep the rows that have no matching value with the left table
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
RIGHT JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b
WHERE a IS NULL;

-- FULL OUTER JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL OUTER JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b;

-- FULL OUTER JOIN but without the intersection
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL OUTER JOIN basket_b
    ON basket_a.fruit_a = basket_b.fruit_b
WHERE a ISNULL OR b ISNULL;

-- cleanup
DROP TABLE basket_a;
DROP TABLE basket_b;