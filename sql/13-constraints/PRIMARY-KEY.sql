/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- PRIMARY KEY

    - A primary key is a column or a group of columns used to identify a row uniquely in a table.
    - You define primary keys through primary key constraints. Technically, a primary key constraint is the combination
        of a not-null constraint and a UNIQUE constraint.
    - A table can have one and only one primary key. It is a good practice to add a primary key to every table. When
        you add a primary key to a table, PostgreSQL creates a unique B-tree index on the column or a group of columns
        used to define the primary key.
    - If you don’t specify explicitly the name for primary key constraint, PostgreSQL will assign a default name to the
        primary key constraint.
*/

-- Define primary key when creating the table --------------------------------------------------------------------------

-- single column primary key
CREATE TABLE po_header(
    po_no INTEGER PRIMARY KEY,
    vendor_no INTEGER,
    description TEXT,
    shipping_address TEXT

);

-- multiple column primary key
CREATE TABLE po_item (
    po_no INTEGER,
    item_no INTEGER,
    product_no INTEGER,
    qty INTEGER,
    net_price INTEGER,
    PRIMARY KEY (po_no, item_no)
);

-- cleanup
DROP TABLE po_header;
DROP TABLE po_item;

-- Define primary key when changing the existing table structure -------------------------------------------------------
CREATE TABLE products (
    product_no INTEGER,
    description TEXT,
    product_cost NUMERIC
);

ALTER TABLE products ADD PRIMARY KEY (product_no);

-- How to add an auto-incremented primary key to an existing table -----------------------------------------------------
CREATE TABLE vendors (name VARCHAR(255));

INSERT INTO
    vendors (NAME)
VALUES
    ('Microsoft'),
    ('IBM'),
    ('Apple'),
    ('Samsung');

SELECT * FROM vendors;

-- Now, if we want to add a primary key named id into the vendors table and the id field is
-- auto-incremented by one, we use the following statement:
ALTER TABLE vendors ADD COLUMN ID SERIAL PRIMARY KEY;

SELECT id, name FROM vendors;

-- Remove primary key --------------------------------------------------------------------------------------------------

ALTER TABLE vendors
DROP CONSTRAINT vendors_pkey;

SELECT * FROM vendors;

-- cleanup
DROP TABLE vendors;
