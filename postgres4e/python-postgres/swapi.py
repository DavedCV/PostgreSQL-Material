# Pulls data from the swapi.py4e.com API and puts it into swapi table

import psycopg2
import hidden
import time
import myutils
import requests
import json


def summary(cur):
    total = myutils.queryValue(cur, "SELECT COUNT(*) FROM swapi;")
    todo = myutils.queryValue(
        cur, "SELECT COUNT(*) FROM swapi WHERE status IS NULL;")
    good = myutils.queryValue(
        cur, "SELECT COUNT(*) FROM swapi WHERE status = 200;")
    error = myutils.queryValue(
        cur, "SELECT COUNT(*) FROM swapi WHERE status != 200;")
    print(f"Total={total}, Todo={todo}, Good={good}, Error={error}")


secrets = hidden.secrets()

conn = psycopg2.connect(host=secrets["host"],
                        port=secrets["port"],
                        database=secrets["database"],
                        user=secrets["user"],
                        password=secrets["pass"],
                        connect_timeout=3)

cur = conn.cursor()

defaulturl = 'https://swapi.py4e.com/api/films/1/'

sql = '''
    CREATE TABLE IF NOT EXISTS swapi
    (id serial, 
    url VARCHAR(2048) UNIQUE, 
    status INTEGER, 
    body JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), 
    updated_at TIMESTAMPTZ);
    '''
print(sql)
cur.execute(sql)

# Check to see if we have urls in the table, if not add starting points
# for each of the object trees
sql = "SELECT COUNT(url) FROM swapi;"
count = myutils.queryValue(cur, sql)
if count < 1:
    objects = ["films", "species", "people"]
    for object in objects:
        sql = f"INSERT INTO swapi (url) VALUES ('https://swapi.py4e.com/api/{object}/1/')"
        print(sql)
        cur.execute(sql)
    conn.commit()

many = 0
count = 0
chars = 0
fail = 0
summary(cur)
while True:
    if (many < 1):
        conn.commit()
        sval = input("How many documents:")
        if len(sval) < 1:
            break
        many = int(sval)

    sql = "SELECT url FROM swapi WHERE status IS NULL LIMIT 1"
    url = myutils.queryValue(cur, sql)
    if not url:
        print('There are no unretrieved documents')
        break

    text = None
    try:
        #print("=== url is", url)
        response = requests.get(url)
        text = response.text
        #print("=== text is", text)
        status = response.status_code
        sql = "UPDATE swapi SET status=%s, body=%s, updated_at=NOW() WHERE url=%s"
        cur.execute(sql, (status, text, url))
        count += 1
        chars += len(text)
    except KeyboardInterrupt:
        print("\nProgram interrumped by user...")
        break
    except Exception as e:
        print("Unnable to retrieve or parse the page:", url)
        print("Error", e)
        fail += 1
        if fail > 5:
            break
        continue

    todo = myutils.queryValue(
        cur, "SELECT COUNT(*) FROM swapi WHERE status IS NULL")
    print(status, len(text), url, todo)

    js = json.loads(text)

    # Look through all of the "linked data" for other urls to retrieve
    links = ['films', 'species', 'vehicles', 'starships', 'characters']
    for link in links:
        stuff = js.get(link)
        if not isinstance(stuff, list):
            continue
        for item in stuff:
            sql = f"INSERT INTO swapi (url) VALUES ('{item}') ON CONFLICT (url) DO NOTHING;"
            cur.execute(sql)

    many -= 1
    if count % 25 == 0:
        conn.commit()
        print(count, "loaded...")
        time.sleep(1)

print(f"\nLoaded {count} documents, {chars} characters")

summary(cur)

print("Closing database connection...")
conn.commit()
cur.close()
conn.close()