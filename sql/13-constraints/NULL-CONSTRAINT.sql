/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- NOT NULL CONSTRAINT

    - If a column has a NOT NULL constraint, any attempt to insert or update NULL in the column will result in an error.
    - In database theory, NULL represents unknown or information missing. NULL is not the same as an empty string or
        the number zero.
    - To check if a value is NULL or not, you use the IS NULL boolean operator. For example, the following expression
        returns true if the value in the email address is NULL.
*/

-- NOT NULL COLUMNS ----------------------------------------------------------------------------------------------------

CREATE TABLE invoices(
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    qty numeric NOT NULL CHECK(qty > 0),
    net_price numeric CHECK(net_price > 0)
);

DROP TABLE invoices;

-- Adding NOT NULL Constraint to existing columns ----------------------------------------------------------------------

CREATE TABLE production_orders (
    id SERIAL PRIMARY KEY,
    description VARCHAR (40) NOT NULL,
    material_id VARCHAR (16),
    qty NUMERIC,
    start_date DATE,
    finish_date DATE
);

ALTER TABLE production_orders
ALTER COLUMN qty SET NOT NULL,
ALTER COLUMN material_id SET NOT NULL,
ALTER COLUMN start_date SET NOT NULL,
ALTER COLUMN finish_date SET NOT NULL;

-- this will throw an error
INSERT INTO
    production_orders (description)
VALUES
    ('Make for Infosys inc.');

DROP TABLE production_orders;