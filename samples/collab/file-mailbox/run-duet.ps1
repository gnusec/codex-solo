Param(
  [switch]$Tmux
)

Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force -Path mailbox | Out-Null

$codex = $env:CODEX_BIN
if (-not $codex) {
  $vendor = Join-Path $PSScriptRoot '..' '..' 'vendor' 'codex' 'codex-rs' 'target' 'release' 'codex'
  if (Test-Path $vendor) { $codex = $vendor }
  else { $codex = 'codex' }
}

Write-Host "Starting A (Builder) in this window. Open another PowerShell and run B:" -ForegroundColor Cyan
Write-Host "`$env:CODEX_SOLO_CONFIG=$PWD/solo-b.json; `$env:CODEX_SOLO_AUTOSTART=1; $codex" -ForegroundColor Yellow

$env:CODEX_SOLO_CONFIG = (Join-Path $PWD 'solo-a.json')
$env:CODEX_SOLO_AUTOSTART = '1'
& $codex

