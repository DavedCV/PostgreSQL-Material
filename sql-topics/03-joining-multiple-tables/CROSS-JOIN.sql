/*
    Author: David Castrillón
    Date: 2023
*/

-- CROSS JOIN

/*
    - A CROSS JOIN clause allows you to produce a Cartesian Product of rows in two or more tables.
    - Different from other join clauses such as LEFT JOIN  or INNER JOIN, the
        CROSS JOIN clause does not have a join predicate.
*/

-- sample tables
CREATE TABLE T1 (label CHAR(1) PRIMARY KEY);
INSERT INTO T1 (label)
VALUES
    ('A'),
    ('B');
SELECT * FROM T1;

CREATE TABLE T2 (score INT PRIMARY KEY);
INSERT INTO T2 (score)
VALUES
    (1),
    (2),
    (3);
SELECT * FROM T2;

-- CROSS JOIN
SELECT
    *
FROM
    T1
CROSS JOIN T2;


-- cleanup
DROP TABLE T1;
DROP TABLE T2;