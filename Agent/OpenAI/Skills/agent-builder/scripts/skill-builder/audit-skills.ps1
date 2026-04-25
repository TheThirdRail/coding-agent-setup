<#
.SYNOPSIS
    Validate and package every skill under Agent/OpenAI/Skills.

.DESCRIPTION
    Runs package_skill.ps1 for each skill and aggregates pass/fail results.
    Returns a non-zero exit code when any skill fails validation.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$SkillsRoot = "Agent/OpenAI/Skills",

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = "$env:TEMP/skill-audit-output",

    [Parameter(Mandatory = $false)]
    [switch]$Strict,

    [Parameter(Mandatory = $false)]
    [switch]$SkipValidation
)

$ErrorActionPreference = "Stop"

$SkillsRoot = (Resolve-Path $SkillsRoot -ErrorAction Stop).Path
$PackageScript = Join-Path $SkillsRoot "skill-builder/scripts/package_skill.ps1"

if (-not (Test-Path $PackageScript)) {
    Write-Error "package_skill.ps1 not found at: $PackageScript"
    exit 1
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$skillDirs = Get-ChildItem $SkillsRoot -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
} | Sort-Object Name

if ($skillDirs.Count -eq 0) {
    Write-Host "No skills found under $SkillsRoot" -ForegroundColor Yellow
    exit 0
}

$passed = [System.Collections.Generic.List[string]]::new()
$failed = [System.Collections.Generic.List[string]]::new()

Write-Host "Auditing $($skillDirs.Count) skills..." -ForegroundColor Cyan

foreach ($skill in $skillDirs) {
    Write-Host "`n[$($skill.Name)]" -ForegroundColor Yellow

    $invocationArgs = @(
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-File', $PackageScript,
        '-Path', $skill.FullName,
        '-OutputDir', $OutputDir
    )

    if ($Strict) {
        $invocationArgs += '-Strict'
    }

    if ($SkipValidation) {
        $invocationArgs += '-SkipValidation'
    }

    & powershell @invocationArgs
    if ($LASTEXITCODE -eq 0) {
        $passed.Add($skill.Name) | Out-Null
    }
    else {
        $failed.Add($skill.Name) | Out-Null
    }
}

Write-Host "`n=== Skill Audit Summary ===" -ForegroundColor Cyan
Write-Host "Passed: $($passed.Count)" -ForegroundColor Green
Write-Host "Failed: $($failed.Count)" -ForegroundColor ($(if ($failed.Count -gt 0) { 'Red' } else { 'Gray' }))

if ($failed.Count -gt 0) {
    Write-Host "Failed skills:" -ForegroundColor Red
    foreach ($name in $failed) {
        Write-Host "  - $name" -ForegroundColor Red
    }
    exit 1
}

Write-Host "All skills passed validation." -ForegroundColor Green
exit 0
