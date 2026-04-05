param(
    [switch]$DryRun,
    [switch]$MirrorAgents,
    [ValidateSet('codex', 'agents', 'both')]
    [string]$Target = 'codex'
)

$ErrorActionPreference = 'Stop'

if ($MirrorAgents -and $Target -eq 'codex') {
    $Target = 'both'
}

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$sourceSkills = Join-Path $projectRoot 'Agent\OpenAI\Skills'
$sourceRules = Join-Path $projectRoot 'Agent\OpenAI\default.rules'
$sourceAutomations = Join-Path $projectRoot 'Agent\OpenAI\Automations'
$sourceAgents = Join-Path $projectRoot 'Agent\OpenAI\AGENTS.md'

function Get-InstallableSkillNames {
    param([string]$SourcePath)

    if (-not (Test-Path $SourcePath)) {
        return @()
    }

    return @(Get-ChildItem -Path $SourcePath -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
        Sort-Object Name |
        Select-Object -ExpandProperty Name)
}

function Get-InstallableAutomationNames {
    param([string]$SourcePath)

    if (-not (Test-Path $SourcePath)) {
        return @()
    }

    return @(Get-ChildItem -Path $SourcePath -File -Filter '*.automation.md' -ErrorAction SilentlyContinue |
        Sort-Object Name |
        Select-Object -ExpandProperty Name)
}

function Remove-Deprecated {
    param(
        [string]$GlobalPath,
        [string[]]$AllowedNames,
        [bool]$Directories
    )

    if (-not (Test-Path $GlobalPath)) {
        Write-Host "  Missing global path: $GlobalPath" -ForegroundColor DarkGray
        return 0
    }

    $items = if ($Directories) {
        Get-ChildItem -Path $GlobalPath -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike '.*' }
    }
    else {
        Get-ChildItem -Path $GlobalPath -File -ErrorAction SilentlyContinue
    }

    $removed = 0
    foreach ($item in $items) {
        if ($AllowedNames -contains $item.Name) {
            continue
        }

        if ($DryRun) {
            Write-Host "  [WOULD DELETE] $($item.FullName)" -ForegroundColor Yellow
        }
        else {
            if ($Directories) {
                Remove-Item -Path $item.FullName -Recurse -Force
            }
            else {
                Remove-Item -Path $item.FullName -Force
            }
            Write-Host "  [DELETED] $($item.FullName)" -ForegroundColor Red
        }
        $removed++
    }

    return $removed
}

function Test-ActivePathRefs {
    param([string]$RootPath)

    $legacyWorkflowsForward = ('Agent/OpenAI/' + 'Workflows')
    $legacyWorkflowsBack = ('Agent\OpenAI\' + 'Workflows')
    $legacyRulesForward = ('Agent/OpenAI/' + 'Rules')
    $legacyRulesBack = ('Agent\OpenAI\' + 'Rules')
    $legacyAutomationForward = ('Agent/OpenAI/Codex/' + 'automations')
    $legacyAutomationBack = ('Agent\OpenAI\Codex\' + 'automations')
    $blocked = @(
        $legacyWorkflowsForward,
        $legacyWorkflowsBack,
        $legacyRulesForward,
        $legacyRulesBack,
        $legacyAutomationForward,
        $legacyAutomationBack
    )

    $scanFiles = @()
    $scanFiles += Get-ChildItem -Path (Join-Path $RootPath 'Agent\OpenAI\Scripts') -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notlike '*\deprecated-Scripts\*' }
    $scanFiles += Get-ChildItem -Path (Join-Path $RootPath 'Agent\OpenAI\Skills') -Recurse -File -Filter 'SKILL.md' -ErrorAction SilentlyContinue
    $scanFiles += Get-Item -Path (Join-Path $RootPath 'AGENTS.md') -ErrorAction SilentlyContinue
    $scanFiles += Get-Item -Path (Join-Path $RootPath 'Agent\OpenAI\AGENTS.md') -ErrorAction SilentlyContinue

    $hits = @()
    foreach ($file in $scanFiles) {
        if (-not $file) { continue }
        $content = Get-Content $file.FullName -Raw
        foreach ($p in $blocked) {
            if ($content -like "*$p*") {
                $hits += "$($file.FullName) -> $p"
            }
        }
    }
    return $hits
}

$targets = @()
if ($Target -in @('codex', 'both')) {
    $targets += [pscustomobject]@{
        Name = 'codex'
        Skills = (Join-Path $env:USERPROFILE '.codex\skills')
        Rules = (Join-Path $env:USERPROFILE '.codex\rules')
        Automations = (Join-Path $env:USERPROFILE '.codex\automations')
        Agents = (Join-Path $env:USERPROFILE '.codex\AGENTS.md')
    }
}
if ($Target -in @('agents', 'both')) {
    $targets += [pscustomobject]@{
        Name = 'agents'
        Skills = (Join-Path $env:USERPROFILE '.agents\skills')
        Rules = (Join-Path $env:USERPROFILE '.agents\rules')
        Automations = (Join-Path $env:USERPROFILE '.agents\automations')
        Agents = (Join-Path $env:USERPROFILE '.agents\AGENTS.md')
    }
}

$skillNames = Get-InstallableSkillNames -SourcePath $sourceSkills
$ruleNames = if (Test-Path $sourceRules) { @('default.rules') } else { @() }
$automationNames = Get-InstallableAutomationNames -SourcePath $sourceAutomations

$total = 0
Write-Host '=== OpenAI Deprecation Checker ===' -ForegroundColor Cyan
Write-Host ''
Write-Host "Canonical skills: $($skillNames.Count)" -ForegroundColor Gray
Write-Host "Canonical automations: $($automationNames.Count)" -ForegroundColor Gray
Write-Host "Canonical rules: $($ruleNames.Count)" -ForegroundColor Gray
Write-Host ''

foreach ($t in $targets) {
    Write-Host "Target: $($t.Name)" -ForegroundColor White

    Write-Host ' Checking skills...' -ForegroundColor Gray
    $count = Remove-Deprecated -GlobalPath $t.Skills -AllowedNames $skillNames -Directories $true
    $total += $count

    Write-Host ' Checking default.rules...' -ForegroundColor Gray
    $count = Remove-Deprecated -GlobalPath $t.Rules -AllowedNames $ruleNames -Directories $false
    $total += $count

    Write-Host ' Checking automation templates...' -ForegroundColor Gray
    $count = Remove-Deprecated -GlobalPath $t.Automations -AllowedNames $automationNames -Directories $false
    $total += $count

    if ((Test-Path $t.Agents) -and (-not (Test-Path $sourceAgents))) {
        if ($DryRun) {
            Write-Host "  [WOULD DELETE] $($t.Agents)" -ForegroundColor Yellow
        }
        else {
            Remove-Item -Path $t.Agents -Force
            Write-Host "  [DELETED] $($t.Agents)" -ForegroundColor Red
        }
        $total += 1
    }

    Write-Host ''
}

$activeRefHits = Test-ActivePathRefs -RootPath $projectRoot
if ($activeRefHits.Count -gt 0) {
    Write-Host 'ERROR: Active files still reference deprecated path names:' -ForegroundColor Red
    $activeRefHits | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

if ($DryRun) {
    Write-Host "[DRY RUN] Deprecation scan complete. Candidates: $total" -ForegroundColor Yellow
}
else {
    Write-Host "Deprecation cleanup complete. Removed: $total" -ForegroundColor Green
}
