[CmdletBinding()]
param(
    [string]$ProjectPath = ".",
    [switch]$ForceRestart
)

$ErrorActionPreference = 'Stop'

$resolvedProjectPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path

Write-Warning 'ensure-shared-serena-project.ps1 is deprecated. Serena is no longer managed as a shared HTTP server.'
Write-Host 'Current setup:' -ForegroundColor Cyan
Write-Host '- Codex starts its own Serena stdio MCP process with --project-from-cwd --context codex.' -ForegroundColor Gray
Write-Host '- Antigravity starts its own Serena stdio MCP process with --context antigravity.' -ForegroundColor Gray
Write-Host '- Do not start or retarget the old shared streamable-http Serena instance for normal client work.' -ForegroundColor Gray
Write-Host ''
Write-Host "Requested project path: $resolvedProjectPath" -ForegroundColor Gray
Write-Host 'Recovery:' -ForegroundColor Cyan
Write-Host '1. Restart the client after MCP config changes.' -ForegroundColor Gray
Write-Host '2. In Antigravity, use Serena project activation tools if the project is not selected automatically.' -ForegroundColor Gray

exit 0
