#!/usr/bin/env pwsh
# OpenCode Supreme Setup — Uninstaller v1
# Compatible with: irm https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/uninstall.ps1 | iex
$ErrorActionPreference = "Continue"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

# Enable VT100
try {
  Add-Type -TypeDefinition @'
using System; using System.Runtime.InteropServices;
public class WinVT2 {
  [DllImport("kernel32")] public static extern bool GetConsoleMode(IntPtr h, out uint m);
  [DllImport("kernel32")] public static extern bool SetConsoleMode(IntPtr h, uint m);
  [DllImport("kernel32")] public static extern IntPtr GetStdHandle(int n);
  public static void Enable() { var h = GetStdHandle(-11); uint m = 0; GetConsoleMode(h, out m); SetConsoleMode(h, m | 4); }
}
'@ -ErrorAction SilentlyContinue
  [WinVT2]::Enable()
} catch {}

$e   = [char]27
$NP  = "$e[38;5;198m"; $NC  = "$e[38;5;51m";  $NG  = "$e[38;5;46m"
$NR  = "$e[38;5;196m"; $DG  = "$e[38;5;238m"; $MG  = "$e[38;5;244m"
$WH  = "$e[38;5;231m"; $YL  = "$e[38;5;226m"; $RST = "$e[0m"; $BLD = "$e[1m"

$ConfDir = "$env:USERPROFILE\.config\opencode"

# ── Helpers ────────────────────────────────────────────────────────────────────
function Write-Step([string]$Label, [string]$Status, [string]$Color) {
  $icon = switch ($Status) {
    'ok'   { "${NG}✔${RST}" }
    'fail' { "${NR}✖${RST}" }
    'skip' { "${DG}·${RST}" }
    'run'  { "${NC}›${RST}" }
  }
  $pad = [Math]::Max(1, 40 - $Label.Length)
  [Console]::WriteLine("  $icon ${WH}$Label${RST}$(" " * $pad)$Color")
}

function Remove-NpmPkg([string]$Pkg) {
  $out = npm uninstall -g $Pkg 2>&1
  if ($LASTEXITCODE -eq 0) { Write-Step $Pkg 'ok' "${DG}removed${RST}" }
  else                      { Write-Step $Pkg 'skip' "${DG}not found / skipped${RST}" }
}

# ── All packages installed by the setup ───────────────────────────────────────
$NpmPackages = @(
  "opencode-ai",
  "bun",
  "opencode-snippets",
  "opencode-snip",
  "opencode-notify",
  "opencode-mem",
  "opencode-quota",
  "opencode-background-agents",
  "opencode-worktree",
  "opencode-dynamic-context-pruning",
  "opencode-smart-title",
  "ocwatch",
  "openskills",
  "@code-yeongyu/comment-checker",
  "@ast-grep/cli",
  "agentsys",
  "firecrawl-cli",
  "opencode-wakatime",
  "opencode-ayu-theme",
  "lavi",
  "opencode-moonlight-theme",
  "opencode-ai-poimandres-theme",
  "agentation-mcp"
)

# ── Header ────────────────────────────────────────────────────────────────────
[Console]::Clear()
[Console]::WriteLine("")
$w = try { $Host.UI.RawUI.WindowSize.Width } catch { 70 }
$border = "═" * ($w - 4)
[Console]::WriteLine("  ${NP}╔${border}╗${RST}")
$hdr = " ${BLD}${NP}◈ OPENCODE SUPREME SETUP${RST}  ${DG}│${RST}  ${NR}${BLD}UNINSTALLER${RST} "
$hdrPad = " " * [Math]::Max(1, $w - 4 - ($hdr -replace "\x1b\[[0-9;]*[a-zA-Z]","").Length)
[Console]::WriteLine("  ${NP}║${RST}$hdr${hdrPad}${NP}║${RST}")
[Console]::WriteLine("  ${NP}╚${border}╝${RST}")
[Console]::WriteLine("")
[Console]::WriteLine("  ${NR}This will remove ALL packages and config installed by the setup.${RST}")
[Console]::WriteLine("  ${DG}Config dir: $ConfDir${RST}")
[Console]::WriteLine("")

# ── Confirmation ──────────────────────────────────────────────────────────────
$q = "Are you sure"
$pad = [Math]::Max(1, 28 - $q.Length)
[Console]::Write("  ${NP}?${RST} $q$(" " * $pad) ${DG}[${RST}${DG}y/${RST}${NG}N${RST}${DG}]${RST} > ")
$ans = [Console]::ReadLine()
if ($ans -notmatch '^[Yy]') {
  [Console]::WriteLine("")
  [Console]::WriteLine("  ${DG}Aborted. Nothing was changed.${RST}")
  [Console]::WriteLine("")
  exit 0
}

