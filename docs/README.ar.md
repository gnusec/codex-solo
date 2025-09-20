اللغات:
[العربية](README.ar.md) · [English](README.en.md) · [简体中文](README.zh-CN.md) · [Español](README.es.md) · [हिन्दी](README.hi.md)

# وضع SOLO في Codex — دليل سريع

روابط سريعة
- الإصدارات: https://github.com/gnusec/codex-solo/releases
- المناقشات: https://github.com/gnusec/codex-solo/discussions
- المساهمة: ../CONTRIBUTING.md
- خارطة الطريق: ROADMAP.md
- Good First Issues: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22
- Help Wanted: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22
- Show & Tell: https://github.com/gnusec/codex-solo/discussions/9

نظرة وظيفية
- يستمر تلقائيًا حتى تمرّ فحوصات النجاح
- فحوصات قابلة للبرمجة: خروج 0 للأوامر/السكربت، نجاح الاختبارات، مطابقة ملف/مخرجات
- يدعم البدء التلقائي، فواصل زمنية بين الدورات، الخروج عند النجاح، وتعدد المثيلات/الملفات

نظرة عامة
- يعمل SOLO تلقائيًا حتى تتحقق حالة النجاح.
- فعِّل عبر `/solo` في الواجهة النصية أو استخدم `CODEX_SOLO_AUTOSTART=1`.
- ملف الإعداد: `.codex-solo.json` (أو `CODEX_SOLO_CONFIG` لتحديد مسار بديل).

الإعدادات
- `kickoff_prompt`: موجه البداية (اختياري).
- `continue_prompt`: نص طلب الاستمرار في كل دورة.
- `done_token`: علامة الإنهاء (الافتراضي `[SOLO_DONE]`). إذا كانت `""` فلن نقترح أي علامة.
- `success_cmd` / `success_sh`: تحقق خارجي؛ النجاح عندما يكون الخروج 0 (مثلًا `test -f FINISH.txt`).
- `exit_on_success`: الخروج عند النجاح (أو `CODEX_SOLO_EXIT_ON_SUCCESS=1`).
- `interval_seconds`: تأخير بين الدورات (أو `CODEX_SOLO_INTERVAL_SECONDS`).

تشغيل مثيلين (A/B)
- الطرفية A (Runner): تتحقق من `FINISH.txt` → تخرج.
- الطرفية B (Judge): تقيّم كل `interval_seconds` وتُنشئ `FINISH.txt` عند اكتمال المشروع.
- استخدم `CODEX_SOLO_CONFIG` لملف إعداد مستقل لكل طرفية.

المزيد
- الدليل المتقدم: SOLO.ar.md
- English: README.en.md ؛ 中文: README.zh-CN.md
