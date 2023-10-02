/*
    Author: David Castrillón
    Date: 2023
*/

-- UNION

/*
    - The UNION operator combines result sets of two or more SELECT statements into a single result set.
    - To combine the result sets of two queries using the UNION operator, the queries must conform to the following rules:
        - The number and the order of the columns in the select list of both queries must be the same.
        - The data types must be compatible.
    - The UNION operator removes all duplicate rows from the combined data set. To retain the duplicate rows, you use
        the the UNION ALL instead.
    - To sort rows in the final result set, you use the ORDER BY clause in the second query.
*/

-- sample tables with similar columns

CREATE TABLE top_rated_films(
    title VARCHAR NOT NULL,
    release_year SMALLINT
);
INSERT INTO
    top_rated_films(title,release_year)
VALUES
    ('The Shawshank Redemption',1994),
    ('The Godfather',1972),
    ('12 Angry Men',1957);
SELECT * FROM top_rated_films;

CREATE TABLE most_popular_films(
    title VARCHAR NOT NULL,
    release_year SMALLINT
);
INSERT INTO
    most_popular_films(title,release_year)
VALUES
    ('An American Pickle',2020),
    ('The Godfather',1972),
    ('Greyhound',2020);
SELECT * FROM most_popular_films;

-- UNION
SELECT * FROM top_rated_films
UNION
SELECT * FROM most_popular_films;

-- UNION ALL
SELECT * FROM top_rated_films
UNION ALL
SELECT * FROM most_popular_films;

-- UNION ALL with ORDER BY

SELECT * FROM top_rated_films
UNION ALL
SELECT * FROM most_popular_films
ORDER BY title;

--cleanup
DROP TABLE most_popular_films;
DROP TABLE top_rated_films;