#!/usr/bin/env pwsh
<#
.SYNOPSIS
  Comprehensive validation test suite for opencode-supreme-setup.

.DESCRIPTION
  Validates config files, cross-references, skills ecosystem, installer
  structure, and git hygiene. Exits 0 if all pass, 1 if any fail.

.PARAMETER Strict
  Enable stricter checks: body length >= 10 lines, description >= 20 chars.

.PARAMETER Json
  Output results as JSON object instead of human-readable text.

.PARAMETER MinCount
  Minimum skill count threshold. Default: 50.
#>
param(
  [switch]$Strict,
  [switch]$Json,
  [string]$MinCount = '50'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Resolve-Path "$PSScriptRoot/.."
$passed = 0
$failed = 0
$results = @()

# ── Helpers ──────────────────────────────────────────────────────────────

function Write-TestResult {
  param([string]$Category, [string]$TestName, [bool]$Pass, [string]$Detail = '')
  $script:passed += [int]$Pass
  $script:failed += [int](-not $Pass)
  $status = if ($Pass) { 'pass' } else { 'fail' }
  $script:results += @{ category = $Category; test = $TestName; status = $status; detail = $Detail }

  if (-not $Json.IsPresent) {
    $e = [char]27
    $icon = if ($Pass) { "${e}[32m[PASS]${e}[0m" } else { "${e}[31m[FAIL]${e}[0m" }
    $d = if ($Detail) { " — $Detail" } else { '' }
    Write-Output "$icon $TestName$d"
  }
}

function Test-JsonFile($Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return $false }
  try { $null = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json; return $true }
  catch { return $false }
}

function Get-SkillDirectories {
  $dir = "$projectRoot/config/skills"
  if (-not (Test-Path -LiteralPath $dir)) { return @() }
  return Get-ChildItem -LiteralPath $dir -Directory | Where-Object { $_.Name -notlike '_*' } | ForEach-Object { $_.Name }
}

function Get-RequiredKeys($Obj, $Keys) {
  $missing = @()
  foreach ($k in $Keys) { if (-not $Obj.$k) { $missing += $k } }
  return $missing
}

# ═══════════════════════════════════════════════════════════════════════
# Category 1: Config Validates
# ═══════════════════════════════════════════════════════════════════════
if (-not $Json.IsPresent) { Write-Output "`n=== Config Validates ===" }

$cat = 'Config Validates'

# 1.1 opencode.json
$ocPath = "$projectRoot/config/opencode.json"
$ocExists = Test-Path -LiteralPath $ocPath
Write-TestResult $cat 'opencode.json exists' $ocExists

if ($ocExists) {
  $ocValid = Test-JsonFile $ocPath
  Write-TestResult $cat 'opencode.json is valid JSON' $ocValid
  if ($ocValid) {
    $oc = Get-Content -LiteralPath $ocPath -Raw | ConvertFrom-Json
    $missing = Get-RequiredKeys $oc @('model', 'default_agent', 'plugin', 'agent', 'skills')
    $detail = if ($missing.Count -gt 0) { "missing: $($missing -join ', ')" } else { '' }
    Write-TestResult $cat 'opencode.json has required keys' ($missing.Count -eq 0) $detail
  }
} else {
  Write-TestResult $cat 'opencode.json is valid JSON' $false 'file not found'
  Write-TestResult $cat 'opencode.json has required keys' $false 'file not found'
}

# 1.2 oh-my-openagent.json
$ohPath = "$projectRoot/config/oh-my-openagent.json"
$ohExists = Test-Path -LiteralPath $ohPath
Write-TestResult $cat 'oh-my-openagent.json exists' $ohExists

if ($ohExists) {
  $ohValid = Test-JsonFile $ohPath
  Write-TestResult $cat 'oh-my-openagent.json is valid JSON' $ohValid
  if ($ohValid) {
    $oh = Get-Content -LiteralPath $ohPath -Raw | ConvertFrom-Json
    $detail = if ($missing.Count -gt 0) { "missing: $($missing -join ', ')" } else { '' }
    Write-TestResult $cat 'oh-my-openagent.json has required keys' ($missing.Count -eq 0) $detail
  }
} else {
  Write-TestResult $cat 'oh-my-openagent.json is valid JSON' $false 'file not found'
  Write-TestResult $cat 'oh-my-openagent.json has required keys' $false 'file not found'
}

# 1.3 AGENTS.md
$agentsMd = "$projectRoot/config/AGENTS.md"
$agentsExists = Test-Path -LiteralPath $agentsMd
$agentsNonEmpty = $agentsExists -and ((Get-Content -LiteralPath $agentsMd).Count -gt 10)
Write-TestResult $cat 'config/AGENTS.md exists and non-empty' $agentsNonEmpty

# ═══════════════════════════════════════════════════════════════════════
# Category 2: Cross-Reference Consistency
# ═══════════════════════════════════════════════════════════════════════
if (-not $Json.IsPresent) { Write-Output "`n=== Cross-Reference Consistency ===" }

