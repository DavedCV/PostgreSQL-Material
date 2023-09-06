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

-- INVERTED STRING INDEX MANUAL CREATION ------------------------------------
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
