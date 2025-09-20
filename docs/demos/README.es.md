Demostraciones de Colaboración (Dueto)
======================================

Ejecuta dos motores en el mismo proyecto con un “buzón” simple: A construye, B revisa/prueba. Puedes usar dos instancias de Codex o adaptar B a otro CLI de IA.

Patrones
- Buzón de archivos: A y B intercambian ficheros pequeños bajo `mailbox/`
- Buzón Git: ramas `duet/a` y `duet/b` como buzones con Actions

Listas rápidas
- Buzón de archivos (A/B, ejecutable): `samples/collab/file-mailbox` · docs/demos/README.es.md
- Buzón Git (workflow): docs/demos/git-mailbox/README.es.md
- Revisión PR / Checks + artefactos: docs/demos/pr-review/README.es.md · docs/demos/pr-checks/README.es.md
- HTTP Inbox: docs/demos/http-inbox/README.es.md
- Buzón S3/MinIO: docs/demos/s3-mailbox/README.es.md
- Buzón SQLite: docs/demos/db-mailbox/README.es.md
- Buzón Redis / NATS / Slack: docs/demos/redis-mailbox/README.es.md · docs/demos/nats-mailbox/README.es.md · docs/demos/slack-mailbox/README.es.md

