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

