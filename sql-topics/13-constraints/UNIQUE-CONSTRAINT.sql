/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- UNIQUE CONSTRAINT

    - Sometimes, you want to ensure that values stored in a column or a group of columns are unique across the whole
        table such as email addresses or usernames.
    - PostgreSQL provides you with the UNIQUE constraint that maintains the uniqueness of the data correctly.
    - When a UNIQUE constraint is in place, every time you insert a new row, it checks if the value is already in the
        table. It rejects the change and issues an error if the value already exists. The same process is carried out
        for updating existing data.
    - When you add a UNIQUE constraint to a column or a group of columns, PostgreSQL will automatically create a unique
        index on the column or the group of columns.
*/

CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR (50),
    last_name VARCHAR (50),
    email VARCHAR (50) UNIQUE
);

INSERT INTO
    person(first_name,last_name,email)
VALUES
    ('john','doe','j.doe@postgresqltutorial.com');

-- this will throw an error because the email is duplicated
INSERT INTO
    person(first_name,last_name,email)
VALUES
    ('jack','doe','j.doe@postgresqltutorial.com');

DROP TABLE person;

-- Adding unique constraint using a unique index -----------------------------------------------------------------------
-- Sometimes, you may want to add a unique constraint to an existing column or group of columns.

CREATE TABLE equipment (
    id SERIAL PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    equip_id VARCHAR (16) NOT NULL
);

CREATE UNIQUE INDEX CONCURRENTLY equipment_equip_id ON equipment (equip_id);

ALTER TABLE equipment
ADD CONSTRAINT unique_equip_id
UNIQUE USING INDEX equipment_equip_id;

DROP TABLE equipment;
