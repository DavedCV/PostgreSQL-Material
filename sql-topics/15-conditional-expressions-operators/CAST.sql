/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- CAST

    There are many cases that you want to convert a value of one data type into another. PostgreSQL provides you with
    the CAST operator that allows you to do this.
*/

SELECT CAST ('100' AS INTEGER);

SELECT
    CAST ('2015-01-01' AS DATE),
    CAST ('01-OCT-2015' AS DATE);

SELECT CAST ('10.2' AS DOUBLE PRECISION);

SELECT
    CAST('true' AS BOOLEAN),
    CAST('false' as BOOLEAN),
    CAST('T' as BOOLEAN),
    CAST('F' as BOOLEAN);

SELECT '2019-06-15 14:30:20'::timestamp;

SELECT
    '15 minute'::interval,
    '2 hour'::interval,
    '1 day'::interval,
    '2 week'::interval,
    '3 month'::interval;