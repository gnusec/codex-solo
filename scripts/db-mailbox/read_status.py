#!/usr/bin/env python3
import sqlite3, sys, os
db = os.environ.get('MAILBOX_DB', 'mailbox.db')
conn = sqlite3.connect(db)
c = conn.cursor()
c.execute('create table if not exists status (k text primary key, v text)')
key = sys.argv[1]
c.execute('select v from status where k=?', (key,))
row = c.fetchone()
print(row[0] if row else '')

