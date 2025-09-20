Buzón Git Dueto (A/B)
=====================

Usa dos ramas como “buzón”: A empuja estado a `duet/a`; el workflow (o el motor B) escribe la revisión y la señal de finalización en `duet/b`.

Arranque (lado A)
```bash
git checkout -b duet/a
mkdir -p mailbox
echo "initial plan" > mailbox/a_to_b.txt
git add mailbox/a_to_b.txt
git commit -m "duet: A → B mensaje inicial"
git push -u origin duet/a
```

Qué sucede
- El workflow `.github/workflows/duet-git-mailbox.yml` se activa con pushes a `duet/a`
- Escribe en `duet/b`:
  - `mailbox/b_to_a.txt`: nota del revisor
  - `mailbox/done_by_b.flag`: señal de éxito

Notas
- Sustituye el workflow por tu revisor real (tests/lints/CLI de IA) si lo necesitas
- Para el buzón de archivos (sin Git), ve `samples/collab/file-mailbox`

SOLO sugerido (opcional, local)
A (Builder)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implementar y esperar la confirmación de B (duet/b).",
  "continue_prompt": "Seguir hasta que B confirme.",
  "success_sh": "git fetch origin duet/b && git show origin/duet/b:mailbox/done_by_b.flag >/dev/null 2>&1",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
B (Reviewer, local opcional)
```json
{
  "done_token": "",
  "kickoff_prompt": "Actuar como revisor. Al estar conforme, crear mailbox/done_by_b.flag y escribir mailbox/b_to_a.txt.",
  "continue_prompt": "Revisar y decidir; crear done_by_b.flag al estar OK.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
