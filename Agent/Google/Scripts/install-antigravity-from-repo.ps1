[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$installRules = (Resolve-Path (Join-Path $PSScriptRoot 'install-rules.ps1')).Path
$installSkills = (Resolve-Path (Join-Path $PSScriptRoot 'install-skills.ps1')).Path
$installWorkflows = (Resolve-Path (Join-Path $PSScriptRoot 'install-workflows.ps1')).Path
$setupLazyLoad = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\MCP-Servers\scripts\setup_lazy_load.ps1')).Path
$installMcp = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\MCP-Servers\scripts\install-mcp-servers.ps1')).Path

Write-Host '=== Install Antigravity From Repo ===' -ForegroundColor Cyan
Write-Host 'This installs the repo-owned global GEMINI.md, skills, workflows, and MCP config.' -ForegroundColor Gray
Write-Host ''

& $installRules -DryRun:$DryRun
Write-Host ''
& $installSkills -DryRun:$DryRun
Write-Host ''
& $installWorkflows -DryRun:$DryRun
Write-Host ''
& $setupLazyLoad -Vendor google -DryRun:$DryRun
Write-Host ''
& $installMcp -Vendor google -DryRun:$DryRun
