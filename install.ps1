#!/usr/bin/env pwsh
# OpenCode Supreme Setup v4.0
param(
  [switch]$NonInteractive,
  [string]$Claude     = "",
  [string]$OpenAI     = "",
  [string]$Gemini     = "",
  [string]$Copilot    = "",
  [string]$OpenCodeGo = "yes"
)
$ErrorActionPreference = "Continue"

# ── Monokai Pastel Palette ─────────────────────────────────────────────────
$ESC    = [char]27
$R      = "$ESC[0m";  $B = "$ESC[1m";  $DIM = "$ESC[2m"
$PURPLE = "$ESC[38;5;141m"   # lavender   #AB9DF2
$GREEN  = "$ESC[38;5;114m"   # sage       #A9DC76
$YELLOW = "$ESC[38;5;222m"   # honey      #FFD866
$CYAN   = "$ESC[38;5;117m"   # sky        #78DCE8
$WHITE  = "$ESC[38;5;253m"   # soft white #F8F8F2
$GRAY   = "$ESC[38;5;242m"   # muted      #75715E
$RED    = "$ESC[38;5;203m"   # pastel red #FF5555

# Enable VT/ANSI on Windows
if ($IsWindows) {
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  try {
    Add-Type -TypeDefinition @'
using System; using System.Runtime.InteropServices;
public class VT {
  [DllImport("kernel32")] public static extern bool GetConsoleMode(IntPtr h, out uint m);
  [DllImport("kernel32")] public static extern bool SetConsoleMode(IntPtr h, uint m);
  [DllImport("kernel32")] public static extern IntPtr GetStdHandle(int n);
  public static void Enable() {
    var h=GetStdHandle(-11); uint m=0; GetConsoleMode(h,out m); SetConsoleMode(h,m|4);
  }
}
'@ -ErrorAction SilentlyContinue
    [VT]::Enable()
  } catch {}
}

# ── Paths & Logging ────────────────────────────────────────────────────────
$ScriptPath = if ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
$RepoDir    = if ($ScriptPath) { Split-Path -Parent $ScriptPath } else { $null }
$ConfUrl    = "https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"
$ConfDir    = "$env:USERPROFILE\.config\opencode"
$LogFile    = "$env:TEMP\oc_setup_$(Get-Date -Format 'yyyyMMdd_HHmm').log"
"" | Set-Content $LogFile

# ── Progress state ─────────────────────────────────────────────────────────
$script:Phase = 0; $TotalPhases = 10

# ── Header ─────────────────────────────────────────────────────────────────
function Show-Header {
  Clear-Host
  Write-Host "${PURPLE}${B}  ╭──────────────────────────────────────────────────────╮"
  Write-Host "  │  ✦  OpenCode Supreme Setup                   v4.0  │"
  Write-Host "  │     150+ skills · 13 plugins · SDD · caveman-v4     │"
  Write-Host "  ╰──────────────────────────────────────────────────────╯${R}"
}

# ── Progress bar ───────────────────────────────────────────────────────────
function Get-Bar {
  $pct   = [math]::Floor($script:Phase * 100 / $TotalPhases)
  $fill  = [math]::Floor($pct * 22 / 100)
  $empty = 22 - $fill
  "${PURPLE}$('█' * $fill)${GRAY}$('░' * $empty)${R} ${GRAY}$("{0,3}" -f $pct)%${R}"
}

# ── Section header ─────────────────────────────────────────────────────────
function Section([string]$Title) {
  $script:Phase++
  $bar = Get-Bar
  Write-Host "`n${PURPLE}${B}  ╌╌  $($Title.PadRight(36))${R}${GRAY} [$("{0:D2}" -f $script:Phase)/$("{0:D2}" -f $TotalPhases)]${R}  $bar"
}

# ── Spinner task ───────────────────────────────────────────────────────────
# Runs a scriptblock in a background job with a live spinner.
# Pass $true as last arg for "soft" (ignore failures).
$Frames = '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

