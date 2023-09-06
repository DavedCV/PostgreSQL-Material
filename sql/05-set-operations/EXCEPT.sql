/*
    Author: David Castrillón
    Date: 2023
*/

-- EXCEPT

/*
    - Like the UNION and INTERSECT operators, the EXCEPT operator returns rows by comparing the
        result sets of two or more queries.
    - The EXCEPT operator returns distinct rows from the first (left) query that are not in the
        output of the second (right) query.
    - The queries that involve in the EXCEPT need to follow these rules:
        - The number of columns and their orders must be the same in the two queries.
        - The data types of the respective columns must be compatible.
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

-- EXCEPT
-- get top rated films that are not popular
SELECT * FROM top_rated_films
EXCEPT
SELECT * FROM most_popular_films;

SELECT * FROM top_rated_films
EXCEPT
SELECT * FROM most_popular_films
ORDER BY title;

--cleanup
DROP TABLE most_popular_films;
DROP TABLE top_rated_films;