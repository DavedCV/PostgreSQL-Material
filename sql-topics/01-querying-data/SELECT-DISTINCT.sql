/*
    Autor: David Castrillon
    Fecha: 2023
*/

/*
    - The DISTINCT clause is used in the SELECT statement to remove duplicate rows from a result set. The DISTINCT
        clause keeps one row for each group of duplicates. The DISTINCT clause can be applied to one or more
        columns in the select list of the SELECT statement.
    - If you specify multiple columns, the DISTINCT clause will evaluate the duplicate based on the combination
        of values of these columns.
    - PostgreSQL also provides the DISTINCT ON (expression) to keep the “first” row of each group of
        duplicates.
    - The order of rows returned from the SELECT statement is unspecified therefore the “first” row of
        each group of the duplicate is also unspecified. It is a good practice to always use the ORDER BY clause
        with the DISTINCT ON(expression) to make the result set predictable.
*/

-- SELECT DISTINCT

CREATE TABLE distinct_demo (
    id serial NOT NULL PRIMARY KEY,
    bcolor VARCHAR,
    fcolor VARCHAR
);

INSERT INTO distinct_demo (bcolor, fcolor)
VALUES
    ('red', 'red'),
    ('red', 'red'),
    ('red', NULL),
    (NULL, 'red'),
    ('red', 'green'),
    ('red', 'blue'),
    ('green', 'red'),
    ('green', 'blue'),
    ('green', 'green'),
    ('blue', 'red'),
    ('blue', 'green'),
    ('blue', 'blue');

SELECT
    id,
    bcolor,
    fcolor
FROM
    distinct_demo;

-- distinct with one column
SELECT
    DISTINCT bcolor
FROM
    distinct_demo
ORDER BY
    bcolor;

-- distinct with multiple columns
-- duplicates are evaluated based on the combination of the column values
SELECT
    DISTINCT bcolor,
             fcolor
FROM
    distinct_demo
ORDER BY
    bcolor,
    fcolor;

-- distinct on
--  for each group of duplicates keeps the first row in the resulted set
-- is important to have the order by to make the output predictable
SELECT
    DISTINCT ON (bcolor) bcolor,
                         fcolor
FROM
    distinct_demo
ORDER BY
    bcolor,
    fcolor;

DROP TABLE distinct_demo;