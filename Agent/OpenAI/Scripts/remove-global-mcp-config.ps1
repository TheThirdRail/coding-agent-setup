[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Purge
)

$ErrorActionPreference = 'Stop'
$helper = (Resolve-Path (Join-Path $PSScriptRoot '..\..\Scripts\remove-installed-path.ps1')).Path
$targetPath = Join-Path $HOME '.codex\config.toml'

& $helper -Path $targetPath -Label 'Codex MCP config' -DryRun:$DryRun -Purge:$Purge
