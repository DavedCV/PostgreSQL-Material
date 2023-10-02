/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- TIME DATA TYPE

    - PostgreSQL provides the TIME data type that allows you to store the time of day values.

    column_name TIME(precision);

    - A time value may have a precision up to 6 digits. The precision specifies the number of fractional digits placed in
        the second field.

    - The TIME data type requires 8 bytes and its allowed range is from 00:00:00 to 24:00:00. The following illustrates
        the common formats of the TIME values:
        - HH:MI
        - HH:MI:SS
        - HHMISS

    - Besides the TIME data type, PostgreSQL provides the TIME with time zone data type that allows you to store and
        manipulate the time of day with time zone.
    - PostgreSQL allows you to apply arithmetic operators such as +, -,  and *  on time values and between time and
        interval values.
*/

CREATE TABLE shifts (
    id serial PRIMARY KEY,
    shift_name VARCHAR NOT NULL,
    start_at TIME NOT NULL,
    end_at TIME NOT NULL
);

INSERT INTO
    shifts(shift_name, start_at, end_at)
VALUES
    ('Morning', '08:00:00', '12:00:00'),
    ('Afternoon', '13:00:00', '17:00:00'),
    ('Night', '18:00:00', '22:00:00');

SELECT * FROM shifts;

-- Getting the current time
SELECT CURRENT_TIME;
SELECT CURRENT_TIME(2);

-- Converting time to a different time zone
SELECT LOCALTIME AT TIME ZONE 'UTC';

-- Extracting hours, minutes, seconds from a time value
SELECT
    LOCALTIME,
    EXTRACT (HOUR FROM LOCALTIME) as hour,
    EXTRACT (MINUTE FROM LOCALTIME) as minute,
    EXTRACT (SECOND FROM LOCALTIME) as second,
    EXTRACT (milliseconds FROM LOCALTIME) as milliseconds;

-- OPERATIONS
SELECT time '10:00' - time '02:00' AS result;
SELECT LOCALTIME + interval '2 hours' AS result;

-- CLEANUP
DROP TABLE shifts;


