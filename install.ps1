#!/usr/bin/env pwsh
# OpenCode Supreme Setup - Windows PowerShell Installer
# One-command setup with oh-my-openagent, caveman mode, and deepseek-v4-flash

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigDir = "$env:USERPROFILE\.config\opencode"
$HostUI = (Get-Host).UI.RawUI
if ($HostUI) { $HostUI.ForegroundColor = "Green" }

function Write-Step {
    param([string]$Msg)
    Write-Host "`n[STEP] $Msg" -ForegroundColor Cyan
}

function Write-OK {
    param([string]$Msg)
    Write-Host "  [OK] $Msg" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Msg)
    Write-Host "  [!] $Msg" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Msg)
    Write-Host "  [i] $Msg" -ForegroundColor DarkGray
}

function Test-Command {
    param([string]$Cmd)
    return (Get-Command $Cmd -ErrorAction SilentlyContinue) -ne $null
}

clear
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  OpenCode Supreme Setup" -ForegroundColor Cyan
Write-Host "  oh-my-openagent + Caveman + DeepSeek" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# === STEP 0: Check OpenCode ===
Write-Step "Checking OpenCode installation..."
if (Test-Command opencode) {
    $ver = opencode --version 2>$null
    Write-OK "OpenCode $ver is installed"
} else {
    Write-Warn "OpenCode not found. Installing..."
    Write-Info "You can also install manually: https://opencode.ai/docs"
    try {
        npm install -g opencode-ai@latest 2>&1 | Out-Null
        Write-OK "OpenCode installed"
    } catch {
        Write-Warn "Could not install OpenCode via npm. Install manually: https://opencode.ai/docs"
        $manualInstall = $true
    }
}

# === STEP 1: Check Bun ===
Write-Step "Checking Bun..."
if (Test-Command bun) {
    $bunVer = bun --version
    Write-OK "Bun $bunVer is installed"
} else {
    Write-Warn "Bun not found. Installing..."
    npm install -g bun 2>&1 | Out-Null
    Write-OK "Bun installed"
}

# === STEP 2: Ask subscription questions ===
Write-Step "Subscription configuration"

$hasClaude = $null
while ($null -eq $hasClaude) {
    $input = Read-Host "Do you have Claude Pro/Max? (y/n/max20)"
    if ($input -eq 'y') { $claudeFlag = '--claude=yes'; $hasClaude = $true }
    elseif ($input -eq 'max20') { $claudeFlag = '--claude=max20'; $hasClaude = $true }
    elseif ($input -eq 'n') { $claudeFlag = '--claude=no'; $hasClaude = $false }
    else { Write-Warn "Enter y, n, or max20" }
}

$hasOpenAI = (Read-Host "ChatGPT Plus subscription? (y/n)") -eq 'y'
$openaiFlag = if ($hasOpenAI) { '--openai=yes' } else { '--openai=no' }

$hasGemini = (Read-Host "Integrate Gemini models? (y/n)") -eq 'y'
$geminiFlag = if ($hasGemini) { '--gemini=yes' } else { '--gemini=no' }

$hasCopilot = (Read-Host "GitHub Copilot subscription? (y/n)") -eq 'y'
$copilotFlag = if ($hasCopilot) { '--copilot=yes' } else { '--copilot=no' }

$hasOpenCodeGo = (Read-Host "OpenCode Go subscription (\$10/mo)? (y/n)") -eq 'y'
$opencodeGoFlag = if ($hasOpenCodeGo) { '--opencode-go=yes' } else { '--opencode-go=no' }

Write-Info "Claude=$claudeFlag OpenAI=$openaiFlag Gemini=$geminiFlag Copilot=$copilotFlag OpenCodeGo=$opencodeGoFlag"

# === STEP 3: Install oh-my-openagent ===
Write-Step "Installing oh-my-openagent..."
$installCmd = "bunx oh-my-openagent install --no-tui $claudeFlag $openaiFlag $geminiFlag $copilotFlag $opencodeGoFlag --skip-auth 2>&1"
Write-Info "Running: bunx oh-my-openagent install --no-tui ..."
try {
    Invoke-Expression $installCmd
    Write-OK "oh-my-openagent installed"
} catch {
    Write-Warn "Install failed: $_"
    Write-Info "Trying again with fallback..."
    Invoke-Expression "bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1"
    Write-OK "oh-my-openagent installed (fallback mode)"
}

