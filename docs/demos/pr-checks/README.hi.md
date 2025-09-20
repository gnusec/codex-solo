PR Checks डेमो (स्टेटस + आर्टिफैक्ट)
=====================================

B इंजन को PR चेकर मानें: PR खुलते ही `.github/workflows/pr-checks-demo.yml` चलता है, एक रिपोर्ट artifact अपलोड करता है और हरा Check सेट करता है।

ट्राई करें
```bash
git checkout -b demo/pr-checks
echo "demo" > PR_CHECKS_DEMO.txt
git add PR_CHECKS_DEMO.txt && git commit -m "demo: pr checks"
git push -u origin demo/pr-checks
# main पर PR खोलें; Check और artifact देखें
```

रियल चेक्स से बदलें
- उदाहरण स्टेप की जगह अपने टेस्ट/Lint या AI रिव्यूअर CLI चलाएँ
- `actions/github-script` से रिच समरी/annotation जोड़े जा सकते हैं

