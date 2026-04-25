<#
.SYNOPSIS
    Validate related skill and workflow references across all skills.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$SkillsRoot = "Agent/Google/Skills",

    [Parameter(Mandatory = $false)]
    [string]$WorkflowsRoot = "Agent/Google/Workflows"
)

$ErrorActionPreference = "Stop"

function Get-SkillXml {
    param([string]$Content)

    $match = [regex]::Match($Content, '(?s)(<skill\b[\s\S]*</skill>)')
    if ($match.Success) {
        return $match.Groups[1].Value
    }
    return $null
}

$SkillsRoot = (Resolve-Path $SkillsRoot -ErrorAction Stop).Path
$WorkflowsRoot = (Resolve-Path $WorkflowsRoot -ErrorAction Stop).Path

$skillDirs = Get-ChildItem $SkillsRoot -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
} | Sort-Object Name

$skillNames = @($skillDirs.Name)
$errors = [System.Collections.Generic.List[string]]::new()

foreach ($skillDir in $skillDirs) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    $content = Get-Content $skillFile -Raw
    $skillXml = Get-SkillXml -Content $content

    if (-not $skillXml) {
        $errors.Add("$($skillDir.Name): missing <skill> XML root") | Out-Null
        continue
    }

    try {
        [xml]$xml = "<root>$skillXml</root>"
        $skillNode = $xml.root.skill
        if (-not $skillNode) {
            $errors.Add("$($skillDir.Name): invalid <skill> XML root") | Out-Null
            continue
        }

        $relatedSkillNodes = $skillNode.SelectNodes('.//related_skills/skill | .//integration_points/skill')
        foreach ($node in $relatedSkillNodes) {
            $ref = $null
            if ($node.Attributes['ref']) {
                $ref = $node.Attributes['ref'].Value.Trim()
            }
            elseif (-not [string]::IsNullOrWhiteSpace($node.InnerText)) {
                $ref = $node.InnerText.Trim()
            }

            if ($ref -and ($skillNames -notcontains $ref)) {
                $errors.Add("$($skillDir.Name): missing skill reference '$ref'") | Out-Null
            }
        }

        $workflowRefNodes = $skillNode.SelectNodes('.//related_workflows/workflow | .//integration_points/workflow')
        foreach ($node in $workflowRefNodes) {
            $ref = $null
            if ($node.Attributes['ref']) {
                $ref = $node.Attributes['ref'].Value.Trim()
            }
            elseif (-not [string]::IsNullOrWhiteSpace($node.InnerText)) {
                $ref = $node.InnerText.Trim()
            }

            if ($ref -and ($ref -match '^/[a-z-]+$')) {
                $wfPath = Join-Path $WorkflowsRoot ($ref.TrimStart('/') + '.md')
                if (-not (Test-Path $wfPath)) {
                    $errors.Add("$($skillDir.Name): missing workflow reference '$ref'") | Out-Null
                }
            }
        }
    }
    catch {
        $errors.Add("$($skillDir.Name): invalid XML ($($_.Exception.Message))") | Out-Null
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Reference validation failed:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
}

Write-Host "All skill/workflow references are valid." -ForegroundColor Green
exit 0
