<#
.SYNOPSIS
    Validate related skill references across all skills.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$SkillsRoot = "Agent/OpenAI/Skills",

    [Parameter(Mandatory = $false)]
    [string]$WorkflowsRoot = "Agent/OpenAI/deprecated-Workflows"
)

$ErrorActionPreference = "Stop"

$SkillsRoot = (Resolve-Path $SkillsRoot -ErrorAction Stop).Path
$skillDirs = Get-ChildItem $SkillsRoot -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
} | Sort-Object Name

$skillNames = @($skillDirs.Name)
$errors = [System.Collections.Generic.List[string]]::new()

function Get-SkillRefs {
    param([string]$Content)

    $refs = [System.Collections.Generic.HashSet[string]]::new()

    $patterns = @(
        '(?m)^- `skill`: ([a-z0-9-]+)\s*$',
        'related skill `([a-z0-9-]+)`',
        'Invoke related skill `([a-z0-9-]+)`',
        'Use `([a-z0-9-]+)` when'
    )

    foreach ($pattern in $patterns) {
        foreach ($match in [regex]::Matches($Content, $pattern)) {
            [void]$refs.Add($match.Groups[1].Value)
        }
    }

    return @($refs)
}

foreach ($skillDir in $skillDirs) {
    $content = Get-Content (Join-Path $skillDir.FullName "SKILL.md") -Raw
    $refs = Get-SkillRefs -Content $content

    foreach ($ref in $refs) {
        if ($ref -eq $skillDir.Name) {
            continue
        }

        if ($skillNames -notcontains $ref) {
            $errors.Add("$($skillDir.Name): missing skill reference '$ref'") | Out-Null
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Reference validation failed:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
}

Write-Host "All skill references are valid." -ForegroundColor Green
exit 0
