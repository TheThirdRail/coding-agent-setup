[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Purge
)

$ErrorActionPreference = 'Stop'
$helper = (Resolve-Path (Join-Path $PSScriptRoot '..\..\Scripts\remove-installed-path.ps1')).Path
$targetPath = Join-Path $HOME '.gemini\antigravity\mcp_config.json'

& $helper -Path $targetPath -Label 'Antigravity MCP config' -DryRun:$DryRun -Purge:$Purge
