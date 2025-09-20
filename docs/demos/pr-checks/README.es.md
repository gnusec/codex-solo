Checks de PR (estado + artefacto)
=================================

Usa el motor B como verificador de PR: al abrir un PR, el workflow `.github/workflows/pr-checks-demo.yml` sube un informe como artifact y marca un Check verde.

Probar
```bash
git checkout -b demo/pr-checks
echo "demo" > PR_CHECKS_DEMO.txt
git add PR_CHECKS_DEMO.txt && git commit -m "demo: pr checks"
git push -u origin demo/pr-checks
# abre PR a main; verás el Check y el artifact
```

Sustituir por verificaciones reales
- Cambia el paso de ejemplo por tus tests/lints o un CLI de IA
- Puedes generar resúmenes/annotaciones más ricos con `actions/github-script`

SOLO opcional (A local)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implementa y abre PR; sal cuando B señale terminado.",
  "continue_prompt": "Itera hasta que pasen los checks de B.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
