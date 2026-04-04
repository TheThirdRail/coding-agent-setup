param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path,
    [int]$MaxBytes = 32768
)

$ErrorActionPreference = 'Stop'
$failures = @()

$canonicalAgentsPath = Join-Path $ProjectRoot 'Agent\OpenAI\AGENTS.md'
$rootAgentsPath = Join-Path $ProjectRoot 'AGENTS.md'
$rulesPath = Join-Path $ProjectRoot 'Agent\OpenAI\default.rules'
$automationsDir = Join-Path $ProjectRoot 'Agent\OpenAI\Automations'
$workflowDir = Join-Path $ProjectRoot 'Agent\OpenAI\deprecated-Workflows'
$skillsDir = Join-Path $ProjectRoot 'Agent\OpenAI\Skills'
$mappingPath = Join-Path $ProjectRoot 'Agent\OpenAI\Codex\mappings\workflow-to-skill-map.yaml'

if (-not (Test-Path $canonicalAgentsPath)) {
    $failures += 'Canonical AGENTS missing: Agent/OpenAI/AGENTS.md'
}
else {
    $bytes = (Get-Item $canonicalAgentsPath).Length
    if ($bytes -gt $MaxBytes) {
        $failures += "Agent/OpenAI/AGENTS.md exceeds byte budget: $bytes > $MaxBytes"
    }
}

if (-not (Test-Path $rootAgentsPath)) {
    $failures += 'Repo root AGENTS.md missing.'
}
elseif (Test-Path $canonicalAgentsPath) {
    $srcHash = (Get-FileHash $canonicalAgentsPath -Algorithm SHA256).Hash
    $dstHash = (Get-FileHash $rootAgentsPath -Algorithm SHA256).Hash
    if ($srcHash -ne $dstHash) {
        $failures += 'Root AGENTS.md is not synchronized with Agent/OpenAI/AGENTS.md'
    }
}

if (-not (Test-Path $rulesPath)) {
    $failures += 'Consolidated rules file missing: Agent/OpenAI/default.rules'
}
else {
    $rulesLines = Get-Content $rulesPath
    $activeLines = $rulesLines | Where-Object {
        $trim = $_.Trim()
        ($trim -ne '') -and (-not $trim.StartsWith('#'))
    }

    if ($activeLines.Count -eq 0) {
        $failures += 'default.rules has no active Starlark rules'
    }

    $prefixRulePattern = '^\s*prefix_rule\s*\(\s*pattern\s*=\s*\[[^\]]+\]\s*,\s*decision\s*=\s*"(allow|prompt|deny)"\s*\)\s*$'
    $index = 0
    foreach ($line in $activeLines) {
        $index++
        if ($line -notmatch $prefixRulePattern) {
            $failures += "default.rules invalid Starlark syntax on active line ${index}: $line"
        }
    }
}

if (-not (Test-Path $automationsDir)) {
    $failures += 'Automations folder missing: Agent/OpenAI/Automations'
}
else {
    $automationCount = (Get-ChildItem -Path $automationsDir -File -Filter '*.automation.md').Count
    if ($automationCount -eq 0) {
        $failures += 'No automation templates found in Agent/OpenAI/Automations'
    }
}

if (-not (Test-Path $workflowDir)) {
    $failures += 'Workflow archive missing: Agent/OpenAI/deprecated-Workflows'
}

if (-not (Test-Path $mappingPath)) {
    $failures += 'workflow-to-skill-map.yaml missing.'
}
elseif (Test-Path $workflowDir) {
    $mappingText = Get-Content $mappingPath -Raw
    $mapped = [regex]::Matches($mappingText, '(?m)^\s*-\s*workflow:\s*([a-z0-9\-]+)') | ForEach-Object { $_.Groups[1].Value }
    $workflowNames = Get-ChildItem $workflowDir -File -Filter '*.md' | ForEach-Object { $_.BaseName }

    foreach ($wf in $workflowNames) {
        if ($mapped -notcontains $wf) {
            $failures += "Workflow missing mapping entry: $wf"
        }
    }
}

$skillNames = Get-ChildItem $skillsDir -Directory | Select-Object -ExpandProperty Name
$refFiles = @()
if (Test-Path $workflowDir) {
    $refFiles += Get-ChildItem $workflowDir -File -Filter '*.md'
}
$refFiles += Get-ChildItem $skillsDir -Recurse -File -Filter 'SKILL.md'
$refFiles += Get-Item $canonicalAgentsPath -ErrorAction SilentlyContinue

foreach ($file in $refFiles) {
    if (-not $file) { continue }
    $content = Get-Content $file.FullName -Raw
    $refs = @()
    $refs += [regex]::Matches($content, '(?m)^- `skill`: ([a-z0-9-]+)\s*$') | ForEach-Object { $_.Groups[1].Value }
    $refs += [regex]::Matches($content, 'related skill `([a-z0-9-]+)`') | ForEach-Object { $_.Groups[1].Value }
    $refs += [regex]::Matches($content, 'Invoke related skill `([a-z0-9-]+)`') | ForEach-Object { $_.Groups[1].Value }
    foreach ($r in $refs) {
        if ($skillNames -notcontains $r) {
            $failures += "Missing skill reference '$r' in $($file.FullName)"
        }
    }
}

$legacyWorkflowsForward = ('Agent/OpenAI/' + 'Workflows')
$legacyWorkflowsBack = ('Agent\OpenAI\' + 'Workflows')
$legacyRulesForward = ('Agent/OpenAI/' + 'Rules')
$legacyRulesBack = ('Agent\OpenAI\' + 'Rules')
$legacyAutomationsForward = ('Agent/OpenAI/Codex/' + 'automations')
$legacyAutomationsBack = ('Agent\OpenAI\Codex\' + 'automations')
$blockedPathPatterns = @(
    $legacyWorkflowsForward,
    $legacyWorkflowsBack,
    $legacyRulesForward,
    $legacyRulesBack,
    $legacyAutomationsForward,
    $legacyAutomationsBack
)
$scanRoots = @(
    (Join-Path $ProjectRoot 'Agent\OpenAI\Scripts'),
    (Join-Path $ProjectRoot 'Agent\OpenAI\Skills'),
    $canonicalAgentsPath,
    $rootAgentsPath
)

foreach ($root in $scanRoots) {
    if (-not (Test-Path $root)) { continue }
    $files = @()
    if ((Get-Item $root) -is [System.IO.DirectoryInfo]) {
        $files = Get-ChildItem -Path $root -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notlike '*\deprecated-Scripts\*' }
    }
    else {
        $files = @(Get-Item $root)
    }
    foreach ($f in $files) {
        $c = Get-Content $f.FullName -Raw
        foreach ($p in $blockedPathPatterns) {
            if ($c -like "*$p*") {
                $failures += "Deprecated path reference '$p' found in $($f.FullName)"
            }
        }
    }
}

if (Test-Path $canonicalAgentsPath) {
    $agentsContent = Get-Content $canonicalAgentsPath -Raw
    $templateRefs = [regex]::Matches($agentsContent, 'template="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    foreach ($rel in $templateRefs) {
        $full = Join-Path $ProjectRoot $rel
        if (-not (Test-Path $full)) {
            $failures += "AGENTS automation template not found: $rel"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host "Validation failed with $($failures.Count) issue(s):" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

Write-Host 'Validation passed: OpenAI consolidation artifacts are consistent.' -ForegroundColor Green
