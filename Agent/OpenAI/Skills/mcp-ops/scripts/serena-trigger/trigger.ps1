[CmdletBinding()]
param(
    [string]$ProjectPath = ".",
    [switch]$ForceRestart
)

$ErrorActionPreference = 'Stop'

$resolvedProjectPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path

Write-Host 'Serena now runs as a native stdio MCP server per client.' -ForegroundColor Cyan
Write-Host "Project path: $resolvedProjectPath" -ForegroundColor Gray
Write-Host ''
Write-Host 'Codex config should start Serena with:' -ForegroundColor Cyan
Write-Host '  uvx -p 3.13 --from git+https://github.com/oraios/serena serena start-mcp-server --project-from-cwd --context codex' -ForegroundColor Gray
Write-Host ''
Write-Host 'Antigravity config should start Serena with:' -ForegroundColor Cyan
Write-Host '  uvx -p 3.13 --from git+https://github.com/oraios/serena serena start-mcp-server --context antigravity' -ForegroundColor Gray
Write-Host ''
Write-Host 'Restart the client after config changes. In Antigravity, activate the project from Serena tools if needed.' -ForegroundColor Yellow

exit 0
