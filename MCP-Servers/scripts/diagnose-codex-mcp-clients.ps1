[CmdletBinding()]
param(
    [ValidateRange(5, 120)]
    [int]$ObserveSeconds = 25,
    [string]$ReportPath = ''
)

$ErrorActionPreference = 'Stop'

function Invoke-TimedCommand {
    param([string]$Command)

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $output = Invoke-Expression $Command 2>&1
    $stopwatch.Stop()

    return [pscustomobject]@{
        command       = $Command
        exit_code     = $LASTEXITCODE
        elapsed_ms    = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 0)
        output_lines  = @($output | ForEach-Object { "$_" })
        output_text   = (@($output | ForEach-Object { "$_" }) -join "`n")
    }
}

function Get-LatestFile {
    param(
        [string]$RootPath,
        [string]$Filter = '*'
    )

    if (-not (Test-Path $RootPath)) {
        return $null
    }

    return Get-ChildItem -Path $RootPath -Recurse -File -Filter $Filter |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

function Get-StandaloneArtifacts {
    $packageRoot = 'C:\Users\jerem\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0'
    $logRoot = Join-Path $packageRoot 'LocalCache\Local\Codex\Logs'
    $latestLog = Get-LatestFile -RootPath $logRoot -Filter '*.log'

    $preferencesPath = Join-Path $packageRoot 'LocalCache\Roaming\Codex\Preferences'
    $localStatePath = Join-Path $packageRoot 'LocalCache\Roaming\Codex\Local State'
    $roamingCodexPath = Join-Path $packageRoot 'LocalCache\Roaming\Codex'

    $preferenceHints = @()
    foreach ($path in @($preferencesPath, $localStatePath)) {
        if (Test-Path $path) {
            $hits = Select-String -Path $path -Pattern 'mcp|gateway|registry|catalog|docker' -CaseSensitive:$false -ErrorAction SilentlyContinue
            foreach ($hit in $hits) {
                $preferenceHints += [pscustomobject]@{
                    path       = $path
                    line       = $hit.LineNumber
                    line_text  = $hit.Line.Trim()
                }
            }
        }
    }

    return [pscustomobject]@{
        package_root        = $packageRoot
        log_root            = $logRoot
        log_path            = if ($latestLog) { $latestLog.FullName } else { '' }
        preferences_path    = $preferencesPath
        local_state_path    = $localStatePath
        roaming_codex_path  = $roamingCodexPath
        preference_hints    = $preferenceHints
    }
}

function Get-ExtensionArtifacts {
    $logRoot = 'C:\Users\jerem\AppData\Roaming\Antigravity\logs'
    $latestLog = Get-ChildItem -Path $logRoot -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match 'openai\.chatgpt\\Codex\.log$' } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    return [pscustomobject]@{
        log_root  = $logRoot
        log_path  = if ($latestLog) { $latestLog.FullName } else { '' }
    }
}

function Get-ConfigEvidence {
    $codexConfigPath = Join-Path $env:USERPROFILE '.codex\config.toml'
    $codexConfigRaw = if (Test-Path $codexConfigPath) { Get-Content -Path $codexConfigPath -Raw } else { '' }

    $extensionConfigPath = Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json'
    $extensionConfigRaw = if (Test-Path $extensionConfigPath) { Get-Content -Path $extensionConfigPath -Raw } else { '' }

    return [pscustomobject]@{
        codex_config_path       = $codexConfigPath
        codex_config_has_entry  = ($codexConfigRaw -match '(?ms)^\[mcp_servers\.MCP_DOCKER\].*?docker(?:\.exe)?')
        codex_config_has_gateway = ($codexConfigRaw -match '(?i)\bmcp\b' -and $codexConfigRaw -match '(?i)\bgateway\b' -and $codexConfigRaw -match '(?i)\brun\b')
        extension_config_path   = $extensionConfigPath
        extension_config_has_entry = ($extensionConfigRaw -match '(?i)"MCP_DOCKER"')
        extension_config_has_gateway = ($extensionConfigRaw -match '(?i)"command"\s*:\s*"docker' -and $extensionConfigRaw -match '(?i)gateway' -and $extensionConfigRaw -match '(?i)runtime\.yaml')
    }
}

