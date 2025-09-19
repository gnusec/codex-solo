# Modo SOLO — Guía Técnica

Objetivos
- Avanzar sin intervención hasta una prueba de éxito verificable.
- Soportar `done_token` o pruebas externas (`success_cmd`/`success_sh`).

Claves de configuración
- `CODEX_SOLO_CONFIG`: ruta del `.json` de SOLO para cada proceso.
- `exit_on_success` / `CODEX_SOLO_EXIT_ON_SUCCESS`.
- `interval_seconds` / `CODEX_SOLO_INTERVAL_SECONDS`.
- `done_token == ""` evita sugerir marcadores.

Código principal (TUI)
- `tui/src/chatwidget.rs`
  - Estado: `solo_*` campos.
  - `load_solo_config_file()` lee `CODEX_SOLO_CONFIG` o `.codex-solo.json`.
  - `enable_solo_mode()` aplica valores y banderas de entorno.
  - `on_solo_after_task()` decide éxito o la siguiente vuelta (con retraso opcional).
  - `run_check_argv()` / `run_check_shell()` ejecutan las pruebas.

Flujo de ejecución
1. Configuración de sesión → `maybe_autostart_solo()`
2. Entrada del usuario (o kickoff) → vuelta de modelo
3. `TaskComplete` → `on_solo_after_task()`
4. Éxito → salir (opcional); si no, continuar (posible retraso)

