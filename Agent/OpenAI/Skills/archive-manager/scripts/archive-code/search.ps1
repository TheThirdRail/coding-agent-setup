<#
.SYNOPSIS
    Search code using ripgrep (rg).
.PARAMETER Pattern
    The search pattern (regex supported).
.PARAMETER Path
    Path to the project or file to search.
.PARAMETER Type
    Optional: 'definition' to try and find definitions, 'reference' for references.
.PARAMETER Context
    Number of context lines to show (default 0).
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Pattern,

    [Parameter(Mandatory = $true)]
    [string]$Path,

    [string]$Type,

    [int]$Context = 0
)

$ErrorActionPreference = "Stop"

# Check for rg (ripgrep)
$RgCommand = Get-Command rg -ErrorAction SilentlyContinue

if ($RgCommand) {
    $RgExe = "rg"
}
else {
    # Fallback to known npm global path on Windows
    $NpmPath = "$env:APPDATA\npm\rg.exe"
    if (Test-Path $NpmPath) {
        $RgExe = $NpmPath
    }
    else {
        Write-Host "Error: ripgrep (rg) is not installed or not in PATH." -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $Path)) {
    Write-Host "Error: Path not found: $Path" -ForegroundColor Red
    exit 1
}

$RgArgs = @("--line-number", "--heading", "--color", "always")

if ($Context -gt 0) {
    $RgArgs += "--context"
    $RgArgs += $Context
}

# Simple heuristics for definitions if Type is set
if ($Type -eq "definition") {
    # This is a basic heuristic and might need per-language adjustment
    # For now we strictly obey the user's pattern but maybe hint at better patterns
    Write-Host "Searching for definition of '$Pattern'..." -ForegroundColor Cyan
}

$RgArgs += $Pattern
$RgArgs += $Path

Write-Host "Running: rg $RgArgs" -ForegroundColor DarkGray

try {
    & $RgExe $RgArgs
}
catch {
    # rg returns exit code 1 if no matches found, which ps1 treats as error with strict mode
    if ($LASTEXITCODE -eq 1) {
        Write-Host "No matches found." -ForegroundColor Yellow
    }
    else {
        Write-Error $_
    }
}
