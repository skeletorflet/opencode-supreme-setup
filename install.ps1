#!/usr/bin/env pwsh
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     N E X U S   I N S T A L L E R                            ║
# ║           OpenCode Supreme Setup · Next-Gen Installation                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
# MIT License · Copyright (c) 2025 OpenCode Supreme Setup Contributors
<#
.SYNOPSIS
    NEXUS INSTALLER - Futuristic CLI installer for OpenCode Supreme Setup
.DESCRIPTION
    Advanced installer with cyberpunk aesthetics, interactive TUI, and real-time animations
.EXAMPLE
    .\install.ps1                    # Full interactive installation
    .\install.ps1 -Turbo              # Fast mode with defaults
    .\install.ps1 -Theme Matrix       # Custom theme (Matrix/Neon/Fire)
    .\install.ps1 -Components @("core","plugins","skills")  # Selective install
    .\install.ps1 -NonInteractive     # Silent installation
#>
param(
    [switch]$Turbo,
    [switch]$NonInteractive,
    [switch]$Verbose,
    [ValidateSet("Matrix","Neon","Fire","Aurora","Cyber")]
    [string]$Theme = "Neon",
    [ValidateSet("Minimal","Standard","Full")]
    [string]$Profile = "Standard",
    [string[]]$Components = @("all"),
    [string]$Claude = "",
    [string]$OpenAI = "",
    [string]$Gemini = "",
    [string]$Copilot = "",
    [string]$OpenCodeGo = ""
)

