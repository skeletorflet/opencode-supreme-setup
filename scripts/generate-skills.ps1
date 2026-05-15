param(
    [Parameter(Mandatory)]
    [string]$csv,

    [switch]$dryRun
)

$templatePath = Join-Path $PSScriptRoot ".." "config" "skills" "_template" "SKILL.md"
$skillsDir = Join-Path $PSScriptRoot ".." "config" "skills"

if (-not (Test-Path $csv)) {
    Write-Error "CSV not found: $csv"
    exit 1
}

if (-not (Test-Path $templatePath)) {
    Write-Error "Template not found: $templatePath"
    exit 1
}

$template = Get-Content $templatePath -Raw
$rows = Import-Csv $csv
$created = 0
$skipped = 0
$errors = @()

foreach ($row in $rows) {
    $name = $row.name.Trim()
    $description = $row.description.Trim()
    $topics = $row.topics

    if (-not $name -or -not $description) {
        $errors += "Row '$($row.name)': missing name or description"
        continue
    }

    $targetDir = Join-Path $skillsDir $name
    $targetFile = Join-Path $targetDir "SKILL.md"

    if (Test-Path $targetFile) {
        $skipped++
        continue
    }

    $content = $template -replace 'skill-name', $name
    $content = $content -replace 'Clear description with trigger keywords. Use when user asks about X\.', $description

    if ($topics) {
        $topicLines = ($topics.Split(',') | ForEach-Object { "- $($_.Trim())" }) -join "`n"
        $comment = "<!-- Topics: $($topics) -->"
        $content = $comment + "`n" + $content
    }

    if ($dryRun) {
        Write-Host "[DRY-RUN] Would create: $targetFile"
        $created++
        continue
    }

    try {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Set-Content -Path $targetFile -Value $content -NoNewline
        Write-Host "[CREATED] $targetFile"
        $created++
    } catch {
        $errors += "Failed to create $name : $_"
    }
}

Write-Host ""
Write-Host "Summary: $created created, $skipped skipped, $($errors.Count) errors"
if ($errors.Count -gt 0) {
    Write-Host "Errors:"
    $errors | ForEach-Object { Write-Host "  - $_" }
}
