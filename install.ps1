#!/usr/bin/env pwsh
# OpenCode Supreme Setup v2.0
param(
  [switch]$NonInteractive,
  [string]$Claude = "",
  [string]$OpenAI = "",
  [string]$Gemini = "",
  [string]$Copilot = "",
  [string]$OpenCodeGo = "yes"
)

$ErrorActionPreference = "Continue"
$ScriptPath = if ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
$RepoDir = if ($ScriptPath) { Split-Path -Parent $ScriptPath } else { $null }
$ConfigUrl = "https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"
$ConfigDir = "$env:USERPROFILE\.config\opencode"
$IsWin = $env:OS -match "Windows"

# ── UI Helpers ─────────────────────────────────────────────────────────────
$Logo = @"
  ╔══════════════════════════════════════════╗
  ║      ███████╗██╗   ██╗██████╗ ██████╗   ║
  ║      ██╔════╝██║   ██║██╔══██╗██╔══██╗  ║
  ║      ███████╗██║   ██║██████╔╝██████╔╝  ║
  ║      ╚════██║██║   ██║██╔═══╝ ██╔══██╗  ║
  ║      ███████║╚██████╔╝██║     ██║  ██║  ║
  ║      ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝  ║
  ║    SUPREME SETUP — v2.0                  ║
  ╚══════════════════════════════════════════╝
"@

$C = @{ Cyan = "Cyan"; Green = "Green"; Yellow = "Yellow"; Red = "Red"; Magenta = "DarkMagenta"; Dim = "DarkGray"; White = "White" }

function Write-Logo { Clear-Host; Write-Host $Logo -ForegroundColor Cyan }
function Write-Step { param([string]$S) Write-Host "`n  ── $S ──" -ForegroundColor Cyan }
function Write-OK   { param([string]$S) Write-Host "  ✓ $S" -ForegroundColor Green }
function Write-Warn { param([string]$S) Write-Host "  ⚠ $S" -ForegroundColor Yellow }
function Write-Info { param([string]$S) Write-Host "    $S" -ForegroundColor DarkGray }
function Write-Sec  { param([string]$S) Write-Host "`n  ═══ $S ═══" -ForegroundColor Magenta }
function Write-Box  { param([string]$T, [string]$B) Write-Host ("  │ {0,-20} {1}" -f $T, $B) -ForegroundColor White }
function Test-Cmd   { param([string]$C) (Get-Command $C -ErrorAction SilentlyContinue) -ne $null }
function Get-YesNo  { param([string]$P) if ($NonInteractive) { $true } else { (Read-Host "  ? $P (y/n)") -eq 'y' } }

function Invoke-Progress {
  param([string]$N, [scriptblock]$B)
  Write-Host "  → $N " -NoNewline -ForegroundColor DarkGray
  try {
    $r = & $B
    Write-Host "✓" -ForegroundColor Green
    return $r
  } catch {
    Write-Host "✗" -ForegroundColor Red
    Write-Warn $_.Exception.Message
    return $null
  }
}

# ── MAIN ───────────────────────────────────────────────────────────────────
Write-Logo
Write-Host "  One-command setup for the ultimate OpenCode experience" -ForegroundColor White
Write-Host "  oh-my-openagent · 50+ skills · caveman mode · deepseek-v4-flash`n" -ForegroundColor DarkGray

# ── Step 0: Prerequisites ──────────────────────────────────────────────────
Write-Step "Prerequisites"
Invoke-Progress -N "Node.js"       -B { if (Test-Cmd node) { Write-Info "$(node --version)"; return $true } else { Write-Warn "https://nodejs.org"; return $false } }
Invoke-Progress -N "PowerShell 7+" -B { if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Info "$($PSVersionTable.PSVersion)"; return $true } else { Write-Warn "Upgrade to PowerShell 7+"; return $false } }

# ── Step 1: OpenCode ───────────────────────────────────────────────────────
Write-Step "OpenCode"
$oc = Invoke-Progress -N "Check/install" -B {
  if (Test-Cmd opencode) { Write-Info "$(opencode --version 2>$null)"; return $true }
  npm install -g opencode-ai@latest 2>&1 | Out-Null
  return (Test-Cmd opencode)
}

# ── Step 2: Bun ────────────────────────────────────────────────────────────
Write-Step "Bun"
Invoke-Progress -N "Check/install" -B {
  if (Test-Cmd bun) { Write-Info "$(bun --version)"; return $true }
  npm install -g bun 2>&1 | Out-Null
  return (Test-Cmd bun)
}

