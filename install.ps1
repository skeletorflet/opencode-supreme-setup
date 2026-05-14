#!/usr/bin/env pwsh
# OpenCode Supreme Setup - Windows PowerShell Installer
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

function Write-Step   { param([string]$Msg) Write-Host "`n[STEP] $Msg" -ForegroundColor Cyan }
function Write-OK     { param([string]$Msg) Write-Host "  [OK] $Msg" -ForegroundColor Green }
function Write-Warn   { param([string]$Msg) Write-Host "  [!] $Msg" -ForegroundColor Yellow }
function Write-Info   { param([string]$Msg) Write-Host "  [i] $Msg" -ForegroundColor DarkGray }
function Test-Cmd     { param([string]$Cmd) (Get-Command $Cmd -ErrorAction SilentlyContinue) -ne $null }
function Get-YesNo    { param([string]$Prompt) if ($NonInteractive) { return $true } else { return (Read-Host "$Prompt (y/n)") -eq 'y' } }

Clear-Host
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  OpenCode Supreme Setup" -ForegroundColor Cyan
Write-Host "  oh-my-openagent + Caveman + DeepSeek" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# STEP 0: Check Node.js
Write-Step "Checking Node.js..."
if (Test-Cmd node) {
  $nodeVer = node --version
  Write-OK "Node.js $nodeVer"
} else {
  Write-Warn "Node.js not found. Download from https://nodejs.org (18+ LTS)"
  Start-Process "https://nodejs.org"
  exit 1
}

# STEP 1: Install OpenCode
Write-Step "Checking OpenCode..."
if (Test-Cmd opencode) {
  $ver = opencode --version 2>$null
  Write-OK "OpenCode $ver"
} else {
  Write-Warn "Installing OpenCode..."
  npm install -g opencode-ai@latest 2>&1 | Out-Null
  if (Test-Cmd opencode) { Write-OK "OpenCode installed" } else { Write-Warn "Install failed. See https://opencode.ai/docs" }
}

# STEP 2: Install Bun
Write-Step "Checking Bun..."
if (Test-Cmd bun) {
  Write-OK "Bun $(bun --version)"
} else {
  Write-Warn "Installing Bun..."
  npm install -g bun 2>&1 | Out-Null
  if (Test-Cmd bun) { Write-OK "Bun installed" } else { Write-Warn "Bun install failed" }
}

