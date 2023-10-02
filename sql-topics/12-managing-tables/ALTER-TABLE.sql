/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- ALTER TABLE

    - To change the structure of an existing table, you use PostgreSQL ALTER TABLE statement.
    - PostgreSQL provides you with many actions:
        - Add a column
        - Drop a column
        - Change the data type of a column
        - Rename a column
        - Set a default value for the column.
        - Add a constraint to a column.
        - Rename a table
*/

CREATE TABLE links (
    link_id serial PRIMARY KEY,
    title VARCHAR (512) NOT NULL,
    url VARCHAR (1024) NOT NULL
);

/*
    -- ADD COLUMN

    ALTER TABLE table_name
    ADD COLUMN column_name datatype column_constraint;
*/
ALTER TABLE links
ADD COLUMN active BOOLEAN;

/*
    -- DROP COLUMN

    ALTER TABLE table_name
    DROP COLUMN column_name;
*/
ALTER TABLE links
DROP COLUMN active;

/*
    -- RENAME COLUMN

    ALTER TABLE table_name
    RENAME COLUMN column_name
    TO new_column_name;
*/
ALTER TABLE links
RENAME COLUMN title TO link_title;

-- add new column
ALTER TABLE links
ADD COLUMN target VARCHAR(10);

/*
    -- ALTER DEFAULT VALUE OF COLUMN

    ALTER TABLE table_name
    ALTER COLUMN column_name
    [SET DEFAULT value | DROP DEFAULT]
*/
ALTER TABLE links
ALTER COLUMN target
SET DEFAULT '_blank';

INSERT INTO links (link_title, url)
VALUES('PostgreSQL Tutorial','https://www.postgresqltutorial.com/');

SELECT * FROM links;

/*
    - ADD A CHECK CONSTRAINT

    ALTER TABLE table_name
    ADD CHECK expression;
*/
ALTER TABLE links
ADD CHECK (target IN ('_self', '_blank', '_parent', '_top'));

-- this will throw and error
INSERT INTO links(link_title,url,target)
VALUES('PostgreSQL','http://www.postgresql.org/','whatever');

/*
    - ADD CONSTRAINTS

    ALTER TABLE table_name
    ADD CONSTRAINT constraint_name constraint_definition;
*/
ALTER TABLE links
ADD CONSTRAINT unique_url UNIQUE (url);

-- this will throw an error cause the url already exists
INSERT INTO links(link_title,url)
VALUES('PostgreSQL','https://www.postgresqltutorial.com/');

/*
    - RENAME A TABLE

    ALTER TABLE table_name
    RENAME TO new_table_name;
*/
ALTER TABLE links
RENAME TO urls;

DROP TABLE urls;