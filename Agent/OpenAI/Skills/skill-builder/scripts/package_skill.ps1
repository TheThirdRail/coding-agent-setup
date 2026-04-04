<#
.SYNOPSIS
    Validate and package a skill for distribution.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = ".",

    [Parameter(Mandatory = $false)]
    [switch]$SkipValidation,

    [Parameter(Mandatory = $false)]
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

$SkillPath = (Resolve-Path $Path -ErrorAction Stop).Path
$SkillDir = Get-Item $SkillPath

if (-not $SkillDir.PSIsContainer) {
    Write-Error "Path is not a skill directory: $SkillPath"
    exit 1
}

$SkillMdPath = Join-Path $SkillPath "SKILL.md"
$OpenAiYamlPath = Join-Path $SkillPath "agents/openai.yaml"
$ScriptsRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$QuickValidate = Join-Path $ScriptsRoot "quick_validate.py"
$ValidateLinks = Join-Path $ScriptsRoot "validate-links.ps1"

if (-not (Test-Path $SkillMdPath)) {
    Write-Error "SKILL.md not found: $SkillMdPath"
    exit 1
}

if (-not (Test-Path $OpenAiYamlPath)) {
    Write-Error "agents/openai.yaml not found: $OpenAiYamlPath"
    exit 1
}

if (-not $SkipValidation) {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python) {
        $python = Get-Command python3 -ErrorAction SilentlyContinue
    }
    if (-not $python) {
        Write-Error "Python executable not found (python/python3)."
        exit 1
    }

    & $python.Source $QuickValidate $SkillPath
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    $skillsRoot = Split-Path -Parent $SkillPath
    & powershell -NoProfile -ExecutionPolicy Bypass -File $ValidateLinks -SkillsRoot $skillsRoot
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

if ($Strict) {
    $skillContent = Get-Content $SkillMdPath -Raw
    if ($skillContent -match '\bTODO\b|\bTBD\b') {
        Write-Error "Strict mode failed: SKILL.md still contains TODO/TBD placeholders."
        exit 1
    }
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$nameMatch = [regex]::Match((Get-Content $SkillMdPath -Raw), '(?m)^name:\s*([a-z0-9-]+)\s*$')
if (-not $nameMatch.Success) {
    Write-Error "Unable to determine skill name from SKILL.md."
    exit 1
}

$skillName = $nameMatch.Groups[1].Value
$zipPath = Join-Path (Resolve-Path $OutputDir).Path "$skillName.skill"

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path (Join-Path $SkillPath '*') -DestinationPath $zipPath -Force
Write-Host "Packaged skill: $zipPath" -ForegroundColor Green
exit 0