$cat = 'Cross-Reference Consistency'

# 2.1 Plugin consistency
if ($ocExists -and $ocValid) {
  $plugins = $oc.plugin
  $dupPlugins = $plugins | Group-Object | Where-Object { $_.Count -gt 1 }
  $detail = if ($dupPlugins.Count -gt 0) { "duplicates: $($dupPlugins.Name -join ', ')" } else { '' }
  Write-TestResult $cat 'No duplicate plugin entries' ($dupPlugins.Count -eq 0) $detail
  $validNames = $plugins | Where-Object { $_ -match '^[\w\-\.]+$' }
  Write-TestResult $cat 'All plugin names are valid' ($validNames.Count -eq $plugins.Count)
}

# 2.2 Agent definitions in opencode.json
if ($ocExists -and $ocValid) {
  $agents = $oc.agent
  $agentNames = $agents.PSObject.Properties.Name
  $badAgents = @()
  foreach ($an in $agentNames) {
    $a = $agents.$an
    if (-not $a.mode -or -not $a.description -or -not $a.model -or -not $a.prompt) { $badAgents += $an }
  }
  $detail = if ($badAgents.Count -gt 0) { "incomplete: $($badAgents -join ', ')" } else { '' }
  Write-TestResult $cat 'All agents have mode/description/model/prompt' ($badAgents.Count -eq 0) $detail
}

# 2.3 Agent configs in oh-my-openagent.json
if ($ohExists -and $ohValid) {
  $ohAgents = $oh.agents
  $ohAgentNames = $ohAgents.PSObject.Properties.Name
  $noModel = @()
  foreach ($an in $ohAgentNames) {
    if (-not $ohAgents.$an.model) { $noModel += $an }
  }
  $detail = if ($noModel.Count -gt 0) { "no model: $($noModel -join ', ')" } else { '' }
  Write-TestResult $cat 'All oh-my-openagent agents have model' ($noModel.Count -eq 0) $detail
}

# ═══════════════════════════════════════════════════════════════════════
# Category 3: Skills Ecosystem
# ═══════════════════════════════════════════════════════════════════════
if (-not $Json.IsPresent) { Write-Output "`n=== Skills Ecosystem ===" }

$cat = 'Skills Ecosystem'

$skillsDir = "$projectRoot/config/skills"
$skillsDirExists = Test-Path -LiteralPath $skillsDir
Write-TestResult $cat 'config/skills/ directory exists' $skillsDirExists

if ($skillsDirExists) {
  $skillDirs = Get-SkillDirectories
  $skillsCount = $skillDirs.Count
  Write-TestResult $cat "Skills count: $skillsCount" ($skillsCount -ge [int]$MinCount) "minimum: $MinCount"

  $missingSkMd = @()
  $badFrontmatter = @()
  $badDesc = @()
  $shortBody = @()
  $shortDesc = @()

  foreach ($s in $skillDirs) {
    $md = "$skillsDir/$s/SKILL.md"
    if (-not (Test-Path -LiteralPath $md)) { $missingSkMd += $s; continue }

    $content = Get-Content -LiteralPath $md -Raw
    $lines = $content -split "`n"

    # frontmatter check
    if ($lines.Count -lt 1 -or $lines[0].Trim() -ne '---') {
      $badFrontmatter += $s
    }

    # description field
    if ($content -notmatch '(?m)^description:\s*.+') {
      $badDesc += $s
    }

    if ($Strict.IsPresent) {
      # body length after frontmatter
      $bodyStart = -1
      for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq '---') { $bodyStart = $i + 1; break }
      }
      $bodyLines = 0
      if ($bodyStart -gt 0 -and $bodyStart -lt $lines.Count) {
        $bodyLines = ($lines | Select-Object -Skip $bodyStart | Where-Object { $_.Trim() -ne '' }).Count
      }
      if ($bodyLines -lt 10) { $shortBody += "$s ($bodyLines lines)" }

      # description quality
      if ($content -match '(?m)^description:\s*(.+)') {
        $descText = $Matches[1].Trim()
        if ($descText.Length -lt 20) { $shortDesc += "$s ($($descText.Length) chars)" }
      }
    }
  }

  $detail = if ($missingSkMd.Count -gt 0) { "missing: $($missingSkMd -join ', ')" } else { '' }
  Write-TestResult $cat 'All skill dirs have SKILL.md' ($missingSkMd.Count -eq 0) $detail
  $detail = if ($badFrontmatter.Count -gt 0) { "bad: $($badFrontmatter -join ', ')" } else { '' }
  Write-TestResult $cat 'All SKILL.md have frontmatter (---)' ($badFrontmatter.Count -eq 0) $detail
  $detail = if ($badDesc.Count -gt 0) { "missing: $($badDesc -join ', ')" } else { '' }
  Write-TestResult $cat 'All SKILL.md have description field' ($badDesc.Count -eq 0) $detail

  if ($Strict.IsPresent) {
    $detail = if ($shortBody.Count -gt 0) { "short: $($shortBody -join ', ')" } else { '' }
    Write-TestResult $cat 'SKILL.md body >= 10 lines (strict)' ($shortBody.Count -eq 0) $detail
    $detail = if ($shortDesc.Count -gt 0) { "short: $($shortDesc -join ', ')" } else { '' }
    Write-TestResult $cat 'Description >= 20 chars (strict)' ($shortDesc.Count -eq 0) $detail
  }

  # skills.txt cross-ref
  $skillsTxt = "$projectRoot/config/skills.txt"
  $skillsTxtExists = Test-Path -LiteralPath $skillsTxt
  Write-TestResult $cat 'skills.txt exists' $skillsTxtExists

  if ($skillsTxtExists) {
    $txtSkills = @()
    Get-Content -LiteralPath $skillsTxt | Where-Object { $_.Trim() -ne '' } | ForEach-Object {
      $parts = $_ -split '\|'
      if ($parts.Count -ge 2) { $txtSkills += $parts[1].Trim() } else { $txtSkills += $_.Trim() }
    }

    $missingFromTxt = $skillDirs | Where-Object { $_ -notin $txtSkills }
    $missingFromFs = $txtSkills | Where-Object { $_ -notin $skillDirs }

    $txtInSync = ($missingFromTxt.Count -eq 0 -and $missingFromFs.Count -eq 0)
    $detailTxt = if (-not $txtInSync) {
      $parts = @()
      if ($missingFromTxt.Count -gt 0) { $parts += "fs->txt: $($missingFromTxt -join ',')" }
      if ($missingFromFs.Count -gt 0) { $parts += "txt->fs: $($missingFromFs -join ',')" }
      $parts -join '; '
    } else { '' }
    Write-TestResult $cat 'skills.txt matches filesystem' $txtInSync $detailTxt
  }
}

