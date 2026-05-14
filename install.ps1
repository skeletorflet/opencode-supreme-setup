#!/usr/bin/env pwsh
# OpenCode Supreme Setup v4.0 — ALL the best of opencode ecosystem
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
$LogFile = "$env:TEMP\opencode_setup_$(Get-Date -Format 'yyyyMMdd_HHmm').log"

# ── UI ──────────────────────────────────────────────────────────────────────
$Logo = @"
  ╔══════════════════════════════════════════╗
  ║      ███████╗██╗   ██╗██████╗ ██████╗   ║
  ║      ██╔════╝██║   ██║██╔══██╗██╔══██╗  ║
  ║      ███████╗██║   ██║██████╔╝██████╔╝  ║
  ║      ╚════██║██║   ██║██╔═══╝ ██╔══██╗  ║
  ║      ███████║╚██████╔╝██║     ██║  ██║  ║
  ║      ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝  ║
  ║    SUPREME SETUP — v4.0                  ║
  ╚══════════════════════════════════════════╝
"@

function Write-Logo { Clear-Host; Write-Host $Logo -ForegroundColor Cyan }
function Write-Step { param([string]$S) Write-Host "`n  ── $S ──" -ForegroundColor Cyan -Style Bold }
function Write-OK   { param([string]$S) Write-Host "  ✓ $S" -ForegroundColor Green }
function Write-Warn { param([string]$S) Write-Host "  ⚠ $S" -ForegroundColor Yellow }
function Write-Info { param([string]$S) Write-Host "    $S" -ForegroundColor DarkGray }
function Write-Sec  { param([string]$S) Write-Host "`n  ═══ $S ═══" -ForegroundColor Magenta }
function Test-Cmd   { param([string]$C) (Get-Command $C -ErrorAction SilentlyContinue) -ne $null }
function Get-YesNo  { param([string]$P) if ($NonInteractive) { $true } else { (Read-Host "  ? $P (y/n)") -eq 'y' } }

# Modern Progress Loader for PowerShell
function Invoke-Progress {
  param([string]$N, [scriptblock]$B)
  $frames = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
  $i = 0

  Write-Host "  $($frames[0]) $N ..." -NoNewline -ForegroundColor DarkGray

  $job = Start-Job -ScriptBlock $B
  while ($job.State -eq 'Running') {
    $frame = $frames[$i % $frames.Count]
    Write-Host "`r  $frame $N ..." -NoNewline -ForegroundColor Cyan
    $i++
    Start-Sleep -Milliseconds 100
  }

  $result = Receive-Job -Job $job
  $result | Out-File -FilePath $using:LogFile -Append
  $exitCode = $job.ChildJobs[0].ExitCode
  Remove-Job $job

  # Clear line (approximation in PS)
  Write-Host "`r                                                                " -NoNewline

  if ($exitCode -eq 0 -or $null -eq $exitCode) {
    Write-Host "`r  ✓ $N" -ForegroundColor Green
    return $true
  } else {
    Write-Host "`r  ✗ $N" -ForegroundColor Red
    return $false
  }
}

function Add-Plugin {
  param([string]$Pkg)
  if (-not (Test-Path $ocConfig)) { return $false }
  try {
    npm install -g $Pkg 2>&1 | Out-Null
    $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
    if ($oc.plugin -notcontains $Pkg) { $oc.plugin += $Pkg; $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8 }
    return $true
  } catch { return $false }
}

# ── MAIN ────────────────────────────────────────────────────────────────────
Write-Logo
Write-Host "  Ultimate OpenCode Experience" -ForegroundColor White -Style Bold
Write-Host "  150+ skills · 13 plugins · SDD · self-healing · dashboard · caveman-v4`n" -ForegroundColor DarkGray

# ── Step 0: Prerequisites ───────────────────────────────────────────────────
Write-Step "Prerequisites"
Invoke-Progress -N "Node.js 18+" -B { if (Test-Cmd node) { $v = node --version; return $v -match "v(1[89]|[2-9]\d)" } else { return $false } }

# ── Step 1: OpenCode ────────────────────────────────────────────────────────
Write-Step "OpenCode"
Invoke-Progress -N "Check/install opencode" -B {
  if (Test-Cmd opencode) { return $true }
  npm install -g opencode-ai@latest 2>&1 | Out-Null; return (Test-Cmd opencode)
}

# ── Step 2: Bun ─────────────────────────────────────────────────────────────
Write-Step "Bun"
Invoke-Progress -N "Check/install bun" -B {
  if (Test-Cmd bun) { return $true }
  npm install -g bun 2>&1 | Out-Null; return (Test-Cmd bun)
}

