#requires -Version 5.1
<#
.SYNOPSIS
  Launch two Codex SOLO consoles (A Runner + B Judge) for Windows/PowerShell.

.USAGE
  .\run-dual.ps1 [-ProjectDir <path>] [-BExit] [-Bin <path>] [-ExtraCliFlags <string>] [-NewWindows]

.PARAMETER ProjectDir
  The project directory where both consoles should run (default: current directory).

.PARAMETER BExit
  Use the Judge config that also exits when done (writes FINISH.txt and JUDGE_DONE.txt).

.PARAMETER Bin
  Path to the Codex binary. If omitted, tries in order: .\codex-solo, vendored x86_64 musl build, then PATH.

.PARAMETER ExtraCliFlags
  Extra CLI flags appended to both invocations, e.g. "--ask-for-approval never --sandbox danger-full-access".

.PARAMETER NewWindows
  If set, open two new PowerShell windows. Otherwise, run as background jobs in the current window.

.NOTES
  - Uses CODEX_SOLO_CONFIG to point each console at a different SOLO config file.
  - Sets CODEX_SOLO_AUTOSTART=1.
#>

param(
  [string]$ProjectDir = (Get-Location).Path,
  [switch]$BExit,
  [string]$Bin,
  [string]$ExtraCliFlags = "--ask-for-approval never --sandbox danger-full-access",
  [switch]$NewWindows
)

$ErrorActionPreference = 'Stop'

# Resolve repo root and default config paths
$ScriptDir = Split-Path -Parent $PSCommandPath
$RepoRoot  = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$AConfigDefault = Join-Path $RepoRoot 'samples/solo/multi/a/solo-a.json'
$BConfigDefault = if ($BExit) { Join-Path $RepoRoot 'samples/solo/multi/b/solo-b-exit.json' } else { Join-Path $RepoRoot 'samples/solo/multi/b/solo-b.json' }
$AConfig = if ($env:A_CONFIG) { $env:A_CONFIG } else { $AConfigDefault }
$BConfig = if ($env:B_CONFIG) { $env:B_CONFIG } else { $BConfigDefault }

if (-not (Test-Path $AConfig)) { throw "Missing A config: $AConfig" }
if (-not (Test-Path $BConfig)) { throw "Missing B config: $BConfig" }

# Resolve binary
if ($Bin) {
  $CodexBin = $Bin
} elseif (Test-Path (Join-Path (Get-Location) 'codex-solo')) {
  $CodexBin = (Resolve-Path .\codex-solo).Path
} elseif (Test-Path (Join-Path $RepoRoot 'vendor\codex\codex-rs\target\x86_64-unknown-linux-musl\release\codex')) {
  $CodexBin = Join-Path $RepoRoot 'vendor\codex\codex-rs\target\x86_64-unknown-linux-musl\release\codex'
} else {
  $CodexBin = 'codex'
}

Write-Host "Project dir : $ProjectDir"
Write-Host "Binary      : $CodexBin"
Write-Host "A config    : $AConfig"
Write-Host "B config    : $BConfig"
Write-Host "Extra flags : $ExtraCliFlags"

$common = "$ExtraCliFlags"

# Build command strings (env vars + cd + run)
function Build-Command([string]$Cfg) {
  # Use double quotes with escaped quotes for paths
  $cmd = @(
    "cd `"$ProjectDir`"",
    "`$env:CODEX_SOLO_CONFIG=`"$Cfg`"",
    "`$env:CODEX_SOLO_AUTOSTART='1'",
    "& `"$CodexBin`" $common"
  ) -join '; '
  return $cmd
}

$cmdA = Build-Command -Cfg $AConfig
$cmdB = Build-Command -Cfg $BConfig

function Start-InNewWindow([string]$Command) {
  $hostExe = (Get-Command pwsh -ErrorAction SilentlyContinue)?.Source
  if (-not $hostExe) { $hostExe = (Get-Command powershell -ErrorAction SilentlyContinue)?.Source }
  if (-not $hostExe) { throw 'Neither pwsh nor powershell found in PATH.' }
  Start-Process -FilePath $hostExe -ArgumentList @('-NoExit','-Command', $Command) | Out-Null
}

if ($NewWindows) {
  Start-InNewWindow -Command $cmdA
  Start-InNewWindow -Command $cmdB
  Write-Host "Launched two windows. Close them to stop."
  return
}

# Background jobs in current console
Write-Host "Starting as background jobs in current window..."
$jobA = Start-Job -ScriptBlock { Invoke-Expression $using:cmdA }
$jobB = Start-Job -ScriptBlock { Invoke-Expression $using:cmdB }
Get-Job | Format-Table -AutoSize
Write-Host "Use 'Receive-Job -Id <id> -Keep' to tail logs; 'Stop-Job -Id <id>' to stop."

