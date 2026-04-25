[CmdletBinding()]
param(
    [string]$ProjectPath = ".",
    [switch]$ForceRestart
)

$ErrorActionPreference = 'Stop'

$skillRoot = Split-Path -Parent $PSScriptRoot
$sharedScript = Join-Path $skillRoot '..\archive-code\scripts\ensure-shared-serena-project.ps1'
$resolvedSharedScript = (Resolve-Path $sharedScript -ErrorAction Stop).Path

$args = @(
    '-ExecutionPolicy', 'Bypass',
    '-File', $resolvedSharedScript,
    '-ProjectPath', $ProjectPath
)

if ($ForceRestart) {
    $args += '-ForceRestart'
}

& powershell @args
exit $LASTEXITCODE
