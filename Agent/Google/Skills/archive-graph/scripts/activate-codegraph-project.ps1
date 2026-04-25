[CmdletBinding()]
param(
    [string]$ProjectPath = ".",
    [ValidateSet('all', 'openai', 'google')]
    [string]$Vendor = 'all'
)

$ErrorActionPreference = 'Stop'

$resolvedProjectPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path

Write-Warning 'activate-codegraph-project.ps1 is deprecated. CodeGraph is no longer a direct client MCP entry.'
Write-Host 'Current setup:' -ForegroundColor Cyan
Write-Host '- CodeGraph is available through Docker MCP lazy-load.' -ForegroundColor Gray
Write-Host '- Use MCP_DOCKER mcp-find/mcp-add to load codegraph only when needed.' -ForegroundColor Gray
Write-Host '- Use mcp-remove to unload codegraph after the task.' -ForegroundColor Gray
Write-Host ''
Write-Host "Requested project path: $resolvedProjectPath" -ForegroundColor Gray
Write-Host 'If CodeGraph cannot see the expected project files, use the local archive-graph scripts for this turn.' -ForegroundColor Yellow

exit 0
