PR रिव्यू डेमो (इंजन B)
========================

PR रिव्यूअर को B इंजन मानें। A PR खोलता है; वर्कफ़्लो `.github/workflows/pr-review-demo.yml` ऑटो‑कमेंट करता है। उदाहरण स्टेप को अपने असली टेस्ट/Lint या AI CLI से बदलें।

ट्राई करें
```bash
git checkout -b demo/pr
echo "demo" > PR_DEMO.txt
git add PR_DEMO.txt && git commit -m "demo: open PR"
git push -u origin demo/pr
# main पर PR खोलें; वर्कफ़्लो कमेंट करेगा
```

टिप्स
- `duet/a` के साथ मिलाएँ: A PR खोले और यह वर्कफ़्लो B की तरह काम करे
- रिव्यू रिपोर्ट को artifact के रूप में अपलोड कर कमेंट में लिंक जोड़ें

