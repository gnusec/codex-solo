# وضع SOLO — دليل تقني

الأهداف
- التقدم تلقائيًا حتى يتحقق إثبات النجاح.
- دعم `done_token` أو فحوصات خارجية (`success_cmd`/`success_sh`).

مفاتيح الإعداد
- `CODEX_SOLO_CONFIG`: مسار ملف إعداد SOLO لكل عملية.
- `exit_on_success` / `CODEX_SOLO_EXIT_ON_SUCCESS`.
- `interval_seconds` / `CODEX_SOLO_INTERVAL_SECONDS`.
- إذا كان `done_token == ""` فلن يُقترح أي مُؤشر انتهاء.

الملف الرئيسي (TUI)
- `tui/src/chatwidget.rs`
  - الحالة: الحقول `solo_*`.
  - `load_solo_config_file()` يقرأ `CODEX_SOLO_CONFIG` أو `.codex-solo.json`.
  - `enable_solo_mode()` يطبق القيم والمتغيرات البيئية.
  - `on_solo_after_task()` يقرر النجاح أو الاستمرار (مع تأخير اختياري).
  - `run_check_argv()` / `run_check_shell()` ينفذان الفحوصات.

التدفق
1. تهيئة الجلسة → `maybe_autostart_solo()`
2. إدخال المستخدم (أو التهيئة) → دورة النموذج
3. `TaskComplete` → `on_solo_after_task()`
4. النجاح → خروج (اختياري)؛ وإلا متابعة (قد يكون هناك تأخير)

