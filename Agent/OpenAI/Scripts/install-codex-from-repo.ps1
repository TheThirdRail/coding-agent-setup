[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$installAgents = (Resolve-Path (Join-Path $PSScriptRoot 'install-agents.ps1')).Path
$installSkills = (Resolve-Path (Join-Path $PSScriptRoot 'install-skills.ps1')).Path
$setupLazyLoad = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\MCP-Servers\scripts\setup_lazy_load.ps1')).Path
$installMcp = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\MCP-Servers\scripts\install-mcp-servers.ps1')).Path

Write-Host '=== Install Codex From Repo ===' -ForegroundColor Cyan
Write-Host 'This installs the repo-owned global AGENTS.md, skills, and MCP config.' -ForegroundColor Gray
Write-Host ''

& $installAgents -Target codex -Scope global -DryRun:$DryRun
Write-Host ''
& $installSkills -Target codex -DryRun:$DryRun
Write-Host ''
& $setupLazyLoad -Vendor openai -DryRun:$DryRun
Write-Host ''
& $installMcp -Vendor openai -DryRun:$DryRun
