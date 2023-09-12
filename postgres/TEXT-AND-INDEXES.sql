-- TEXT IN POSTGRESQL --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- GENERATING DATA -----------------------------------------------------------------------------------------------------

-- generate random numbers
SELECT random(), random(), trunc(random()*100);

-- generate string pattern
SELECT repeat('Neon ', 5);

-- generate a list of rows
SELECT generate_series(1,5);

-- merge pattern generation with rows generation
SELECT 'Neon' || generate_series(1,5);

-- CREATE SAMPLE TABLE AND POPULATE ------------------------------------------------------------------------------------

CREATE TABLE textfun (
    content TEXT
);

-- add index to the table (btree)
CREATE INDEX textfun_b ON textfun (content);

-- see information about table
SELECT pg_relation_size('textfun'), pg_indexes_size('textfun');

-- generate random with pattern
SELECT (
    CASE WHEN (random() < 0.5)
    THEN 'https://www.pg4e.com/neon/'
    ELSE 'https://www.pg4e.com/LEMONS/'
    END
) || generate_series(1000,1005);

-- add generated data to the table
INSERT INTO
    textfun (content)
SELECT (
    CASE WHEN (random() < 0.5)
    THEN 'https://www.pg4e.com/neon/'
    ELSE 'https://www.pg4e.com/LEMONS/'
    END
) || generate_series(100000,200000);

-- analyze index space growth
SELECT pg_relation_size('textfun'), pg_indexes_size('textfun');

-- USE TEXT FUNCTIONS IN SAMPLE TABLE ----------------------------------------------------------------------------------

-- using LIKE clause to pattern match the table
SELECT content FROM textfun WHERE content LIKE '%150000%';

-- using UPPER text function to format text output
SELECT upper(content) FROM textfun WHERE content LIKE '%150000%';

-- using LOWER text function to format text output
SELECT lower(content) FROM textfun WHERE content LIKE '%150000%';

-- using RIGHT to get the 4 rightmost characters from the text output
SELECT right(content, 4) FROM textfun WHERE content LIKE '%150000%';

-- using LEFT to get the 4 leftmost characters from the text output
SELECT left(content, 4) FROM textfun WHERE content LIKE '%150000%';

-- using STRPOS to get the index where pattern is present (1 based), if pattern is not present output is 0
SELECT strpos(content, 'ttps://') FROM textfun WHERE content LIKE '%150000%';
SELECT strpos(content, 'jajajaja') FROM textfun WHERE content LIKE '%150000%';

-- using SUBSTR to get the substring from pos 2 to 4
SELECT substr(content, 2, 4) FROM textfun WHERE content LIKE '%150000%';

-- using SPLIT_PART to split the text output based on a delimiter, and select the 4 fragment after splitting
SELECT split_part(content, '/', 1) FROM textfun WHERE content LIKE '%150000%';

-- using TRANSLATE to map every character specified with 1-1 translation
SELECT translate(content, 'th.p/', 'TH!P_') FROM textfun WHERE content LIKE '%150000%';

-- LIKE wildcards:
-- % any character, any number
-- _ any character, only 1 character
SELECT content FROM textfun WHERE content LIKE '%150000%';
SELECT content FROM textfun WHERE content LIKE '%150_00%';

-- CHARACTER SET -------------------------------------------------------------------------------------------------------

-- ASCII function gives us the character encoding number
-- CHR function five us the character associated with that character encoding number
select ascii('H'), ascii('e'), ascii('l'), chr(72), chr(42);

-- REGEX ---------------------------------------------------------------------------------------------------------------

/*
    Regular Expression Quick Guide

    ^        Matches the beginning of a line
    $        Matches the end of the line
    .        Matches any character
    \s       Matches whitespace
    \S       Matches any non-whitespace character
    *        Repeats a character zero or more times
    *?       Repeats a character zero or more times
             (non-greedy)
    +        Repeats a character one or more times
    +?       Repeats a character one or more times
             (non-greedy)
    [aeiou]  Matches a single character in the listed set
    [^XYZ]   Matches a single character not in the listed set
    [a-z0-9] The set of characters can include a range
    (        Indicates where string extraction is to start
    )        Indicates where string extraction is to end
*/

-- create sample table
CREATE TABLE em (
    id serial,
    primary key(id),
    email text
);

INSERT INTO
    em (email)
VALUES
    ('csev@umich.edu'),
    ('coleen@umich.edu'),
    ('sally@uiuc.edu'),
    ('ted79@umuc.edu'),
    ('glenn1@apple.com'),
    ('nbody@apple.com');


