    8/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- FOREIGN KEYS

    - A foreign key is a column or a group of columns in a table that reference the primary key of another table.
    - The table that contains the foreign key is called the referencing table or child table. And the table referenced
        by the foreign key is called the referenced table or parent table.
    - A table can have multiple foreign keys depending on its relationships with other tables.
*/

/*
    [CONSTRAINT fk_name]
    FOREIGN KEY(fk_columns)
    REFERENCES parent_table(parent_key_columns)
    [ON DELETE delete_action]
    [ON UPDATE update_action]

    - First, specify the name for the foreign key constraint after the CONSTRAINT keyword. The CONSTRAINT clause is
        optional. If you omit it, PostgreSQL will assign an auto-generated name.
    - Second, specify one or more foreign key columns in parentheses after the FOREIGN KEY keywords.
    - Third, specify the parent table and parent key columns referenced by the foreign key columns in the REFERENCES clause.
    - Finally, specify the delete and update actions in the ON DELETE and ON UPDATE clauses: The delete and update
        actions determine the behaviors when the primary key in the parent table is deleted and updated.

    POSTGRES support the following actions:
        - SET NULL
        - SET DEFAULT
        - RESTRICT
        - NO ACTION
        - CASCADE
*/

CREATE TABLE customers(
    customer_id INT GENERATED ALWAYS AS IDENTITY,
    customer_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(customer_id)
);

CREATE TABLE contacts(
    contact_id INT GENERATED ALWAYS AS IDENTITY,
    customer_id INT,
    contact_name VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    PRIMARY KEY(contact_id),
    CONSTRAINT fk_customer
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
);

INSERT INTO
    customers(customer_name)
VALUES
    ('BlueBird Inc'),
    ('Dolphin LLC');

INSERT INTO
    contacts(customer_id, contact_name, phone, email)
VALUES
    (1,'John Doe','(408)-111-1234','john.doe@bluebird.dev'),
    (1,'Jane Doe','(408)-111-1235','jane.doe@bluebird.dev'),
    (2,'David Wright','(408)-222-1234','david.wright@dolphin.dev');

SELECT * FROM customers;
SELECT * FROM contacts;

-- NO ACTION -----------------------------------------------------------------------------------------------------------

-- Because of the ON DELETE NO ACTION, PostgreSQL issues a constraint violation because the referencing rows of
-- the customer id 1 still exist in the contacts table:
DELETE FROM customers
WHERE
    customer_id = 1;

-- SET NULL ------------------------------------------------------------------------------------------------------------
-- The SET NULL automatically sets NULL to the foreign key columns in the referencing rows of the child table when the
-- referenced rows in the parent table are deleted.

ALTER TABLE contacts
DROP CONSTRAINT fk_customer;

ALTER TABLE contacts
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id)
ON DELETE SET NULL;

DELETE FROM customers
WHERE customer_id = 1;

-- Because of the ON DELETE SET NULL action, the referencing rows in the contacts table set to NULL.
-- As can be seen clearly from the output, the rows that have the customer_id 1 now have the customer_id sets to NULL
SELECT * FROM contacts;

-- CASCADE -------------------------------------------------------------------------------------------------------------
-- The ON DELETE CASCADE automatically deletes all the referencing rows in the child table when the referenced rows
-- in the parent table are deleted

DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
    customer_id INT GENERATED ALWAYS AS IDENTITY,
    customer_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(customer_id)
);

CREATE TABLE contacts(
    contact_id INT GENERATED ALWAYS AS IDENTITY,
    customer_id INT,
    contact_name VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    PRIMARY KEY(contact_id),
    CONSTRAINT fk_customer
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
);

INSERT INTO
    customers(customer_name)
VALUES
    ('BlueBird Inc'),
    ('Dolphin LLC');

INSERT INTO
    contacts(customer_id, contact_name, phone, email)
VALUES
    (1,'John Doe','(408)-111-1234','john.doe@bluebird.dev'),
    (1,'Jane Doe','(408)-111-1235','jane.doe@bluebird.dev'),
    (2,'David Wright','(408)-222-1234','david.wright@dolphin.dev');

DELETE FROM customers
WHERE customer_id = 1;

-- Because of the ON DELETE CASCADE action, all the referencing rows in the contacts table are automatically deleted
SELECT * FROM contacts;

-- SET NULL ------------------------------------------------------------------------------------------------------------
-- The ON DELETE SET DEFAULT sets the default value to the foreign key column of the referencing rows in the child
-- table when the referenced rows from the parent table are deleted.

-- CLEANUP
DROP TABLE contacts;
DROP TABLE customers;
