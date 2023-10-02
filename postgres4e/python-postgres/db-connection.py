import psycopg2
import hidden

secrets = hidden.secrets()

conn = psycopg2.connect(
  host = secrets["host"],
  database = secrets["database"],
  user = secrets["user"],
  password = secrets["pass"],
  connect_timeout = 3
)

cur = conn.cursor()

sql = 'DROP TABLE IF EXISTS pythonfun CASCADE;'
print(sql)
cur.execute(sql)

sql = 'CREATE TABLE pythonfun (id SERIAL, line TEXT);'
print(sql)
cur.execute(sql)

conn.commit()    # Flush it all to the DB server

for i in range(10) : 
    txt = f"'Have a nice day {str(i)}'"
    sql = f'INSERT INTO pythonfun (line) VALUES ({txt});'
    cur.execute(sql)

conn.commit()

sql = "SELECT id, line FROM pythonfun WHERE id=5;" 
print(sql)
cur.execute(sql)

row = cur.fetchone()
if row is None : 
    print('Row not found')
else:
    print('Found:', row)

sql = f'INSERT INTO pythonfun (line) VALUES ({txt}) RETURNING id;'
cur.execute(sql)
id = cur.fetchone()[0]
print('New id:', id)

conn.commit()
cur.close()
conn.close()