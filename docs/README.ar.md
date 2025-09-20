اللغات:
[العربية](README.ar.md) · [English](README.en.md) · [简体中文](README.zh-CN.md) · [Español](README.es.md) · [हिन्दी](README.hi.md)

# وضع SOLO في Codex — دليل سريع

روابط سريعة
- الإصدارات: https://github.com/gnusec/codex-solo/releases
- المناقشات: https://github.com/gnusec/codex-solo/discussions
- المساهمة: ../CONTRIBUTING.md
- خارطة الطريق: ROADMAP.md
- البنية والتصميم: architecture/README.en.md
- Good First Issues: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22
- Help Wanted: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22
- Show & Tell: https://github.com/gnusec/codex-solo/discussions/9

وسائل التواصل
- الاسم: 耘峥
- البريد الإلكتروني: huangdeng@safe87.com
- WeChat: gnusec

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

أمثلة
1) موضوع + علامة نهاية
```json
{
  "kickoff_prompt": "أنشئ CLI يقرأ CSV ويطبع JSON. أخيرًا اطبع [SOLO_DONE]",
  "done_token": "[SOLO_DONE]",
  "continue_prompt": "استمر"
}
```

2) موضوع + تحقق بالأمر
```json
{
  "kickoff_prompt": "أكمل التنفيذ واجعل الاختبارات تنجح",
  "success_cmd": ["pytest", "-q"],
  "continue_prompt": "استمر (حتى تمر الاختبارات)"
}
```

3) موضوع + تحقق عبر shell
```json
{
  "kickoff_prompt": "تأكد أن التقرير يظهر 42 passed",
  "success_sh": "pytest -q | tee /tmp/pytest.out >/dev/null && grep -q '42 passed' /tmp/pytest.out",
  "continue_prompt": "استمر (حتى يظهر 42 passed)",
  "exit_on_success": true
}
```

تشغيل تلقائي
```bash
CODEX_SOLO_AUTOSTART=1 ./codex
```

البناء (Linux musl)
```bash
rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl
bash scripts/build-static.sh
```

تشغيل
```bash
cd vendor/codex/codex-rs && cargo build -p codex-cli --release
./vendor/codex/codex-rs/target/release/codex   # اكتب /solo أو استخدم التشغيل التلقائي
```