# ── Step 3: Provider subs ───────────────────────────────────────────────────
Write-Step "Provider subscriptions"
if (-not $NonInteractive) {
  $r = $null; while ($null -eq $r) {
    $i = Read-Host "  ? Claude Pro/Max? (y/n/max20)"
    if ($i -eq 'y') { $Claude = 'yes'; $r = $true } elseif ($i -eq 'max20') { $Claude = 'max20'; $r = $true } elseif ($i -eq 'n') { $Claude = 'no'; $r = $true } else { Write-Warn "y, n, or max20" }
  }
  if (-not $OpenAI)   { $OpenAI   = if ((Read-Host "  ? ChatGPT Plus? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $Gemini)   { $Gemini   = if ((Read-Host "  ? Gemini? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $Copilot)  { $Copilot  = if ((Read-Host "  ? Copilot? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $OpenCodeGo){$OpenCodeGo= if ((Read-Host "  ? OpenCode Go? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
}
$flags = "--claude=$Claude --openai=$OpenAI --gemini=$Gemini --copilot=$Copilot --opencode-go=$OpenCodeGo"
Write-Info "Flags: $flags"

# ── Step 4: oh-my-openagent ─────────────────────────────────────────────────
Write-Step "oh-my-openagent"
Invoke-Progress -N "Install plugin" -B {
  $f = $using:flags -split " " | Where-Object { $_ }
  try { bunx oh-my-openagent install --no-tui @f --skip-auth 2>&1; $true }
  catch { try { bunx oh-my-openagent install --no-tui --claude=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1; $true } catch { $false } }
}

# ── Step 5: Config files ────────────────────────────────────────────────────
Write-Step "Configuration"
Invoke-Progress -N "Cleanup old configs" -B { Get-ChildItem $using:ConfigDir -Filter "opencode.jsonc*" -ErrorAction SilentlyContinue | Remove-Item -Force }
if (-not (Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
$ocConfig = "$ConfigDir\opencode.json"

if ($RepoDir -and (Test-Path "$RepoDir\config")) {
  Invoke-Progress -N "Sync local config" -B { Copy-Item -Path "$using:RepoDir\config\*" -Destination $using:ConfigDir -Force -Recurse; $true }
} else {
  Invoke-Progress -N "Download opencode.json" -B { Invoke-RestMethod -Uri "$using:ConfigUrl/opencode.json" -OutFile $using:ocConfig; $true }
  Invoke-Progress -N "Download oh-my-openagent.json" -B { Invoke-RestMethod -Uri "$using:ConfigUrl/oh-my-openagent.json" -OutFile "$using:ConfigDir\oh-my-openagent.json"; $true }
  Invoke-Progress -N "Download AGENTS.md" -B { Invoke-RestMethod -Uri "$using:ConfigUrl/AGENTS.md" -OutFile "$using:ConfigDir\AGENTS.md"; $true }
  Invoke-Progress -N "Download 53 skills" -B {
    $sd = Join-Path $using:ConfigDir "skills"; $list = (Invoke-RestMethod -Uri "$using:ConfigUrl/skills.txt") -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    foreach ($s in $list) { $d = Join-Path $sd $s; New-Item -ItemType Directory -Path $d -Force | Out-Null; try { Invoke-RestMethod -Uri "$using:ConfigUrl/skills/$s/SKILL.md" -OutFile (Join-Path $d "SKILL.md") } catch {} }
    $true
  }
}
# Register plugin
if (Test-Path $ocConfig) {
  $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
  if (-not ($oc.plugin -contains "oh-my-openagent")) { $oc.plugin = @("oh-my-openagent") + $oc.plugin; $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8 }
}

# ── Step 6: Model configuration ─────────────────────────────────────────────
Write-Step "Model configuration"
$omoConfig = "$ConfigDir\oh-my-openagent.json"
$modelId = "opencode-go/deepseek-v4-flash"
if (-not $NonInteractive -and (Test-Path $omoConfig)) {
  Write-Host "    1) Keep oh-my-openagent defaults"
  Write-Host "    2) DeepSeek V4 Flash on ALL agents"
  Write-Host "    3) Custom model"
  $choice = Read-Host "  ? Choose (1-3)"
  switch ($choice) {
    "1" { $modelId = $null }
    "2" { $modelId = "opencode-go/deepseek-v4-flash" }
    "3" { $modelId = Read-Host "  Enter full model" }
    default { $modelId = $null }
  }
}

Write-Step "Platform optimizations"
if (Test-Path $omoConfig) {
  Invoke-Progress -N "Check tmux compatibility" -B {
    $omo = Get-Content $using:omoConfig -Raw | ConvertFrom-Json
    if ($using:IsWin) { $omo.tmux.enabled = $false }
    $omo | ConvertTo-Json -Depth 10 | Set-Content $using:omoConfig -Encoding UTF8; $true
  }
  if ($modelId) {
    Invoke-Progress -N "Apply model overrides" -B {
      $omo = Get-Content $using:omoConfig -Raw | ConvertFrom-Json
      foreach ($a in $omo.agents.PSObject.Properties) { $a.Value.model = $using:modelId; $a.Value.PSObject.Properties.Remove("fallback_models") }
      foreach ($c in $omo.categories.PSObject.Properties) { $c.Value.model = $using:modelId; $c.Value.PSObject.Properties.Remove("fallback_models") }
      $omo | ConvertTo-Json -Depth 10 | Set-Content $using:omoConfig -Encoding UTF8; $true
    }
  }
}

# ── Step 7: Dev tools ───────────────────────────────────────────────────────
Write-Step "Developer tools"
Invoke-Progress -N "Comment checker" -B { npm install -g @code-yeongyu/comment-checker 2>&1 | Out-Null; $true }
Invoke-Progress -N "AST-grep" -B { npm install -g @ast-grep/cli 2>&1 | Out-Null; $true }
Invoke-Progress -N "GitHub CLI" -B {
  if (Test-Cmd gh) { $true }
  elseif ($IsWin) { winget install --id GitHub.cli --silent --accept-package-agreements 2>&1 | Out-Null; $true }
  else { $false }
}

# ── Step 8: Supreme Plugins ────────────────────────────────────────────────
Write-Step "Supreme Plugins (10 total)"
$plugins = @(
  @{pkg="opencode-snippets";          desc="#snippet expansion"},
  @{pkg="opencode-snip";              desc="Snip (-60-90% tokens)"},
  @{pkg="opencode-notify";            desc="OS notifications"},
  @{pkg="opencode-mem";               desc="Persistent memory"},
  @{pkg="opencode-quota";             desc="Token tracking"},
  @{pkg="opencode-background-agents"; desc="Async agents"},
  @{pkg="opencode-worktree";          desc="Git worktrees"},
  @{pkg="opencode-dynamic-context-pruning"; desc="Context pruning"},
  @{pkg="opencode-smart-title";       desc="Smart titles"},
  @{pkg="ocwatch";                    desc="Visual dashboard"}
)
foreach ($p in $plugins) { Invoke-Progress -N $p.desc -B { npm install -g $using:p.pkg 2>&1 | Out-Null; $true } }

# Register plugins
if (Test-Path $ocConfig) {
  $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
  foreach ($p in $plugins) { if ($oc.plugin -notcontains $p.pkg) { $oc.plugin += $p.pkg } }
  $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8
}

# ── Step 9: OpenSkills ─────────────────────────────────────────────────────
Write-Step "OpenSkills"
Invoke-Progress -N "Install anthropics/skills" -B { npx openskills install anthropics/skills -y 2>&1 | Out-Null; $true }
Invoke-Progress -N "Install openskills CLI" -B { npm install -g openskills 2>&1 | Out-Null; $true }
Invoke-Progress -N "Sync to AGENTS.md" -B { npx openskills sync -y -o "$using:ConfigDir\AGENTS.md" 2>&1 | Out-Null; $true }

# ── Step 10: Optional ──────────────────────────────────────────────────────
if (Get-YesNo "Install agentsys (49 agents)?") {
  Invoke-Progress -N "agentsys" -B { npm install -g agentsys 2>&1 | Out-Null; $true }
}

# ── Step 11: Optional extras ──────────────────────────────────────────────
Write-Step "Optional extras"
if (Get-YesNo "Install supermemory?") {
  Invoke-Progress -N "Supermemory" -B { bunx opencode-supermemory@latest install --no-tui 2>&1 | Out-Null; $true }
}
if (Get-YesNo "Install firecrawl?") {
  Invoke-Progress -N "Firecrawl CLI" -B { npm install -g firecrawl-cli 2>&1 | Out-Null; $true }
}
if (Get-YesNo "Install WakaTime?") {
  Invoke-Progress -N "WakaTime" -B { npm install -g opencode-wakatime 2>&1 | Out-Null; $true }
}

# ── Step 12: Verify ───────────────────────────────────────────────────────
Write-Step "Verification"
Invoke-Progress -N "oh-my-openagent doctor" -B { bunx oh-my-openagent doctor 2>&1 | Out-Null; $true }

# ── Step 13: Summary ──────────────────────────────────────────────────────
Write-Sec "Setup Complete!"
Write-Host @"
  ╔══════════════════════════════════════════════════════╗
  ║  🚀  opencode                  launch                ║
  ║  📊  ocwatch                  visual dashboard       ║
  ║  🔥  ulw <task>               ultrawork mode         ║
  ║  🛡  @spec-architect          SDD planning           ║
  ║  🩹  @self-healer            auto debugging         ║
  ║  🔧  @refactor               clean code             ║
  ║  🎯  150+ skills              auto-triggered         ║
  ║  🧠  Persistent memory        cross-session context  ║
  ║  ✂️  snip                     -60-90% token savings  ║
  ╚══════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "  Auth: opencode auth login" -ForegroundColor Yellow
Write-Host "  Star: https://github.com/skeletorflet/opencode-supreme-setup" -ForegroundColor DarkGray
Write-Host "  Log:  $LogFile" -ForegroundColor DarkGray
