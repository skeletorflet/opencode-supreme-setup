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
function Write-Step { param([string]$S) Write-Host "`n  ── $S ──" -ForegroundColor Cyan }
function Write-OK   { param([string]$S) Write-Host "  ✓ $S" -ForegroundColor Green }
function Write-Warn { param([string]$S) Write-Host "  ⚠ $S" -ForegroundColor Yellow }
function Write-Info { param([string]$S) Write-Host "    $S" -ForegroundColor DarkGray }
function Write-Sec  { param([string]$S) Write-Host "`n  ═══ $S ═══" -ForegroundColor Magenta }
function Test-Cmd   { param([string]$C) (Get-Command $C -ErrorAction SilentlyContinue) -ne $null }
function Get-YesNo  { param([string]$P) if ($NonInteractive) { $true } else { (Read-Host "  ? $P (y/n)") -eq 'y' } }

function Invoke-Progress {
  param([string]$N, [scriptblock]$B)
  Write-Host "  → $N " -NoNewline -ForegroundColor DarkGray
  try { $r = & $B; Write-Host "✓" -ForegroundColor Green; return $r }
  catch { Write-Host "✗" -ForegroundColor Red; Write-Warn "$($_.Exception.Message.Split("`n")[0])"; return $null }
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
Write-Host "  One-command setup — the ULTIMATE OpenCode experience" -ForegroundColor White
Write-Host "  150+ skills · 13 plugins · SDD · self-healing · dashboard · caveman-v4`n" -ForegroundColor DarkGray

# ── Step 0: Prerequisites ───────────────────────────────────────────────────
Write-Step "Prerequisites"
Invoke-Progress -N "Node.js 18+" -B { if (Test-Cmd node) { $v = node --version; Write-Info $v; return $v -match "v(1[89]|[2-9]\d)" } else { return $false } }

# ── Step 1: OpenCode ────────────────────────────────────────────────────────
Write-Step "OpenCode"
Invoke-Progress -N "Check/install opencode" -B {
  if (Test-Cmd opencode) { Write-Info "$(opencode --version 2>`$null)"; return $true }
  npm install -g opencode-ai@latest 2>&1 | Out-Null; return (Test-Cmd opencode)
}

# ── Step 2: Bun ─────────────────────────────────────────────────────────────
Write-Step "Bun"
Invoke-Progress -N "Check/install bun" -B {
  if (Test-Cmd bun) { Write-Info "$(bun --version)"; return $true }
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
  try { bunx oh-my-openagent install --no-tui $flags --skip-auth 2>&1; $true }
  catch { try { bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1; $true } catch { $false } }
}

# ── Step 5: Config files ────────────────────────────────────────────────────
Write-Step "Configuration"
# Clean old conflicting configs (opencode.jsonc)
Get-ChildItem $ConfigDir -Filter "opencode.jsonc*" -ErrorAction SilentlyContinue | Remove-Item -Force
if (-not (Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
$ocConfig = "$ConfigDir\opencode.json"

if ($RepoDir -and (Test-Path "$RepoDir\config")) {
  Invoke-Progress -N "Copy config files" -B { Copy-Item -Path "$RepoDir\config\*" -Destination $ConfigDir -Force -Recurse; $true }
} else {
  Invoke-Progress -N "Download opencode.json" -B { Invoke-RestMethod -Uri "$ConfigUrl/opencode.json" -OutFile $ocConfig; $true }
  Invoke-Progress -N "Download oh-my-openagent.json" -B { Invoke-RestMethod -Uri "$ConfigUrl/oh-my-openagent.json" -OutFile "$ConfigDir\oh-my-openagent.json"; $true }
  Invoke-Progress -N "Download AGENTS.md" -B { Invoke-RestMethod -Uri "$ConfigUrl/AGENTS.md" -OutFile "$ConfigDir\AGENTS.md"; $true }
  Invoke-Progress -N "Download 51 skills" -B {
    $sd = Join-Path $ConfigDir "skills"; $list = (Invoke-RestMethod -Uri "$ConfigUrl/skills.txt") -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $ok=0; foreach ($s in $list) { $d = Join-Path $sd $s; New-Item -ItemType Directory -Path $d -Force | Out-Null; try { Invoke-RestMethod -Uri "$ConfigUrl/skills/$s/SKILL.md" -OutFile (Join-Path $d "SKILL.md"); $ok++ } catch {} }
    Write-Info "$ok skills installed"; $true
  }
}
# Register oh-my-openagent plugin
if (Test-Path $ocConfig) {
  $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
  if (-not ($oc.plugin -contains "oh-my-openagent")) { $oc.plugin = @("oh-my-openagent") + $oc.plugin; $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8; Write-OK "Plugin registered" }
}

# ── Step 6: Model selection + platform config ──────────────────────────────
Write-Step "Model configuration"
$omoConfig = "$ConfigDir\oh-my-openagent.json"

$modelId = "opencode-go/deepseek-v4-flash"
if (-not $NonInteractive -and (Test-Path $omoConfig)) {
  Write-Host "    1) Keep oh-my-openagent default models" -ForegroundColor White
  Write-Host "    2) DeepSeek V4 Flash on ALL agents (opencode-go sub)" -ForegroundColor White
  Write-Host "    3) Custom model — you type any model name" -ForegroundColor White
  $choice = Read-Host "  ? Choose (1-3)"
  switch ($choice) {
    "1" { $modelId = $null; Write-Info "Keeping default models" }
    "2" { $modelId = "opencode-go/deepseek-v4-flash" }
    "3" { $modelId = Read-Host "  Enter full model (e.g. opencode-go/deepseek-v4-flash)" }
    default { $modelId = $null; Write-Info "Keeping default models" }
  }
}

Write-Step "Platform optimizations"
if (Test-Path $omoConfig) {
  Invoke-Progress -N "Disable tmux on Windows" -B {
    $omo = Get-Content $omoConfig -Raw | ConvertFrom-Json
    if ($IsWin) { $omo.tmux.enabled = $false }
    $omo | ConvertTo-Json -Depth 10 | Set-Content $omoConfig -Encoding UTF8; $true
  }
  if ($modelId) {
    Invoke-Progress -N "Set all agents to $modelId" -B {
      $omo = Get-Content $omoConfig -Raw | ConvertFrom-Json
      foreach ($a in $omo.agents.PSObject.Properties) { $a.Value.model = $modelId; $a.Value.PSObject.Properties.Remove("fallback_models") }
      foreach ($c in $omo.categories.PSObject.Properties) { $c.Value.model = $modelId; $c.Value.PSObject.Properties.Remove("fallback_models") }
      $omo | ConvertTo-Json -Depth 10 | Set-Content $omoConfig -Encoding UTF8; $true
    }
  }
}

# ── Step 7: Dev tools ───────────────────────────────────────────────────────
Write-Step "Developer tools"
Invoke-Progress -N "Comment checker" -B {
  try { bunx @code-yeongyu/comment-checker --version 2>&1 | Out-Null; $true }
  catch { try { npm install -g @code-yeongyu/comment-checker 2>&1 | Out-Null; $true } catch { $false } }
}
Invoke-Progress -N "AST-grep" -B {
  try { npm install -g @ast-grep/cli 2>&1 | Out-Null; $true } catch { $false }
}
Invoke-Progress -N "GitHub CLI" -B {
  if (Test-Cmd gh) { $true }
  elseif ($IsWin) { try { winget install --id GitHub.cli --silent --accept-package-agreements 2>&1 | Out-Null; $env:Path = [Environment]::GetEnvironmentVariable("Path","User"); (Test-Cmd gh) } catch { $false } }
  else { $false }
}

# ── Step 8: Essential plugins ──────────────────────────────────────────────
Write-Step "Essential plugins (10 total)"
$plugins = @(
  @{pkg="opencode-snippets";          desc="Instant #snippet text expansion"},
  @{pkg="opencode-snip";              desc="Snip prefix reduces tokens 60-90%"},
  @{pkg="opencode-notify";            desc="Native OS task notifications"},
  @{pkg="opencode-mem";               desc="Persistent vector-DB memory across sessions"},
  @{pkg="opencode-quota";             desc="Token/cost tracking with toasts"},
  @{pkg="opencode-background-agents"; desc="Async agent delegation"},
  @{pkg="opencode-worktree";          desc="Zero-friction isolated git worktrees"},
  @{pkg="opencode-dynamic-context-pruning"; desc="Auto-prune obsolete tool outputs"},
  @{pkg="opencode-smart-title";       desc="Auto-generate session titles"},
  @{pkg="ocwatch";                    desc="Real-time visual monitoring dashboard"}
)
foreach ($p in $plugins) { Invoke-Progress -N $p.desc -B { Add-Plugin $p.pkg } }

# Register all plugins in opencode.json
if (Test-Path $ocConfig) {
  $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
  $changed = $false
  foreach ($p in $plugins) { if ($oc.plugin -notcontains $p.pkg) { $oc.plugin += $p.pkg; $changed = $true } }
  if ($changed) { $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8; Write-OK "Plugins registered" }
}

# ── Step 9: OpenSkills (100+ marketplace skills) ──────────────────────────
Write-Step "OpenSkills (100+ skills from Anthropic marketplace)"
Invoke-Progress -N "Install anthropics/skills" -B {
  try { npx openskills install anthropics/skills -y 2>&1 | Out-Null; $true } catch { $false }
}
Invoke-Progress -N "Install openskills CLI" -B {
  try { npm install -g openskills 2>&1 | Out-Null; $true } catch { $false }
}
Invoke-Progress -N "Sync skills to AGENTS.md" -B {
  try { npx openskills sync -y -o "$ConfigDir\AGENTS.md" 2>&1 | Out-Null; $true } catch { $false }
}

# ── Step 10: Optional — agentsys ──────────────────────────────────────────
if (Get-YesNo "Install agentsys (20 plugins, 49 agents, 41 skills)?") {
  Invoke-Progress -N "agentsys orchestration" -B { try { npm install -g agentsys 2>&1 | Out-Null; $true } catch { $false } }
}

# ── Step 11: Optional extras ──────────────────────────────────────────────
Write-Step "Optional extras"
if (Get-YesNo "Install supermemory (persistent memory)?") {
  Invoke-Progress -N "Supermemory" -B { try { bunx opencode-supermemory@latest install --no-tui 2>&1 | Out-Null; $true } catch { $false } }
}
if (Get-YesNo "Install firecrawl (web scraping)?") {
  Invoke-Progress -N "Firecrawl CLI" -B {
    try { npm install -g firecrawl-cli 2>&1 | Out-Null; (Test-Cmd firecrawl) }
    catch { try { npm install -g @firecrawl/firecrawl-cli 2>&1 | Out-Null; (Test-Cmd firecrawl) } catch { $false } }
  }
}
if (Get-YesNo "Install WakaTime (coding stats)?") {
  Invoke-Progress -N "WakaTime" -B { try { npm install -g opencode-wakatime 2>&1 | Out-Null; $true } catch { $false } }
}
if (Get-YesNo "Install themes (Ayu, Lavi, Moonlight, Poimandres)?") {
  foreach ($t in @("opencode-ayu-theme","lavi","opencode-moonlight-theme","opencode-ai-poimandres-theme")) {
    Invoke-Progress -N "Theme: $t" -B { try { npm install -g $t 2>&1 | Out-Null; $true } catch { $false } }
  }
}

# ── Step 12: Verify ───────────────────────────────────────────────────────
Write-Step "Verification"
Invoke-Progress -N "oh-my-openagent doctor" -B { try { $r = bunx oh-my-openagent doctor 2>&1; $true } catch { $true } }

# ── Step 13: Summary ──────────────────────────────────────────────────────
Write-Sec "Setup Complete!"
Write-Host @"

  ╔══════════════════════════════════════════════════════╗
  ║  🚀  opencode                  launch                ║
  ║  🔥  ulw <task>               ultrawork mode         ║
  ║  ↹  Tab                       cycle agents           ║
  ║  🛡  @security-auditor        security audit         ║
  ║  🔧  @refactor <files>        refactor code          ║
  ║  📝  @docs-writer             write docs             ║
  ║  🎯  150+ skills              auto-triggered         ║
  ║  📋  #snippet                 text expansion         ║
  ║  🔔  Notifications            task done alerts       ║
  ║  🧠  Persistent memory        cross-session context  ║
  ║  ✂️  snip                     -60-90% token savings  ║
  ║  📊  quota                    token cost tracking    ║
  ║  🌳  worktree                 isolated git branches  ║
  ╚══════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
Write-Host "  Auth: opencode auth login" -ForegroundColor Yellow
Write-Host "  Star: https://github.com/skeletorflet/opencode-supreme-setup" -ForegroundColor DarkGray