# ═══════════════════════════════════════════════════════════════════════
# Category 4: Installer Structure
# ═══════════════════════════════════════════════════════════════════════
if (-not $Json.IsPresent) { Write-Output "`n=== Installer Structure ===" }

$cat = 'Installer Structure'

$installPs1 = "$projectRoot/install.ps1"
$installSh = "$projectRoot/install.sh"
$uninstallPs1 = "$projectRoot/uninstall.ps1"
$uninstallSh = "$projectRoot/uninstall.sh"

# Shebang checks
$ips1Ok = Test-Path -LiteralPath $installPs1
$ips1Shebang = $ips1Ok -and ((Get-Content -LiteralPath $installPs1 -TotalCount 1) -match 'pwsh')
Write-TestResult $cat 'install.ps1 has pwsh shebang' $ips1Shebang

$ishOk = Test-Path -LiteralPath $installSh
$ishShebang = $ishOk -and ((Get-Content -LiteralPath $installSh -TotalCount 1) -match 'bash')
Write-TestResult $cat 'install.sh has bash shebang' $ishShebang

Write-TestResult $cat 'uninstall.ps1 exists' (Test-Path -LiteralPath $uninstallPs1)
Write-TestResult $cat 'uninstall.sh exists' (Test-Path -LiteralPath $uninstallSh)

# README
$readme = "$projectRoot/README.md"
$readmeOk = Test-Path -LiteralPath $readme
$readmeContent = if ($readmeOk) { Get-Content -LiteralPath $readme -Raw } else { '' }
$hasWhatYouGet = $readmeContent -match 'What You Get'
$hasQuickInstall = $readmeContent -match 'Quick Install'
Write-TestResult $cat 'README.md has "What You Get" section' $hasWhatYouGet
Write-TestResult $cat 'README.md has "Quick Install" section' $hasQuickInstall

# ═══════════════════════════════════════════════════════════════════════
# Category 5: Git Hygiene
# ═══════════════════════════════════════════════════════════════════════
if (-not $Json.IsPresent) { Write-Output "`n=== Git Hygiene ===" }

$cat = 'Git Hygiene'

Write-TestResult $cat '.gitignore exists' (Test-Path -LiteralPath "$projectRoot/.gitignore")
Write-TestResult $cat '.gitattributes exists' (Test-Path -LiteralPath "$projectRoot/.gitattributes")
Write-TestResult $cat 'LICENSE exists' (
  (Test-Path -LiteralPath "$projectRoot/LICENSE") -or (Test-Path -LiteralPath "$projectRoot/LICENSE.md")
)
Write-TestResult $cat 'CONTRIBUTING.md exists' (Test-Path -LiteralPath "$projectRoot/CONTRIBUTING.md")

# ═══════════════════════════════════════════════════════════════════════
# Results
# ═══════════════════════════════════════════════════════════════════════
$total = $passed + $failed
$allPass = $failed -eq 0

if ($Json.IsPresent) {
  $output = @{
    passed  = $passed
    failed  = $failed
    total   = $total
    results = $results
  }
  $output | ConvertTo-Json
} else {
  Write-Output "`nResults: $passed passed, $failed failed, $total total"
}

exit $(if ($allPass) { 0 } else { 1 })
