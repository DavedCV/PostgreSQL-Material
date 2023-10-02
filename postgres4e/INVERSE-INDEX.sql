-- INVERTED INDEXES

/*
    useful functions:
    -- string_to_array(): split long text based on delimiter
    -- unnest(): turn array to separate rows
*/

-- string_to_array()
SELECT string_to_array('Hello World', ' ');
SELECT string_to_array('Hello World', 'l');

-- unnest()
SELECT unnest(string_to_array('Hello World', ' '));
SELECT unnest(string_to_array('Hello World', 'l'));

-- INVERTED STRING INDEX MANUAL CREATION -------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- create necessary tables
CREATE TABLE docs (
    id SERIAL PRIMARY KEY ,
    doc TEXT
);

INSERT INTO docs (doc)
VALUES
    ('This is SQL and Python and other fun teaching stuff'),
    ('More people should learn SQL from UMSI'),
    ('UMSI also teaches Python and also SQL');

SELECT * FROM docs;

CREATE TABLE docs_gin (
    keyword TEXT,
    doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);

-- get all the words of every doc
SELECT
    DISTINCT unnest(string_to_array(doc, ' ')),
    id
FROM docs
ORDER BY id;

-- use query to populate docs_gin table
INSERT INTO
    docs_gin (keyword, doc_id)
SELECT
    DISTINCT unnest(string_to_array(doc, ' ')),
    id
FROM docs;

-- SEE THE DATA
SELECT
    *
FROM
    docs_gin
ORDER BY doc_id, keyword;

-- use inverse index

-- Find all the distinct documents that match a keyword
SELECT
    DISTINCT keyword, doc_id
FROM
    docs_gin AS G
WHERE
    G.keyword = 'UMSI';

-- Find all the distinct documents that match a keyword
SELECT DISTINCT
    id, doc
FROM
    docs AS D
JOIN docs_gin AS G
    ON D.id = G.doc_id
WHERE
    G.keyword = 'UMSI';

-- Find all the documents that have the keyword 'fun' and 'people'
SELECT
    DISTINCT doc
FROM
    docs AS D
JOIN docs_gin AS G
    ON D.id = G.doc_id
WHERE
    G.keyword IN ('fun', 'people');

-- We can handle a phrase
SELECT
    DISTINCT doc
FROM docs AS D
JOIN docs_gin AS G
    ON D.id = G.doc_id
WHERE
    G.keyword = ANY(string_to_array('I want to learn', ' '));

-- This can go sideways - (foreshadowing stop words)
SELECT
    DISTINCT id, doc
FROM docs AS D
JOIN docs_gin AS G
    ON D.id = G.doc_id
WHERE
    G.keyword = ANY(string_to_array('Search for Lemons and Neons', ' '));

-- docs_gin is purely a text (not language) based Inverted Index
-- PostgreSQL already knows how to do this using the GIN index

/*
--- INVERTED INDEXES WITH STEMMING AND STOP WORDS ----------------------------------------------------------------------

    If we know the documents contain natural language, we can optimize indexes:
    1 - Ignore the case of words in the index and in the query
    2 - Don't index low-meaning "stop words" that we will ignore if they are in a search query
*/

-- get all the words of every doc and put the words in lower case
SELECT
    DISTINCT unnest(string_to_array(lower(doc), ' ')),
             id
FROM docs
ORDER BY id;

-- create new inverted index table
CREATE TABLE docs_gin2 (
    keyword TEXT,
    doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);

-- create table to save stop words
CREATE TABLE stop_words (
    word TEXT UNIQUE
);


INSERT INTO
    stop_words (word)
VALUES
    ('is'),
    ('this'),
    ('and');

-- filter words that are not into stop words
SELECT
    DISTINCT keyword,
    id
FROM docs, unnest(string_to_array(lower(doc), ' ')) as keyword
WHERE keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

-- insert into new inverse index
INSERT INTO
    docs_gin2 (keyword, doc_id)
SELECT
    DISTINCT keyword,
    id
FROM docs, unnest(string_to_array(lower(doc), ' ')) as keyword
WHERE keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

SELECT * FROM docs_gin2;

-- query that inverted index
SELECT
    DISTINCT doc
FROM
    docs
JOIN docs_gin2 d
    ON docs.id = d.doc_id
WHERE d.keyword = lower('UMSI');

-- A stop word query - as if it were never there
SELECT
    DISTINCT doc
FROM
    docs
JOIN docs_gin2 AS d
    ON d.doc_id = docs.id
WHERE d.keyword = lower('and');

-- Add stemming
-- (3) Only store the "stems" of words
-- Our simple approach is to make a "dictionary" of word -> stem

CREATE TABLE docs_stem (
    word TEXT,
    stem TEXT
);

INSERT INTO
    docs_stem (word, stem)
VALUES
    ('teaching', 'teach'),
    ('teaches', 'teach');

SELECT * FROM docs_stem;

SELECT
    DISTINCT docs.id,
    keyword,
    stem
FROM
    docs,
    unnest(string_to_array(lower(doc), ' ')) keyword
LEFT JOIN docs_stem
ON keyword = docs_stem.word
ORDER BY id, keyword;

-- if the stem is there, use it
SELECT
    id,
    CASE WHEN stem IS NOT NULL THEN stem ELSE keyword END AS merged,
    keyword,
    stem
FROM
    docs,
    unnest(string_to_array(lower(doc), ' ')) as keyword
LEFT JOIN docs_stem
ON keyword = docs_stem.word;

-- use NULL COALESCING to return the first non-null in a list
SELECT
    id,
    COALESCE(stem, keyword)
