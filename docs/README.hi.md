भाषाएँ:
[हिन्दी](README.hi.md) · [English](README.en.md) · [简体中文](README.zh-CN.md) · [Español](README.es.md) · [العربية](README.ar.md)

# Codex का SOLO मोड — त्वरित मार्गदर्शिका

त्वरित लिंक्स
- रिलीज़: https://github.com/gnusec/codex-solo/releases
- डिस्कशंस: https://github.com/gnusec/codex-solo/discussions
- कॉन्ट्रिब्यूट: ../CONTRIBUTING.md
- रोडमैप: ROADMAP.md
- आर्किटेक्चर और डिज़ाइन: architecture/README.hi.md
- Good First Issues: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22
- Help Wanted: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22
- Show & Tell: https://github.com/gnusec/codex-solo/discussions/9

संपर्क (Contact)
- नाम: 耘峥
- ईमेल: huangdeng@safe87.com
- WeChat: gnusec

कार्यात्मक सार
- सफलता जाँच पास होने तक स्वचालित रूप से जारी रहता है
- Scriptable जाँच: कमांड/स्क्रिप्ट exit 0, सभी परीक्षण पास, फ़ाइल/आउटपुट मिलान
- Autostart, interval, exit‑on‑success, multi‑instance कॉन्फ़िग समर्थित

सार
- SOLO तब तक स्वचालित रूप से काम करता है जब तक सफलता की शर्त पूरी नहीं होती।
- TUI में `/solo` से चालू करें या `CODEX_SOLO_AUTOSTART=1` का उपयोग करें।
- कॉन्फ़िग फ़ाइल: `.codex-solo.json` (या `CODEX_SOLO_CONFIG` से रास्ता बदलें)।

कॉन्फ़िगरेशन
- `kickoff_prompt`: प्रारंभिक प्रॉम्प्ट (वैकल्पिक)।
- `continue_prompt`: हर टर्न पर आगे बढ़ने का संदेश।
- `done_token`: सफलता चिह्न (डिफ़ॉल्ट `[SOLO_DONE]`)। यदि `""`, तो कोई चिह्न सुझाव नहीं दिया जाएगा।
- `success_cmd` / `success_sh`: बाहरी जाँच; एग्ज़िट कोड 0 होने पर सफलता (जैसे `test -f FINISH.txt`)।
- `exit_on_success`: सफलता पर बाहर निकलें (या `CODEX_SOLO_EXIT_ON_SUCCESS=1`)।
- `interval_seconds`: स्वतः‑जारी अंतराल (या `CODEX_SOLO_INTERVAL_SECONDS`)।

दो इंस्टेंस (A/B)
- कंसोल A (Runner): `FINISH.txt` दिखते ही बाहर निकलता है।
- कंसोल B (Judge): हर `interval_seconds` सेकंड पर मूल्यांकन; पूर्ण होने पर `FINISH.txt` बनाता है।
- प्रत्येक कंसोल के लिए अलग `.json` हेतु `CODEX_SOLO_CONFIG` का प्रयोग करें।

अधिक जानकारी
- उन्नत मार्गदर्शिका: SOLO.hi.md
- English: README.en.md; 中文: README.zh-CN.md

उदाहरण
1) विषय + समाप्ति चिन्ह
```json
{
  "kickoff_prompt": "CSV पढ़कर JSON प्रिंट करने वाला CLI बनाएं। अंत में [SOLO_DONE] प्रिंट करें",
  "done_token": "[SOLO_DONE]",
  "continue_prompt": "जारी रखें"
}
```

2) विषय + कमांड से जाँच
```json
{
  "kickoff_prompt": "इम्प्लीमेंटेशन पूरा करें और टेस्ट पास कराएं",
  "success_cmd": ["pytest", "-q"],
  "continue_prompt": "जारी रखें (जब तक टेस्ट पास न हों)"
}
```

3) विषय + shell से जाँच
```json
{
  "kickoff_prompt": "रिपोर्ट में 42 passed दिखना सुनिश्चित करें",
  "success_sh": "pytest -q | tee /tmp/pytest.out >/dev/null && grep -q '42 passed' /tmp/pytest.out",
  "continue_prompt": "जारी रखें (जब तक 42 passed न दिखे)",
  "exit_on_success": true
}
```

ऑटोस्टार्ट
```bash
CODEX_SOLO_AUTOSTART=1 ./codex
```

बिल्ड (Linux musl)
```bash
rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl
bash scripts/build-static.sh
```

रन
```bash
cd vendor/codex/codex-rs && cargo build -p codex-cli --release
./vendor/codex/codex-rs/target/release/codex   # /solo टाइप करें या ऑटोस्टार्ट करें
```