# === STEP 4: Copy config files ===
Write-Step "Copying configuration files..."
if (Test-Path "$RepoDir\config") {
    if (-not (Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    }
    Copy-Item -Path "$RepoDir\config\*" -Destination $ConfigDir -Force -Recurse
    Write-OK "Config files copied to $ConfigDir"
} else {
    Write-Warn "No config/ directory found in repo"
}

# === STEP 5: Set deepseek-v4-flash on ALL agents ===
Write-Step "Setting all agents to deepseek-v4-flash..."
$omoConfig = "$ConfigDir\oh-my-openagent.json"
if (Test-Path $omoConfig) {
    $config = Get-Content $omoConfig -Raw | ConvertFrom-Json
    # Walk all agents and categories, set model to deepseek-v4-flash, remove fallbacks
    $agents = $config.agents.PSObject.Properties
    foreach ($a in $agents) {
        $a.Value.model = "opencode-go/deepseek-v4-flash"
        if ($a.Value.PSObject.Properties.Name -contains "fallback_models") {
            $a.Value.PSObject.Properties.Remove("fallback_models")
        }
    }
    $cats = $config.categories.PSObject.Properties
    foreach ($c in $cats) {
        $c.Value.model = "opencode-go/deepseek-v4-flash"
        if ($c.Value.PSObject.Properties.Name -contains "fallback_models") {
            $c.Value.PSObject.Properties.Remove("fallback_models")
        }
    }
    $config | ConvertTo-Json -Depth 10 | Set-Content $omoConfig -Encoding UTF8
    Write-OK "All agents set to opencode-go/deepseek-v4-flash"
} else {
    Write-Warn "oh-my-openagent.json not found, skipping model override"
}

# === STEP 6: Optional plugins ===
Write-Step "Optional plugins"
if ((Read-Host "Install opencode-supermemory (persistent memory)? (y/n)") -eq 'y') {
    try {
        Invoke-Expression "bunx opencode-supermemory@latest install --no-tui 2>&1"
        Write-OK "Supermemory installed"
        Write-Info "Set API key later: export SUPERMEMORY_API_KEY=sm_..."
    } catch {
        Write-Warn "Supermemory install failed"
    }
}

if ((Read-Host "Install firecrawl (web scraping)? (y/n)") -eq 'y') {
    try {
        npm install -g firecrawl-cli 2>&1 | Out-Null
        Write-OK "Firecrawl CLI installed"
        Write-Info "Login later: firecrawl login --browser"
    } catch {
        Write-Warn "Firecrawl install failed"
    }
}

# === STEP 7: Verify ===
Write-Step "Verifying setup..."
try {
    Invoke-Expression "bunx oh-my-openagent doctor 2>&1"
} catch {
    Write-Warn "Doctor check skipped"
}

# === STEP 8: Auth guidance ===
Write-Step "Authentication"
Write-Host "`nYou need to authenticate your providers. Run these when ready:`n" -ForegroundColor Yellow
if ($hasOpenCodeGo) {
    Write-Host "  opencode auth login  -> Select OpenCode Go -> Paste API key" -ForegroundColor White
}
if ($hasClaude) {
    Write-Host "  opencode auth login  -> Select Anthropic -> OAuth" -ForegroundColor White
}
if ($hasOpenAI) {
    Write-Host "  opencode auth login  -> Select OpenAI -> Paste API key" -ForegroundColor White
}
if ($hasGemini) {
    Write-Host "  opencode auth login  -> Select Google -> OAuth" -ForegroundColor White
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "`nQuick start:" -ForegroundColor Cyan
Write-Host "  1. opencode                  # Launch" -ForegroundColor White
Write-Host "  2. ulw <your task>           # Ultrawork mode" -ForegroundColor White
Write-Host "  3. Tab to cycle: build/plan/caveman" -ForegroundColor White
Write-Host "  4. @security-auditor         # Security audit" -ForegroundColor White
Write-Host "  5. @refactor <files>         # Refactor code" -ForegroundColor White
Write-Host "  6. @docs-writer              # Write docs" -ForegroundColor White
Write-Host "`nIf you found this helpful, star the repo!" -ForegroundColor Yellow
