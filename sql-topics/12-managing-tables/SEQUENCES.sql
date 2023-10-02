/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- SEQUENCES

    - By definition, a sequence is an ordered list of integers. The orders of numbers in the sequence are important.
    - A sequence in PostgreSQL is a user-defined schema-bound object that generates a sequence of integers based on a
        specified specification.
    - To create a sequence in PostgreSQL, you use the CREATE SEQUENCE statement.
*/

/*
    CREATE SEQUENCE [ IF NOT EXISTS ] sequence_name
    [ AS { SMALLINT | INT | BIGINT } ]
    [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ]
    [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ]
    [ CACHE cache ]
    [ [ NO ] CYCLE ]
    [ OWNED BY { table_name.column_name | NONE } ]

    - CACHE: The CACHE determines how many sequence numbers are preallocated and stored in memory for faster access.
        One value can be generated at a time.
    - CYCLE: The CYCLE allows you to restart the value if the limit is reached. The next number will be the minimum
        value for the ascending sequence and maximum value for the descending sequence.
*/

-- Creating an ascending sequence example
CREATE SEQUENCE mysequence
INCREMENT 5
START 100;

-- To get the next value from the sequence to you use the nextval() function:
SELECT nextval('mysequence');
SELECT nextval('mysequence');
SELECT nextval('mysequence');

-- Creating a descending sequence example
CREATE SEQUENCE three
INCREMENT -1
MINVALUE 1
MAXVALUE 3
START 3
CYCLE;

SELECT nextval('three');

-- Creating a sequence associated with a table column
CREATE TABLE order_details(
    order_id SERIAL,
    item_id INT NOT NULL,
    item_text VARCHAR NOT NULL,
    price DEC(10,2) NOT NULL,
    PRIMARY KEY(order_id, item_id)
);

CREATE SEQUENCE order_item_id
START 10
INCREMENT 10
MINVALUE 10
OWNED BY order_details.item_id;

INSERT INTO
    order_details(order_id, item_id, item_text, price)
VALUES
    (100, nextval('order_item_id'),'DVD Player',100),
    (100, nextval('order_item_id'),'Android TV',550),
    (100, nextval('order_item_id'),'Speaker',250);

SELECT
    order_id,
    item_id,
    item_text,
    price
FROM
    order_details;

DROP TABLE order_details;

-- Deleting sequences
-- If a sequence is associated with a table column, it will be automatically dropped once the table column is removed
-- or the table is dropped.