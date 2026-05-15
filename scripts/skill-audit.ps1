#!/usr/bin/env pwsh
<#
.SYNOPSIS
  Audits all skill SKILL.md files for structure and completeness.

.DESCRIPTION
  Scans config/skills/<name>/SKILL.md, skipping _template.
  Checks frontmatter (---), description: field, counts lines.

.PARAMETER Format
  Output format: md, json, or check.
  md     - Markdown table with | Skill | Lines | Status |
  json   - JSON with {count, skills[], timestamp}
  check  - Exit 0 if all valid, exit 1 if any issues

.EXAMPLE
  .\scripts\skill-audit.ps1 -Format md

.EXAMPLE
  .\scripts\skill-audit.ps1 -Format json

.EXAMPLE
  .\scripts\skill-audit.ps1 -Format check
#>

param(
  [ValidateSet('md', 'json', 'check')]
  [string]$Format = 'md'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Resolve-Path "$PSScriptRoot/.."
$skillsDir = "$projectRoot/config/skills"

if (-not (Test-Path -LiteralPath $skillsDir)) {
  Write-Error "Skills directory not found: $skillsDir"
  exit 1
}

$results = @()
$allValid = $true

Get-ChildItem -LiteralPath $skillsDir -Directory | Where-Object { $_.Name -notlike '_*' } | ForEach-Object {
  $name = $_.Name
  $mdPath = Join-Path $_.FullName 'SKILL.md'
  if (-not (Test-Path -LiteralPath $mdPath)) { return }

  $content = Get-Content -LiteralPath $mdPath -Raw
  $lines = $content -split "`n"
  $totalLines = $lines.Count
  $hasFrontmatter = $content -match '^---'
  $hasDescription = $content -match '(?m)^description:\s*.+'
  $valid = $hasFrontmatter -and $hasDescription

  if (-not $valid) { $allValid = $false }

  $results += [PSCustomObject]@{
    Name           = $name
    TotalLines     = $totalLines
    HasFrontmatter = $hasFrontmatter
    HasDescription = $hasDescription
    Valid          = $valid
  }
}

$count = $results.Count
$timestamp = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')

switch ($Format) {
  'json' {
    $jsonResult = @{
      count     = $count
      skills    = $results | ForEach-Object {
        @{
          name            = $_.Name
          lines           = $_.TotalLines
          has_frontmatter = $_.HasFrontmatter
          has_description = $_.HasDescription
          valid           = $_.Valid
        }
      }
      timestamp = $timestamp
      all_valid = $allValid
    }
    $jsonResult | ConvertTo-Json
  }
  'md' {
    Write-Output "| Skill | Lines | Frontmatter | Description | Status |"
    Write-Output "|-------|-------|-------------|-------------|--------|"
    $results | Sort-Object Name | ForEach-Object {
      $icon = if ($_.Valid) { '✅' } else { '❌' }
      $fmIcon = if ($_.HasFrontmatter) { '✅' } else { '❌' }
      $descIcon = if ($_.HasDescription) { '✅' } else { '❌' }
      Write-Output "| $($_.Name) | $($_.TotalLines) | $fmIcon | $descIcon | $icon |"
    }
    Write-Output ""
    $statusText = if ($allValid) { 'all valid' } else { 'issues found' }
    Write-Output "**$count skills audited — $statusText**"
  }
  'check' {
    if ($allValid) { Write-Output "OK: $count skills all valid"; exit 0 }
    $failed = $results | Where-Object { -not $_.Valid }
    Write-Output "FAIL: $count skills audited, some have issues"
    $failed | ForEach-Object {
      $issues = @()
      if (-not $_.HasFrontmatter) { $issues += 'missing frontmatter' }
      if (-not $_.HasDescription) { $issues += 'missing description' }
      $issueStr = $issues -join ', '
      $msg = '  {0}: {1}' -f $_.Name, $issueStr
      Write-Output $msg
    }
    exit 1
  }
}
