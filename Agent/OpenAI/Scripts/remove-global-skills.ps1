[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Purge
)

$ErrorActionPreference = 'Stop'
$helper = (Resolve-Path (Join-Path $PSScriptRoot '..\..\Scripts\remove-installed-path.ps1')).Path
$targetPath = Join-Path $HOME '.codex\skills'

& $helper -Path $targetPath -Label 'Codex global skills' -ChildrenOnly -ExcludeNames '.system' -DryRun:$DryRun -Purge:$Purge
