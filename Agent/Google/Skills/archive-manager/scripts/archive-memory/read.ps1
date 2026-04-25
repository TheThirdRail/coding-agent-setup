<#
.SYNOPSIS
    Read memories from the local SQLite archive via Python implementation.
#>
param(
    [string]$Category,
    [string]$Key,
    [string]$Search,
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
$PythonScript = Join-Path $ScriptDir "read.py"

if (-not (Test-Path $PythonScript)) {
    throw "Missing script: $PythonScript"
}

if (-not (Test-Path $ProjectPath)) {
    throw "Project path not found: $ProjectPath"
}

$ResolvedProjectPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path
$PythonExe = Get-PythonCommand

$args = @()
if ($Category) {
    $args += @("--category", $Category)
}
if ($Key) {
    $args += @("--key", $Key)
}
if ($Search) {
    $args += @("--search", $Search)
}
$args += @("--project-path", $ResolvedProjectPath)

& $PythonExe $PythonScript @args
exit $LASTEXITCODE