function Get-CodexProcesses {
    $rows = Get-CimInstance Win32_Process | Where-Object {
        $_.Name -match '^(Codex|codex|docker)\.exe$'
    }

    $results = foreach ($row in $rows) {
        [pscustomobject]@{
            pid         = $row.ProcessId
            parent_pid  = $row.ParentProcessId
            name        = $row.Name
            command     = [string]$row.CommandLine
        }
    }

    return @($results | Sort-Object name, pid)
}

function Get-ChildMap {
    param([object[]]$Processes)

    $map = @{}
    foreach ($process in $Processes) {
        if (-not $map.ContainsKey([string]$process.parent_pid)) {
            $map[[string]$process.parent_pid] = @()
        }
        $map[[string]$process.parent_pid] += $process
    }
    return $map
}

function Get-ProcessObservation {
    param(
        [int]$Seconds
    )

    $deadline = (Get-Date).AddSeconds($Seconds)
    $samples = @()
    $dockerGatewaySeen = $false

    while ((Get-Date) -lt $deadline) {
        $snapshot = Get-CodexProcesses
        foreach ($process in $snapshot) {
            $samples += [pscustomobject]@{
                timestamp = (Get-Date).ToString('o')
                pid       = $process.pid
                parent_pid = $process.parent_pid
                name      = $process.name
                command   = $process.command
            }

            if ($process.name -match '(?i)^docker\.exe$' -and $process.command -match '(?i)\bmcp\b' -and $process.command -match '(?i)\bgateway\b') {
                $dockerGatewaySeen = $true
            }
        }

        Start-Sleep -Milliseconds 1000
    }

    return [pscustomobject]@{
        docker_gateway_seen = $dockerGatewaySeen
        samples             = @($samples)
    }
}

