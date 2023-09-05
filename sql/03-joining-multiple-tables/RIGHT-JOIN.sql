/*
    Author: David Castrillón
    Date: 2023
*/

-- RIGHT JOIN
/*
    - The RIGHT JOIN clause starts selecting data from the right table. For each row from the right
        table, it checks if the value in the selected column equals the value in the selected column
        of every row from the left table. If they are equal, the RIGHT JOIN creates a new row that contains columns
        from both tables specified in the SELECT clause and includes this new row in the result set. Otherwise, the
        RIGHT JOIN still creates a new row that contains columns from both tables and includes this new row in the
        result set. However, it fills the columns from the left table (films) with NULL.
*/

-- create sample tables
CREATE TABLE films(
    film_id SERIAL PRIMARY KEY,
    title varchar(255) NOT NULL
);
INSERT INTO films(title)
VALUES('Joker'),
      ('Avengers: Endgame'),
      ('Parasite');
SELECT * FROM films;

CREATE TABLE film_reviews(
    review_id SERIAL PRIMARY KEY,
    film_id INT,
    review VARCHAR(255) NOT NULL
);
INSERT INTO film_reviews(film_id, review)
VALUES(1, 'Excellent'),
      (1, 'Awesome'),
      (2, 'Cool'),
      (NULL, 'Beautiful');
SELECT * FROM film_reviews;

-- RIGHT JOIN
SELECT
    title,
    review
FROM
    films
RIGHT JOIN film_reviews
    ON film_reviews.film_id = films.film_id;

-- RIGHT JOIN with USING syntax
SELECT
    title, review
FROM
    films
RIGHT JOIN film_reviews USING (film_id);

-- RIGHT JOIN, excluding intersection
SELECT
    title,
    review
FROM
    films
RIGHT JOIN film_reviews USING (film_id)
WHERE title ISNULL;

DROP TABLE film_reviews;
DROP TABLE films;