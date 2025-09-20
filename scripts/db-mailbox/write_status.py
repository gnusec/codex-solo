#!/usr/bin/env python3
import sqlite3, sys, os
db = os.environ.get('MAILBOX_DB', 'mailbox.db')
conn = sqlite3.connect(db)
c = conn.cursor()
c.execute('create table if not exists status (k text primary key, v text)')
key = sys.argv[1]
val = sys.argv[2]
c.execute('insert into status(k,v) values(?,?) on conflict(k) do update set v=excluded.v', (key, val))
conn.commit()
print('OK')

