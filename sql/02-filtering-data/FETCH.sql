/*
    Author: David Castrillón
    Date: 2023
*/

/*
    - The LIMIT clause is widely used by many relational database management systems such as MySQL, H2, and HSQLDB.
        However, the LIMIT clause is not a SQL-standard.
    - To conform with the SQL standard, PostgreSQL supports the FETCH clause to retrieve a number of rows returned
        by a query. Note that the FETCH clause was introduced in SQL:2008.

    OFFSET start { ROW | ROWS }
    FETCH { FIRST | NEXT } [ row_count ] { ROW | ROWS } ONLY

    - ROW is the synonym for ROWS, FIRST is the synonym for NEXT . SO you can use them interchangeably
    - The start is an integer that must be zero or positive. By default, it is zero if the OFFSET clause is not
        specified. In case the start is greater than the number of rows in the result set, no rows are returned;
    - The row_count is 1 or greater. By default, the default value of row_count is 1 if you do not specify it
        explicitly.
    - Because the order of rows stored in the table is unspecified, you should always use the FETCH clause with the
        ORDER BY clause to make the order of rows in the returned result set consistent.
*/

-- FETCH

-- select the first row
SELECT
    film_id,
    title
FROM
    film
ORDER BY
    title
FETCH FIRST ROW ONLY;

-- select the first 5 rows
SELECT
    film_id,
    title
FROM
    film
ORDER BY
    title
FETCH FIRST 5 ROW ONLY;

-- select 5 next films after the 5 first films
SELECT
    film_id,
    title
FROM
    film
ORDER BY
    title
OFFSET 5 ROWS
FETCH FIRST 5 ROW ONLY;