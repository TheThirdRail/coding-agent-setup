[CmdletBinding()]
param(
    [ValidateSet('google', 'openai', 'all')]
    [string]$Vendor = 'all',
    [switch]$DryRun,
    [switch]$SkipBackup
)

$ErrorActionPreference = 'Stop'

function Ensure-Directory {
    param([string]$Path)

    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function New-BackupPath {
    param([string]$Path)

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    return "$Path.bak-$timestamp"
}

function Write-TextFileUtf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Get-TemplateContent {
    param(
        [string]$TemplatePath,
        [string]$RepoRoot,
        [string]$HybridRegistryPath
    )

    $content = Get-Content -Path $TemplatePath -Raw
    $repoRootForward = $RepoRoot -replace '\\', '/'
    $hybridRegistryForward = $HybridRegistryPath -replace '\\', '/'

    # Keep templates portable if this repo is checked out somewhere else.
    $content = $content.Replace('D:/Coding/Tools/mcp-docker-stack', $repoRootForward)
    return $content.Replace('__HYBRID_REGISTRY_PATH__', $hybridRegistryForward)
}

function Test-JsonContent {
    param([string]$Content)

    $null = $Content | ConvertFrom-Json
}

function Install-TemplateFile {
    param(
        [string]$Label,
        [string]$TemplatePath,
        [string]$DestinationPath,
        [string]$RepoRoot,
        [string]$HybridRegistryPath,
        [switch]$ValidateJson,
        [switch]$DryRunMode,
        [switch]$SkipBackupMode
    )

    if (-not (Test-Path $TemplatePath)) {
        throw "Template not found: $TemplatePath"
    }

    $content = Get-TemplateContent -TemplatePath $TemplatePath -RepoRoot $RepoRoot -HybridRegistryPath $HybridRegistryPath
    if ($ValidateJson) {
        Test-JsonContent -Content $content
    }

    if ($DryRunMode) {
        Write-Host "[DRY RUN] Would install $Label config" -ForegroundColor Yellow
        Write-Host "  Template:    $TemplatePath" -ForegroundColor Gray
        Write-Host "  Destination: $DestinationPath" -ForegroundColor Gray
        if ((Test-Path $DestinationPath) -and -not $SkipBackupMode) {
            Write-Host "  Backup:      $(New-BackupPath -Path $DestinationPath)" -ForegroundColor Gray
        }
        return
    }

    Ensure-Directory -Path $DestinationPath

    if ((Test-Path $DestinationPath) -and -not $SkipBackupMode) {
        $backupPath = New-BackupPath -Path $DestinationPath
        Copy-Item -Path $DestinationPath -Destination $backupPath -Force
        Write-Host "Backed up existing $Label config: $backupPath" -ForegroundColor DarkYellow
    }

    Write-TextFileUtf8NoBom -Path $DestinationPath -Content $content
    Write-Host "Installed $Label config: $DestinationPath" -ForegroundColor Green
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$codexHybridRegistryPath = Join-Path $env:USERPROFILE '.docker\mcp\registry.hybrid-supplementals.yaml'
$antigravityHybridRegistryPath = Join-Path $env:USERPROFILE '.docker\mcp\registry.hybrid-supplementals-antigravity.yaml'
$targets = @()

switch ($Vendor) {
    'openai' {
        $targets += @{
            Label              = 'OpenAI Codex'
            Template           = (Join-Path $repoRoot 'Agent\OpenAI\Codex\mcp\config.toml')
            Destination        = (Join-Path $env:USERPROFILE '.codex\config.toml')
            Json               = $false
            HybridRegistryPath = $codexHybridRegistryPath
        }
    }
    'google' {
        $targets += @{
            Label              = 'Google Antigravity'
            Template           = (Join-Path $repoRoot 'Agent\Google\Antigravity\mcp\mcp_config.json')
            Destination        = (Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json')
            Json               = $true
            HybridRegistryPath = $antigravityHybridRegistryPath
        }
    }
    'all' {
        $targets += @{
            Label              = 'OpenAI Codex'
            Template           = (Join-Path $repoRoot 'Agent\OpenAI\Codex\mcp\config.toml')
            Destination        = (Join-Path $env:USERPROFILE '.codex\config.toml')
            Json               = $false
            HybridRegistryPath = $codexHybridRegistryPath
        }
        $targets += @{
            Label              = 'Google Antigravity'
            Template           = (Join-Path $repoRoot 'Agent\Google\Antigravity\mcp\mcp_config.json')
            Destination        = (Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json')
            Json               = $true
            HybridRegistryPath = $antigravityHybridRegistryPath
        }
    }
}

Write-Host '=== Hybrid MCP Config Installer ===' -ForegroundColor Cyan
Write-Host "Repo root: $repoRoot" -ForegroundColor Gray
Write-Host 'This installs the repo-owned hybrid templates:' -ForegroundColor Gray
Write-Host '- direct always-on MCP servers in each client config' -ForegroundColor Gray
Write-Host '- one MCP_DOCKER gateway per client wired to its per-user lazy-load registry' -ForegroundColor Gray
Write-Host "Codex runtime registry: $codexHybridRegistryPath" -ForegroundColor Gray
Write-Host "Antigravity runtime registry: $antigravityHybridRegistryPath" -ForegroundColor Gray
Write-Host ''

foreach ($target in $targets) {
    Install-TemplateFile `
        -Label $target.Label `
        -TemplatePath $target.Template `
        -DestinationPath $target.Destination `
        -RepoRoot $repoRoot `
        -HybridRegistryPath $target.HybridRegistryPath `
        -ValidateJson:$target.Json `
        -DryRunMode:$DryRun `
        -SkipBackupMode:$SkipBackup
}

Write-Host ''
if ($DryRun) {
    Write-Host '[DRY RUN] No files were modified.' -ForegroundColor Yellow
}
else {
    Write-Host 'Next steps:' -ForegroundColor Cyan
    Write-Host "1. Build the local adapter image:" -ForegroundColor Gray
    Write-Host "   docker build -t mcp-local-adapters:latest -f $repoRoot\MCP-Servers\local\adapters\Dockerfile $repoRoot" -ForegroundColor Gray
    Write-Host "2. Start local SearXNG:" -ForegroundColor Gray
    Write-Host "   docker compose -f $repoRoot\MCP-Servers\local\searxng\docker-compose.yml up -d" -ForegroundColor Gray
    Write-Host "3. Refresh the seeded lazy-load registry:" -ForegroundColor Gray
    Write-Host "   .\setup_lazy_load.ps1" -ForegroundColor Gray
    Write-Host "4. Sync Docker secrets from .env:" -ForegroundColor Gray
    Write-Host "   .\set-mcp-secrets.ps1" -ForegroundColor Gray
    Write-Host "5. Start the shared Serena HTTP server:" -ForegroundColor Gray
    Write-Host "   powershell -ExecutionPolicy Bypass -File $repoRoot\MCP-Servers\scripts\start-serena-http.ps1" -ForegroundColor Gray
    Write-Host "6. Restart Codex and/or Antigravity." -ForegroundColor Gray
}
