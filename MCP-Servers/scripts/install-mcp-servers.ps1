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

function Get-TemplateContent {
    param(
        [string]$TemplatePath,
        [string]$RepoRoot
    )

    $content = Get-Content -Path $TemplatePath -Raw
    $repoRootForward = $RepoRoot -replace '\\', '/'

    # Keep templates portable if this repo is checked out somewhere else.
    return $content.Replace('D:/Coding/Tools/mcp-docker-stack', $repoRootForward)
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
        [switch]$ValidateJson,
        [switch]$DryRunMode,
        [switch]$SkipBackupMode
    )

    if (-not (Test-Path $TemplatePath)) {
        throw "Template not found: $TemplatePath"
    }

    $content = Get-TemplateContent -TemplatePath $TemplatePath -RepoRoot $RepoRoot
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

    Set-Content -Path $DestinationPath -Value $content -Encoding utf8
    Write-Host "Installed $Label config: $DestinationPath" -ForegroundColor Green
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$targets = @()

switch ($Vendor) {
    'openai' {
        $targets += @{
            Label       = 'OpenAI Codex'
            Template    = (Join-Path $repoRoot 'Agent\OpenAI\Codex\mcp\config.toml')
            Destination = (Join-Path $env:USERPROFILE '.codex\config.toml')
            Json        = $false
        }
    }
    'google' {
        $targets += @{
            Label       = 'Google Antigravity'
            Template    = (Join-Path $repoRoot 'Agent\Google\Antigravity\mcp\mcp_config.json')
            Destination = (Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json')
            Json        = $true
        }
    }
    'all' {
        $targets += @{
            Label       = 'OpenAI Codex'
            Template    = (Join-Path $repoRoot 'Agent\OpenAI\Codex\mcp\config.toml')
            Destination = (Join-Path $env:USERPROFILE '.codex\config.toml')
            Json        = $false
        }
        $targets += @{
            Label       = 'Google Antigravity'
            Template    = (Join-Path $repoRoot 'Agent\Google\Antigravity\mcp\mcp_config.json')
            Destination = (Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json')
            Json        = $true
        }
    }
}

Write-Host '=== Hybrid MCP Config Installer ===' -ForegroundColor Cyan
Write-Host "Repo root: $repoRoot" -ForegroundColor Gray
Write-Host 'This installs the repo-owned hybrid templates:' -ForegroundColor Gray
Write-Host '- direct always-on MCP servers in each client config' -ForegroundColor Gray
Write-Host '- one MCP_DOCKER gateway for supplemental lazy-load servers' -ForegroundColor Gray
Write-Host ''

foreach ($target in $targets) {
    Install-TemplateFile `
        -Label $target.Label `
        -TemplatePath $target.Template `
        -DestinationPath $target.Destination `
        -RepoRoot $repoRoot `
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
    Write-Host "3. Sync Docker secrets from .env:" -ForegroundColor Gray
    Write-Host "   .\set-mcp-secrets.ps1" -ForegroundColor Gray
    Write-Host "4. Restart Codex and/or Antigravity." -ForegroundColor Gray
}
