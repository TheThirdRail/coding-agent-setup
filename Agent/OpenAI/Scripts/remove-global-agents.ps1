[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Purge
)

$ErrorActionPreference = 'Stop'
$helper = (Resolve-Path (Join-Path $PSScriptRoot '..\..\Scripts\remove-installed-path.ps1')).Path
$targetPath = Join-Path $HOME '.codex\AGENTS.md'

& $helper -Path $targetPath -Label 'Codex global AGENTS.md' -DryRun:$DryRun -Purge:$Purge
