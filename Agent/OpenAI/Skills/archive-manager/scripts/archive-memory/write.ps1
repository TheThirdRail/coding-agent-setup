<#
.SYNOPSIS
    Write memories to the local SQLite archive via Python implementation.
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("decisions", "patterns", "files", "context", "custom")]
    [string]$Category,

    [Parameter(Mandatory = $true)]
    [string]$Key,

    [Parameter(Mandatory = $true)]
    [string]$Value,

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
$PythonScript = Join-Path $ScriptDir "write.py"

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
    "--value", $Value,
    "--project-path", $ResolvedProjectPath
)

& $PythonExe $PythonScript @args
exit $LASTEXITCODE
