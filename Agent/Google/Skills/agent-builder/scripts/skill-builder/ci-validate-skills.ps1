<#
.SYNOPSIS
    CI entrypoint for strict skill catalog validation.

.DESCRIPTION
    Runs parser checks for PowerShell scripts, Python syntax checks,
    cross-reference checks, and strict packaging validation for all skills.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$SkillsRoot = "Agent/Google/Skills"
)

$ErrorActionPreference = "Stop"

$SkillsRoot = (Resolve-Path $SkillsRoot -ErrorAction Stop).Path
$RepoRoot = Split-Path $SkillsRoot -Parent
$WorkflowsRoot = Join-Path $RepoRoot "Workflows"
$SkillBuilderScripts = Join-Path $SkillsRoot "skill-builder/scripts"

function Assert-PowerShellParse {
    param([string]$RootPath)

    $parseErrors = [System.Collections.Generic.List[string]]::new()
    $ps1Files = Get-ChildItem -Path $RootPath -Recurse -File -Filter *.ps1

    foreach ($file in $ps1Files) {
        $tokens = $null
        $errors = $null
        [void][System.Management.Automation.Language.Parser]::ParseFile(
            $file.FullName,
            [ref]$tokens,
            [ref]$errors
        )

        foreach ($err in $errors) {
            $parseErrors.Add("$($file.FullName): $($err.Message)") | Out-Null
        }
    }

    if ($parseErrors.Count -gt 0) {
        Write-Host "PowerShell parse validation failed:" -ForegroundColor Red
        foreach ($err in $parseErrors) {
            Write-Host "  - $err" -ForegroundColor Red
        }
        exit 1
    }

    Write-Host "PowerShell parse validation passed." -ForegroundColor Green
}

function Assert-PythonCompile {
    param([string]$RootPath)

    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonCmd) {
        $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
    }

    if (-not $pythonCmd) {
        Write-Error "Python executable not found (python/python3)."
        exit 1
    }

    $pyFiles = Get-ChildItem -Path $RootPath -Recurse -File -Filter *.py
    foreach ($file in $pyFiles) {
        & $pythonCmd.Source -m py_compile $file.FullName
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Python compile failed: $($file.FullName)"
            exit 1
        }
    }

    Write-Host "Python compile validation passed." -ForegroundColor Green
}

Assert-PowerShellParse -RootPath $SkillsRoot
Assert-PythonCompile -RootPath $SkillsRoot

$validateLinksScript = Join-Path $SkillBuilderScripts "validate-links.ps1"
$auditScript = Join-Path $SkillBuilderScripts "audit-skills.ps1"

if (-not (Test-Path $validateLinksScript)) {
    Write-Error "validate-links.ps1 not found at: $validateLinksScript"
    exit 1
}
if (-not (Test-Path $auditScript)) {
    Write-Error "audit-skills.ps1 not found at: $auditScript"
    exit 1
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $validateLinksScript -SkillsRoot $SkillsRoot -WorkflowsRoot $WorkflowsRoot
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $auditScript -SkillsRoot $SkillsRoot -Strict
exit $LASTEXITCODE
