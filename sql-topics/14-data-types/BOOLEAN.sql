/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- BOOLEAN DATA TYPE

    PostgreSQL supports a single Boolean data type: BOOLEAN that can have three values: true, false and NULL.
*/

CREATE TABLE stock_availability (
    product_id INT PRIMARY KEY,
    available BOOLEAN NOT NULL
);

INSERT INTO
    stock_availability (product_id, available)
VALUES
    (100, TRUE),
    (200, FALSE),
    (300, 't'),
    (400, '1'),
    (500, 'y'),
    (600, 'yes'),
    (700, 'no'),
    (800, '0');

SELECT
    *
FROM
    stock_availability
WHERE
    available = 'yes';

-- You can imply the true value by using the Boolean column without any operator
SELECT
    *
FROM
    stock_availability
WHERE
    available;

-- Boolean false
SELECT
    *
FROM
    stock_availability
WHERE
    available = '0';

SELECT
    *
FROM
    stock_availability
WHERE
    NOT available;

-- CLEANUP

DROP TABLE stock_availability;