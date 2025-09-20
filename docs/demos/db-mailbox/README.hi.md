SQLite मेलबॉक्स
================

सिंगल‑फाइल SQLite DB को मेलबॉक्स (status तालिका) रूप में उपयोग करें।

स्टेटस लिखें
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py done_by_b 1
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py b_to_a "review ok"
```

स्टेटस पढ़ें
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py b_to_a
```

नोट्स
- DuckDB भी ऐसे ही इस्तेमाल किया जा सकता है
- ऑफ़लाइन/कॉनफ्लिक्ट‑फ्रेंडली सहयोग हेतु CRDT (जैसे Automerge) देखें

