/*
    Author: David Castrillón
    Date: 2023
*/

-- DELETE JOIN

/*

    - PostgreSQL doesn’t support the DELETE JOIN statement. However, it does support the USING clause in the DELETE
        statement that provides similar functionality as the DELETE JOIN.

    SYNTAX:
    - First, specify the table expression after the USING keyword. It can be one or more tables.
    - Then, use columns from the tables that appear in the USING clause in the WHERE clause for joining data.

*/

-- sample tables

CREATE TABLE contacts(
    contact_id serial PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    phone varchar(15) NOT NULL
);
INSERT INTO contacts(first_name, last_name, phone)
VALUES ('John','Doe','(408)-523-9874'),
       ('Jane','Doe','(408)-511-9876'),
       ('Lily','Bush','(408)-124-9221');
SELECT * FROM contacts;

CREATE TABLE blacklist(
    phone varchar(15) PRIMARY KEY
);
INSERT INTO blacklist(phone)
VALUES ('(408)-523-9874'),
       ('(408)-511-9876');
SELECT * FROM blacklist;

-- DELETE JOIN (DELETE USING)

DELETE FROM contacts
USING blacklist
WHERE contacts.phone = blacklist.phone;

SELECT * FROM contacts;

-- DELETE JOIN USING A SUBQUERY
-- to maintain compatibility with other rdbms

DELETE FROM contacts
WHERE phone IN (SELECT phone FROM blacklist);

-- cleanup
DROP TABLE contacts;
DROP TABLE blacklist;