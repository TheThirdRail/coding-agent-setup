[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [string]$Path,

    [string]$Resources = "",
    [switch]$Examples,
    [string[]]$Interface = @()
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
}
if (-not $python) {
    Write-Error "Python executable not found (python/python3)."
    exit 1
}

$args = @(
    (Join-Path $scriptRoot 'init_skill.py'),
    $Name,
    '--path', $Path
)

if ($Resources) {
    $args += @('--resources', $Resources)
}
if ($Examples) {
    $args += '--examples'
}
foreach ($item in $Interface) {
    $args += @('--interface', $item)
}

& $python.Source @args
exit $LASTEXITCODE
