[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Purge
)

$ErrorActionPreference = 'Stop'
$helper = (Resolve-Path (Join-Path $PSScriptRoot '..\..\Scripts\remove-installed-path.ps1')).Path
$targetPath = Join-Path $HOME '.gemini\antigravity\global_workflows'

& $helper -Path $targetPath -Label 'Antigravity global workflows' -ChildrenOnly -DryRun:$DryRun -Purge:$Purge
