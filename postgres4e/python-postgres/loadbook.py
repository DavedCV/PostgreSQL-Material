"""
The program makes a document database, reads through the book text, breaking 
it into "paragraphs" and inserting each paragraph into a row of the database. 
The table is automatically created by the code and named the same as the book 
file so you can have more than one book in your database at one time.
"""


import psycopg2
import hidden
import time

bookfile = input("Enter book file (i.e pg19337.txt): ")
bookfile = bookfile or "pg19337.txt"
base = bookfile.split(".")[0]

# Make sure we can open the file
fhand = open(bookfile)

# load the secrets
secrets = hidden.secrets()

# start db connection
conn = psycopg2.connect(host=secrets['host'], port=secrets['port'],
                        database=secrets['database'],
                        user=secrets['user'],
                        password=secrets['pass'],
                        connect_timeout=3)

cur = conn.cursor()

# create table
sql = 'DROP TABLE IF EXISTS ' + base + ' CASCADE;'
print(sql)
cur.execute(sql)

sql = 'CREATE TABLE ' + base + ' (id SERIAL, body TEXT);'
print(sql)
cur.execute(sql)

# read the book file and populate the database with the paragraphs
para = ''
chars = 0
count = 0
pcount = 0
for line in fhand:
    count = count + 1
    line = line.strip()
    chars = chars + len(line)
    if line == '' and para == '':
        continue
    if line == '':
        sql = f'INSERT INTO {base} (body) VALUES (%s);'
        cur.execute(sql, (para,))
        pcount = pcount + 1
        if pcount % 50 == 0:
            conn.commit()
        if pcount % 100 == 0:
            print(pcount, 'loaded...')
            time.sleep(1)
        para = ''
        continue

    para = para + ' ' + line

# close connection
conn.commit()
cur.close()
conn.close()

print(' ')
print('Loaded',pcount,'paragraphs',count,'lines',chars,'characters')

sql = "CREATE INDEX TABLE_gin ON TABLE USING gin(to_tsvector('english', body));"
sql = sql.replace('TABLE', base)
print(' ')
print('Run this manually to make your index:')
print(sql)

# SELECT body FROM pg19337  WHERE to_tsquery('english', 'goose') @@ to_tsvector('english', body) LIMIT 5;
# EXPLAIN ANALYZE SELECT body FROM pg19337  WHERE to_tsquery('english', 'goose') @@ to_tsvector('english', body);