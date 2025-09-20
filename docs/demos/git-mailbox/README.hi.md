Git मेलबॉक्स Duet (A/B)
=======================

दो ब्रांच को “मेलबॉक्स” की तरह इस्तेमाल करें: A `duet/a` पर स्थिति पुश करता है; वर्कफ़्लो (या B इंजन) `duet/b` पर रिव्यू और फ़िनिश सिग्नल लिखता है।

शुरू करें (A तरफ)
```bash
git checkout -b duet/a
mkdir -p mailbox
echo "initial plan" > mailbox/a_to_b.txt
git add mailbox/a_to_b.txt
git commit -m "duet: A → B initial message"
git push -u origin duet/a
```

क्या होता है
- वर्कफ़्लो `.github/workflows/duet-git-mailbox.yml` `duet/a` पर push होने पर ट्रिगर होता है
- यह `duet/b` में लिखता है:
  - `mailbox/b_to_a.txt`: रिव्यू नोट
  - `mailbox/done_by_b.flag`: सफलता संकेत

नोट्स
- यदि वास्तविक B इंजन चाहिए तो इस वर्कफ़्लो को अपने टेस्ट/Lint/AI CLI से बदलें
- फ़ाइल‑मेलबॉक्स (बिना Git) के लिए `samples/collab/file-mailbox` देखें

