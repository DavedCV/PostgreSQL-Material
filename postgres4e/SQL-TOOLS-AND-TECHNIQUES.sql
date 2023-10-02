-- SQL TOOLS AND TECHNIQUES --------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- SAMPLE TABLES CREATION

DROP TABLE comment;
DROP TABLE fav;
DROP TABLE post;
DROP TABLE account;

CREATE TABLE account (
    id SERIAL,
    email VARCHAR(128) UNIQUE,
    created_at DATE NOT NULL DEFAULT NOW(),
    updated_at DATE NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE post (
    id SERIAL,
    title VARCHAR(128) UNIQUE NOT NULL,
    content VARCHAR(1024), -- Will extend with ALTER
    account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE comment (
    id SERIAL,
    content TEXT NOT NULL,
    account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
    post_id INTEGER REFERENCES post(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE fav (
    id SERIAL,
    oops TEXT,  -- Will remove later with ALTER
    post_id INTEGER REFERENCES post(id) ON DELETE CASCADE,
    account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(post_id, account_id),
    PRIMARY KEY(id)
);

-- INSERT DATA INTO SAMPLE TABLES

ALTER SEQUENCE account_id_seq RESTART WITH 1;
ALTER SEQUENCE post_id_seq RESTART WITH 1;
ALTER SEQUENCE comment_id_seq RESTART WITH 1;
ALTER SEQUENCE fav_id_seq RESTART WITH 1;

INSERT INTO
    account(email)
VALUES
    ('ed@umich.edu'),
    ('sue@umich.edu'),
    ('sally@umich.edu');
SELECT * FROM account;

INSERT INTO post
(title, content, account_id)
VALUES
    ( 'Dictionaries', 'Are fun', 3),  -- sally@umich.edu
    ( 'BeautifulSoup', 'Has a complex API', 1), -- ed@mich.edu
    ( 'Many to Many', 'Is elegant', (SELECT id FROM account WHERE email='sue@umich.edu'));
SELECT * FROM post;

INSERT INTO comment (content, post_id, account_id) VALUES
    ( 'I agree', 1, 1), -- dict / ed
    ( 'Especially for counting', 1, 2), -- dict / sue
    ( 'And I don''t understand why', 1, 2), -- dict / sue
    ( 'Someone should make "EasySoup" or something like that',
      (SELECT id FROM post WHERE title='BeautifulSoup'),
      (SELECT id FROM account WHERE email='ed@umich.edu' )),
    ( 'Good idea - I might just do that',
      (SELECT id FROM post WHERE title='BeautifulSoup'),
      (SELECT id FROM account WHERE email='sally@umich.edu' ));
SELECT * FROM comment;

-- ALTER TABLE ---------------------------------------------------------------------------------------------------------

ALTER TABLE post ALTER COLUMN content TYPE TEXT;

ALTER TABLE fav DROP COLUMN oops;

ALTER TABLE fav ADD COLUMN howmuch INTEGER;

-- DATES ---------------------------------------------------------------------------------------------------------------

-- get TIMESTAMP of now
SELECT NOW();

-- get timestamp and show in specific timezone
SELECT NOW() AT TIME ZONE 'utc';
SELECT NOW() AT TIME ZONE 'HST';

-- get diff timezone names
SELECT * FROM pg_timezone_names;
SELECT * FROM pg_timezone_names WHERE name LIKE '%Hawaii%';

-- do some casting to the dates
SELECT NOW()::DATE;
SELECT NOW()::TIME;

-- do some operations with intervals
SELECT NOW() - INTERVAL '2 days';
SELECT CAST (NOW() - INTERVAL '2 days' AS DATE);
SELECT (NOW() - INTERVAL '2 days')::DATE;

-- trunc date data
SELECT DATE_TRUNC('day', NOW());

-- From string to timestamp
SELECT '2012-01-01 04:23:55'::TIMESTAMP;
SELECT CAST('2012-01-01 04:23:55' AS TIMESTAMP);

-- get part of dates
SELECT NOW() - '2012-01-01'::TIMESTAMP;
SELECT DATE_PART('days', NOW() - '2012-01-01'::TIMESTAMP);

SELECT DATE_PART('years',NOW());
SELECT DATE_PART('years',NOW()) - DATE_PART('years', '2012-01-01'::DATE);

-- Inefficient - full table scan due to the casting
SELECT
    id, content, created_at
FROM
    comment
WHERE
    created_at::DATE = NOW()::DATE;

-- A range query evaluated inside the database, efficient because we are avoiding casting
SELECT
    id, content, created_at
FROM
    comment
WHERE
    created_at >= DATE_TRUNC('day',NOW())
    AND created_at < DATE_TRUNC('day',NOW() + INTERVAL '1 day');

-- DISTINCT AND DISTINCT ON --------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS racing;

CREATE TABLE racing (
    make VARCHAR,
    model VARCHAR,
    year INTEGER,
    price INTEGER
);

INSERT INTO racing (make, model, year, price)
VALUES
    ('Nissan', 'Stanza', 1990, 2000),
    ('Dodge', 'Neon', 1995, 800),
    ('Dodge', 'Neon', 1998, 2500),
    ('Dodge', 'Neon', 1999, 3000),
    ('Ford', 'Mustang', 2001, 1000),
    ('Ford', 'Mustang', 2005, 2000),
    ('Subaru', 'Impreza', 1997, 1000),
    ('Mazda', 'Miata', 2001, 5000),
    ('Mazda', 'Miata', 2001, 3000),
    ('Mazda', 'Miata', 2001, 2500),
    ('Mazda', 'Miata', 2002, 5500),
    ('Opel', 'GT', 1972, 1500),
    ('Opel', 'GT', 1969, 7500),
    ('Opel', 'Cadet', 1973, 500);

SELECT * FROM racing ORDER BY model;

-- DISTINCT make values
SELECT DISTINCT make FROM racing;

-- DISTINCT models
SELECT DISTINCT model FROM racing;

-- DITINCT ON select the first of every distinct row by model
SELECT DISTINCT ON (model) make,model,year FROM racing;

-- in order to have deterministic output, must use order by
SELECT DISTINCT ON (model) * FROM racing ORDER BY model;
SELECT DISTINCT ON (model) * FROM racing ORDER BY model DESC;
SELECT DISTINCT ON (model) * FROM racing ORDER BY model DESC LIMIT 2;

-- GROUP BY ------------------------------------------------------------------------------------------------------------

SELECT * FROM pg_timezone_names LIMIT 20;
SELECT COUNT(*) FROM pg_timezone_names;
SELECT DISTINCT is_dst FROM pg_timezone_names;

-- grouping by is_dst values and aggregating results
SELECT COUNT(is_dst), is_dst FROM pg_timezone_names GROUP BY is_dst;

-- grouping by abbrev values and aggregating results
SELECT COUNT(abbrev), abbrev FROM pg_timezone_names GROUP BY abbrev;

-- WHERE is before GROUP BY, HAVING is after GROUP BY
SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names WHERE is_dst= 't' GROUP BY abbrev HAVING COUNT(abbrev) > 10;
SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names GROUP BY abbrev HAVING COUNT(abbrev) > 10;
SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names GROUP BY abbrev HAVING COUNT(abbrev) > 10 ORDER BY COUNT(abbrev) DESC;

-- SUBQUERY ------------------------------------------------------------------------------------------------------------

SELECT
    *
FROM
    account
WHERE
    email='ed@umich.edu';

SELECT
    content
FROM
    comment
WHERE
    account_id = 1;

-- same as above but with subquery
SELECT
    content
FROM
    comment
WHERE
    account_id = (SELECT id FROM account WHERE email='ed@umich.edu');

-- If you did not have the HAVING clause for GROUP_BY
SELECT
    ct, abbrev
FROM (
    SELECT
        COUNT(abbrev) AS ct,
        abbrev
    FROM
        pg_timezone_names
    WHERE
        is_dst = 'f'
    GROUP BY abbrev
) AS
    zap
WHERE
    ct > 10;

-- UPSERT --------------------------------------------------------------------------------------------------------------

-- Do this twice
INSERT INTO
    fav (post_id, account_id, howmuch)
VALUES
    (1,1,1)
RETURNING *;

UPDATE
    fav
SET howmuch=howmuch+1
WHERE
    post_id = 1
    AND account_id = 1
RETURNING *;

-- using upsert to minimize interaction
INSERT INTO
    fav (post_id, account_id, howmuch)
VALUES
    (1,1,1)
ON CONFLICT (post_id, account_id)
DO UPDATE SET howmuch = fav.howmuch + 1
RETURNING *;

