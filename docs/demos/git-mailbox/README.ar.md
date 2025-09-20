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

