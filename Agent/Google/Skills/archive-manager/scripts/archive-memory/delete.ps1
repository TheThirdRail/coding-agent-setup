<#
.SYNOPSIS
    Delete memories from the local SQLite archive via Python implementation.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Category,

    [Parameter(Mandatory = $true)]
    [string]$Key,

    [string]$ProjectPath = "."
)

$ErrorActionPreference = "Stop"

function Get-PythonCommand {
    $candidates = @("python", "python3", "py")
    foreach ($name in $candidates) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) {
            return $cmd.Source
        }
    }
    throw "Python executable not found. Install Python or add it to PATH."
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PythonScript = Join-Path $ScriptDir "delete.py"

if (-not (Test-Path $PythonScript)) {
    throw "Missing script: $PythonScript"
}

if (-not (Test-Path $ProjectPath)) {
    throw "Project path not found: $ProjectPath"
}

$ResolvedProjectPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path
$PythonExe = Get-PythonCommand

$args = @(
    "--category", $Category,
    "--key", $Key,
    "--project-path", $ResolvedProjectPath
)

& $PythonExe $PythonScript @args
exit $LASTEXITCODE
