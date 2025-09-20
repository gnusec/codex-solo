مراجعة PR (المحرك B)
=====================

اعتبر مُراجع PR هو المحرك B. يفتح A طلب دمج؛ يقوم الـ workflow `.github/workflows/pr-review-demo.yml` بالتعليق تلقائيًا. استبدل خطوة المثال باختبارات/linters أو CLI للذكاء الاصطناعي.

جرّب
```bash
git checkout -b demo/pr
echo "demo" > PR_DEMO.txt
git add PR_DEMO.txt && git commit -m "demo: open PR"
git push -u origin demo/pr
# افتح PR إلى main؛ سيقوم الـ workflow بالتعليق
```

نصائح
- اجمعها مع `duet/a`: يفتح A طلب الدمج وهذا workflow يعمل كمحرك B
- ارفع تقارير كمصنوعات (artifacts) وأرفق رابطًا في التعليق

تهيئة SOLO (A محليًا اختيارية)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ وافتح PR؛ انتظر إشارة B.",
  "continue_prompt": "واصل حتى يؤكد B.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