function Invoke-Task {
  param([string]$Label, [scriptblock]$Body, [switch]$Soft)
  $pad = $Label.PadRight(38)
  Write-Host -NoNewline "    ${CYAN}⠋${R}  $pad"
  $job = Start-Job -ScriptBlock $Body
  $i   = 0
  while ($job.State -eq 'Running') {
    $f = $Frames[$i % 10]
    Write-Host -NoNewline "`r    ${CYAN}$f${R}  $pad"
    $i++; Start-Sleep -Milliseconds 70
  }
  $out = Receive-Job $job 2>$null; Remove-Job $job
  $out | Add-Content $LogFile -ErrorAction SilentlyContinue
  $ok = ($job.ChildJobs.Count -eq 0) -or ($job.ChildJobs[0].State -eq 'Completed')
  if ($ok) { Write-Host "`r    ${GREEN}✓${R}  ${WHITE}$pad${R}" }
  else     { Write-Host "`r    ${RED}✗${R}  ${RED}$pad${R}  ${GRAY}↳ $LogFile${R}" }
  if (-not $ok -and -not $Soft) { return $false }
  return $true
}

# ── Prompt  [Y/n]  Enter = Y ───────────────────────────────────────────────
function Ask-YN([string]$Q, [string]$Def = "y") {
  if ($NonInteractive) { return ($Def -eq "y") }
  $hint = if ($Def -eq "y") { "${GREEN}${B}Y${R}${GRAY}/n${R}" } else { "${GRAY}y/${R}${RED}${B}N${R}" }
  Write-Host -NoNewline "`n    ${YELLOW}?${R}  ${WHITE}$($Q.PadRight(42))${R}  ${GRAY}[${R}$hint${GRAY}]${R}  "
  $ans = Read-Host
  if ([string]::IsNullOrEmpty($ans)) { $ans = $Def }
  return ($ans -match '^[Yy]')
}

# ── MAIN ───────────────────────────────────────────────────────────────────
Show-Header
Write-Host "  ${GRAY}log → $LogFile${R}`n"

# ─────────────────────────────────────────── [1] Prerequisites ──────────────
Section "Prerequisites"
Invoke-Task "Node.js 18+" -Soft -Body {
  $v = node --version 2>$null
  $v -match 'v(1[89]|[2-9]\d)'
}
Invoke-Task "PowerShell 7+" -Soft -Body {
  $PSVersionTable.PSVersion.Major -ge 7
}

# ─────────────────────────────────────────── [2] Core Tools ─────────────────
Section "Core Tools"
Invoke-Task "opencode-ai" -Soft -Body {
  if (Get-Command opencode -ErrorAction SilentlyContinue) { return $true }
  npm install -g opencode-ai@latest 2>&1 | Out-Null; $true
}
Invoke-Task "bun runtime" -Soft -Body {
  if (Get-Command bun -ErrorAction SilentlyContinue) { return $true }
  npm install -g bun 2>&1 | Out-Null; $true
}

# ─────────────────────────────────────────── [3] Provider config ────────────
Section "Provider Subscriptions"
Write-Host "`n    ${GRAY}Select active subscriptions  (Enter = default shown)${R}"

if (-not $NonInteractive) {
  do {
    Write-Host -NoNewline "`n    ${YELLOW}?${R}  ${WHITE}$("Claude Pro/Max?".PadRight(42))${R}  ${GRAY}[${R}${GREEN}${B}Y${R}${GRAY}/n/max20]${R}  "
    $r = Read-Host; if ([string]::IsNullOrEmpty($r)) { $r = "n" }
  } while ($r -notin @("y","yes","n","no","max20"))
  $Claude     = switch ($r) { "max20" { "max20" } { $_ -match '^[Yy]' } { "yes" } default { "no" } }
  $OpenAI     = if (Ask-YN "ChatGPT Plus?"  "n") { "yes" } else { "no" }
  $Gemini     = if (Ask-YN "Gemini?"        "n") { "yes" } else { "no" }
  $Copilot    = if (Ask-YN "Copilot?"       "n") { "yes" } else { "no" }
  $OpenCodeGo = if (Ask-YN "OpenCode Go?"   "y") { "yes" } else { "no" }
}
$Flags = "--claude=$Claude --openai=$OpenAI --gemini=$Gemini --copilot=$Copilot --opencode-go=$OpenCodeGo"
Write-Host "`n    ${GRAY}$Flags${R}"

