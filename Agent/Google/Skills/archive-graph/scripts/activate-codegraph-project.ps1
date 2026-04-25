[CmdletBinding()]
param(
    [string]$ProjectPath = ".",
    [ValidateSet('all', 'openai', 'google')]
    [string]$Vendor = 'all'
)

$ErrorActionPreference = 'Stop'

function Write-TextFileUtf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Convert-ToForwardSlashPath {
    param([string]$Path)

    return ($Path -replace '\\', '/')
}

function Get-ResolvedProjectPath {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Project path not found: $Path"
    }

    $resolved = (Resolve-Path $Path -ErrorAction Stop).Path
    if (-not (Test-Path $resolved -PathType Container)) {
        throw "Project path must be a directory: $resolved"
    }

    return $resolved
}

function Update-CodexConfig {
    param(
        [string]$ConfigPath,
        [string]$ProjectPath
    )

    if (-not (Test-Path $ConfigPath)) {
        throw "Codex config not found: $ConfigPath"
    }

    $projectForward = Convert-ToForwardSlashPath $ProjectPath
    $content = Get-Content -Path $ConfigPath -Raw
    $replacement = @"
[mcp_servers.codegraph]
command = "docker.exe"
args = [
  "run",
  "--rm",
  "-i",
  "-v",
  "${projectForward}:/workspace",
  "mcp-local-adapters:latest",
  "--mode",
  "codegraph",
]
startup_timeout_sec = 30
tool_timeout_sec = 120
"@

    $updated = [regex]::Replace(
        $content,
        '(?ms)^\[mcp_servers\.codegraph\]\r?\n.*?(?=^\[mcp_servers\.|\z)',
        $replacement + [Environment]::NewLine
    )

    if ($updated -eq $content) {
        throw "Could not find [mcp_servers.codegraph] block in $ConfigPath"
    }

    Write-TextFileUtf8NoBom -Path $ConfigPath -Content $updated
}

function Update-AntigravityConfig {
    param(
        [string]$ConfigPath,
        [string]$ProjectPath
    )

    if (-not (Test-Path $ConfigPath)) {
        throw "Antigravity config not found: $ConfigPath"
    }

    $projectForward = Convert-ToForwardSlashPath $ProjectPath
    $config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

    if (-not $config.mcpServers.codegraph) {
        throw "Could not find mcpServers.codegraph in $ConfigPath"
    }

    $config.mcpServers.codegraph.command = "docker.exe"
    $config.mcpServers.codegraph.startup_timeout_sec = 30
    $config.mcpServers.codegraph.tool_timeout_sec = 120
    $config.mcpServers.codegraph.args = @(
        "run",
        "--rm",
        "-i",
        "-v",
        "${projectForward}:/workspace",
        "mcp-local-adapters:latest",
        "--mode",
        "codegraph"
    )

    $json = $config | ConvertTo-Json -Depth 20
    Write-TextFileUtf8NoBom -Path $ConfigPath -Content $json
}

$resolvedProjectPath = Get-ResolvedProjectPath -Path $ProjectPath
$codexConfigPath = Join-Path $env:USERPROFILE '.codex\config.toml'
$antigravityConfigPath = Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json'

Write-Host '=== Activate Project-Scoped CodeGraph ===' -ForegroundColor Cyan
Write-Host "Project: $resolvedProjectPath" -ForegroundColor Gray
Write-Host "Vendor:  $Vendor" -ForegroundColor Gray
Write-Host ''

switch ($Vendor) {
    'openai' {
        Update-CodexConfig -ConfigPath $codexConfigPath -ProjectPath $resolvedProjectPath
        Write-Host "Updated Codex config: $codexConfigPath" -ForegroundColor Green
    }
    'google' {
        Update-AntigravityConfig -ConfigPath $antigravityConfigPath -ProjectPath $resolvedProjectPath
        Write-Host "Updated Antigravity config: $antigravityConfigPath" -ForegroundColor Green
    }
    'all' {
        Update-CodexConfig -ConfigPath $codexConfigPath -ProjectPath $resolvedProjectPath
        Update-AntigravityConfig -ConfigPath $antigravityConfigPath -ProjectPath $resolvedProjectPath
        Write-Host "Updated Codex config: $codexConfigPath" -ForegroundColor Green
        Write-Host "Updated Antigravity config: $antigravityConfigPath" -ForegroundColor Green
    }
}

Write-Host ''
Write-Host 'CodeGraph is now pointed at this project only.' -ForegroundColor Cyan
Write-Host 'If a client already has CodeGraph running or cached, restart that client before expecting the new project root to take effect.' -ForegroundColor Yellow
