/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- COPY A TABLE

    - Note that all the statement below copy table structure and data but do not copy indexes and constraints of
    the existing table.

    - To copy a table completely, including both table structure and data, you use the following statement:

        CREATE TABLE new_table AS
        TABLE existing_table;

    - To copy a table structure without data, you add the WITH NO DATA clause to the CREATE TABLE statement as follows:

        CREATE TABLE new_table AS
        TABLE existing_table
        WITH NO DATA;

    - To copy a table with partial data from an existing table, you use the following statement:

        CREATE TABLE new_table AS
        SELECT
            *
        FROM
            existing_table
        WHERE
            condition;
*/

CREATE TABLE contacts(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE
);

INSERT INTO
    contacts(first_name, last_name, email)
VALUES
    ('John','Doe','john.doe@postgresqltutorial.com'),
    ('David','William','david.william@postgresqltutorial.com');

-- copy table
CREATE TABLE contact_backup
AS TABLE contacts;

SELECT * FROM contact_backup;

DROP TABLE contact_backup;
DROP TABLE contacts;