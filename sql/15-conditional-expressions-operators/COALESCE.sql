/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- COALESCE

    The COALESCE function accepts an unlimited number of arguments. It returns the first argument that is not null. If
    all arguments are null, the COALESCE function will return null.

    We often use the COLAESCE function to substitute a default value for null values when we querying the data
*/

SELECT COALESCE (1, 2);
SELECT COALESCE (NULL, 2 , 1);

-- SAMPLE TABLE
CREATE TABLE items (
    ID serial PRIMARY KEY,
    product VARCHAR (100) NOT NULL,
    price NUMERIC NOT NULL,
    discount NUMERIC
);

INSERT INTO
    items (product, price, discount)
VALUES
    ('A', 1000 ,10),
    ('B', 1500 ,20),
    ('C', 800 ,5),
    ('D', 500, NULL);

SELECT
    product,
    (price - discount) AS net_price
FROM
    items;

-- COALESCE HELPS WHEN THERE ARE NULL VALUES
SELECT
    product,
    (price - COALESCE(discount,0)) AS net_price
FROM
    items;

-- CLEANUP
DROP TABLE items;