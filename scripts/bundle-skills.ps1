<#
.SYNOPSIS
  Bundle all skills from config/skills/ into a .tar.gz archive.

.DESCRIPTION
  Packages every config/skills/<name>/ directory into a single compressed
  archive (skills.tar.gz) for use by the installer. Uses tar.exe on Windows
  (built-in since Win10/Server 2016) with a 7-Zip fallback.

.PARAMETER Output
  Path for the output archive.  Default: config/skills.tar.gz

.PARAMETER Quiet
  Suppress verbose progress messages (errors still shown).

.EXAMPLE
  .\scripts\bundle-skills.ps1

.EXAMPLE
  .\scripts\bundle-skills.ps1 -Output dist/skills.tar.gz

.EXAMPLE
  .\scripts\bundle-skills.ps1 -Quiet
#>

param(
  [string]$Output = "",
  [switch]$Quiet
)

$ErrorActionPreference = "Stop"

# ── paths ──────────────────────────────────────────────────────────────────
$RepoRoot = Resolve-Path "$PSScriptRoot/.."
$SkillsDir = Join-Path (Join-Path $RepoRoot "config") "skills"
$OutPath   = if ($Output) { $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Output) }
             else         { Join-Path (Join-Path $RepoRoot "config") "skills.tar.gz" }

# ── guard: skills directory must exist and be non-empty ─────────────────────
if (-not (Test-Path -LiteralPath $SkillsDir)) {
  Write-Error "Skills directory not found: $SkillsDir"
  exit 1
}

$SkillDirs = Get-ChildItem -LiteralPath $SkillsDir -Directory
if ($SkillDirs.Count -eq 0) {
  Write-Error "No skill directories found in $SkillsDir"
  exit 1
}

if (-not $Quiet) {
  Write-Host "→ Bundling $($SkillDirs.Count) skills from $SkillsDir"
  Write-Host "→ Output: $OutPath"
}

# ── ensure parent of output exists ─────────────────────────────────────────
$OutParent = Split-Path -Parent -Path $OutPath
if ($OutParent -and -not (Test-Path -LiteralPath $OutParent)) {
  New-Item -ItemType Directory -Path $OutParent -Force | Out-Null
}

# ── locate archiver ────────────────────────────────────────────────────────
function Test-Command([string]$Exe) {
  return [bool](Get-Command $Exe -ErrorAction SilentlyContinue)
}

$Archiver = $null
if (Test-Command "tar.exe")  { $Archiver = "tar" }
elseif (Test-Command "7z")   { $Archiver = "7z" }
else {
  Write-Error "Neither tar.exe nor 7z found.  Install tar (Win10+ built-in) or 7-Zip."
  exit 1
}

# ── build archive ──────────────────────────────────────────────────────────
if ($Archiver -eq "tar") {
  # tar.exe on Windows normalises paths relative to CWD.
  Push-Location -LiteralPath $SkillsDir
  try {
    $Names = ($SkillDirs | ForEach-Object { $_.Name })
    if ($Quiet) {
      tar -czf $OutPath $Names 2>&1 | Out-Null
    } else {
      tar -czf $OutPath $Names 2>&1
    }
  }
  finally {
    Pop-Location
  }
}
else {
  # 7-Zip fallback: create .tar first, then compress to .tar.gz
  $TempTar = Join-Path ([System.IO.Path]::GetTempPath()) "skills-bundle-$([System.IO.Path]::GetRandomFileName()).tar"
  try {
    if (-not $Quiet) { Write-Host "   (using 7z: creating intermediate tar…)" }
    & 7z a -ttar -r $TempTar "$SkillsDir\*" 2>&1 | Out-Null
    if (-not $Quiet) { Write-Host "   (compressing tar → gzip…)" }
    & 7z a -tgzip $OutPath $TempTar 2>&1 | Out-Null
  }
  finally {
    if (Test-Path -LiteralPath $TempTar) { Remove-Item -LiteralPath $TempTar -Force }
  }
}

# ── verify ─────────────────────────────────────────────────────────────────
if (-not (Test-Path -LiteralPath $OutPath)) {
  Write-Error "Archive creation failed: $OutPath not created"
  exit 1
}

$Size = (Get-Item -LiteralPath $OutPath).Length
if (-not $Quiet) {
  Write-Host "✓ Done — $($SkillDirs.Count) skills bundled ($([math]::Round($Size / 1KB)) KB)"
}
