#!/usr/bin/env pwsh
<#
.SYNOPSIS
Validates the skills ecosystem for opencode-supreme-setup.

.DESCRIPTION
Checks that every skill directory has a valid SKILL.md, skills.txt is in sync
with the filesystem, and minimum skill count threshold is met.

.PARAMETER Strict
Enable additional checks: body length >= 15 lines, description >= 20 chars.

.PARAMETER MinCount
Minimum skill count threshold. Default: 50.

.PARAMETER Format
Output format: text (default) or json.
#>

param(
    [switch]$Strict,
    [int]$MinCount = 50,
    [ValidateSet('text', 'json')]
    [string]$Format = 'text'
)

$ErrorActionPreference = 'Stop'
$issues = @()
$projectRoot = Resolve-Path "$PSScriptRoot/.."
$skillsDir = "$projectRoot/config/skills"
$skillsTxt = "$projectRoot/config/skills.txt"

# Gather dirs from filesystem
$dirSkills = Get-ChildItem -LiteralPath $skillsDir -Directory | Where-Object { $_.Name -notlike '_*' } | ForEach-Object { $_.Name } | Sort-Object

# Gather names from skills.txt
$txtSkills = @()
if (Test-Path -LiteralPath $skillsTxt) {
    $txtSkills = Get-Content -LiteralPath $skillsTxt | Where-Object { $_.Trim() -ne '' } | ForEach-Object {
        # Extract skill name after hashline tag (e.g. "1#QR|a11y" -> "a11y")
        $parts = $_ -split '\|'
        if ($parts.Count -ge 2) { $parts[1].Trim() } else { $_.Trim() }
    } | Sort-Object
}

$count = $dirSkills.Count
$missingFromTxt = @()
$missingFromFs = @()
$frontmatterErrors = @()
$descErrors = @()
$bodyErrors = @()
$descQualityErrors = @()

# Check 1: skills.txt sync - skills on filesystem but missing from txt
foreach ($s in $dirSkills) {
    if ($s -notin $txtSkills) { $missingFromTxt += $s }
}

# Check 2: skills.txt sync - skills in txt but missing from filesystem
foreach ($s in $txtSkills) {
    if ($s -notin $dirSkills) { $missingFromFs += $s }
}

# Check 3: Frontmatter and description for every SKILL.md
$skillMdFiles = Get-ChildItem -LiteralPath $skillsDir -Recurse -Filter 'SKILL.md'
foreach ($file in $skillMdFiles) {
    $name = $file.Directory.Name
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $lines = $content -split "`n"

    # Frontmatter check: must start with ---
    if ($lines.Count -lt 1 -or $lines[0].Trim() -ne '---') {
        $frontmatterErrors += $name
    }

    # Description check: must have description: field in frontmatter
    if ($content -notmatch '(?m)^description:\s*.+') {
        $descErrors += $name
    }

    if ($Strict) {
        # Body length: after frontmatter (skip first --- block), count remaining lines
        $bodyStart = -1
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i].Trim() -eq '---') {
                $bodyStart = $i + 1
                break
            }
        }
        $bodyLines = 0
        if ($bodyStart -gt 0 -and $bodyStart -lt $lines.Count) {
            $bodyLines = ($lines | Select-Object -Skip $bodyStart | Where-Object { $_.Trim() -ne '' }).Count
        }
        if ($bodyLines -lt 15) {
            $bodyErrors += "$name ($bodyLines lines)"
        }

        # Description quality: length >= 20 chars
        if ($content -match '(?m)^description:\s*(.+)') {
            $descText = $Matches[1].Trim()
            if ($descText.Length -lt 20) {
                $descQualityErrors += "$name ($($descText.Length) chars)"
            }
        }
    }
}

# Build issue list
if ($missingFromTxt.Count -gt 0) { $issues += "skills.txt out of sync - missing from txt: $($missingFromTxt -join ', ')" }
if ($missingFromFs.Count -gt 0) { $issues += "skills.txt out of sync - missing from filesystem: $($missingFromFs -join ', ')" }
if ($frontmatterErrors.Count -gt 0) { $issues += "SKILL.md missing frontmatter: $($frontmatterErrors -join ', ')" }
if ($descErrors.Count -gt 0) { $issues += "SKILL.md missing description: $($descErrors -join ', ')" }
if ($bodyErrors.Count -gt 0) { $issues += "SKILL.md body too short (strict): $($bodyErrors -join ', ')" }
if ($descQualityErrors.Count -gt 0) { $issues += "SKILL.md description too short (strict): $($descQualityErrors -join ', ')" }
if ($count -lt $MinCount) { $issues += "Skill count $count below minimum $MinCount" }

$isValid = $issues.Count -eq 0

if ($Format -eq 'json') {
    $result = @{
        status = if ($isValid) { 'ok' } else { 'fail' }
        count = $count
        issues = $issues
        strict = $Strict.IsPresent
    }
    $result | ConvertTo-Json
} else {
    if ($isValid) {
        $syncStatus = if ($missingFromTxt.Count -eq 0 -and $missingFromFs.Count -eq 0) { 'in sync' } else { 'out of sync' }
        Write-Output "OK: $count skills validated, skills.txt $syncStatus"
    } else {
        foreach ($issue in $issues) {
            Write-Output "FAIL: $issue"
        }
    }
}

exit $(if ($isValid) { 0 } else { 1 })
