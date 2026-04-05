[CmdletBinding()]
param(
    [string]$RegistryPath = '',
    [string]$CatalogPath = '',
    [switch]$DryRun,
    [switch]$SkipSmokeTest
)

$ErrorActionPreference = 'Stop'

function Ensure-Directory {
    param([string]$Path)

    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Convert-ToForwardSlashPath {
    param([string]$Path)

    return ($Path -replace '\\', '/')
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error 'Docker CLI not found on PATH.'
    exit 1
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

if ([string]::IsNullOrWhiteSpace($RegistryPath)) {
    $RegistryPath = Join-Path $env:USERPROFILE '.docker\mcp\registry.hybrid-supplementals.yaml'
}

if ([string]::IsNullOrWhiteSpace($CatalogPath)) {
    $CatalogPath = Join-Path $repoRoot 'MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml'
}

if (-not (Test-Path $CatalogPath)) {
    Write-Error "Runtime catalog not found: $CatalogPath"
    exit 1
}

$registryContent = "registry:`n"

Write-Host '=== Hybrid Lazy-Load Setup ===' -ForegroundColor Cyan
Write-Host "Registry path: $RegistryPath" -ForegroundColor Gray
Write-Host "Runtime catalog: $CatalogPath" -ForegroundColor Gray
Write-Host ''

if ($DryRun) {
    Write-Host "[DRY RUN] Would refresh the hybrid lazy-load registry at $RegistryPath" -ForegroundColor Yellow
}
else {
    Ensure-Directory -Path $RegistryPath
    Set-Content -Path $RegistryPath -Value $registryContent -Encoding utf8
    Write-Host "Hybrid lazy-load registry refreshed: $RegistryPath" -ForegroundColor Green
}

if (-not $SkipSmokeTest) {
    $registryPathForSmokeTest = $RegistryPath
    if ($DryRun -and -not (Test-Path $RegistryPath)) {
        $registryPathForSmokeTest = Join-Path $env:TEMP 'registry.hybrid-supplementals.dry-run.yaml'
        Set-Content -Path $registryPathForSmokeTest -Value $registryContent -Encoding utf8
    }

    $registryArg = "--gateway-arg=--registry=$(Convert-ToForwardSlashPath -Path $registryPathForSmokeTest)"
    $catalogArg = "--gateway-arg=--additional-catalog=$(Convert-ToForwardSlashPath -Path $CatalogPath)"
    $countOutput = & docker mcp tools count $registryArg $catalogArg 2>&1
    $listOutput = & docker mcp tools ls $registryArg $catalogArg 2>&1

    $countText = (@($countOutput) -join "`n")
    $listText = (@($listOutput) -join "`n")
    $expectedTools = @('code-mode', 'mcp-add', 'mcp-config-set', 'mcp-exec', 'mcp-find', 'mcp-remove')
    $missingTools = @($expectedTools | Where-Object { $listText -notmatch [regex]::Escape($_) })

    $toolCount = -1
    if ($countText -match '(\d+)\s+tools') {
        $toolCount = [int]$Matches[1]
    }

    if ($toolCount -ne 6 -or $missingTools.Count -gt 0) {
        Write-Error "Hybrid lazy-load smoke test failed. Expected 6 management tools only. Count=$toolCount Missing=$($missingTools -join ', ')"
        exit 1
    }

    Write-Host 'Hybrid lazy-load smoke test passed: control-only MCP_DOCKER surface confirmed.' -ForegroundColor Green
}
else {
    Write-Host 'Skipping smoke test.' -ForegroundColor Yellow
}

$serverListOutput = & docker mcp server ls --json 2>&1
if ($LASTEXITCODE -eq 0 -and $serverListOutput) {
    try {
        $configuredServers = $serverListOutput | ConvertFrom-Json
        if ($configuredServers.Count -gt 0) {
            Write-Host ''
            Write-Warning 'Docker still has servers configured in its default state. The hybrid registry isolates MCP_DOCKER from them, but they may still affect other Docker MCP commands.'
            foreach ($server in $configuredServers) {
                Write-Host "  - $($server.name)" -ForegroundColor DarkYellow
            }
        }
    }
    catch {
        Write-Host ''
        Write-Warning 'Unable to parse default Docker MCP server state.'
    }
}