/*
    WHERE CLAUSE REGEX OPERATORS

    ~ MATCHES
    ~* MATCHES CASE INSENSITIVE
    !~ DOES NOT MATCH
    !~* DOES NOS MATCH CASE INSENSITIVE
*/

-- has "umich" in it
SELECT email FROM em WHERE email ~ 'umich';

-- start with "c"
SELECT email FROM em WHERE email ~ '^c';

-- ends with "edu"
SELECT email FROM em WHERE email ~ 'edu$';

-- starts with "g" or "n" or "t"
SELECT email FROM em WHERE email ~ '^[gnt]';

-- has a number in it
SELECT email FROM em WHERE email ~ '[0-9]';

-- has two numbers sequentially
SELECT email FROM em WHERE email ~ '[0-9][0-9]';

-- gets the sequential numbers from an email with numbers
SELECT substring(email FROM '[0-9]+') FROM em WHERE email ~ '[0-9]';

-- select the domain substring from email column
SELECT substring(email FROM '.+@(.*)$') FROM em;

-- select the distinct email domains
SELECT DISTINCT substring(email FROM '.+@(.*)$') FROM em;

-- select the distinct email domains and count the number of each one
SELECT substring(email FROM '.+@(.*)$') as domain,
       count(substring(email FROM '.+@(.*)$'))
FROM em GROUP BY domain;

-- select email where the domain is 'umich.edu'
SELECT * FROM em WHERE substring(email FROM '.+@(.*)$') = 'umich.edu';

-- create another sample table

CREATE TABLE tw (
    id serial,
    primary key(id),
    tweet text
);

INSERT INTO
    tw (tweet)
VALUES
    ('This is #SQL and #FUN stuff'),
    ('More people should learn #SQL FROM #UMSI');
    ('#UMSI also teaches #PYTHON');

SELECT tweet FROM tw;

SELECT id, tweet FROM tw WHERE tweet ~ '#SQL';

-- multiple matches
SELECT regexp_matches(tweet,'#([A-Za-z0-9_]+)', 'g') FROM tw;
SELECT DISTINCT regexp_matches(tweet,'#([A-Za-z0-9_]+)', 'g') FROM tw;
SELECT id, regexp_matches(tweet,'#([A-Za-z0-9_]+)', 'g') FROM tw;

-- INDEXES -------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--  using indexes with hashing functions and btree ---------------------------------------------------------------------

CREATE TABLE cr1 (
    id SERIAL,
    url TEXT,
    content TEXT
);

INSERT INTO
    cr1(url)
SELECT
    repeat('Neon', 1000) || generate_series(1,5000);

SELECT * FROM cr1;

-- create index, normal btree
CREATE unique index cr1_unique on cr1 (url);

-- see table space usage
SELECT pg_relation_size('cr1'), pg_indexes_size('cr1');

-- drop index
DROP index cr1_unique;

-- create index using md5 function
CREATE unique index cr1_md5 on cr1 (md5(url));

-- see table space usage
SELECT pg_relation_size('cr1'), pg_indexes_size('cr1');

-- see database process for a query using indexes

-- seq scan
explain analyze SELECT * FROM cr1 WHERE url='lemons';
-- index scan using md5 function
explain analyze SELECT * FROM cr1 WHERE md5(url)=md5('lemons');

-- drop index
DROP index cr1_md5;

-- create index using sha256 function
CREATE unique index cr1_sha256 on cr1 (sha256(url::bytea));

-- query using index sha256
explain analyze SELECT * FROM cr1 WHERE sha256(url::bytea)=sha256('bob'::bytea);

-- using index in table columns ----------------------------------------------------------------------------------------

CREATE TABLE cr2 (
    id SERIAL,
    url TEXT,
    url_md5 uuid unique,
    content TEXT
);

INSERT INTO cr2 (url)

SELECT repeat('Neon', 1000) || generate_series(1,5000);

SELECT pg_relation_size('cr2'), pg_indexes_size('cr2');

UPDATE cr2 SET url_md5 = md5(url)::uuid;

SELECT pg_relation_size('cr2'), pg_indexes_size('cr2');

EXPLAIN ANALYZE SELECT * FROM cr2 WHERE url_md5=md5('lemons')::uuid;

-- using indexes with hash native function of postgres ----------------------------------------------------------------

CREATE TABLE cr3 (
    id SERIAL,
    url TEXT,
    content TEXT
);

INSERT INTO cr3 (url)
SELECT repeat('Neon', 1000) || generate_series(1,5000);

CREATE index cr3_hash on cr3 using hash (url);

SELECT pg_relation_size('cr3'), pg_indexes_size('cr3');

EXPLAIN ANALYZE SELECT * FROM cr3 WHERE url='lemons';
