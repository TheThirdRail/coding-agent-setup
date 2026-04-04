[CmdletBinding()]
param(
    [string]$EnvFilePath = '',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($EnvFilePath)) {
    $EnvFilePath = Join-Path $PSScriptRoot '..\..\.env'
}

if (-not (Test-Path $EnvFilePath)) {
    Write-Error "File not found: $EnvFilePath"
    exit 1
}

$dockerSecretMappings = [ordered]@{
    'GITHUB_PERSONAL_ACCESS_TOKEN' = @('github.token', 'github.personal_access_token')
    'FIRECRAWL_API_KEY'            = @('firecrawl.api_key', 'firecrawl.key')
}

$directOnlyVariables = [ordered]@{
    'SEARXNG_URL'      = 'Direct client config value for the local SearXNG adapter. Not written to Docker secrets.'
    'CONTEXT7_API_KEY' = 'Optional direct-client Context7 auth. Not written to Docker secrets by this script.'
}

function ConvertTo-NormalizedEnvValue {
    param([string]$Value)

    $trimmed = $Value.Trim()
    if (
        ($trimmed.StartsWith('"') -and $trimmed.EndsWith('"')) -or
        ($trimmed.StartsWith("'") -and $trimmed.EndsWith("'"))
    ) {
        return $trimmed.Substring(1, $trimmed.Length - 2)
    }

    return $trimmed
}

function Get-EnvEntries {
    param([string]$Path)

    $entries = @{}
    foreach ($rawLine in Get-Content $Path) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) {
            continue
        }

        $parts = $line.Split('=', 2)
        if ($parts.Count -ne 2) {
            continue
        }

        $name = $parts[0].Trim()
        $value = ConvertTo-NormalizedEnvValue -Value $parts[1]
        if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($value)) {
            continue
        }

        $entries[$name] = $value
    }

    return $entries
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error 'Docker CLI not found on PATH.'
    exit 1
}

$envEntries = Get-EnvEntries -Path $EnvFilePath
$setCount = 0
$failCount = 0

Write-Host '+--------------------------------------------+' -ForegroundColor Cyan
Write-Host '|   Docker MCP Secrets Configuration         |' -ForegroundColor Cyan
Write-Host '+--------------------------------------------+' -ForegroundColor Cyan
Write-Host "Reading environment values from $EnvFilePath..." -ForegroundColor Yellow
Write-Host ''

foreach ($envName in $dockerSecretMappings.Keys) {
    if (-not $envEntries.ContainsKey($envName)) {
        continue
    }

    foreach ($secretName in $dockerSecretMappings[$envName]) {
        if ($DryRun) {
            Write-Host "[DRY RUN] Would set $secretName from $envName" -ForegroundColor Yellow
            continue
        }

        Write-Host "  Setting $secretName..." -NoNewline
        try {
            $envEntries[$envName] | docker mcp secret set $secretName 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host ' [OK]' -ForegroundColor Green
                $setCount++
            }
            else {
                Write-Host ' [FAIL]' -ForegroundColor Red
                $failCount++
            }
        }
        catch {
            Write-Host ' [FAIL]' -ForegroundColor Red
            $failCount++
        }
    }
}

Write-Host ''
Write-Host 'Direct-client variables detected in .env:' -ForegroundColor Cyan
foreach ($name in $directOnlyVariables.Keys) {
    if ($envEntries.ContainsKey($name)) {
        Write-Host "  - $name" -ForegroundColor Gray
        Write-Host "    $($directOnlyVariables[$name])" -ForegroundColor DarkGray
    }
}

$missingDockerVars = @($dockerSecretMappings.Keys | Where-Object { -not $envEntries.ContainsKey($_) })

Write-Host ''
Write-Host '--------------------------------------------' -ForegroundColor Cyan
if ($DryRun) {
    Write-Host '[DRY RUN] No Docker secrets were changed.' -ForegroundColor Yellow
}
else {
    Write-Host "Results: $setCount secrets set, $failCount failed" -ForegroundColor $(if ($failCount -eq 0) { 'Green' } else { 'Yellow' })
}

if ($missingDockerVars.Count -gt 0) {
    Write-Host 'Missing optional Docker-secret env vars:' -ForegroundColor Yellow
    foreach ($name in $missingDockerVars) {
        Write-Host "  - $name" -ForegroundColor Gray
    }
}

Write-Host "Run 'docker mcp secret ls' to verify stored Docker secrets." -ForegroundColor Gray
