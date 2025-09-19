Idiomas: Español (actual) · English · 简体中文 · العربية · हिन्दी
- English: ../docs/README.en.md
- 简体中文: ../docs/README.zh-CN.md
- العربية: ../docs/README.ar.md
- हिन्दी: ../docs/README.hi.md

# Modo SOLO de Codex — Guía Rápida

Resumen
- SOLO continúa trabajando automáticamente hasta que se cumpla una condición de éxito.
- Activa con `/solo` en la TUI o usa `CODEX_SOLO_AUTOSTART=1`.
- Archivo de configuración: `.codex-solo.json` (o `CODEX_SOLO_CONFIG` para sobrescribir la ruta).

Configuración
- `kickoff_prompt`: prompt inicial (opcional).
- `continue_prompt`: cómo pedir continuar cada vuelta.
- `done_token`: marcador de finalización (por defecto `[SOLO_DONE]`). Si lo dejas como `""`, no se sugiere ningún marcador.
- `success_cmd` / `success_sh`: prueba externa; éxito cuando el comando sale con código 0 (p.ej., `test -f FINISH.txt`).
- `exit_on_success`: salir cuando haya éxito (o `CODEX_SOLO_EXIT_ON_SUCCESS=1`).
- `interval_seconds`: retraso entre vueltas automáticas (o `CODEX_SOLO_INTERVAL_SECONDS`).

Multi‑instancia (A/B)
- Consola A (Runner): detecta `FINISH.txt` → sale.
- Consola B (Judge): evalúa cada `interval_seconds` y crea `FINISH.txt` cuando el proyecto esté listo.
- Usa `CODEX_SOLO_CONFIG` para que cada consola tenga su propio archivo `.json`.

Más
- Guía avanzada: ../docs/SOLO.es.md
- English: ../docs/README.en.md; 中文: ../docs/README.zh-CN.md
