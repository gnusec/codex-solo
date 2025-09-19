Codex का SOLO मोड — त्वरित मार्गदर्शिका

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
- उन्नत मार्गदर्शिका: `docs/SOLO.hi.md`
- English: `docs/README.en.md`; 中文: `docs/README.zh-CN.md`
