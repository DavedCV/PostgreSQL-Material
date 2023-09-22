/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- TIMESTAMP

    PostgreSQL provides you with two temporal data types for handling timestamp:
        - timestamp: a timestamp without timezone one.
        - timestamptz: timestamp with a timezone.

    - Notice that both timestamp and timestamptz uses 8 bytes for storing the timestamp values.
    - The timestamp datatype allows you to store both date and time. However, it does not have any time zone data.
        It means that when you change the timezone of your database server, the timestamp value stored in the database
        will not change automatically.

    - The timestamptz datatype is the timestamp with the time zone. The timestamptz datatype is a time zone-aware
        date and time data type.
    - When you insert a value into a timestamptz column, PostgreSQL converts the timestamptz value into a
        UTC value and stores the UTC value in the table.
    - When you query timestamptz from the database, PostgreSQL converts the UTC value back to the time value of
        the timezone set by the database server, the user, or the current database connection.

*/

-- CREATE SAMPLE TABLE
CREATE TABLE timestamp_demo (
    ts TIMESTAMP,
    tstz TIMESTAMPTZ
);

-- SERVER TIMEZONE
SHOW TIMEZONE;

-- INSERT DATA
INSERT INTO
    timestamp_demo (ts, tstz)
VALUES
    ('2016-06-22 19:10:25-07','2016-06-22 19:10:25-07');

-- QUERY DATA
SELECT
    ts, tstz
FROM
    timestamp_demo;

-- CHANGE TIMEZONE OF THE CURRENT SECTION
SET timezone = 'America/New_York';

-- SEE THE CHANGE IN THE tstz
SELECT
    ts,
    tstz
FROM
    timestamp_demo;

-- TIMESTAMP FUNCTIONS -------------------------------------------------------------------------------------------------

-- CURRENT TIME STAMP
SELECT NOW();
SELECT CURRENT_TIMESTAMP;

-- To get the current time without date, you use CURRENT_TIME:
SELECT CURRENT_TIME;

-- To get the time of day in the string format, you use the timeofday() function.
SELECT TIMEOFDAY();

-- Convert between timezones
SELECT timezone('America/New_York','2016-06-01 00:00');
SELECT timezone('America/New_York','2016-06-01 00:00'::timestamptz);

-- CLEANUP
DROP TABLE timestamp_demo;