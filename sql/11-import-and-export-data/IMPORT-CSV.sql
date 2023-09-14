/*
    Author: David Castrillón
    Date: 2023
*/

-- IMPORT CSV FILE INTO A TABLE

-- sample table

CREATE TABLE persons (
    id SERIAL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    email VARCHAR(255),
    PRIMARY KEY (id)
)

-- sample csv file = persons.csv

/*
    Import a CSV file into a table using COPY statement ------------------------------
    To import this CSV file into the persons table, you use COPY statement as follows:

    - First, you specify the table with column names after the COPY keyword. The order of the columns must be the same
    as the ones in the CSV file.
    - Second, you put the CSV file path after the FROM keyword. Because CSV file format is used, you need to specify
    DELIMITER as well as CSV clauses.
    - Third, specify the HEADER keyword to indicate that the CSV file contains a header. When the COPY command imports
    data, it ignores the header of the file.

    Notice that the file must be read directly by the PostgreSQL server, not by the client application. Therefore, it
    must be accessible by the PostgreSQL server machine. Also, you need to have superuser access in order to execute
    the COPY statement successfully.

*/

COPY persons(first_name, last_name, dob, email)
FROM '/home/davidcv/Documents/sql/PostgreSQL-Learning/sql/11-import-and-export-data/persons.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM persons;