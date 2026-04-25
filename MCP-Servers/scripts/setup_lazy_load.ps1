[CmdletBinding()]
param(
    [ValidateSet('google', 'openai', 'all')]
    [string]$Vendor = 'all',
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

function New-RegistryTarget {
    param(
        [string]$Label,
        [string]$Path,
        [string]$SeedPath
    )

    return [pscustomobject]@{
        Label    = $Label
        Path     = $Path
        SeedPath = $SeedPath
    }
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error 'Docker CLI not found on PATH.'
    exit 1
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

if ([string]::IsNullOrWhiteSpace($CatalogPath)) {
    $CatalogPath = Join-Path $repoRoot 'MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml'
}

if (-not (Test-Path $CatalogPath)) {
    Write-Error "Runtime catalog not found: $CatalogPath"
    exit 1
}

$codexRegistryPath = Join-Path $env:USERPROFILE '.docker\mcp\registry.hybrid-supplementals.yaml'
$antigravityRegistryPath = Join-Path $env:USERPROFILE '.docker\mcp\registry.hybrid-supplementals-antigravity.yaml'
$codexSeedRegistryPath = Join-Path $repoRoot 'MCP-Servers\mcp-docker-stack\registry.supplementals.yaml'
$antigravitySeedRegistryPath = Join-Path $repoRoot 'MCP-Servers\mcp-docker-stack\registry.supplementals.antigravity.yaml'
$targets = @()

if (-not [string]::IsNullOrWhiteSpace($RegistryPath)) {
    if ([string]::IsNullOrWhiteSpace($SeedRegistryPath)) {
        $SeedRegistryPath = $codexSeedRegistryPath
    }

    $targets += New-RegistryTarget -Label 'Custom' -Path $RegistryPath -SeedPath $SeedRegistryPath
}
else {
    switch ($Vendor) {
        'openai' {
            $targets += New-RegistryTarget -Label 'OpenAI Codex' -Path $codexRegistryPath -SeedPath $codexSeedRegistryPath
        }
        'google' {
            $targets += New-RegistryTarget -Label 'Google Antigravity' -Path $antigravityRegistryPath -SeedPath $antigravitySeedRegistryPath
        }
        'all' {
            $targets += New-RegistryTarget -Label 'OpenAI Codex' -Path $codexRegistryPath -SeedPath $codexSeedRegistryPath
            $targets += New-RegistryTarget -Label 'Google Antigravity' -Path $antigravityRegistryPath -SeedPath $antigravitySeedRegistryPath
        }
    }
}

$catalogText = Get-Content -Path $CatalogPath -Raw
$emptyRegistryContent = "registry: {}`n"

Write-Host '=== Hybrid Lazy-Load Setup ===' -ForegroundColor Cyan
Write-Host "Runtime catalog: $CatalogPath" -ForegroundColor Gray
Write-Host 'Runtime registries are initialized empty so only Docker gateway native Dynamic MCP tools are exposed at startup.' -ForegroundColor Gray
Write-Host ''

foreach ($target in $targets) {
    if (-not (Test-Path $target.SeedPath)) {
        Write-Error "Supplemental registry seed not found for $($target.Label): $($target.SeedPath)"
        exit 1
    }

    $seedServerNames = Get-RegistryServerNames -Path $target.SeedPath
    $missingCatalogServers = @($seedServerNames | Where-Object { $catalogText -notmatch "(?m)^  $([regex]::Escape($_)):\s*$" })

    if ($missingCatalogServers.Count -gt 0) {
        Write-Error "Supplemental registry for $($target.Label) references missing runtime catalog entries: $($missingCatalogServers -join ', ')"
        exit 1
    }

    Write-Host "$($target.Label) registry: $($target.Path)" -ForegroundColor Gray
    Write-Host "$($target.Label) seed registry: $($target.SeedPath)" -ForegroundColor Gray
    Write-Host "$($target.Label) discoverable supplemental servers: $($seedServerNames.Count)" -ForegroundColor Gray

    if ($DryRun) {
        Write-Host "[DRY RUN] Would initialize native-only runtime registry at $($target.Path)" -ForegroundColor Yellow
    }
    else {
        Ensure-Directory -Path $target.Path
        Set-Content -Path $target.Path -Value $emptyRegistryContent -Encoding utf8
        Write-Host "Native-only runtime registry initialized: $($target.Path)" -ForegroundColor Green
    }

    if (-not $SkipSmokeTest) {
        $registryPathForSmokeTest = $target.Path
        $tempSmokeRegistry = $null

        if ($DryRun -or -not (Test-Path $target.Path)) {
            $tempSmokeRegistry = Join-Path $env:TEMP "registry.native-only.$($target.Label -replace '[^A-Za-z0-9._-]', '-').yaml"
            Set-Content -Path $tempSmokeRegistry -Value $emptyRegistryContent -Encoding utf8
            $registryPathForSmokeTest = $tempSmokeRegistry
        }

        $registryArg = "--gateway-arg=--registry=$(Convert-ToForwardSlashPath -Path $registryPathForSmokeTest)"
        $catalogArg = "--gateway-arg=--additional-catalog=$(Convert-ToForwardSlashPath -Path $CatalogPath)"
        $nativeCountOutput = & docker mcp tools count $registryArg $catalogArg 2>&1
        $nativeCountText = (@($nativeCountOutput) -join "`n")
        $nativeToolCount = -1

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Native-only smoke test failed for $($target.Label). Output: $nativeCountText"
            exit 1
        }

        if ($nativeCountText -match '(\d+)\s+tools') {
            $nativeToolCount = [int]$Matches[1]
        }

        if ($nativeToolCount -ne 6) {
            Write-Error "Native-only smoke test failed for $($target.Label). Expected 6 Docker gateway native tools, but count was $nativeToolCount."
            exit 1
        }

        $spotCheckServers = @('playwright', 'filescopemcp') | Where-Object { $seedServerNames -contains $_ }
        $spotCheckResults = @()

        foreach ($serverName in $spotCheckServers) {
            $serverArg = "--gateway-arg=--servers=$serverName"
            $countOutput = & docker mcp tools count $registryArg $catalogArg $serverArg 2>&1
            $countText = (@($countOutput) -join "`n")
            $toolCount = -1

            if ($LASTEXITCODE -ne 0) {
                Write-Error "Lazy-load smoke test failed while checking '$serverName' for $($target.Label). Output: $countText"
                exit 1
            }

            if ($countText -match '(\d+)\s+tools') {
                $toolCount = [int]$Matches[1]
            }

            if ($toolCount -le 0) {
                Write-Error "Lazy-load smoke test failed. Expected '$serverName' to expose tools when explicitly loaded for $($target.Label), but count was $toolCount."
                exit 1
            }

            $spotCheckResults += "${serverName}=$toolCount"
        }

        if ($tempSmokeRegistry -and (Test-Path $tempSmokeRegistry)) {
            Remove-Item -LiteralPath $tempSmokeRegistry -Force
        }

        if ($spotCheckResults.Count -gt 0) {
            Write-Host "Smoke test passed for $($target.Label): native=6, explicit loads available ($($spotCheckResults -join ', '))." -ForegroundColor Green
        }
        else {
            Write-Host "Smoke test passed for $($target.Label): native=6." -ForegroundColor Green
        }
    }
    else {
        Write-Host 'Skipping smoke test.' -ForegroundColor Yellow
    }

    Write-Host ''
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