# ── Step 3: Subscription flags ─────────────────────────────────────────────
Write-Step "Provider subscriptions"
if (-not $NonInteractive) {
  $r = $null; while ($null -eq $r) {
    $i = Read-Host "  ? Claude Pro/Max? (y/n/max20)"
    if ($i -eq 'y') { $Claude = 'yes'; $r = $true }
    elseif ($i -eq 'max20') { $Claude = 'max20'; $r = $true }
    elseif ($i -eq 'n') { $Claude = 'no'; $r = $true }
    else { Write-Warn "y, n, or max20" }
  }
  if (-not $OpenAI)   { $OpenAI   = if ((Read-Host "  ? ChatGPT Plus? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $Gemini)   { $Gemini   = if ((Read-Host "  ? Gemini? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $Copilot)  { $Copilot  = if ((Read-Host "  ? Copilot? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $OpenCodeGo){$OpenCodeGo= if ((Read-Host "  ? OpenCode Go? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
}
$flags = "--claude=$Claude --openai=$OpenAI --gemini=$Gemini --copilot=$Copilot --opencode-go=$OpenCodeGo"
Write-Info "Flags: $flags"

# ── Step 4: oh-my-openagent ────────────────────────────────────────────────
Write-Step "oh-my-openagent"
Invoke-Progress -N "Install plugin" -B {
  $r = $null
  try { $r = bunx oh-my-openagent install --no-tui $flags --skip-auth 2>&1; $true }
  catch {
    try { $r = bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1; $true }
    catch { $false }
  }
}

# ── Step 5: Config files ───────────────────────────────────────────────────
Write-Step "Configuration"
if (-not (Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }

if ($RepoDir -and (Test-Path "$RepoDir\config")) {
  Invoke-Progress -N "Copy config files" -B { Copy-Item -Path "$RepoDir\config\*" -Destination $ConfigDir -Force -Recurse; $true }
} else {
  Invoke-Progress -N "Download opencode.json" -B { Invoke-RestMethod -Uri "$ConfigUrl/opencode.json" -OutFile "$ConfigDir\opencode.json"; $true }
  Invoke-Progress -N "Download oh-my-openagent.json" -B { Invoke-RestMethod -Uri "$ConfigUrl/oh-my-openagent.json" -OutFile "$ConfigDir\oh-my-openagent.json"; $true }
  Invoke-Progress -N "Download AGENTS.md" -B { Invoke-RestMethod -Uri "$ConfigUrl/AGENTS.md" -OutFile "$ConfigDir\AGENTS.md"; $true }
  Invoke-Progress -N "Download skills" -B {
    $sd = Join-Path $ConfigDir "skills"
    $list = (Invoke-RestMethod -Uri "$ConfigUrl/skills.txt") -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $ok = 0; $fail = 0
    foreach ($s in $list) {
      $d = Join-Path $sd $s; New-Item -ItemType Directory -Path $d -Force | Out-Null
      try { Invoke-RestMethod -Uri "$ConfigUrl/skills/$s/SKILL.md" -OutFile (Join-Path $d "SKILL.md"); $ok++ }
      catch { $fail++ }
    }
    Write-Info "$ok downloaded, $fail failed"; $true
  }
}

# Register plugin in opencode.json
$ocConfig = "$ConfigDir\opencode.json"
if (Test-Path $ocConfig) {
  $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
  if (-not ($oc.plugin -contains "oh-my-openagent")) {
    $oc.plugin = @("oh-my-openagent") + $oc.plugin
    $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8
    Write-OK "Plugin registered"
  }
}

# ── Step 6: Platform optimizations ─────────────────────────────────────────
Write-Step "Platform optimizations"
$omoConfig = "$ConfigDir\oh-my-openagent.json"
if (Test-Path $omoConfig) {
  Invoke-Progress -N "Optimize oh-my-openagent.json" -B {
    $omo = Get-Content $omoConfig -Raw | ConvertFrom-Json
    if ($IsWin) { $omo.tmux.enabled = $false }
    foreach ($a in $omo.agents.PSObject.Properties) { $a.Value.model = "opencode-go/deepseek-v4-flash"; $a.Value.PSObject.Properties.Remove("fallback_models") }
    foreach ($c in $omo.categories.PSObject.Properties) { $c.Value.model = "opencode-go/deepseek-v4-flash"; $c.Value.PSObject.Properties.Remove("fallback_models") }
    $omo | ConvertTo-Json -Depth 10 | Set-Content $omoConfig -Encoding UTF8; $true
  }
}

# ── Step 7: Tools ──────────────────────────────────────────────────────────
Write-Step "Developer tools"
Invoke-Progress -N "Comment checker" -B {
  try { bunx @code-yeongyu/comment-checker --version 2>&1 | Out-Null; $true }
  catch { try { npm install -g @code-yeongyu/comment-checker 2>&1 | Out-Null; $true } catch { $false } }
}

Invoke-Progress -N "GitHub CLI" -B {
  if (Test-Cmd gh) { $true }
  elseif ($IsWin) { try { winget install --id GitHub.cli --silent --accept-package-agreements 2>&1 | Out-Null; $env:Path = [Environment]::GetEnvironmentVariable("Path","User"); (Test-Cmd gh) } catch { $false } }
  else { $false }
}

# ── Step 8: 🔌 Plugins from awesome-opencode ────────────────────────────────
Write-Step "Essential plugins"
Write-Host "  Installing plugins from the opencode ecosystem...`n" -ForegroundColor DarkGray

$plugins = @(
  @{ name = "opencode-snippets"; pkg = "opencode-snippets"; desc = "Instant text expansion — type #snippet → transforms inline" },
  @{ name = "opencode-notify";   pkg = "opencode-notify";   desc = "OS notifications when tasks complete" }
)

foreach ($p in $plugins) {
  $ok = Invoke-Progress -N $p.desc -B {
    try {
      $dir = "$env:USERPROFILE\.config\opencode\plugins"
      New-Item -ItemType Directory -Path $dir -Force | Out-Null
      npm install -g $p.pkg 2>&1 | Out-Null
      # Register in opencode.json
      if (Test-Path $ocConfig) {
        $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
        if ($oc.plugin -notcontains $p.pkg) { $oc.plugin += $p.pkg; $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8 }
      }
      $true
    } catch { $false }
  }
}

# Optional: agentsys
Write-Host "`n" -NoNewline
if (Get-YesNo "Install agentsys (20 plugins, 49 agents, 41 skills)?") {
  Invoke-Progress -N "agentsys orchestration system" -B {
    try { npm install -g agentsys 2>&1 | Out-Null; $true } catch { $false }
  }
}

# ── Step 9: Optional extras ─────────────────────────────────────────────────
Write-Step "Optional extras"
if (Get-YesNo "Install opencode-supermemory (persistent memory)?") {
  Invoke-Progress -N "Supermemory" -B { try { bunx opencode-supermemory@latest install --no-tui 2>&1 | Out-Null; $true } catch { $false } }
}
if (Get-YesNo "Install firecrawl (web scraping)?") {
  Invoke-Progress -N "Firecrawl CLI" -B {
    try { npm install -g firecrawl-cli 2>&1 | Out-Null; (Test-Cmd firecrawl) }
    catch { try { npm install -g @firecrawl/firecrawl-cli 2>&1 | Out-Null; (Test-Cmd firecrawl) } catch { $false } }
  }
}
if (Get-YesNo "Install opencode-wakatime (coding stats)?") {
  Invoke-Progress -N "WakaTime" -B { try { npm install -g opencode-wakatime 2>&1 | Out-Null; $true } catch { $false } }
}

# ── Step 10: Verify ─────────────────────────────────────────────────────────
Write-Step "Verification"
Invoke-Progress -N "oh-my-openagent doctor" -B {
  try { $r = bunx oh-my-openagent doctor 2>&1; $true } catch { $true }
}

# ── Step 11: Summary ────────────────────────────────────────────────────────
Write-Sec "Setup Complete!"
Write-Host @"

  ╔══════════════════════════════════════════╗
  ║  🚀  opencode          — launch          ║
  ║  🔥  ulw <task>        — ultrawork mode   ║
  ║  ↹  Tab                — cycle agents    ║
  ║  🛡  @security-auditor — security audit  ║
  ║  🔧  @refactor <files> — refactor code   ║
  ║  📝  @docs-writer      — write docs      ║
  ║  🎯  50+ skills        — auto-triggered   ║
  ║  📋  #snippet          — text expansion   ║
  ║  🔔  Notifications     — task done alerts ║
  ╚══════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "  Auth needed: opencode auth login" -ForegroundColor Yellow
Write-Host "  Star the repo: https://github.com/skeletorflet/opencode-supreme-setup" -ForegroundColor DarkGray
Write-Host "`n" -NoNewline
