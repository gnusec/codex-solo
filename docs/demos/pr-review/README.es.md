Revisión de PR (motor B)
========================

Trata al revisor de PR como el motor B. A abre un PR; el workflow `.github/workflows/pr-review-demo.yml` comenta automáticamente. Sustituye el paso de ejemplo por tus pruebas/lints o un CLI de IA.

Probar
```bash
git checkout -b demo/pr
echo "demo" > PR_DEMO.txt
git add PR_DEMO.txt && git commit -m "demo: open PR"
git push -u origin demo/pr
# abre un PR a main; el workflow comentará
```

Consejos
- Combina con `duet/a`: A abre PR y este workflow actúa como B
- Sube informes como artifacts y enlázalos en el comentario

SOLO opcional (A local)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implementa y abre un PR; espera la señal de B.",
  "continue_prompt": "Itera hasta que B confirme.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
