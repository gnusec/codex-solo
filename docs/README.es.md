Idiomas:
[Español](README.es.md) · [English](README.en.md) · [简体中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

# Modo SOLO de Codex — Guía Rápida

Enlaces rápidos
- Lanzamientos: https://github.com/gnusec/codex-solo/releases
- Debates (Discussions): https://github.com/gnusec/codex-solo/discussions
- Contribuir: ../CONTRIBUTING.md
- Hoja de ruta: ROADMAP.md
- Good First Issues: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22
- Help Wanted: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22
- Show & Tell: https://github.com/gnusec/codex-solo/discussions/9

Descripción funcional
- Avanza automáticamente hasta que las comprobaciones de éxito se cumplan
- Comprobaciones scriptables: salida 0 de comando/script, tests en verde, coincidencia de archivo/salida
- Soporta autoinicio, intervalo entre iteraciones, salir al tener éxito y configuración multi‑instancia

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
- Guía avanzada: SOLO.es.md
- English: README.en.md; 中文: README.zh-CN.md

Ejemplos
1) Tema + token de finalización
```json
{
  "kickoff_prompt": "Construye un CLI que lea CSV y devuelva JSON. Finalmente imprime [SOLO_DONE]",
  "done_token": "[SOLO_DONE]",
  "continue_prompt": "continuar"
}
```

2) Tema + verificación por comando
```json
{
  "kickoff_prompt": "Completa la implementación y haz que pasen las pruebas",
  "success_cmd": ["pytest", "-q"],
  "continue_prompt": "continuar (iterar hasta pasar)"
}
```

3) Tema + verificación por shell
```json
{
  "kickoff_prompt": "Asegura que el reporte muestre 42 passed",
  "success_sh": "pytest -q | tee /tmp/pytest.out >/dev/null && grep -q '42 passed' /tmp/pytest.out",
  "continue_prompt": "continuar (hasta ver 42 passed)",
  "exit_on_success": true
}
```

Autoinicio
```bash
CODEX_SOLO_AUTOSTART=1 ./codex
```

Compilar (Linux musl)
```bash
rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl
bash scripts/build-static.sh
```

Ejecutar
```bash
cd vendor/codex/codex-rs && cargo build -p codex-cli --release
./vendor/codex/codex-rs/target/release/codex   # escribe /solo o usa autoinicio
```
