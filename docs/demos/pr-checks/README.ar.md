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

