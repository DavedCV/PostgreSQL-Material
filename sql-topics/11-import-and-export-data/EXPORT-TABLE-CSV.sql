/*
    Author: David Castrillón
    Date: 2023
*/

-- EXPORT TABLE TO CSV FILE

SELECT
    *
FROM
    persons;

/*
    Export data from a table to CSV using COPY statement

    For example, if you want to export the data of the persons table to a CSV file named persons_db.csv in
    the /home/davidcv/Documents/sql/PostgreSQL-Learning/sql/11-import-and-export-data, you can use the
    following statement.

    In some cases, you want to export data from just some columns of a table to a CSV file. To do this, you specify
    the column names together with table name after COPY keyword.

    If you don’t want to export the header, which contains the column names of the table, just remove the HEADER flag
    in the COPY statement.

    Notice that the CSV file name that you specify in the COPY command must be written directly by the server. It
    means that the CSV file must reside on the database server machine, not your local machine. The CSV file also
    needs to be writable by the user that PostgreSQL server runs as.
*/

COPY persons TO '/home/davidcv/Documents/sql/PostgreSQL-Learning/sql/11-import-and-export-data/persons_db.csv'
DELIMITER ',' CSV HEADER;

-- cleanup

DROP TABLE persons;