def queryValue(cur, sql, fields=None, error=None):
    row = queryRow(cur, sql, fields, error)
    if not row:
        return None
    else:
        return row[0]


def queryRow(cur, sql, fields=None, error=None):
    row = doQuery(cur, sql, fields)

    try:
        row = cur.fetchone()
        return row
    except Exception as e:
        if (error):
            print(error, e)
        else:
            print(e)

        return None


def doQuery(cur, sql, fields):
    row = cur.execute(sql, fields)
    return row
