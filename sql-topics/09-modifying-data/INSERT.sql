/*
    Author: David Castrillón
    Date: 2023
*/

-- INSERT

/*
    - The PostgreSQL INSERT statement allows you to insert a new row into a table.
    - The INSERT statement also has an optional RETURNING clause that returns the information of the inserted row.
        If you want to return the entire inserted row, you use an asterisk (*) after the RETURNING keyword.
*/

-- sample table creation

CREATE TABLE links (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    last_update DATE
);

-- INSERT
INSERT INTO links (url, name)
VALUES('https://www.coursera.org','Coursera');

-- have to scape the ' from name, with another preceding '
INSERT INTO links (url, name)
VALUES('http://www.oreilly.com','O''Reilly Media');

SELECT	* FROM links;

-- using returning keyword
INSERT INTO links (url, name)
VALUES('http://www.postgresql.org','PostgreSQL')
RETURNING *;

-- INSERT multiple values
INSERT INTO
    links (url, name)
VALUES
    ('https://www.google.com','Google'),
    ('https://www.yahoo.com','Yahoo'),
    ('https://www.bing.com','Bing');

INSERT INTO
    links(url,name, description)
VALUES
    ('https://duckduckgo.com/','DuckDuckGo','Privacy & Simplified Search Engine'),
    ('https://swisscows.com/','Swisscows','Privacy safe WEB-search')
RETURNING *;

-- cleanup
DROP TABLE links;