# ═══════════════════════════════════════════════════════════════════════════════
# HEADER BLOCK - DO NOT MODIFY
# ═══════════════════════════════════════════════════════════════════════════════
$ErrorActionPreference = "Continue"
$Script:ProgressData = @{
    TotalTasks = 0
    CompletedTasks = 0
    FailedTasks = 0
    CurrentTask = ""
    StartTime = Get-Date
    LogEntries = @()
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: THEME ENGINE - Neon Cyberpunk Palette
# ═══════════════════════════════════════════════════════════════════════════════
$script:ThemePalette = @{
    Matrix = @{
        Primary   = "`e[38;5;82m"    # #00FF41 Matrix Green
        Secondary = "`e[38;5;28m"    # #008F11 Dark Green
        Accent    = "`e[38;5;196m"   # #FF0000 Alert Red
        Glow      = "`e[38;5;46m"    # #00FF00 Bright Green
        BG        = "`e[48;5;16m"    # #0D0D0D Near Black
        Text      = "`e[38;5;82m"    # #00FF41 Matrix Text
        Dim       = "`e[38;5;23m"    # #005F00 Dim Green
        Highlight = "`e[1;38;5;82m"  # Bold Matrix
    }
    Neon = @{
        Primary   = "`e[38;5;201m"   # #FF00FF Magenta
        Secondary = "`e[38;5;45m"    # #00FFFF Cyan
        Accent    = "`e[38;5;213m"   # #FF79C6 Pink
        Glow      = "`e[38;5;231m"   # #FFFFFF White
        BG        = "`e[48;5;53m"    # Deep Purple BG
        Text      = "`e[38;5;252m"   # #F8F8F2 Light Gray
        Dim       = "`e[38;5;59m"    # #5A5A7A Muted
        Highlight = "`e[1;38;5;201m" # Bold Magenta
    }
    Fire = @{
        Primary   = "`e[38;5;208m"   # #FF8700 Orange
        Secondary = "`e[38;5;196m"   # #FF0000 Red
        Accent    = "`e[38;5;226m"   # #FFFF00 Yellow
        Glow      = "`e[38;5;214m"   # #FFAF00 Bright Orange
        BG        = "`e[48;5;52m"    # Dark Red BG
        Text      = "`e[38;5;254m"   # Near White
        Dim       = "`e[38;5;130m"   # #870000 Dark Red
        Highlight = "`e[1;38;5;208m" # Bold Orange
    }
    Aurora = @{
        Primary   = "`e[38;5;147m"   # #AF87FF Purple
        Secondary = "`e[38;5;159m"   # #87FFD7 Teal
        Accent    = "`e[38;5;223m"   # #FFAFD7 Rose
        Glow      = "`e[38;5;255m"   # #FFFFFF White
        BG        = "`e[48;5;54m"     # Dark Blue BG
        Text      = "`e[38;5;251m"   # #F8F8F2 Light
        Dim       = "`e[38;5;60m"    # #5A5A8A Muted
        Highlight = "`e[1;38;5;147m" # Bold Purple
    }
    Cyber = @{
        Primary   = "`e[38;5;51m"    # #00D7FF Electric Blue
        Secondary = "`e[38;5;220m"   # #FFD700 Gold
        Accent    = "`e[38;5;163m"   # #FF00AF Hot Pink
        Glow      = "`e[38;5;123m"   # #00FF87 Neon Green
        BG        = "`e[48;5;17m"    # #010D17 Deep Blue
        Text      = "`e[38;5;250m"   # #FAFAFA Near White
        Dim       = "`e[38;5;24m"    # #005F87 Muted Blue
        Highlight = "`e[1;38;5;51m"  # Bold Cyan
    }
}

$script:C = $script:ThemePalette[$Theme]
$script:R = "`e[0m"
$script:B = "`e[1m"
$script:DIM = "`e[2m"
$script:BLINK = "`e[5m"
$script:UNDERLINE = "`e[4m"

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: TERMINAL SETUP & ANSI SUPPORT
# ═══════════════════════════════════════════════════════════════════════════════
function Initialize-Terminal {
    # Enable VT/ANSI on Windows
    if ($IsWindows) {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        try {
            Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class VTEnable {
    [DllImport("kernel32.dll")] public static extern bool SetConsoleMode(IntPtr h, uint m);
    [DllImport("kernel32.dll")] public static extern bool GetConsoleMode(IntPtr h, out uint m);
    [DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int n);
    public static void Enable() {
        var h = GetStdHandle(-11);
        uint mode = 0;
        GetConsoleMode(h, out mode);
        SetConsoleMode(h, mode | 0x0004 | 0x0080);
    }
}
'@ -ErrorAction SilentlyContinue
            [VTEnable]::Enable()
        } catch {}
    }

    # Get terminal dimensions
    $script:TerminalWidth = if ($Host.UI.RawUI.WindowSize.Width) { $Host.UI.RawUI.WindowSize.Width } else { 120 }
    $script:TerminalHeight = if ($Host.UI.RawUI.WindowSize.Height) { $Host.UI.RawUI.WindowSize.Height } else { 40 }
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: ADVANCED ANSI EFFECTS
# ═══════════════════════════════════════════════════════════════════════════════
function Get-GlowEffect {
    param([string]$Text, [int]$Intensity = 1)
    $glow = switch ($Intensity) {
        1 { "`e[38;5;255m`e[48;5;16m" }
        2 { "`e[38;5;255m`e[48;5;52m`e[1m" }
        3 { "`e[38;5;231m`e[48;5;196m`e[1m" }
        default { $C.Glow }
    }
    return "$glow$Text$script:R"
}

function Get-GradientText {
    param([string]$Text, [string]$StartColor, [string]$EndColor)
    $len = $Text.Length
    if ($len -eq 0) { return "" }
    $output = ""
    for ($i = 0; $i -lt $len; $i++) {
        $ratio = $i / ($len - 1)
        $char = $Text[$i]
        $output += $char  # Simplified: use primary color
    }
    return "$StartColor$Text$script:R"
}

function Get-PulseAnimation {
    param([string]$Text, [int]$Frame)
    $frames = @(
        "$($script:C.Glow)$($script:B)$Text$script:R",
        "$($script:C.Primary)$Text$script:R",
        "$($script:C.Secondary)$Text$script:R",
        "$($script:C.Glow)$($script:DIM)$Text$script:R"
    )
    return $frames[$Frame % $frames.Count]
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: ANIMATED ASCII ART GENERATOR
# ═══════════════════════════════════════════════════════════════════════════════
function Get-NexusLogo {
    param([int]$Frame = 0)

    $logo = @"
    $($C.Primary)╔═══════════════════════════════════════════════════════════════════════════╗
    ║$($C.Secondary)   ███╗   ███╗ ██████╗ ███╗  ██╗ ██████╗ ███████╗ ██████╗  ██████╗ ███╗  ██╗$($C.Primary)   ║
    ║$($C.Primary)   ████╗ ████║██╔═══██╗████╗ ██║██╔═══██╗██╔════╝██╔═══██╗██╔═══██╗████╗ ██║$($C.Primary)   ║
    ║$($C.Secondary)  ██╔████╔██║██║   ██║██╔██╗██║██║   ██║███████╗██║   ██║██║   ██║██╔██╗██║$($C.Primary)   ║
    ║$($C.Primary)   ██║╚██╔╝██║██║   ██║██║╚████║██║   ██║╚════██║██║   ██║██║   ██║██║╚████║$($C.Primary)   ║
    ║$($C.Secondary)  ██║ ╚═╝ ██║╚██████╔╝██║ ╚███║╚██████╔╝███████║╚██████╔╝╚██████╔╝██║ ╚███║$($C.Primary)   ║
    ║$($C.Primary)   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚══╝$($C.Primary)   ║
    ║                                                                                   ║
    ║$($C.Dim)                    ◈ NEXUS INSTALLER v3.0 · NEXT-GEN CLI ◈$($C.Primary)                      ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
"@
    return $logo
}

function Get-MatrixRain {
    param([int]$Lines = 10, [int]$Frame = 0)
    $chars = "ｦｱｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾙﾚﾛﾜﾝ0123456789"
    $rain = ""
    $random = New-Object System.Random
    for ($i = 0; $i -lt $Lines; $i++) {
        $offset = ($Frame + $i) % $chars.Length
        $lineLength = [Math]::Max(5, ($TerminalWidth - 60) / 2)
        $drops = -join (1..$lineLength | ForEach-Object { $chars[($random.Next($chars.Length))] })
        $tail = -join ($drops[0..[Math]::Min(3, $drops.Length-1)] | ForEach-Object {
            if ((Get-Random -Minimum 0 -Maximum 10) -gt 7) { $C.Primary + $_ } else { $C.Dim + $_ }
        })
        $rain += "$($C.Dim)│$tail$($C.Glow)$(' ' * 5)$($C.Dim)│$R`n"
    }
    return $rain
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: PROGRESS BAR SYSTEM
# ═══════════════════════════════════════════════════════════════════════════════
function New-HolographicProgressBar {
    param(
        [int]$Width = 40,
        [int]$Percentage = 0,
        [string]$Label = "",
        [switch]$Animated
    )

    $filled = [Math]::Floor($Percentage * $Width / 100)
    $empty = $Width - $filled

    # Animated gradient effect
    $gradient = @($C.Primary, $C.Secondary, $C.Accent, $C.Glow)
    $bar = ""
    for ($i = 0; $i -lt $filled; $i++) {
        $colorIdx = [Math]::Floor($i / ($Width / 4))
        if ($colorIdx -ge $gradient.Count) { $colorIdx = $gradient.Count - 1 }
        $char = if ((Get-Random -Minimum 0 -Maximum 10) -gt 8) { "█" } else { "█" }
        $bar += "$($gradient[$colorIdx])$($script:B)$char"
    }
    $bar += "$($C.Dim)$('░' * $empty)"

    $percentageStr = "$Percentage%".PadLeft(4)
    $barStr = "$bar$script:R $C$($script:B)$percentageStr$script:R"

    if ($Label) {
        $barStr = "$($C.Text)$Label$script:R  " + $barStr
    }

    return $barStr
}

function Write-AnimatedText {
    param([string]$Text, [int]$DelayMs = 20, [string]$Color = "")

    $color = if ($Color) { $Color } else { $C.Text }
    foreach ($char in $Text.ToCharArray()) {
        Write-Host -NoNewline "$color$char$script:R"
        Start-Sleep -Milliseconds $DelayMs
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: INTERACTIVE TUI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════════
function Show-InteractiveMenu {
    param(
        [string]$Title,
        [array]$Options,
        [int]$DefaultIndex = 0
    )

    $currentIndex = $DefaultIndex
    $selected = $false

    # Draw menu
    function Draw-Menu {
        param($idx)
        Clear-Host
        Write-Host ""
        Write-Host "  $($C.Primary)┌─$($C.Dim)${'─' * ($TerminalWidth - 30)}$($C.Primary)─┐$R"
        Write-Host "  $($C.Primary)│$($C.Secondary)  ◈ $Title$($C.Dim)$(' ' * ($TerminalWidth - 40 - $Title.Length))$($C.Primary)│$R"
        Write-Host "  $($C.Primary)├─$($C.Dim)${'─' * ($TerminalWidth - 30)}$($C.Primary)─┤$R"

        for ($i = 0; $i -lt $Options.Count; $i++) {
            $opt = $Options[$i]
            $prefix = if ($i -eq $idx) { "$($C.Glow)$($script:B)► " } else { "  " }
            $suffix = if ($i -eq $idx) { " ◄" } else { "   " }
            $textColor = if ($i -eq $idx) { $C.Glow } else { $C.Text }
            $desc = if ($opt.Description) { "$($C.Dim) - $($opt.Description)" } else { "" }
            Write-Host "  $($C.Primary)│$($textColor)$prefix$($opt.Name)$suffix$($desc)$(' ' * [Math]::Max(0, $TerminalWidth - 50 - $opt.Name.Length - $opt.Description.Length))$($C.Primary)│$R"
        }

        Write-Host "  $($C.Primary)└─$($C.Dim)${'─' * ($TerminalWidth - 30)}$($C.Primary)─┘$R"
        Write-Host ""
        Write-Host "  $($C.Dim)↑↓ Navigate  ↩ Enter Select  Esc Cancel$R"
    }

    Draw-Menu $currentIndex

    while (-not $selected) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($key.VirtualKeyCode) {
            38 {  # Up Arrow
                $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $Options.Count - 1 }
                Draw-Menu $currentIndex
            }
            40 {  # Down Arrow
                $currentIndex = if ($currentIndex -lt $Options.Count - 1) { $currentIndex + 1 } else { 0 }
                Draw-Menu $currentIndex
            }
            13 {  # Enter
                $selected = $true
                return $Options[$currentIndex]
            }
            27 {  # Escape
                return $null
            }
        }
    }
}

function Show-CheckboxList {
    param(
        [string]$Title,
        [array]$Items,
        [bool[]]$DefaultStates
    )

    $states = @($DefaultStates)
    $currentIndex = 0
    $selected = $false

    function Draw-CheckboxList {
        param($idx, $states)
        Clear-Host
        Write-Host ""
        Write-Host "  $($C.Primary)╭─$($C.Dim)${'─' * ($TerminalWidth - 25)}$($C.Primary)─╮$R"
        Write-Host "  $($C.Primary)│$($C.Secondary)  ◈ $Title$($C.Dim)$(' ' * ($TerminalWidth - 38 - $Title.Length))$($C.Primary)│$R"
        Write-Host "  $($C.Primary)├$($C.Dim)${'─' * ($TerminalWidth - 25)}$($C.Primary)┤$R"

        for ($i = 0; $i -lt $Items.Count; $i++) {
            $item = $Items[$i]
            $check = if ($states[$i]) { "$($C.Glow)☑" } else { "$($C.Dim)☐" }
            $prefix = if ($i -eq $idx) { "$($C.Primary)► " } else { "  " }
            $textColor = if ($i -eq $idx) { $C.Glow } else { $C.Text }
            Write-Host "  $($C.Primary)│$($textColor)$prefix$check $($item.Name)$(' ' * [Math]::Max(0, $TerminalWidth - 45 - $item.Name.Length))$($C.Primary)│$R"
        }

        Write-Host "  $($C.Primary)╰─$($C.Dim)${'─' * ($TerminalWidth - 25)}$($C.Primary)─╯$R"
        Write-Host ""
        Write-Host "  $($C.Dim)↑↓ Navigate  Space Toggle  Enter Confirm  Esc Cancel$R"
    }

    Draw-CheckboxList $currentIndex $states

    while (-not $selected) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($key.VirtualKeyCode) {
            38 { $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $Items.Count - 1 }; Draw-CheckboxList $currentIndex $states }
            40 { $currentIndex = if ($currentIndex -lt $Items.Count - 1) { $currentIndex + 1 } else { 0 }; Draw-CheckboxList $currentIndex $states }
            32 {  # Space
                $states[$currentIndex] = -not $states[$currentIndex]
                Draw-CheckboxList $currentIndex $states
            }
            13 { $selected = $true; return $states }
            27 { return $null }
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: LOGGING SYSTEM
# ═══════════════════════════════════════════════════════════════════════════════
$script:LogFile = "$env:TEMP\nexus_setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $entry = "[$timestamp] [$Level] $Message"
    $script:ProgressData.LogEntries += $entry
    Add-Content -Path $script:LogFile -Value $entry -ErrorAction SilentlyContinue

    if ($Verbose) {
        $color = switch ($Level) {
            "ERROR" { $C.Accent }
            "WARN" { $C.Secondary }
            "SUCCESS" { $C.Primary }
            default { $C.Text }
        }
        Write-Host "  $($C.Dim)[$timestamp]$R $color$Message$R"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: TASK EXECUTION ENGINE
# ═══════════════════════════════════════════════════════════════════════════════
$script:TaskFrames = @('⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏')
$script:CurrentFrame = 0

function Invoke-NexusTask {
    param(
        [string]$Name,
        [scriptblock]$Task,
        [switch]$Critical,
        [switch]$Quiet,
        [string]$Description = ""
    )

    $script:ProgressData.TotalTasks++
    $script:ProgressData.CurrentTask = $Name

    # Draw task line
    $namePad = $Name.PadRight(35)
    if (-not $Quiet) {
        Write-Host -NoNewline "  $($C.Secondary)⚡$R  $namePad"
        if ($Description) { Write-Host -NoNewline " $($C.Dim)» $Description" }
        Write-Host ""
    }

    # Execute with spinner
    $spinnerJob = Start-Job -ScriptBlock $Task
    $frame = 0
    $startTime = Get-Date

    while ($spinnerJob.State -eq 'Running') {
        if (-not $Quiet) {
            $spinner = $script:TaskFrames[$frame % $script:TaskFrames.Count]
            Write-Host -NoNewline "`r  $($C.Secondary)$spinner$R  $namePad  $($C.Dim)$(Get-ElapsedTime -StartTime $startTime)$R"
        }
        Start-Sleep -Milliseconds 50
        $frame++
    }

    $result = Receive-Job $spinnerJob 2>$null
    Remove-Job $spinnerJob -Force

    $duration = (Get-Date) - $startTime
    $success = $spinnerJob.ChildJobs[0].State -eq 'Completed'

    if ($result) { Add-Content -Path $script:LogFile -Value $result -ErrorAction SilentlyContinue }

    if ($success) {
        $script:ProgressData.CompletedTasks++
        if (-not $Quiet) {
            Write-Host "`r  $($C.Primary)✓$R  $namePad  $($C.Dim)$(Get-ElapsedTime -StartTime $startTime)$R"
        }
        return $true
    } else {
        if ($Critical) { $script:ProgressData.FailedTasks++ }
        if (-not $Quiet) {
            Write-Host "`r  $($C.Accent)✗$R  $namePad  $($C.Dim)Failed$R"
        }
        Write-Log "$Name failed" "ERROR"
        if ($Critical) { throw "Critical task failed: $Name" }
        return $false
    }
}

function Get-ElapsedTime {
    param([datetime]$StartTime)
    $elapsed = (Get-Date) - $StartTime
    return "$($elapsed.TotalSeconds.ToString('0.0'))s"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: STATUS DISPLAY SYSTEM
# ═══════════════════════════════════════════════════════════════════════════════
function Write-NexusStatus {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )

    $icon = switch ($Type) {
        "SUCCESS" { "$($C.Primary)⚡" }
        "ERROR" { "$($C.Accent)⚠" }
        "WARN" { "$($C.Secondary)⚡" }
        "INFO" { "$($C.Dim)◆" }
        default { "$($C.Text)•" }
    }

    Write-Host "  $icon  $($C.Text)$Message$R"
}

function Write-NexusHeader {
    param([int]$Frame = 0)

    Clear-Host
    $logo = Get-NexusLogo -Frame $Frame
    Write-Host $logo

    # Stats bar
    $runtime = (Get-Date) - $script:ProgressData.StartTime
    $stats = "$($C.Dim)◈ Runtime: $($runtime.ToString('mm\:ss'))  ◈ Tasks: $($script:ProgressData.CompletedTasks)/$($script:ProgressData.TotalTasks)  ◈ Failed: $($script:ProgressData.FailedTasks)$R"
    Write-Host "  $stats"
    Write-Host "  $($C.Dim)$('─' * ($TerminalWidth - 4))$R"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: PACKAGE DEFINITIONS
# ═══════════════════════════════════════════════════════════════════════════════
$script:PackageManifest = @{
    Core = @{
        Name = "Core Components"
        Description = "Essential tools for OpenCode"
        Packages = @(
            @{ Name = "Node.js 18+"; Check = { node --version 2>$null -match 'v(1[89]|[2-9]\d)' } }
            @{ Name = "PowerShell 7+"; Check = { $PSVersionTable.PSVersion.Major -ge 7 } }
        )
    }
    Runtime = @{
        Name = "Runtime Environment"
        Description = "JavaScript runtimes and package managers"
        Packages = @(
            @{ Name = "opencode-ai"; Install = { npm install -g opencode-ai@latest 2>&1 | Out-Null; $true }; Check = { Get-Command opencode -ErrorAction SilentlyContinue } }
            @{ Name = "bun runtime"; Install = { npm install -g bun 2>&1 | Out-Null; $true }; Check = { Get-Command bun -ErrorAction SilentlyContinue } }
        )
    }
    Orchestrator = @{
        Name = "oh-my-openagent"
        Description = "Agent orchestration framework"
        Packages = @(
            @{ Name = "oh-my-openagent orchestrator"; Install = { bunx oh-my-openagent install --no-tui 2>&1 | Out-Null; $true } }
        )
    }
    Plugins = @{
        Name = "OpenCode Plugins"
        Description = "Essential plugin suite"
        Packages = @(
            @{ Name = "opencode-snippets"; Install = { npm install -g opencode-snippets 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-snip"; Install = { npm install -g opencode-snip 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-notify"; Install = { npm install -g opencode-notify 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-mem"; Install = { npm install -g opencode-mem 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-quota"; Install = { npm install -g opencode-quota 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-background-agents"; Install = { npm install -g opencode-background-agents 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-worktree"; Install = { npm install -g opencode-worktree 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-dynamic-context-pruning"; Install = { npm install -g opencode-dynamic-context-pruning 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-smart-title"; Install = { npm install -g opencode-smart-title 2>&1 | Out-Null; $true } }
            @{ Name = "ocwatch"; Install = { npm install -g ocwatch 2>&1 | Out-Null; $true } }
        )
    }
    Skills = @{
        Name = "OpenSkills Collection"
        Description = "100+ AI skill packages"
        Packages = @(
            @{ Name = "anthropics/skills"; Install = { npx openskills install anthropics/skills -y 2>&1 | Out-Null; $true } }
            @{ Name = "mattpocock/skills"; Install = { npx openskills install mattpocock/skills -y 2>&1 | Out-Null; $true } }
            @{ Name = "JuliusBrussee/caveman"; Install = { npx openskills install JuliusBrussee/caveman -y 2>&1 | Out-Null; $true } }
            @{ Name = "safishamsi/graphify"; Install = { npx openskills install safishamsi/graphify -y 2>&1 | Out-Null; $true } }
            @{ Name = "nexu-io/open-design"; Install = { npx openskills install nexu-io/open-design -y 2>&1 | Out-Null; $true } }
            @{ Name = "openskills CLI"; Install = { npm install -g openskills 2>&1 | Out-Null; $true } }
        )
    }
    DevTools = @{
        Name = "Developer Tools"
        Description = "Code quality and analysis tools"
        Packages = @(
            @{ Name = "comment-checker"; Install = { npm install -g @code-yeongyu/comment-checker 2>&1 | Out-Null; $true } }
            @{ Name = "ast-grep"; Install = { npm install -g @ast-grep/cli 2>&1 | Out-Null; $true } }
            @{ Name = "GitHub CLI"; Install = { if (Get-Command gh -ErrorAction SilentlyContinue) { $true } elseif ($IsWindows) { winget install --id GitHub.cli --silent --accept-package-agreements 2>&1 | Out-Null; $true } else { $false } } }
        )
    }
    Extras = @{
        Name = "Optional Enhancements"
        Description = "Additional tools and themes"
        Packages = @(
            @{ Name = "agentsys"; Install = { npm install -g agentsys 2>&1 | Out-Null; $true } }
            @{ Name = "firecrawl"; Install = { npm install -g firecrawl-cli 2>&1 | Out-Null; $true } }
            @{ Name = "wakatime"; Install = { npm install -g opencode-wakatime 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-ayu-theme"; Install = { npm install -g opencode-ayu-theme 2>&1 | Out-Null; $true } }
            @{ Name = "opencode-moonlight-theme"; Install = { npm install -g opencode-moonlight-theme 2>&1 | Out-Null; $true } }
        )
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: MAIN INSTALLATION LOGIC
# ═══════════════════════════════════════════════════════════════════════════════
function Install-NexusCore {
    Write-NexusHeader
    Write-Host ""
    Write-Host "  $($C.Primary)◈ $($C.Secondary)Initializing NEXUS Installation Environment$R"
    Write-Host "  $($C.Dim)◈ Theme: $Theme  ◈ Profile: $Profile  ◈ Log: $script:LogFile$R"
    Write-Host "  $($C.Dim)$('─' * ($TerminalWidth - 4))$R"
    Write-Host ""
}

function Select-InstallationProfile {
    if ($Turbo -or $NonInteractive) {
        switch ($Profile) {
            "Minimal" { return @("Core", "Runtime", "Orchestrator") }
            "Standard" { return @("Core", "Runtime", "Orchestrator", "Plugins", "Skills", "DevTools") }
            "Full" { return @("Core", "Runtime", "Orchestrator", "Plugins", "Skills", "DevTools", "Extras") }
        }
    }

    # Interactive mode - show TUI
    $options = @(
        @{ Name = "Minimal Install"; Description = "Core + Runtime + Orchestrator" }
        @{ Name = "Standard Install"; Description = "Recommended: Plugins + Skills + DevTools" }
        @{ Name = "Full Installation"; Description = "Everything + Optional Enhancements" }
        @{ Name = "Custom Selection"; Description = "Choose specific components" }
    )

    $selection = Show-InteractiveMenu -Title "SELECT INSTALLATION PROFILE" -Options $options -DefaultIndex 1

    if ($null -eq $selection) {
        Write-Host "`n  $($C.Accent)Installation cancelled by user$($C.Dim)» Run with -Turbo for automated install$R"
        exit 0
    }

    switch ($selection.Name) {
        "Minimal Install" { return @("Core", "Runtime", "Orchestrator") }
        "Standard Install" { return @("Core", "Runtime", "Orchestrator", "Plugins", "Skills", "DevTools") }
        "Full Installation" { return @("Core", "Runtime", "Orchestrator", "Plugins", "Skills", "DevTools", "Extras") }
        "Custom Selection" {
            $components = @()
            foreach ($key in $script:PackageManifest.Keys) {
                $manifest = $script:PackageManifest[$key]
                $states = ,$false
                $result = Show-CheckboxList -Title $manifest.Name -Items $manifest.Packages -DefaultStates $states
                if ($null -ne $result) {
                    for ($i = 0; $i -lt $result.Count; $i++) {
                        if ($result[$i]) { $components += $key; break }
                    }
                }
            }
            return $components
        }
    }
}

function Invoke-InstallationPhase {
    param([string]$PhaseName, [array]$Packages)

    Write-NexusHeader
    Write-Host ""
    Write-Host "  $($C.Primary)◈ $($C.Secondary)$PhaseName$R"
    Write-Host "  $($C.Dim)$('─' * ($TerminalWidth - 4))$R"
    Write-Host ""

    foreach ($pkg in $Packages) {
        if ($pkg.Check) {
            $alreadyInstalled = & $pkg.Check
            if ($alreadyInstalled) {
                Write-NexusStatus "$($pkg.Name) (already installed)" "INFO"
                $script:ProgressData.TotalTasks++
                $script:ProgressData.CompletedTasks++
                continue
            }
        }

        if ($pkg.Install) {
            Invoke-NexusTask -Name $pkg.Name -Task $pkg.Install -Quiet:$Turbo
        }
    }

    Write-Host ""
}

function Show-CompletionScreen {
    param([bool]$Success, [TimeSpan]$Duration)

    Clear-Host
    Write-Host ""

    if ($Success) {
        Write-Host "$($C.Primary)"
        Write-Host "    ╔═══════════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║                                                                               ║"
        Write-Host "    ║         ◈ ◈ ◈  INSTALLATION COMPLETE  ◈ ◈ ◈                          ║"
        Write-Host "    ║                                                                               ║"
        Write-Host "    ║         All systems operational · Ready to launch                          ║"
        Write-Host "    ║                                                                               ║"
        Write-Host "    ╚═══════════════════════════════════════════════════════════════════════╝"
        Write-Host "$R"
    } else {
        Write-Host "$($C.Accent)"
        Write-Host "    ╔═══════════════════════════════════════════════════════════════════╗"
        Write-Host "    ║                                                                   ║"
        Write-Host "    ║      ████████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗   ██╗           ║"
        Write-Host "    ║      ╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║   ██║           ║"
        Write-Host "    ║         ██║    ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║   ██║           ║"
        Write-Host "    ║         ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║   ██║           ║"
        Write-Host "    ║         ██║      ██║   ██║     ███████╗██║  ██║╚██████╔╝           ║"
        Write-Host "    ║         ╚═╝      ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝            ║"
        Write-Host "    ║                                                                   ║"
        Write-Host "    ║                   Installation Failed - Check Logs                ║"
        Write-Host "    ║                                                                   ║"
        Write-Host "    ╚═══════════════════════════════════════════════════════════════════╝"
        Write-Host "$R"
    }

    Write-Host ""
    Write-Host "  $($C.Dim)◈ Installation Summary$R"
    Write-Host "  $($C.Dim)$('─' * 60)$R"
    Write-Host "  $($C.Text)◈ Duration:$($C.Dim) $($Duration.ToString('mm\:ss\.fff'))$R"
    Write-Host "  $($C.Text)◈ Tasks:$($C.Dim) $($script:ProgressData.CompletedTasks) completed, $($script:ProgressData.FailedTasks) failed$R"
    Write-Host "  $($C.Text)◈ Log:$($C.Dim) $script:LogFile$R"
    Write-Host ""

    Write-Host "  $($C.Primary)◈ Quick Start Commands$R"
    Write-Host "  $($C.Dim)$('─' * 60)$R"
    Write-Host "  $($C.Glow)opencode$R                    $($C.Dim)Launch OpenCode$R"
    Write-Host "  $($C.Glow)opencode auth login$R         $($C.Dim)Authenticate your account$R"
    Write-Host "  $($C.Glow)ocwatch$R                     $($C.Dim)Open visual dashboard (port 3000)$R"
    Write-Host "  $($C.Glow)npx openskills sync$R         $($C.Dim)Sync available skills$R"
    Write-Host ""
    Write-Host "  $($C.Secondary)◈ Repository:$($C.Dim) https://github.com/skeletorflet/opencode-supreme-setup$R"
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════════
function Main {
    $startTime = Get-Date
    $script:ProgressData.StartTime = $startTime

    try {
        Initialize-Terminal
        Install-NexusCore

        # Show welcome animation
        if (-not $Turbo) {
            Write-Host "  $($C.Dim)Press any key to continue...$R"
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }

        # Select profile
        $selectedComponents = Select-InstallationProfile

        # Execute installation
        Write-NexusHeader
        Write-Host ""
        Write-Host "  $($C.Primary)◈ $($C.Glow)Starting Installation...$R"
        Write-Host "  $($C.Dim)◈ Components: $($selectedComponents -join ', ')$R"
        Write-Host "  $($C.Dim)$('─' * ($TerminalWidth - 4))$R"
        Write-Host ""

        Start-Sleep -Milliseconds 500

        foreach ($component in $selectedComponents) {
            if ($script:PackageManifest.ContainsKey($component)) {
                $manifest = $script:PackageManifest[$component]
                Invoke-InstallationPhase -PhaseName $manifest.Name -Packages $manifest.Packages
            }
        }

        # Config sync
        Write-NexusHeader
        Write-Host ""
        Write-Host "  $($C.Primary)◈ $($C.Secondary)Synchronizing Configuration$R"
        Write-Host "  $($C.Dim)$('─' * ($TerminalWidth - 4))$R"

        $confDir = "$env:USERPROFILE\.config\opencode"
        $confUrl = "https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"
        $repoDir = if ($MyInvocation.MyCommand.Path) { Split-Path -Parent $MyInvocation.MyCommand.Path } else { $null }

        if (-not (Test-Path $confDir)) { New-Item -ItemType Directory -Path $confDir -Force | Out-Null }

        if ($repoDir -and (Test-Path "$repoDir\config")) {
            Invoke-NexusTask -Name "Sync local config" -Task {
                Copy-Item -Path "$($using:repoDir)\config\*" -Destination $using:confDir -Force -Recurse; $true
            } -Quiet:$Turbo
        } else {
            Invoke-NexusTask -Name "opencode.json" -Task {
                Invoke-RestMethod "$($using:confUrl)/opencode.json" -OutFile "$($using:confDir)\opencode.json" -ErrorAction SilentlyContinue; $true
            } -Quiet:$Turbo
        }

        # Final verification
        Write-Host ""
        Write-NexusStatus "Running health checks..." "INFO"
        Invoke-NexusTask -Name "oh-my-openagent doctor" -Task { bunx oh-my-openagent doctor 2>&1 | Out-Null; $true } -Quiet -Critical

        $duration = (Get-Date) - $startTime
        Show-CompletionScreen -Success ($script:ProgressData.FailedTasks -eq 0) -Duration $duration

    } catch {
        Write-Host ""
        Write-NexusStatus "Installation error: $_" "ERROR"
        Write-Log "Fatal error: $_" "ERROR"
        $duration = (Get-Date) - $startTime
        Show-CompletionScreen -Success $false -Duration $duration
        exit 1
    }
}

# Execute
Main