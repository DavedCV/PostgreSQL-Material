/*
    Author: David Castrillón
    Date: 2023
*/

-- UPSERT

/*

    - in relational databases, the term upsert is referred to as merge. The idea is that when you insert a new
        row into the table, PostgreSQL will update the row if it already exists, otherwise, it will insert the new row.
        That is why we call the action is upsert (the combination of update or insert).

    - PostgreSQL added the "ON CONFLICT target action" clause to the INSERT statement to support the upsert feature.
    - In this statement, the target can be one of the following:
        -  (column_name) – a column name.
        -  ON CONSTRAINT constraint_name – where the constraint name could be the name of the UNIQUE constraint.
        -  WHERE predicate – a WHERE clause with a predicate.
    - The action can be one of the following:
        -  DO NOTHING – means do nothing if the row already exists in the table.
        -  DO UPDATE SET column_1 = value_1, .. WHERE condition – update some fields in the table.

*/

-- sample tables

CREATE TABLE customers (
    customer_id serial PRIMARY KEY,
    name VARCHAR UNIQUE,
    email VARCHAR NOT NULL,
    active bool NOT NULL DEFAULT TRUE
);
INSERT INTO
    customers (name, email)
VALUES
    ('IBM', 'contact@ibm.com'),
    ('Microsoft', 'contact@microsoft.com'),
    ('Intel', 'contact@intel.com');


-- UPSERT - DO NOTHING
-- name is unique

INSERT INTO customers (name, email)
VALUES('Microsoft','hotline@microsoft.com')
ON CONFLICT ON CONSTRAINT customers_name_key
    DO NOTHING;

SELECT * FROM customers;

-- UPSERT - UPDATE
-- EXCLUDED is the row that represents the data specified by "values"
INSERT INTO customers (name, email)
VALUES ('Microsoft', 'hotline@microsoft.com')
ON CONFLICT ON CONSTRAINT customers_name_key
    DO UPDATE SET email = EXCLUDED.email || ';' || customers.email;

SELECT * FROM customers;

-- cleanup

DROP TABLE customers;