# STEP 3: Subscription flags
Write-Step "Subscription configuration"
if (-not $NonInteractive) {
  $input = $null; while ($null -eq $input) {
    $r = Read-Host "Do you have Claude Pro/Max? (y/n/max20)"
    if ($r -eq 'y') { $Claude = 'yes'; $input = $true }
    elseif ($r -eq 'max20') { $Claude = 'max20'; $input = $true }
    elseif ($r -eq 'n') { $Claude = 'no'; $input = $true }
    else { Write-Warn "Enter y, n, or max20" }
  }
  if (-not $OpenAI) { $OpenAI = if ((Read-Host "ChatGPT Plus? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $Gemini) { $Gemini = if ((Read-Host "Integrate Gemini? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $Copilot) { $Copilot = if ((Read-Host "GitHub Copilot? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
  if (-not $OpenCodeGo) { $OpenCodeGo = if ((Read-Host "OpenCode Go (\$10/mo)? (y/n)") -eq 'y') { 'yes' } else { 'no' } }
}
$flags = "--claude=$Claude --openai=$OpenAI --gemini=$Gemini --copilot=$Copilot --opencode-go=$OpenCodeGo"
Write-Info "Flags: $flags"

# STEP 4: Install oh-my-openagent
Write-Step "Installing oh-my-openagent..."
try {
  $output = bunx oh-my-openagent install --no-tui $flags --skip-auth 2>&1
  Write-OK "oh-my-openagent installed"
} catch {
  Write-Warn "First attempt failed, trying fallback..."
  $output = bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1
  Write-OK "oh-my-openagent installed (fallback)"
}

# STEP 5: Register plugin in opencode.json if missing
Write-Step "Registering plugin..."
$ocConfig = "$ConfigDir\opencode.json"
if (Test-Path $ocConfig) {
  $oc = Get-Content $ocConfig -Raw | ConvertFrom-Json
  if (-not ($oc.plugin -contains "oh-my-openagent")) {
    $oc.plugin = @("oh-my-openagent")
    $oc | ConvertTo-Json -Depth 10 | Set-Content $ocConfig -Encoding UTF8
    Write-OK "oh-my-openagent registered in opencode.json"
  } else {
    Write-OK "Already registered"
  }
} else {
  Write-Warn "opencode.json not found at $ocConfig — plugin entry may need manual setup"
}

# STEP 6: Copy config files
Write-Step "Copying configuration files..."
if (-not (Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
if ($RepoDir -and (Test-Path "$RepoDir\config")) {
  Copy-Item -Path "$RepoDir\config\*" -Destination $ConfigDir -Force -Recurse
  Write-OK "Config files copied from local repo"
} else {
  Write-Info "Downloading config files from GitHub..."
  $files = @("opencode.json", "oh-my-openagent.json", "AGENTS.md")
  foreach ($f in $files) {
    try { Invoke-RestMethod -Uri "$ConfigUrl/$f" -OutFile (Join-Path $ConfigDir $f); Write-OK "Downloaded $f" }
    catch { Write-Warn "Failed $f" }
  }
  Write-Info "Downloading skills..."
  try {
    $skillsDir = Join-Path $ConfigDir "skills"
    $skillsRaw = Invoke-RestMethod -Uri "$ConfigUrl/skills.txt"
    $skillsList = $skillsRaw -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    foreach ($s in $skillsList) {
      $skillDir = Join-Path $skillsDir $s
      New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
      Invoke-RestMethod -Uri "$ConfigUrl/skills/$s/SKILL.md" -OutFile (Join-Path $skillDir "SKILL.md")
      Write-OK "  skill: $s"
    }
  } catch { Write-Warn "Skills download issue: $_" }
}

# STEP 7: Fix oh-my-openagent.json for platform
Write-Step "Optimizing config for platform..."
$omoConfig = "$ConfigDir\oh-my-openagent.json"
if (Test-Path $omoConfig) {
  $omo = Get-Content $omoConfig -Raw | ConvertFrom-Json
  if ($IsWin) {
    $omo.tmux.enabled = $false
  }
  # Deepset model on all agents/categories
  foreach ($a in $omo.agents.PSObject.Properties) { $a.Value.model = "opencode-go/deepseek-v4-flash"; $a.Value.PSObject.Properties.Remove("fallback_models") }
  foreach ($c in $omo.categories.PSObject.Properties) { $c.Value.model = "opencode-go/deepseek-v4-flash"; $c.Value.PSObject.Properties.Remove("fallback_models") }
  $omo | ConvertTo-Json -Depth 10 | Set-Content $omoConfig -Encoding UTF8
  Write-OK "oh-my-openagent.json optimized"
}

# STEP 8: Install comment-checker
Write-Step "Installing comment-checker..."
try {
  bunx @code-yeongyu/comment-checker --version 2>&1 | Out-Null
  Write-OK "Comment checker available"
} catch {
  try {
    bun add -g @code-yeongyu/comment-checker 2>&1 | Out-Null
    Write-OK "Comment checker installed"
  } catch {
    try { npm install -g @code-yeongyu/comment-checker 2>&1 | Out-Null; Write-OK "Comment checker installed" }
    catch { Write-Warn "Comment checker skipped" }
  }
}

# STEP 9: Install GitHub CLI
Write-Step "Checking GitHub CLI..."
if (Test-Cmd gh) {
  Write-OK "gh $(gh --version | Select-Object -First 1)"
} elseif ($IsWin) {
  try {
    winget install --id GitHub.cli --silent --accept-package-agreements 2>&1 | Out-Null
    $env:Path = [Environment]::GetEnvironmentVariable("Path","User") + ";" + [Environment]::GetEnvironmentVariable("Path","Machine")
    if (Test-Cmd gh) { Write-OK "GitHub CLI installed via winget" } else { Write-Warn "gh CLI install attempted — may need restart" }
  } catch { Write-Warn "gh CLI install failed. Install from https://cli.github.com/" }
} else {
  Write-Warn "Skipping gh CLI (not on Windows). Install from https://cli.github.com/"
}

# STEP 10: Optional plugins
Write-Step "Optional plugins"
if (Get-YesNo "Install opencode-supermemory (persistent memory)?") {
  try { bunx opencode-supermemory@latest install --no-tui 2>&1; Write-OK "Supermemory installed" }
  catch { Write-Warn "Supermemory failed" }
}
if (Get-YesNo "Install firecrawl (web scraping)?") {
  try {
    $fc = npm install -g firecrawl-cli 2>&1
    if ($LASTEXITCODE -eq 0) { Write-OK "Firecrawl CLI installed" }
    else { throw "exit $LASTEXITCODE" }
  } catch {
    try {
      npm install -g @firecrawl/firecrawl-cli 2>&1 | Out-Null
      if (Test-Cmd firecrawl) { Write-OK "Firecrawl CLI installed (@firecrawl)" }
      else { Write-Warn "Firecrawl install failed. Try: npm install -g @firecrawl/firecrawl-cli" }
    } catch { Write-Warn "Firecrawl install failed" }
  }
}

# STEP 11: Verify
Write-Step "Verifying setup..."
try { bunx oh-my-openagent doctor 2>&1 } catch { Write-Warn "Doctor check skipped" }

# STEP 12: Auth guidance
Write-Step "Authentication"
Write-Host "`nAuthenticate your providers when ready:`n" -ForegroundColor Yellow
if ($OpenCodeGo -eq 'yes') { Write-Host "  opencode auth login" -ForegroundColor White }
if ($Claude -eq 'yes' -or $Claude -eq 'max20') { Write-Host "  opencode auth login" -ForegroundColor White }
if ($OpenAI -eq 'yes') { Write-Host "  opencode auth login" -ForegroundColor White }

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "`nQuick start:" -ForegroundColor Cyan
Write-Host "  1. opencode              # Launch" -ForegroundColor White
Write-Host "  2. ulw your task         # Ultrawork mode" -ForegroundColor White
Write-Host "  3. Tab to cycle agents   # build / plan / caveman" -ForegroundColor White
Write-Host "  4. @security-auditor     # Security audit" -ForegroundColor White
Write-Host "  5. @refactor <files>     # Refactor code" -ForegroundColor White
Write-Host "  6. @docs-writer          # Write docs" -ForegroundColor White
Write-Host "  7. use skills            # 50+ built-in skills" -ForegroundColor White
Write-Host "`nStar the repo if helpful!" -ForegroundColor Yellow