# ─────────────────────────────────────────── [4] oh-my-openagent ────────────
Section "oh-my-openagent"
$f = $Flags
Invoke-Task "install orchestrator" -Soft -Body {
  $args2 = $using:f -split " " | Where-Object { $_ }
  bunx oh-my-openagent install --no-tui @args2 --skip-auth 2>&1 | Out-Null; $true
}

# ─────────────────────────────────────────── [5] Config + 135 skills ────────
Section "Config + 135 Skills"
if (-not (Test-Path $ConfDir)) { New-Item -ItemType Directory -Path $ConfDir -Force | Out-Null }
$d  = $ConfDir
$u  = $ConfUrl
$rd = $RepoDir
$oc = "$ConfDir\opencode.json"

Invoke-Task "cleanup legacy jsonc" -Soft -Body {
  Get-ChildItem $using:d -Filter "opencode.jsonc*" -ErrorAction SilentlyContinue |
    Remove-Item -Force; $true
}

if ($RepoDir -and (Test-Path "$RepoDir\config")) {
  Invoke-Task "sync local config" -Soft -Body {
    Copy-Item -Path "$($using:rd)\config\*" -Destination $using:d -Force -Recurse; $true
  }
} else {
  Invoke-Task "opencode.json" -Soft -Body {
    Invoke-RestMethod "$($using:u)/opencode.json" -OutFile $using:oc; $true
  }
  Invoke-Task "oh-my-openagent.json" -Soft -Body {
    Invoke-RestMethod "$($using:u)/oh-my-openagent.json" -OutFile "$($using:d)\oh-my-openagent.json"; $true
  }
  Invoke-Task "AGENTS.md" -Soft -Body {
    Invoke-RestMethod "$($using:u)/AGENTS.md" -OutFile "$($using:d)\AGENTS.md"; $true
  }
  Invoke-Task "135 skills (bundle)" -Soft -Body {
    $sd = Join-Path $using:d "skills"
    New-Item -ItemType Directory -Path $sd -Force | Out-Null
    $bundleUrl = "$($using:u)/skills.tar.gz"
    $bundlePath = Join-Path $using:d "skills.tar.gz"
    Invoke-RestMethod $bundleUrl -OutFile $bundlePath
    tar -xzf $bundlePath -C $sd
    Remove-Item $bundlePath -Force
    $true
}

# register plugin in config
if (Test-Path $oc) {
  try {
    $cfg = Get-Content $oc -Raw | ConvertFrom-Json
    if ($cfg.plugin -notcontains "oh-my-openagent") {
      $cfg.plugin = @("oh-my-openagent") + @($cfg.plugin)
      $cfg | ConvertTo-Json -Depth 10 | Set-Content $oc -Encoding UTF8
    }
  } catch {}
}

# ─────────────────────────────────────────── [6] Model config ───────────────
Section "Model Configuration"
$ModelId = ""; $OmoCfg = "$ConfDir\oh-my-openagent.json"
if (-not $NonInteractive -and (Test-Path $OmoCfg)) {
  Write-Host ""
  Write-Host "    ${GRAY}1${R}  Keep defaults"
  Write-Host "    ${GRAY}2${R}  DeepSeek V4 Flash  ${GRAY}(recommended)${R}"
  Write-Host "    ${GRAY}3${R}  Custom model"
  Write-Host -NoNewline "`n    ${YELLOW}?${R}  ${WHITE}$("Choose".PadRight(42))${R}  ${GRAY}[${R}${GREEN}${B}1${R}${GRAY}/2/3]${R}  "
  $mc = Read-Host; if ([string]::IsNullOrEmpty($mc)) { $mc = "1" }
  switch ($mc) {
    "2" { $ModelId = "opencode-go/deepseek-v4-flash" }
    "3" { Write-Host -NoNewline "    ${WHITE}Model ID:${R} "; $ModelId = Read-Host }
  }
  if ($ModelId) { Write-Host "    ${GRAY}→ $ModelId${R}" }
}

$omo = $OmoCfg; $win = $IsWindows
Invoke-Task "tmux compatibility" -Soft -Body {
  $c = Get-Content $using:omo -Raw | ConvertFrom-Json
  if ($using:win -and $c.PSObject.Properties['tmux']) { $c.tmux.enabled = $false }
  $c | ConvertTo-Json -Depth 10 | Set-Content $using:omo -Encoding UTF8; $true
}

if ($ModelId) {
  $mid = $ModelId
  Invoke-Task "apply model: $mid" -Soft -Body {
    $c = Get-Content $using:omo -Raw | ConvertFrom-Json
    foreach ($a in $c.agents.PSObject.Properties)     { $a.Value.model = $using:mid }
    foreach ($a in $c.categories.PSObject.Properties) { $a.Value.model = $using:mid }
    $c | ConvertTo-Json -Depth 10 | Set-Content $using:omo -Encoding UTF8; $true
  }
}

# ─────────────────────────────────────────── [7] Developer Tools ────────────
Section "Developer Tools"
Invoke-Task "comment-checker" -Soft -Body { npm install -g @code-yeongyu/comment-checker 2>&1 | Out-Null; $true }
Invoke-Task "ast-grep"        -Soft -Body { npm install -g @ast-grep/cli 2>&1 | Out-Null; $true }
Invoke-Task "GitHub CLI"      -Soft -Body {
  if (Get-Command gh -ErrorAction SilentlyContinue) { $true }
  elseif ($IsWindows) { winget install --id GitHub.cli --silent --accept-package-agreements 2>&1 | Out-Null; $true }
  else { $false }
}

# ─────────────────────────────────────────── [8] Plugins (10) ───────────────
Section "Plugins  (10)"
$PluginList = @(
  @{ pkg="opencode-snippets";                 lbl="#snippet text expansion"   },
  @{ pkg="opencode-snip";                     lbl="snip  60-90% token savings"},
  @{ pkg="opencode-notify";                   lbl="OS notifications"          },
  @{ pkg="opencode-mem";                      lbl="persistent vector memory"  },
  @{ pkg="opencode-quota";                    lbl="token + cost tracking"     },
  @{ pkg="opencode-background-agents";        lbl="async agent delegation"    },
  @{ pkg="opencode-worktree";                 lbl="isolated git worktrees"    },
  @{ pkg="opencode-dynamic-context-pruning";  lbl="auto context pruning"      },
  @{ pkg="opencode-smart-title";              lbl="smart session titles"      },
  @{ pkg="ocwatch";                           lbl="visual dashboard  :3000"   }
)
foreach ($p in $PluginList) {
  $pkg = $p.pkg; $lbl = $p.lbl
  Invoke-Task $lbl -Soft -Body {
    npm install -g $using:pkg 2>&1 | Out-Null; $true
  }
}
# register in config
if (Test-Path $oc) {
  try {
    $cfg = Get-Content $oc -Raw | ConvertFrom-Json
    foreach ($p in $PluginList) {
      if ($cfg.plugin -notcontains $p.pkg) { $cfg.plugin += $p.pkg }
    }
    $cfg | ConvertTo-Json -Depth 10 | Set-Content $oc -Encoding UTF8
  } catch {}
}

# ─────────────────────────────────────────── [9] OpenSkills (100+) ──────────
Section "OpenSkills  (100+)"
Invoke-Task "anthropics/skills"  -Soft -Body { npx openskills install anthropics/skills -y 2>&1 | Out-Null; $true }
Invoke-Task "mattpocock/skills"           -Soft -Body { npx openskills install mattpocock/skills -y 2>&1 | Out-Null; $true }
Invoke-Task "JuliusBrussee/caveman"       -Soft -Body { npx openskills install JuliusBrussee/caveman -y 2>&1 | Out-Null; $true }
Invoke-Task "safishamsi/graphify"         -Soft -Body { npx openskills install safishamsi/graphify -y 2>&1 | Out-Null; $true }
Invoke-Task "nexu-io/open-design"         -Soft -Body { npx openskills install nexu-io/open-design -y 2>&1 | Out-Null; $true }
Invoke-Task "nextlevelbuilder/ui-ux-pro-max-skill" -Soft -Body { npx openskills install nextlevelbuilder/ui-ux-pro-max-skill -y 2>&1 | Out-Null; $true }
Invoke-Task "openskills CLI"     -Soft -Body { npm install -g openskills 2>&1 | Out-Null; $true }
$amd = "$ConfDir\AGENTS.md"
Invoke-Task "sync to AGENTS.md"  -Soft -Body { npx openskills sync -y -o $using:amd 2>&1 | Out-Null; $true }

# ─────────────────────────────────────────── [10] Optional Extras ───────────
Section "Optional Extras"
if (Ask-YN "agentsys  (49 agents, 20 plugins)" "n") {
  Invoke-Task "agentsys" -Soft -Body { npm install -g agentsys 2>&1 | Out-Null; $true }
}
if (Ask-YN "supermemory" "n") {
  Invoke-Task "supermemory" -Soft -Body { bunx opencode-supermemory@latest install --no-tui 2>&1 | Out-Null; $true }
}
if (Ask-YN "firecrawl" "n") {
  Invoke-Task "firecrawl" -Soft -Body { npm install -g firecrawl-cli 2>&1 | Out-Null; $true }
}
if (Ask-YN "WakaTime" "n") {
  Invoke-Task "wakatime" -Soft -Body { npm install -g opencode-wakatime 2>&1 | Out-Null; $true }
}
if (Ask-YN "Themes  (ayu / lavi / moonlight / poimandres)" "n") {
  foreach ($t in @("opencode-ayu-theme","lavi","opencode-moonlight-theme","opencode-ai-poimandres-theme")) {
    $tn = $t
    Invoke-Task $t -Soft -Body { npm install -g $using:tn 2>&1 | Out-Null; $true }
  }
}

# ── Verify ─────────────────────────────────────────────────────────────────
Write-Host "`n    ${DIM}verifying…${R}"
Invoke-Task "oh-my-openagent doctor" -Soft -Body { bunx oh-my-openagent doctor 2>&1 | Out-Null; $true }

# ── Summary ────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "${GREEN}${B}  ╭──────────────────────────────────────────────────────╮"
Write-Host "  │  ✦  Setup Complete!                                  │"
Write-Host "  ╰──────────────────────────────────────────────────────╯${R}"
Write-Host ""
@(
  @("opencode",        "launch"),
  @("ocwatch",         "visual dashboard  :3000"),
  @("ulw <task>",      "ultrawork (parallel agents)"),
  @("@spec-architect", "spec-driven development"),
  @("@self-healer",    "autonomous debugging"),
  @("@refactor",       "clean code")
) | ForEach-Object {
  Write-Host "  ${CYAN}$($_[0].PadRight(22))${R}${GRAY}→${R}  $_[1]"
}
Write-Host ""
Write-Host "  ${YELLOW}${B}opencode auth login${R}  ${GRAY}← run this first${R}"
Write-Host "  ${GRAY}log → $LogFile${R}"
Write-Host "  ${GRAY}★   https://github.com/skeletorflet/opencode-supreme-setup${R}`n"
