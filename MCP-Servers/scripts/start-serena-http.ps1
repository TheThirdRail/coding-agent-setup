[CmdletBinding()]
param(
    [ValidateRange(1, 65535)]
    [int]$Port = 9121,
    [string]$ProjectPath = '',
    [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')]
    [string]$LogLevel = 'INFO',
    [switch]$OpenDashboard
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$uvCacheDir = Join-Path $repoRoot '.cache\uv'

if (-not (Test-Path $uvCacheDir)) {
    New-Item -ItemType Directory -Path $uvCacheDir -Force | Out-Null
}

$env:UV_CACHE_DIR = $uvCacheDir

if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
    $ProjectPath = $repoRoot
}
elseif (-not (Test-Path $ProjectPath)) {
    throw "Project path not found: $ProjectPath"
}
else {
    $ProjectPath = (Resolve-Path $ProjectPath).Path
}

$dashboardValue = if ($OpenDashboard) { 'true' } else { 'false' }
$url = "http://127.0.0.1:$Port/mcp"

Write-Host '=== Serena Shared HTTP Server ===' -ForegroundColor Cyan
Write-Host "Project:   $ProjectPath" -ForegroundColor Gray
Write-Host "Context:   ide" -ForegroundColor Gray
Write-Host "Transport: streamable-http" -ForegroundColor Gray
Write-Host "URL:       $url" -ForegroundColor Gray
Write-Host "UV cache:  $uvCacheDir" -ForegroundColor Gray
Write-Host ''
Write-Host 'Keep this process running while Antigravity and/or Codex are connected.' -ForegroundColor Yellow
Write-Host ''

& uvx `
    --from git+https://github.com/oraios/serena `
    serena start-mcp-server `
    --transport streamable-http `
    --host 127.0.0.1 `
    --port $Port `
    --project $ProjectPath `
    --context ide `
    --log-level $LogLevel `
    --open-web-dashboard $dashboardValue
