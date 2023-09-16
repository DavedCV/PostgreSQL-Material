/*
    - create table and insert data from python -------------------------------------------------------------------------

    - python3 db-connection.py
*/

-- The program will do these two commands and insert some rows
DROP TABLE IF EXISTS pythonfun CASCADE;
CREATE TABLE pythonfun (id SERIAL, line TEXT);

-- To check the results, use psql and look at the pythonfun table
SELECT * FROM pythonfun;

/*
    -- create table and insert book paragraphs -------------------------------------------------------------------------

    - Get a book from Gutenberg
    - wget http://www.gutenberg.org/cache/epub/19337/pg19337.txt

    - python3 loadbook.py
    - Enter book file (i.e. pg19337.txt): pg19337.txt

    - DROP TABLE IF EXISTS pg19337 CASCADE;
    - CREATE TABLE pg19337 (id SERIAL, body TEXT);
    - 100 loaded...

    - Loaded 814 paragraphs 3853 lines 178898 characters
*/

-- We could have done this before we did all the inserts..
CREATE INDEX pg19337_gin ON pg19337 USING gin(to_tsvector('english', body));

-- It might take a little while before explain uses the GIN
SELECT id, body FROM pg19337  WHERE to_tsquery('english', 'goose') @@ to_tsvector('english', body) LIMIT 5;
EXPLAIN ANALYZE SELECT body FROM pg19337  WHERE to_tsquery('english', 'goose') @@ to_tsvector('english', body);

SELECT count(body) FROM pg19337  WHERE to_tsquery('english', 'tiny <-> tim') @@ to_tsvector('english', body);
EXPLAIN ANALYZE SELECT body FROM pg19337  WHERE to_tsquery('english', 'tiny <-> tim') @@ to_tsvector('english', body) LIMIT 5;

/*
    - Using a natural language index on an email corpus ----------------------------------------------------------------

    - http://mbox.dr-chuck.net/sakai.devel/

    - python3 gmane.py
    - Pulls data from the web and puts it into messages table
    - Load at least 300 messages (can be stopped and started)
*/

-- Making a language oriented inverted index in mail messages
CREATE INDEX messages_gin ON messages USING gin(to_tsvector('english', body));

SELECT to_tsvector('english', body) FROM messages LIMIT 1;

SELECT to_tsquery('english', 'easier');

SELECT id, to_tsquery('english', 'neon') @@ to_tsvector('english', body)
FROM messages LIMIT 10;

SELECT id, to_tsquery('english', 'easier') @@ to_tsvector('english', body)
FROM messages LIMIT 10;

--- Extract from the headers and make a new column for display purposes
ALTER TABLE messages ADD COLUMN sender TEXT;
UPDATE messages SET sender=substring(headers, '\nFrom: [^\n]*<([^>]*)');

SELECT subject, sender FROM messages
WHERE to_tsquery('english', 'monday') @@ to_tsvector('english', body) LIMIT 10;

EXPLAIN ANALYZE SELECT subject, sender FROM messages
WHERE to_tsquery('english', 'monday') @@ to_tsvector('english', body);

-- We did not make a Spanish index
EXPLAIN ANALYZE SELECT subject, sender FROM messages
WHERE to_tsquery('spanish', 'monday') @@ to_tsvector('spanish', body);

DROP INDEX messages_gin;
CREATE INDEX messages_gist ON messages USING gist(to_tsvector('english', body));
DROP INDEX messages_gist;

---
SELECT subject, sender FROM messages
WHERE to_tsquery('english', 'monday') @@ to_tsvector('english', body);

EXPLAIN ANALYZE SELECT subject, sender
FROM messages WHERE to_tsquery('english', 'monday') @@ to_tsvector('english', body);

-- https://www.postgresql.org/docs/current/functions-textsearch.html
SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', 'personal & learning') @@ to_tsvector('english', body);

SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', 'learning & personal') @@ to_tsvector('english', body);

-- Both words but in order
SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', 'personal <-> learning') @@ to_tsvector('english', body);

SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', 'learning <-> personal') @@ to_tsvector('english', body);

-- not personal present and learning present
SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', '! personal & learning') @@ to_tsvector('english', body);

-- plainto_tsquery() Is tolerant of "syntax errors" in the expression
SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', '(personal learning') @@ to_tsvector('english', body);

SELECT id, subject, sender FROM messages
WHERE plainto_tsquery('english', '(personal learning') @@ to_tsvector('english', body);

-- phraseto_tsquery() implies followed by
SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', 'I <-> think') @@ to_tsvector('english', body);

SELECT id, subject, sender FROM messages
WHERE phraseto_tsquery('english', 'I think') @@ to_tsvector('english', body);

-- websearch_to_tsquery is in PostgreSQL > 11
SELECT id, subject, sender FROM messages
WHERE to_tsquery('english', '! personal & learning') @@ to_tsvector('english', body);

SELECT id, subject, sender FROM messages
WHERE websearch_to_tsquery('english', '-personal learning') @@ to_tsvector('english', body)
LIMIT 10;

-- https://www.postgresql.org/docs/12/textsearch-controls.html#TEXTSEARCH-RANKING
SELECT id, subject, sender,
  ts_rank(to_tsvector('english', body), to_tsquery('english', 'personal & learning')) as ts_rank
FROM messages
WHERE to_tsquery('english', 'personal & learning') @@ to_tsvector('english', body)
ORDER BY ts_rank DESC;

-- A different ranking algorithm
SELECT id, subject, sender,
  ts_rank_cd(to_tsvector('english', body), to_tsquery('english', 'personal & learning')) as ts_rank
FROM messages
WHERE to_tsquery('english', 'personal & learning') @@ to_tsvector('english', body)
ORDER BY ts_rank DESC;

-- Indexing within structured data - Email messages from address (advanced)

SELECT substring(headers, '\nFrom: [^\n]*<([^>]*)') FROM messages LIMIT 10;

--- Extract from the headers and make a new column
ALTER TABLE messages ADD COLUMN sender TEXT;
UPDATE messages SET sender=substring(headers, '\nFrom: [^\n]*<([^>]*)');

CREATE INDEX messages_from ON messages (substring(headers, '\nFrom: [^\n]*<([^>]*)'));

SELECT sender,subject FROM messages WHERE substring(headers, '\nFrom: [^\n]*<([^>]*)') = 'john@caret.cam.ac.uk';

EXPLAIN ANALYZE SELECT sent_at FROM messages WHERE substring(headers, '\nFrom: [^\n]*<([^>]*)') = 'john@caret.cam.ac.uk';

SELECT subject, substring(headers, '\nLines: ([0-9]*)') AS lines FROM messages LIMIT 100;
SELECT AVG(substring(headers, '\nLines: ([0-9]*)')::integer) FROM messages;

-- A variable - actually more like a macro - escaping is tricky
\set zap 'substring(headers, \'\\nFrom: [^\\n]*<([^>]*)\')'
DROP INDEX messages_from;
EXPLAIN ANALYZE SELECT :zap FROM messages where :zap = 'john@caret.cam.ac.uk';
CREATE INDEX messages_from ON messages (:zap);
EXPLAIN ANALYZE SELECT :zap FROM messages where :zap = 'john@caret.cam.ac.uk';

-- https://www.postgresql.org/docs/current/textsearch-indexes.html