[Console]::WriteLine("")

# ── Step 1: npm packages ──────────────────────────────────────────────────────
[Console]::WriteLine("  ${NC}── npm packages $('─' * 41)${RST}")
foreach ($pkg in $NpmPackages) { Remove-NpmPkg $pkg }

# ── Step 2: bun (if installed via bun installer, not npm) ────────────────────
[Console]::WriteLine("")
[Console]::WriteLine("  ${NC}── bun runtime $('─' * 42)${RST}")
$bunDir = "$env:USERPROFILE\.bun"
if (Test-Path $bunDir) {
  try {
    Remove-Item $bunDir -Recurse -Force
    Write-Step "~/.bun directory" 'ok' "${DG}removed${RST}"
  } catch {
    Write-Step "~/.bun directory" 'fail' "${NR}$_${RST}"
  }
} else {
  Write-Step "~/.bun directory" 'skip' "${DG}not found${RST}"
}

# Remove bun from PATH in user profile if it was added
$profilePaths = @(
  "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
  "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
)
foreach ($prof in $profilePaths) {
  if (Test-Path $prof) {
    $content = Get-Content $prof -Raw
    if ($content -match '\.bun') {
      $newContent = $content -replace '.*\.bun.*\r?\n', ''
      Set-Content $prof $newContent -Encoding UTF8
      Write-Step "Removed bun from profile" 'ok' "${DG}$prof${RST}"
    }
  }
}

# ── Step 3: oh-my-openagent ──────────────────────────────────────────────────
[Console]::WriteLine("")
[Console]::WriteLine("  ${NC}── oh-my-openagent $('─' * 38)${RST}")
try {
  $omoOut = bunx oh-my-openagent uninstall --force 2>&1
  Write-Step "oh-my-openagent" 'ok' "${DG}uninstalled${RST}"
} catch {
  # try npm fallback
  Remove-NpmPkg "oh-my-openagent"
}

# ── Step 4: Config directory ──────────────────────────────────────────────────
[Console]::WriteLine("")
[Console]::WriteLine("  ${NC}── config & skills $('─' * 38)${RST}")

$q2 = "Remove ~/.config/opencode"
$pad2 = [Math]::Max(1, 28 - $q2.Length)
[Console]::Write("  ${NP}?${RST} $q2$(" " * $pad2) ${DG}[${RST}${NR}Y${RST}${DG}/n]${RST} > ")
$ansConf = [Console]::ReadLine()
if ($ansConf -notmatch '^[Nn]') {
  if (Test-Path $ConfDir) {
    try {
      Remove-Item $ConfDir -Recurse -Force
      Write-Step "$ConfDir" 'ok' "${DG}removed${RST}"
    } catch {
      Write-Step "$ConfDir" 'fail' "${NR}$_${RST}"
    }
  } else {
    Write-Step "$ConfDir" 'skip' "${DG}not found${RST}"
  }
} else {
  Write-Step "Config dir kept" 'skip' "${DG}skipped by user${RST}"
}

# ── Step 5: opencode config in APPDATA (if any) ───────────────────────────────
$appDataConf = "$env:APPDATA\opencode"
if (Test-Path $appDataConf) {
  try {
    Remove-Item $appDataConf -Recurse -Force
    Write-Step "APPDATA\opencode" 'ok' "${DG}removed${RST}"
  } catch {
    Write-Step "APPDATA\opencode" 'fail' "${NR}$_${RST}"
  }
}

# ── Step 6: log files ─────────────────────────────────────────────────────────
[Console]::WriteLine("")
[Console]::WriteLine("  ${NC}── cleanup logs $('─' * 41)${RST}")
$logs = Get-ChildItem "$env:TEMP\oc_setup_*.log" -ErrorAction SilentlyContinue
if ($logs.Count -gt 0) {
  $logs | Remove-Item -Force -ErrorAction SilentlyContinue
  Write-Step "$($logs.Count) install log(s)" 'ok' "${DG}removed from TEMP${RST}"
} else {
  Write-Step "install logs" 'skip' "${DG}none found${RST}"
}

# ── Done ──────────────────────────────────────────────────────────────────────
[Console]::WriteLine("")
[Console]::WriteLine("  ${NG}${BLD}UNINSTALL COMPLETE${RST}")
[Console]::WriteLine("  ${DG}$('─' * 50)${RST}")
[Console]::WriteLine("  ${DG}opencode and all supreme setup components have been removed.${RST}")
[Console]::WriteLine("  ${DG}Restart your terminal to clear any stale PATH entries.${RST}")
[Console]::WriteLine("")
