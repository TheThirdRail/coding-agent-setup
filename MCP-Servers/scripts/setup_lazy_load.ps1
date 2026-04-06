[CmdletBinding()]
param(
    [string]$RegistryPath = '',
    [string]$CatalogPath = '',
    [string]$SeedRegistryPath = '',
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

function Get-RegistryServerNames {
    param([string]$Path)

    $matches = Get-Content -Path $Path | Select-String -Pattern '^\s{2}([A-Za-z0-9._-]+):\s*$'
    return @($matches | ForEach-Object { $_.Matches[0].Groups[1].Value })
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

if ([string]::IsNullOrWhiteSpace($SeedRegistryPath)) {
    $SeedRegistryPath = Join-Path $repoRoot 'MCP-Servers\mcp-docker-stack\registry.supplementals.yaml'
}

if (-not (Test-Path $CatalogPath)) {
    Write-Error "Runtime catalog not found: $CatalogPath"
    exit 1
}

if (-not (Test-Path $SeedRegistryPath)) {
    Write-Error "Supplemental registry seed not found: $SeedRegistryPath"
    exit 1
}

$registryContent = Get-Content -Path $SeedRegistryPath -Raw
$seedServerNames = Get-RegistryServerNames -Path $SeedRegistryPath
$catalogText = Get-Content -Path $CatalogPath -Raw
$missingCatalogServers = @($seedServerNames | Where-Object { $catalogText -notmatch "(?m)^  $([regex]::Escape($_)):\s*$" })

if ($missingCatalogServers.Count -gt 0) {
    Write-Error "Supplemental registry references missing runtime catalog entries: $($missingCatalogServers -join ', ')"
    exit 1
}

Write-Host '=== Hybrid Lazy-Load Setup ===' -ForegroundColor Cyan
Write-Host "Registry path: $RegistryPath" -ForegroundColor Gray
Write-Host "Runtime catalog: $CatalogPath" -ForegroundColor Gray
Write-Host "Seed registry: $SeedRegistryPath" -ForegroundColor Gray
Write-Host "Seeded supplemental servers: $($seedServerNames.Count)" -ForegroundColor Gray
Write-Host ''

if ($DryRun) {
    Write-Host "[DRY RUN] Would refresh the hybrid lazy-load registry at $RegistryPath from the repo seed registry" -ForegroundColor Yellow
}
else {
    Ensure-Directory -Path $RegistryPath
    Set-Content -Path $RegistryPath -Value $registryContent -Encoding utf8
    Write-Host "Hybrid lazy-load registry refreshed from seed: $RegistryPath" -ForegroundColor Green
}

if (-not $SkipSmokeTest) {
    $registryPathForSmokeTest = $RegistryPath
    if ($DryRun -and -not (Test-Path $RegistryPath)) {
        $registryPathForSmokeTest = Join-Path $env:TEMP 'registry.hybrid-supplementals.dry-run.yaml'
        Set-Content -Path $registryPathForSmokeTest -Value $registryContent -Encoding utf8
    }

    $registryArg = "--gateway-arg=--registry=$(Convert-ToForwardSlashPath -Path $registryPathForSmokeTest)"
    $catalogArg = "--gateway-arg=--additional-catalog=$(Convert-ToForwardSlashPath -Path $CatalogPath)"
    $spotCheckServers = @('playwright', 'filescopemcp')
    $spotCheckResults = @()

    foreach ($serverName in $spotCheckServers) {
        $serverArg = "--gateway-arg=--servers=$serverName"
        $countOutput = & docker mcp tools count $registryArg $catalogArg $serverArg 2>&1
        $countText = (@($countOutput) -join "`n")
        $toolCount = -1

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Hybrid lazy-load smoke test failed while checking '$serverName'. Output: $countText"
            exit 1
        }

        if ($countText -match '(\d+)\s+tools') {
            $toolCount = [int]$Matches[1]
        }

        if ($toolCount -le 0) {
            Write-Error "Hybrid lazy-load smoke test failed. Expected '$serverName' to expose tools, but count was $toolCount."
            exit 1
        }

        $spotCheckResults += "${serverName}=$toolCount"
    }

    Write-Host "Hybrid lazy-load smoke test passed: seeded registry validated and spot-check servers available ($($spotCheckResults -join ', '))." -ForegroundColor Green
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
