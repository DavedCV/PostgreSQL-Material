/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- INTERVAL DATA TYPE

    - The interval data type allows you to store and manipulate a period of time in years, months, days, hours, minutes,
        seconds, etc. The following illustrates the interval type:

    interval [ fields ] [ (p) ]

    - In addition, an interval value can have an optional precision value p with the permitted range is from 0 to 6. The
        precision is the number of fraction digits retained in the second field.

    - Internally, PostgreSQL stores interval values as months, days, and seconds. The months and days values are integers
        while the seconds can field can have fractions.
*/

/*
    -- INTERVAL INPUT FORMAT

    PostgreSQL provides you with the following verbose syntax to write the interval values:

    quantity unit [quantity unit...] [direction]

    - quantity is a number, sign + or - is also accepted
    - unit can be any of millennium, century, decade, year, month, week, day, hour, minute, second, millisecond,
        microsecond, or abbreviation (y, m, d, etc.,) or plural forms (months, days, etc.).
    - direction can be ago or empty string ''

    - You can apply the arithmetic operator ( +, -, *, etc.,) to the interval values
    - To convert an interval value to string, you use the TO_CHAR() function.
    - To extract field such as year, month, date, etc., from an interval, you use the EXTRACT() function.
    - PostgreSQL provides two functions justifydays and  justifyhours that allows you to adjust the interval of 30-day
        as one month and the interval of 24-hour as one day
*/

-- INTERVAL
SELECT
    NOW(),
    NOW() - INTERVAL '1 year 3 hours 20 minutes'
        AS "3 hours 20 minutes ago of last year";

-- OPERATORS
SELECT INTERVAL '2h 50m' + INTERVAL '10m'; -- 03:00:00
SELECT INTERVAL '2h 50m' - INTERVAL '50m'; -- 02:00:00
SELECT 600 * INTERVAL '1 minute'; -- 10:00:00

-- INTERVAL TO STRING
SELECT TO_CHAR(INTERVAL '17h 20m 05s', 'HH24:MI:SS');

-- EXTRACT FIELD
SELECT EXTRACT (MINUTE FROM INTERVAL '5 hours 21 minutes');

-- JUSTIFY INTERVALS
SELECT
    justify_days(INTERVAL '30 days'),
    justify_hours(INTERVAL '24 hours');

SELECT
    justify_interval(interval '1 year -1 hour');


