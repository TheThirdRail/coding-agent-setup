param(
    [ValidateSet('codex', 'agents', 'both')]
    [string]$Target = 'codex',

    [switch]$MirrorAgents,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if ($MirrorAgents -and $Target -eq 'codex') {
    $Target = 'both'
}

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$sourceSkills = Join-Path $projectRoot 'Agent\OpenAI\Skills'

if (-not (Test-Path $sourceSkills)) {
    Write-Host "ERROR: Skills source folder missing: $sourceSkills" -ForegroundColor Red
    exit 1
}

$skills = Get-ChildItem -Path $sourceSkills -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
    Sort-Object Name
if ($skills.Count -eq 0) {
    Write-Host "ERROR: No skills found under $sourceSkills" -ForegroundColor Red
    exit 1
}

$targets = @()
if ($Target -in @('codex', 'both')) {
    $targets += (Join-Path $env:USERPROFILE '.codex\skills')
}
if ($Target -in @('agents', 'both')) {
    $targets += (Join-Path $env:USERPROFILE '.agents\skills')
}

Write-Host '=== OpenAI Skills Installer ===' -ForegroundColor Cyan
Write-Host ''

foreach ($destRoot in $targets) {
    if ($DryRun) {
        Write-Host "[DRY RUN] Target skill root: $destRoot" -ForegroundColor Yellow
    }
    elseif (-not (Test-Path $destRoot)) {
        New-Item -ItemType Directory -Path $destRoot -Force | Out-Null
    }

    foreach ($skill in $skills) {
        $dest = Join-Path $destRoot $skill.Name
        $exists = Test-Path $dest
        if ($DryRun) {
            $status = if ($exists) { 'OVERWRITE' } else { 'CREATE' }
            Write-Host "  [DRY RUN][$status] $($skill.Name)/" -ForegroundColor Yellow
            continue
        }

        if ($exists) {
            Remove-Item -Path $dest -Recurse -Force
        }

        Copy-Item -Path $skill.FullName -Destination $dest -Recurse -Force
        $status = if ($exists) { 'Updated' } else { 'Installed' }
        Write-Host "  $status`: $($skill.Name)/" -ForegroundColor Green
    }
}

Write-Host ''
if ($DryRun) {
    Write-Host "[DRY RUN] Skills install preview complete. Count: $($skills.Count)" -ForegroundColor Yellow
}
else {
    Write-Host "Installed $($skills.Count) skills." -ForegroundColor Green
}