FROM
    docs,
    unnest(string_to_array(lower(doc), ' ')) keyword
LEFT JOIN docs_stem
ON keyword = docs_stem.word;

-- now create the query to select only stem words without stop words
SELECT
    id,
    COALESCE(stem, keyword) keyword
FROM
    docs,
    unnest(string_to_array(lower(doc), ' ')) keyword
LEFT JOIN docs_stem
    ON keyword = docs_stem.word
WHERE
    keyword NOT IN (SELECT word FROM stop_words);

-- update inverted index
DELETE FROM docs_gin2;

INSERT INTO
    docs_gin2 (doc_id, keyword)
SELECT
    id,
    COALESCE(stem, keyword) keyword
FROM
    docs,
    unnest(string_to_array(lower(doc), ' ')) keyword
LEFT JOIN docs_stem
    ON keyword = docs_stem.word
WHERE
    keyword NOT IN (SELECT word FROM stop_words);

SELECT * FROM docs_gin2;

-- handling the stems in queries. use keyword if there is not stem
SELECT
    DISTINCT doc,
    id
FROM
    docs
JOIN docs_gin2
    ON docs.id = docs_gin2.doc_id
WHERE
    docs_gin2.keyword = COALESCE((SELECT stem FROM docs_stem WHERE word = LOWER('SQL')), LOWER('SQL'));

SELECT
    DISTINCT id,
    doc
FROM
    docs
JOIN docs_gin2
    ON docs.id = docs_gin2.doc_id
WHERE
    docs_gin2.keyword = COALESCE((SELECT stem FROM docs_stem WHERE word = LOWER('teaching')), LOWER('teaching'));

-- INVERTED INDEXES WITH POSTGRES NATIVES ------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

CREATE TABLE docsNative (
    id SERIAL,
    doc TEXT,
    PRIMARY KEY(id)
);

-- The GIN (General Inverted Index) thinks about columns that contain arrays
-- A GIN needs to know what kind of data will be in the arrays
-- array_ops means that it is expecting text[] (arrays of strings)
-- and WHERE clauses will use array operators (i.e. like <@ )

-- create gin index
CREATE INDEX gin1 ON docsNative USING gin(string_to_array(doc, ' ')  array_ops);

INSERT INTO docsNative (doc) VALUES
    ('This is SQL and Python and other fun teaching stuff'),
    ('More people should learn SQL from UMSI'),
    ('UMSI also teaches Python and also SQL');

-- Insert enough lines to get PostgreSQL attention
INSERT INTO docsNative (doc) SELECT 'Neon ' || generate_series(10000,20000);

-- query using gin
SELECT
    id,
    doc
FROM
    docsNative
WHERE
    '{SQL}' <@ string_to_array(doc, ' ');

-- The <@ if "is contained within" or "intersection" from set theory
SELECT
    id,
    doc
FROM
    docsNative
WHERE '{learn}' <@ string_to_array(doc, ' ');

EXPLAIN SELECT id, doc FROM docsNative WHERE '{learn}' <@ string_to_array(doc, ' ');

-- text search functions -----------------------------------------------------------------------------------------------
-- PostgreSQL provides some functions that turn a text document/string into an "array" with stemming, stop words,
-- and other language-oriented features.

-- ts_vector is an special "array" of stemmed words, passed through a stop-word
-- filter + positions within the document
SELECT to_tsvector('english', 'This is SQL and Python and other fun teaching stuff');
SELECT to_tsvector('english', 'More people should learn SQL from UMSI');
SELECT to_tsvector('english', 'UMSI also teaches Python and also SQL');

-- ts_query is an "array" of lower case, stemmed words with
-- stop words removed plus logical operators & = and, ! = not, | = or
SELECT to_tsquery('english', 'teaching');
SELECT to_tsquery('english', 'teaches');
SELECT to_tsquery('english', 'and');
SELECT to_tsquery('english', 'SQL');
SELECT to_tsquery('english', 'Teach | teaches | teaching | and | the | if');

-- Plaintext just pulls out the keywords
SELECT plainto_tsquery('english', 'SQL Python');
SELECT plainto_tsquery('english', 'Teach teaches teaching and the if');

-- A phrase is words that come in order
SELECT phraseto_tsquery('english', 'SQL Python');

-- Websearch is in PostgreSQL >= 11 and a bit like
-- https://www.google.com/advanced_search
SELECT websearch_to_tsquery('english', 'SQL -not Python');

-- In a WHERE clause we use the @@ operator to ask is a ts_query matches a ts_vector.

SELECT to_tsquery('english', 'teaching') @@
       to_tsvector('english', 'UMSI also teaches Python and also SQL');

-- Making a Natural Language Inverted Index with PostgreSQL ------------------------------------------------------------

CREATE TABLE docsNatural (
    id SERIAL,
    doc TEXT,
    PRIMARY KEY(id)
);

-- create index using ts vector
CREATE INDEX gin2 ON docsNatural USING gin(to_tsvector('english', doc));

INSERT INTO docsNatural (doc) VALUES
    ('This is SQL and Python and other fun teaching stuff'),
    ('More people should learn SQL from UMSI'),
    ('UMSI also teaches Python and also SQL');

-- Filler rows
INSERT INTO docsNatural (doc) SELECT 'Neon ' || generate_series(10000,20000);

SELECT
    id,
    doc
FROM
    docsNatural
WHERE
    to_tsquery('english', 'learn') @@ to_tsvector('english', doc);

EXPLAIN SELECT id, doc FROM docsNatural WHERE
        to_tsquery('english', 'learn') @@ to_tsvector('english', doc);