function Get-StandaloneLogEvidence {
    param(
        [string]$LogRoot,
        [string]$LatestLogPath
    )

    if (-not $LogRoot -or -not (Test-Path $LogRoot)) {
        return [pscustomobject]@{
            exists                      = $false
            stdio_transport_spawned     = $false
            mcp_status_calls            = @()
            direct_transport_hits       = @()
            app_server_failure_hits     = @()
            registry_path_seen          = $false
            catalog_path_seen           = $false
            last_lines                  = @()
        }
    }

    $logFiles = @(Get-ChildItem -Path $LogRoot -Recurse -File -Filter '*.log' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
    if ($logFiles.Count -eq 0) {
        return [pscustomobject]@{
            exists                      = $false
            stdio_transport_spawned     = $false
            mcp_status_calls            = @()
            direct_transport_hits       = @()
            app_server_failure_hits     = @()
            registry_path_seen          = $false
            catalog_path_seen           = $false
            last_lines                  = @()
        }
    }

    $mcpHits = Select-String -Path $logFiles -Pattern 'mcpServerStatus/list' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $transportHits = Select-String -Path $logFiles -Pattern 'docker\.exe|registry\.all\.yaml|docker-mcp-catalog\.runtime\.yaml|--additional-catalog|--registry|gateway run|MCP_DOCKER' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $spawnHits = Select-String -Path $logFiles -Pattern 'stdio_transport_spawned' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $appServerFailureHits = Select-String -Path $logFiles -Pattern 'Codex app-server is not available|Codex app-server exited unexpectedly' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $lastLines = if ($LatestLogPath -and (Test-Path $LatestLogPath)) { Get-Content -Path $LatestLogPath -Tail 80 } else { @() }

    return [pscustomobject]@{
        exists                  = $true
        stdio_transport_spawned = ($spawnHits.Count -gt 0)
        mcp_status_calls        = @($mcpHits | Select-Object -First 50 | ForEach-Object {
            [pscustomobject]@{
                path      = $_.Path
                line      = $_.LineNumber
                text      = $_.Line.Trim()
            }
        })
        direct_transport_hits   = @($transportHits | Select-Object -First 50 | ForEach-Object {
            [pscustomobject]@{
                path      = $_.Path
                line      = $_.LineNumber
                text      = $_.Line.Trim()
            }
        })
        app_server_failure_hits = @($appServerFailureHits | Select-Object -First 20 | ForEach-Object {
            [pscustomobject]@{
                path      = $_.Path
                line      = $_.LineNumber
                text      = $_.Line.Trim()
            }
        })
        registry_path_seen      = ($transportHits | Where-Object { $_.Line -match 'registry\.all\.yaml' } | Measure-Object).Count -gt 0
        catalog_path_seen       = ($transportHits | Where-Object { $_.Line -match 'docker-mcp-catalog\.runtime\.yaml' } | Measure-Object).Count -gt 0
        last_lines              = @($lastLines)
    }
}

function Get-ExtensionLogEvidence {
    param([string]$LogPath)

    if (-not $LogPath -or -not (Test-Path $LogPath)) {
        return [pscustomobject]@{
            exists                           = $false
            spawn_hits                       = @()
            unsupported_capability_hits      = @()
            direct_transport_hits            = @()
            last_lines                       = @()
        }
    }

    $spawnHits = Select-String -Path $LogPath -Pattern 'CodexMcpConnection|Spawning codex app-server' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $unsupportedHits = Select-String -Path $LogPath -Pattern 'local-environments is not supported in the extension|open-in-target not supported in extension|chatSessionsProvider' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $directTransportHits = Select-String -Path $LogPath -Pattern 'docker\.exe|registry\.all\.yaml|docker-mcp-catalog\.runtime\.yaml|--additional-catalog|--registry|gateway run|MCP_DOCKER' -CaseSensitive:$false -ErrorAction SilentlyContinue
    $lastLines = Get-Content -Path $LogPath -Tail 120

    return [pscustomobject]@{
        exists                      = $true
        spawn_hits                  = @($spawnHits | ForEach-Object {
            [pscustomobject]@{
                line = $_.LineNumber
                text = $_.Line.Trim()
            }
        })
        unsupported_capability_hits = @($unsupportedHits | ForEach-Object {
            [pscustomobject]@{
                line = $_.LineNumber
                text = $_.Line.Trim()
            }
        })
        direct_transport_hits       = @($directTransportHits | Select-Object -First 50 | ForEach-Object {
            [pscustomobject]@{
                line = $_.LineNumber
                text = $_.Line.Trim()
            }
        })
        last_lines                  = @($lastLines)
    }
}

function Get-StandaloneClassification {
    param(
        [object]$Artifacts,
        [object]$LogEvidence,
        [object]$Observation
    )

    $result = [ordered]@{
        client                = 'standalone'
        config_source         = 'external config present; package-local MCP config not evidenced'
        app_server_path       = 'Store app packaged codex.exe app-server'
        docker_spawn_observed = $false
        gateway_result_observed = 'control-only'
        failure_stage         = ''
        likely_root_cause     = ''
        confidence            = 'medium'
    }

    $dockerSeen = $Observation.docker_gateway_seen -or ($LogEvidence.direct_transport_hits.Count -gt 0)
    $result.docker_spawn_observed = $dockerSeen

    if ($LogEvidence.exists -and $LogEvidence.app_server_failure_hits.Count -gt 0 -and -not $dockerSeen) {
        $result.gateway_result_observed = 'none from standalone path'
        $result.failure_stage = 'after internal app-server startup, before any external Docker gateway transport evidence'
        $result.likely_root_cause = 'standalone launches its bundled codex app-server, but that internal layer becomes unavailable or stalls before any configured Docker gateway transport is evidenced'
        $result.confidence = 'high'
        return [pscustomobject]$result
    }

    if ($LogEvidence.exists -and $LogEvidence.mcp_status_calls.Count -gt 0 -and -not $dockerSeen) {
        $result.gateway_result_observed = 'none from standalone path'
        $result.failure_stage = 'after internal app-server startup, before any external Docker gateway transport evidence'
        $result.likely_root_cause = 'standalone polls MCP status through its internal app-server, but there is no evidence that it ever invokes the configured Docker gateway transport'
        $result.confidence = 'high'
        return [pscustomobject]$result
    }

    if ($LogEvidence.exists -and $LogEvidence.mcp_status_calls.Count -gt 0 -and $dockerSeen) {
        $result.failure_stage = 'after transport invocation, during UI/server-status handling'
        $result.likely_root_cause = 'standalone app appears to reach the transport path, but the UI status layer is stalling or mishandling the returned state'
        return [pscustomobject]$result
    }

    $result.failure_stage = 'insufficient runtime evidence'
    $result.likely_root_cause = 'no conclusive standalone MCP status evidence was captured'
    $result.confidence = 'low'
    return [pscustomobject]$result
}

function Get-ExtensionClassification {
    param(
        [object]$LogEvidence,
        [object]$Observation
    )

    $result = [ordered]@{
        client                  = 'ide-extension'
        config_source           = 'Codex-side external config present; extension host behavior dominates outcome'
        app_server_path         = 'bundled extension codex.exe app-server'
        docker_spawn_observed   = $false
        gateway_result_observed = 'not directly observed from extension path'
        failure_stage           = ''
        likely_root_cause       = ''
        confidence              = 'high'
    }

    $dockerSeen = $Observation.docker_gateway_seen -or ($LogEvidence.direct_transport_hits.Count -gt 0)
    $result.docker_spawn_observed = $dockerSeen

    if ($LogEvidence.unsupported_capability_hits.Count -gt 0) {
        $result.failure_stage = 'before MCP meaningfully matters; extension host capability layer is failing first'
        $result.likely_root_cause = 'the IDE extension is blocked by unsupported extension-host capabilities, so MCP is a secondary symptom rather than the primary failure'
        return [pscustomobject]$result
    }

    if ($dockerSeen) {
        $result.failure_stage = 'after extension app-server startup, during transport handling'
        $result.likely_root_cause = 'the extension reaches the transport path but mishandles or obscures the MCP result'
        $result.confidence = 'medium'
        return [pscustomobject]$result
    }

    $result.failure_stage = 'after extension app-server startup, before direct Docker transport evidence'
    $result.likely_root_cause = 'the extension app-server starts, but there is no direct evidence that it ever executes the configured Docker gateway transport'
    $result.confidence = 'medium'
    return [pscustomobject]$result
}

function Get-CorrelationSummary {
    param(
        [object]$Standalone,
        [object]$Extension
    )

    if ($Extension.likely_root_cause -match 'unsupported extension-host capabilities' -and $Standalone.likely_root_cause -match 'standalone') {
        return 'The two clients appear to fail for separate reasons: standalone status handling on one side and extension-host capability limits on the other.'
    }

    if (-not $Standalone.docker_spawn_observed -and -not $Extension.docker_spawn_observed) {
        return 'Neither client produced direct Docker transport evidence during observation. This may indicate a shared config-loading or app-server transport path issue.'
    }

    if ($Standalone.docker_spawn_observed -and -not $Extension.docker_spawn_observed) {
        return 'Standalone appears closer to the transport path than the IDE extension. The extension likely has a client-specific failure.'
    }

    if (-not $Standalone.docker_spawn_observed -and $Extension.docker_spawn_observed) {
        return 'The IDE extension appears closer to the transport path than standalone. Standalone likely has a client-specific failure.'
    }

    return 'Both clients show partial MCP activity, but the evidence does not support a single shared gateway-entry defect.'
}

function Write-MarkdownReport {
    param(
        [string]$Path,
        [object]$Standalone,
        [object]$Extension,
        [string]$Correlation,
        [object[]]$Baseline
    )

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add('# Codex MCP Client Diagnosis')
    $lines.Add('')
    $lines.Add("Generated: $(Get-Date -Format o)")
    $lines.Add('')
    $lines.Add('## Diagnosis Matrix')
    $lines.Add('')
    $lines.Add('| client | config source | app-server path | docker spawn observed | gateway result observed | failure stage | likely root cause | confidence |')
    $lines.Add('| --- | --- | --- | --- | --- | --- | --- | --- |')
    foreach ($row in @($Standalone, $Extension)) {
        $lines.Add("| $($row.client) | $($row.config_source) | $($row.app_server_path) | $($row.docker_spawn_observed) | $($row.gateway_result_observed) | $($row.failure_stage) | $($row.likely_root_cause) | $($row.confidence) |")
    }
    $lines.Add('')
    $lines.Add('## Correlation')
    $lines.Add('')
    $lines.Add($Correlation)
    $lines.Add('')
    $lines.Add('## Control Baseline')
    $lines.Add('')
    foreach ($item in $Baseline) {
        $lines.Add("- ``$($item.command)`` -> exit=$($item.exit_code), elapsed_ms=$($item.elapsed_ms)")
    }

    Set-Content -Path $Path -Value $lines -Encoding utf8
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$reportsRoot = Join-Path $repoRoot 'MCP-Servers\reports'
if (-not (Test-Path $reportsRoot)) {
    New-Item -ItemType Directory -Path $reportsRoot -Force | Out-Null
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
if ([string]::IsNullOrWhiteSpace($ReportPath)) {
    $ReportPath = Join-Path $reportsRoot "codex-mcp-client-diagnosis-$timestamp.json"
}

$markdownReportPath = [System.IO.Path]::ChangeExtension($ReportPath, '.md')

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Codex MCP Client Diagnosis' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

Write-Host 'Running control baseline...' -ForegroundColor Yellow
$baselineResults = @(
    (Invoke-TimedCommand -Command 'docker mcp tools count'),
    (Invoke-TimedCommand -Command 'docker mcp tools ls'),
    (Invoke-TimedCommand -Command "docker mcp tools count --gateway-arg=`"--registry=D:\Coding\Tools\mcp-docker-stack\MCP-Servers\mcp-docker-stack\registry.all.yaml`" --gateway-arg=`"--additional-catalog=D:\Coding\Tools\mcp-docker-stack\MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml`" --gateway-arg=`"--servers=serena`"")
)

Write-Host 'Collecting config and log evidence...' -ForegroundColor Yellow
$configEvidence = Get-ConfigEvidence
$standaloneArtifacts = Get-StandaloneArtifacts
$extensionArtifacts = Get-ExtensionArtifacts
$standaloneLogEvidence = Get-StandaloneLogEvidence -LogRoot $standaloneArtifacts.log_root -LatestLogPath $standaloneArtifacts.log_path
$extensionLogEvidence = Get-ExtensionLogEvidence -LogPath $extensionArtifacts.log_path

Write-Host "Observing live processes for $ObserveSeconds second(s)..." -ForegroundColor Yellow
$processObservation = Get-ProcessObservation -Seconds $ObserveSeconds
$processSnapshot = Get-CodexProcesses

$standaloneClassification = Get-StandaloneClassification -Artifacts $standaloneArtifacts -LogEvidence $standaloneLogEvidence -Observation $processObservation
$extensionClassification = Get-ExtensionClassification -LogEvidence $extensionLogEvidence -Observation $processObservation
$correlationSummary = Get-CorrelationSummary -Standalone $standaloneClassification -Extension $extensionClassification

$report = [ordered]@{
    generated_at             = (Get-Date).ToString('o')
    observe_seconds          = $ObserveSeconds
    baseline_results         = $baselineResults
    config_evidence          = $configEvidence
    standalone               = [ordered]@{
        artifacts            = $standaloneArtifacts
        log_evidence         = $standaloneLogEvidence
        classification       = $standaloneClassification
    }
    ide_extension            = [ordered]@{
        artifacts            = $extensionArtifacts
        log_evidence         = $extensionLogEvidence
        classification       = $extensionClassification
    }
    process_snapshot         = $processSnapshot
    process_observation      = $processObservation
    correlation_summary      = $correlationSummary
}

$report | ConvertTo-Json -Depth 20 | Set-Content -Path $ReportPath -Encoding utf8
Write-MarkdownReport -Path $markdownReportPath -Standalone $standaloneClassification -Extension $extensionClassification -Correlation $correlationSummary -Baseline $baselineResults

Write-Host ''
Write-Host 'Diagnosis matrix:' -ForegroundColor Cyan
@($standaloneClassification, $extensionClassification) |
    Select-Object client, config_source, app_server_path, docker_spawn_observed, gateway_result_observed, failure_stage, likely_root_cause, confidence |
    Format-Table -Wrap -AutoSize

Write-Host ''
Write-Host 'Correlation summary:' -ForegroundColor Cyan
Write-Host $correlationSummary -ForegroundColor Yellow
Write-Host ''
Write-Host "JSON report: $ReportPath" -ForegroundColor Green
Write-Host "Markdown report: $markdownReportPath" -ForegroundColor Green
