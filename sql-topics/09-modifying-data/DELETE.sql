/*
    Author: David Castrillón
    Date: 2023
*/

-- DELETE

/*

    - The PostgreSQL DELETE statement allows you to delete one or more rows from a table.
    - The WHERE clause is optional. If you omit the WHERE clause, the DELETE statement will delete all rows in the table.
    - To return the deleted row(s) to the client, you use the RETURNING clause

*/

-- sample tables
CREATE TABLE links (
    id serial PRIMARY KEY,
    url varchar(255) NOT NULL,
    name varchar(255) NOT NULL,
    description varchar(255),
    rel varchar(10),
    last_update date DEFAULT now()
);
INSERT INTO
    links
VALUES
    ('1', 'https://www.postgresqltutorial.com', 'PostgreSQL Tutorial', 'Learn PostgreSQL fast and easy', 'follow', '2013-06-02'),
    ('2', 'http://www.oreilly.com', 'O''Reilly Media', 'O''Reilly Media', 'nofollow', '2013-06-02'),
    ('3', 'http://www.google.com', 'Google', 'Google', 'nofollow', '2013-06-02'),
    ('4', 'http://www.yahoo.com', 'Yahoo', 'Yahoo', 'nofollow', '2013-06-02'),
    ('5', 'http://www.bing.com', 'Bing', 'Bing', 'nofollow', '2013-06-02'),
    ('6', 'http://www.facebook.com', 'Facebook', 'Facebook', 'nofollow', '2013-06-01'),
    ('7', 'https://www.tumblr.com/', 'Tumblr', 'Tumblr', 'nofollow', '2013-06-02'),
    ('8', 'http://www.postgresql.org', 'PostgreSQL', 'PostgreSQL', 'nofollow', '2013-06-02');
SELECT * FROM links;

-- DELETE
DELETE FROM links
WHERE id = 8;

-- DELETE and RETURN
DELETE FROM links
WHERE id = 7
RETURNING *;

-- DELETE MULTIPLE ROWS
DELETE FROM links
WHERE id IN (6,5)
RETURNING *;

-- DELETE ALL ROWS
DELETE FROM links;

-- cleanup
DROP TABLE links;