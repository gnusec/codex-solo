صندوق Git (Duet)
=================

استخدم فرعين كـ “صندوق بريد”: يدفع A الحالة إلى `duet/a`؛ ويكتب الـ workflow (أو محرك B) المراجعة وإشارة الانتهاء في `duet/b`.

التمهيد (جانب A)
```bash
git checkout -b duet/a
mkdir -p mailbox
echo "initial plan" > mailbox/a_to_b.txt
git add mailbox/a_to_b.txt
git commit -m "duet: A → B رسالة أولية"
git push -u origin duet/a
```

ما الذي يحدث
- يتم تشغيل workflow `.github/workflows/duet-git-mailbox.yml` عند الدفع إلى `duet/a`
- يكتب إلى `duet/b`:
  - `mailbox/b_to_a.txt`: ملاحظة المراجعة
  - `mailbox/done_by_b.flag`: إشارة النجاح

ملاحظات
- يمكن استبدال الـ workflow بمراجع حقيقي (اختبارات/‎Linters/CLI للذكاء الاصطناعي)
- للصندوق القائم على الملفات (بدون Git) انظر `samples/collab/file-mailbox`

تهيئة SOLO (اختيارية محليًا)
A (Builder)
```json
{
  "done_token": "",
  "kickoff_prompt": "تنفيذ المهام؛ عند الجاهزية انتظر تأكيد B (duet/b).",
  "continue_prompt": "واصل حتى يؤكد B.",
  "success_sh": "git fetch origin duet/b && git show origin/duet/b:mailbox/done_by_b.flag >/dev/null 2>&1",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
B (Reviewer، محلي اختياري)
```json
{
  "done_token": "",
  "kickoff_prompt": "كمراجع، عند الرضا أنشئ mailbox/done_by_b.flag واكتب mailbox/b_to_a.txt.",
  "continue_prompt": "راجع واتخذ قرارًا؛ أنشئ done_by_b.flag عند الموافقة.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
