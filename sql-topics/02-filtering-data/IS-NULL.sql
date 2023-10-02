/*
    Author: David Castrillón
    Date: 2023
*/

-- IS NULL

/*
    - In the database world, NULL means missing information or not applicable. NULL is not a value, therefore,
        you cannot compare it with any other values like numbers or strings. The comparison of NULL with a value
        will always result in NULL, which means an unknown result.
*/

-- create table with phone (nullable column)
CREATE TABLE contacts(
    id INT GENERATED BY DEFAULT AS IDENTITY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    PRIMARY KEY (id)
);

-- insert data, one with NULL value
INSERT INTO contacts(first_name, last_name, email, phone)
VALUES ('John','Doe','john.doe@example.com',NULL),
       ('Lily','Bush','lily.bush@example.com','(408-234-2764)');

-- this query does not work, phone = NULL, always return false
SELECT
    id,
    first_name,
    last_name,
    email,
    phone
FROM
    contacts
WHERE
    phone = NULL;

-- using IS NULL
SELECT
    id,
    first_name,
    last_name,
    email,
    phone
FROM
    contacts
WHERE
    phone IS NULL;

--using IS NOT NULL
SELECT
    id,
    first_name,
    last_name,
    email,
    phone
FROM
    contacts
WHERE
    phone IS NOT NULL;

DROP TABLE contacts;