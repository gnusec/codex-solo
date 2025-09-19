# SOLO मोड — तकनीकी मार्गदर्शिका

लक्ष्य
- बिना हस्तक्षेप के सफलता तक लगातार प्रगति।
- `done_token` या बाहरी जाँच (`success_cmd`/`success_sh`) को समर्थन।

मुख्य सेटिंग्स
- `CODEX_SOLO_CONFIG`: हर प्रक्रिया के लिए SOLO कॉन्फ़िग फ़ाइल का पथ।
- `exit_on_success` / `CODEX_SOLO_EXIT_ON_SUCCESS`।
- `interval_seconds` / `CODEX_SOLO_INTERVAL_SECONDS`।
- `done_token == ""` होने पर कोई मार्कर सुझाया नहीं जाएगा।

मुख्य कोड (TUI)
- `tui/src/chatwidget.rs`
  - स्टेट: `solo_*` फ़ील्ड।
  - `load_solo_config_file()` `CODEX_SOLO_CONFIG` या `.codex-solo.json` पढ़ता है।
  - `enable_solo_mode()` वैल्यू और env फ्लैग लागू करता है।
  - `on_solo_after_task()` सफलता या अगली टर्न (वैकल्पिक देरी) तय करता है।
  - `run_check_argv()` / `run_check_shell()` जाँच चलाते हैं।

फ्लो
1. सेशन कॉन्फ़िगरेशन → `maybe_autostart_solo()`
2. यूज़र इनपुट (या kickoff) → मॉडल टर्न
3. `TaskComplete` → `on_solo_after_task()`
4. सफलता → बाहर निकलना (वैकल्पिक); अन्यथा जारी रखना (संभव देरी के साथ)

