[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

Write-Host "=== Deprecation Checker (google) ===" -ForegroundColor Cyan
Write-Host ""

$googleRoot = (Resolve-Path (Join-Path $PSScriptRoot "..") -ErrorAction Stop).Path
$sourceGeminiPath = Join-Path $googleRoot "GEMINI.md"
$sourceSkillsRoot = Join-Path $googleRoot "Skills"
$sourceWorkflowsRoot = Join-Path $googleRoot "Workflows"

$globalGeminiRoot = Join-Path $HOME ".gemini"
$globalRuleFile = Join-Path $globalGeminiRoot "GEMINI.md"
$legacyGlobalRules = Join-Path $globalGeminiRoot "rules"
$globalSkillsRoot = Join-Path $globalGeminiRoot "antigravity\skills"
$globalWorkflowsRoot = Join-Path $globalGeminiRoot "antigravity\global_workflows"

$totalRemoved = 0

function Get-InstallableGoogleSkillNames {
    param([string]$SourcePath)

    if (-not (Test-Path $SourcePath)) {
        return @()
    }

    return @(Get-ChildItem -Path $SourcePath -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
        Sort-Object Name |
        Select-Object -ExpandProperty Name)
}

function Get-InstallableWorkflowNames {
    param([string]$SourcePath)

    if (-not (Test-Path $SourcePath)) {
        return @()
    }

    return @(Get-ChildItem -Path $SourcePath -Filter '*.md' -File -ErrorAction SilentlyContinue |
        Sort-Object Name |
        Select-Object -ExpandProperty Name)
}

function Remove-DeprecatedItems {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GlobalPath,
        [Parameter(Mandatory = $true)]
        [string[]]$SourceNames,
        [Parameter(Mandatory = $true)]
        [string]$ItemType,
        [Parameter(Mandatory = $false)]
        [switch]$IsDirectory
    )

    $removed = 0

    if (-not (Test-Path $GlobalPath)) {
        Write-Host "  Global folder not found: $GlobalPath" -ForegroundColor DarkGray
        return 0
    }

    if ($IsDirectory) {
        $globalItems = Get-ChildItem -Path $GlobalPath -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notlike '.*' }
    }
    else {
        $globalItems = Get-ChildItem -Path $GlobalPath -Filter "*.md" -File -ErrorAction SilentlyContinue
    }

    if (-not $globalItems -or $globalItems.Count -eq 0) {
        Write-Host "  No $ItemType found in global folder." -ForegroundColor DarkGray
        return 0
    }

    foreach ($item in $globalItems) {
        if ($SourceNames -notcontains $item.Name) {
            if ($DryRun) {
                Write-Host "  [WOULD DELETE] $($item.FullName)" -ForegroundColor Yellow
            }
            else {
                if ($IsDirectory) {
                    Remove-Item -Path $item.FullName -Recurse -Force
                }
                else {
                    Remove-Item -Path $item.FullName -Force
                }
                Write-Host "  [DELETED] $($item.FullName)" -ForegroundColor Red
            }
            $removed++
        }
    }

    return $removed
}

Write-Host "Checking Global GEMINI..." -ForegroundColor White
if (-not (Test-Path $sourceGeminiPath)) {
    if (Test-Path $globalRuleFile) {
        if ($DryRun) {
            Write-Host "  [WOULD DELETE] $globalRuleFile (source Agent\Google\GEMINI.md missing)" -ForegroundColor Yellow
        }
        else {
            Remove-Item -Path $globalRuleFile -Force
            Write-Host "  [DELETED] $globalRuleFile (source Agent\Google\GEMINI.md missing)" -ForegroundColor Red
        }
        $totalRemoved++
    }
}
else {
    Write-Host "  Global GEMINI managed at: $globalRuleFile" -ForegroundColor DarkGray
}

if (Test-Path $legacyGlobalRules) {
    $legacyRuleItems = Get-ChildItem -Path $legacyGlobalRules -Force -ErrorAction SilentlyContinue
    if ($legacyRuleItems) {
        foreach ($legacyItem in $legacyRuleItems) {
            if ($DryRun) {
                Write-Host "  [WOULD DELETE] $($legacyItem.FullName) (legacy rules path)" -ForegroundColor Yellow
            }
            else {
                Remove-Item -Path $legacyItem.FullName -Recurse -Force
                Write-Host "  [DELETED] $($legacyItem.FullName) (legacy rules path)" -ForegroundColor Red
            }
            $totalRemoved++
        }
    }
    else {
        Write-Host "  No legacy rules found in: $legacyGlobalRules" -ForegroundColor DarkGray
    }
}
else {
    Write-Host "  Legacy rules folder not found: $legacyGlobalRules" -ForegroundColor DarkGray
}

Write-Host "Checking Skills..." -ForegroundColor White
$sourceSkillNames = Get-InstallableGoogleSkillNames -SourcePath $sourceSkillsRoot

$count = Remove-DeprecatedItems -GlobalPath $globalSkillsRoot -SourceNames $sourceSkillNames -ItemType "skills" -IsDirectory
if ($count -eq 0) { Write-Host "  All skills are current." -ForegroundColor Green }
$totalRemoved += $count

Write-Host "Checking Workflows..." -ForegroundColor White
$sourceWorkflowNames = Get-InstallableWorkflowNames -SourcePath $sourceWorkflowsRoot

$count = Remove-DeprecatedItems -GlobalPath $globalWorkflowsRoot -SourceNames $sourceWorkflowNames -ItemType "workflows"
if ($count -eq 0) { Write-Host "  All workflows are current." -ForegroundColor Green }
$totalRemoved += $count

Write-Host ""
if ($DryRun) {
    if ($totalRemoved -gt 0) {
        Write-Host "[DRY RUN] Would remove $totalRemoved deprecated item(s). Remove -DryRun to apply." -ForegroundColor Yellow
    }
    else {
        Write-Host "[DRY RUN] No deprecated items found. Everything is in sync!" -ForegroundColor Green
    }
}
else {
    if ($totalRemoved -gt 0) {
        Write-Host "Removed $totalRemoved deprecated item(s) for google." -ForegroundColor Red
    }
    else {
        Write-Host "No deprecated items found. Everything is in sync!" -ForegroundColor Green
    }
}
