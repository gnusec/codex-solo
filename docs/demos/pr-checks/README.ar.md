Checks لطلبات الدمج (الحالة + artifact)
=======================================

اجعل المحرك B متحققًا للـ PR: عند فتح PR، يقوم `.github/workflows/pr-checks-demo.yml` برفع تقرير كـ artifact ووضع Check أخضر.

تجربة
```bash
git checkout -b demo/pr-checks
echo "demo" > PR_CHECKS_DEMO.txt
git add PR_CHECKS_DEMO.txt && git commit -m "demo: pr checks"
git push -u origin demo/pr-checks
# افتح PR إلى main؛ ستجد الـ Check والـ artifact
```

استبدال بالتحقق الحقيقي
- بدّل خطوة المثال باختبارات/linters أو CLI للذكاء الاصطناعي
- استخدم `actions/github-script` لمُلخصات/تعليقات أكثر ثراءً

تهيئة SOLO (A محليًا اختيارية)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ وافتح PR؛ اخرج عند إشارة B بالانتهاء.",
  "continue_prompt": "واصل حتى تمرّ فحوص B.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
