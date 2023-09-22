/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- INTEGER TYPES

    To store the whole numbers in PostgreSQL, you use one of the following integer types: SMALLINT, INTEGER, and BIGINT.

    - The SMALLINT requires 2 bytes storage size which can store any integer numbers that is in
        the range of (-32,767, 32,767).
    - The INTEGER type requires 4 bytes storage size that can store numbers in the range of (-2,147,483,648, 2,147,483,647).
    - The BIGINT type requires 8 bytes storage size that can store any number in the range of
        (-9,223,372,036,854,775,808,+9,223,372,036,854,775,807).
*/

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR (255) NOT NULL,
    pages SMALLINT NOT NULL CHECK (pages > 0)
);

CREATE TABLE cities (
    city_id serial PRIMARY KEY,
    city_name VARCHAR (255) NOT NULL,
    population INT NOT NULL CHECK (population >= 0)
);

-- CLEANUP
DROP TABLE books;
DROP TABLE cities;