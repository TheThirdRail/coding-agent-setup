[CmdletBinding()]
param(
    [ValidateRange(5, 300)]
    [int]$ObserveSeconds = 20,
    [switch]$SkipEventWatch,
    [string]$ReportPath = ''
)

$ErrorActionPreference = 'Stop'

function Test-Utf8Bom {
    param([byte[]]$Bytes)
    return (
        $Bytes.Length -ge 3 -and
        $Bytes[0] -eq 0xEF -and
        $Bytes[1] -eq 0xBB -and
        $Bytes[2] -eq 0xBF
    )
}

function Get-FileEncodingHint {
    param([byte[]]$Bytes)

    if ($Bytes.Length -ge 4) {
        if ($Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE -and $Bytes[2] -eq 0x00 -and $Bytes[3] -eq 0x00) {
            return 'utf32-le'
        }
        if ($Bytes[0] -eq 0x00 -and $Bytes[1] -eq 0x00 -and $Bytes[2] -eq 0xFE -and $Bytes[3] -eq 0xFF) {
            return 'utf32-be'
        }
    }
    if ($Bytes.Length -ge 3 -and (Test-Utf8Bom -Bytes $Bytes)) {
        return 'utf8-bom'
    }
    if ($Bytes.Length -ge 2) {
        if ($Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) {
            return 'utf16-le'
        }
        if ($Bytes[0] -eq 0xFE -and $Bytes[1] -eq 0xFF) {
            return 'utf16-be'
        }
    }
    return 'utf8-or-ascii'
}

function Get-ConfigSummary {
    param(
        [string]$ClientName,
        [string]$Path,
        [ValidateSet('toml', 'json')]
        [string]$Kind
    )

    if (-not (Test-Path $Path)) {
        return [pscustomobject]@{
            client          = $ClientName
            path            = $Path
            exists          = $false
            encoding        = 'missing'
            has_utf8_bom    = $false
            gateway_enabled = $false
            parse_error     = ''
        }
    }

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $raw = [System.IO.File]::ReadAllText($Path)
    $encoding = Get-FileEncodingHint -Bytes $bytes
    $hasUtf8Bom = Test-Utf8Bom -Bytes $bytes
    $gatewayEnabled = $false
    $parseError = ''

    if ($Kind -eq 'toml') {
        $match = [regex]::Match($raw, '(?ms)^\[mcp_servers\.MCP_DOCKER\].*?(?=^\[|\z)')
        if ($match.Success) {
            $block = $match.Value
            $hasDockerCommand = $block -match '(?im)^\s*command\s*=\s*["'']docker(?:\.exe)?["'']\s*$'
            $hasGatewayArgs = (
                $block -match '(?i)\bmcp\b' -and
                $block -match '(?i)\bgateway\b' -and
                $block -match '(?i)\brun\b'
            )
            $gatewayEnabled = $hasDockerCommand -and $hasGatewayArgs
        }
    }
    else {
        try {
            $json = $raw | ConvertFrom-Json -Depth 30
            if ($null -ne $json.mcpServers) {
                foreach ($property in $json.mcpServers.PSObject.Properties) {
                    $entry = $property.Value
                    if ($null -eq $entry) {
                        continue
                    }

                    $command = [string]$entry.command
                    $argsText = ''
                    if ($entry.args -is [array]) {
                        $argsText = ($entry.args -join ' ')
                    }
                    elseif ($entry.args) {
                        $argsText = [string]$entry.args
                    }

                    if (
                        $command -match '(?i)^docker(?:\.exe)?$' -and
                        $argsText -match '(?i)\bmcp\b' -and
                        $argsText -match '(?i)\bgateway\b' -and
                        $argsText -match '(?i)\brun\b'
                    ) {
                        $gatewayEnabled = $true
                        break
                    }
                }
            }
        }
        catch {
            $parseError = $_.Exception.Message
        }
    }

    return [pscustomobject]@{
        client          = $ClientName
        path            = $Path
        exists          = $true
        encoding        = $encoding
        has_utf8_bom    = $hasUtf8Bom
        gateway_enabled = $gatewayEnabled
        parse_error     = $parseError
    }
}

function Get-ProcessRole {
    param(
        [string]$Name,
        [string]$CommandLine
    )

    if ($CommandLine -match '(?i)\bapp-server\b') {
        return 'app-server'
    }
    if ($CommandLine -match '(?i)\bmcp\b' -or $CommandLine -match '(?i)\bgateway\b') {
        return 'mcp-related'
    }
    if ($Name -match '(?i)^codex\.exe$') {
        return 'codex-ui'
    }
    if ($Name -match '(?i)^chatgpt\.exe$') {
        return 'chatgpt-ui'
    }
    if ($Name -match '(?i)^claude\.exe$') {
        return 'claude-ui'
    }
    if ($Name -match '(?i)^antigravity\.exe$') {
        return 'antigravity-ui'
    }
    return 'client-other'
}

function Get-AgentHostProcesses {
    $commandPattern = '(?i)\bapp-server\b|\bgateway\b|--additional-catalog|--registry|openai\.chatgpt|google\.antigravity'

    $rows = Get-CimInstance Win32_Process | Where-Object {
        $_.CommandLine -match $commandPattern
    }

    $results = @()
    foreach ($row in $rows) {
        $startTime = $null
        if ($row.CreationDate) {
            try {
                $startTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($row.CreationDate)
            }
            catch {
                $startTime = $null
            }
        }
        if (-not $startTime) {
            try {
                $startTime = (Get-Process -Id $row.ProcessId -ErrorAction Stop).StartTime
            }
            catch {
                $startTime = $null
            }
        }
        $ageMinutes = $null
        if ($startTime) {
            $ageMinutes = [Math]::Round(((Get-Date) - $startTime).TotalMinutes, 1)
        }

        $commandLine = [string]$row.CommandLine
        $preview = $commandLine
        if ([string]::IsNullOrWhiteSpace($preview)) {
            $preview = '[no command line available]'
        }
        if ($preview.Length -gt 180) {
            $preview = $preview.Substring(0, 177) + '...'
        }

        $role = Get-ProcessRole -Name $row.Name -CommandLine $commandLine
        $signature = "$($row.Name)|$role"

        $results += [pscustomobject]@{
            pid             = $row.ProcessId
            parent_pid      = $row.ParentProcessId
            name            = $row.Name
            role            = $role
            signature       = $signature
            start_time      = $startTime
            age_minutes     = $ageMinutes
            command_preview = $preview
        }
    }

    return $results | Sort-Object role, name, start_time
}

function Test-DockerReady {
    try {
        $output = docker version --format '{{.Server.Version}}' 2>&1
        if ($LASTEXITCODE -ne 0) {
            return [pscustomobject]@{
                ready = $false
                note  = ($output -join ' ')
            }
        }

        return [pscustomobject]@{
            ready = $true
            note  = ($output | Select-Object -First 1)
        }
    }
    catch {
        return [pscustomobject]@{
            ready = $false
            note  = $_.Exception.Message
        }
    }
}

function Get-ContainerEvents {
    param([int]$Seconds)

    $now = [DateTimeOffset]::UtcNow
    $since = $now.AddSeconds(-1).ToUnixTimeSeconds()
    $until = $now.AddSeconds($Seconds).ToUnixTimeSeconds()

    $raw = docker events `
        --since $since `
        --until $until `
        --filter type=container `
        --format '{{json .}}' 2>&1

    if ($LASTEXITCODE -ne 0) {
        throw "docker events failed: $($raw -join ' ')"
    }

    $events = @()
    foreach ($line in $raw) {
        $text = "$line".Trim()
        if (-not $text.StartsWith('{')) {
            continue
        }

        try {
            $evt = $text | ConvertFrom-Json -Depth 10
            $events += [pscustomobject]@{
                time   = if ($evt.time) { [string]$evt.time } else { '' }
                action = if ($evt.Action) { [string]$evt.Action } else { '' }
                id     = if ($evt.ID) { [string]$evt.ID } elseif ($evt.id) { [string]$evt.id } else { '' }
                name   = if ($evt.Actor -and $evt.Actor.Attributes) { [string]$evt.Actor.Attributes.name } else { '' }
                image  = if ($evt.Actor -and $evt.Actor.Attributes) { [string]$evt.Actor.Attributes.image } else { '' }
            }
        }
        catch {
            continue
        }
    }

    return $events
}

function Ensure-ReportPath {
    param([string]$PathHint)

    if (-not [string]::IsNullOrWhiteSpace($PathHint)) {
        $parent = Split-Path -Parent $PathHint
        if ($parent -and -not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        return $PathHint
    }

    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $reportsDir = Join-Path $repoRoot 'MCP-Servers\reports'
    if (-not (Test-Path $reportsDir)) {
        New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    return (Join-Path $reportsDir "mcp-background-diagnose-$stamp.json")
}

$homePath = [Environment]::GetFolderPath('UserProfile')
$targets = @(
    @{ client = 'OpenAI Codex'; kind = 'toml'; path = (Join-Path $homePath '.codex\config.toml') },
    @{ client = 'Anthropic Claude'; kind = 'json'; path = (Join-Path $homePath '.claude.json') },
    @{ client = 'Google Antigravity'; kind = 'json'; path = (Join-Path $homePath '.gemini\antigravity\mcp_config.json') }
)

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'MCP Background Container Diagnostics' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

$configResults = @()
foreach ($target in $targets) {
    $configResults += Get-ConfigSummary -ClientName $target.client -Path $target.path -Kind $target.kind
}

$processResults = Get-AgentHostProcesses
$dockerStatus = Test-DockerReady
$eventResults = @()
$eventError = ''

if ($dockerStatus.ready -and -not $SkipEventWatch) {
    Write-Host "Watching Docker container events for $ObserveSeconds seconds..." -ForegroundColor Yellow
    try {
        $eventResults = Get-ContainerEvents -Seconds $ObserveSeconds
    }
    catch {
        $eventError = $_.Exception.Message
    }
}
elseif (-not $dockerStatus.ready) {
    $eventError = "Docker is not ready: $($dockerStatus.note)"
}

$interestingActions = @('create', 'start', 'die', 'stop', 'kill', 'destroy')
$interestingEvents = @($eventResults | Where-Object { $_.action -in $interestingActions })
$gatewayConfigs = @($configResults | Where-Object { $_.exists -and $_.gateway_enabled })
$encodingWarnings = @($configResults | Where-Object { $_.exists -and ($_.has_utf8_bom -or $_.encoding -like 'utf16*' -or $_.encoding -like 'utf32*') })
$parseErrors = @($configResults | Where-Object { -not [string]::IsNullOrWhiteSpace($_.parse_error) })
$hostRoles = @('app-server', 'gateway', 'mcp-related')
$duplicateHostGroups = @(
    $processResults |
        Where-Object { $_.role -in $hostRoles } |
        Group-Object -Property signature |
        Where-Object { $_.Count -gt 1 }
)

Write-Host 'Client config check:' -ForegroundColor Cyan
$configResults |
    Select-Object client, exists, gateway_enabled, encoding, has_utf8_bom |
    Format-Table -AutoSize

Write-Host ''
Write-Host 'Agent host processes:' -ForegroundColor Cyan
if ($processResults.Count -eq 0) {
    Write-Host 'No matching agent host processes found.' -ForegroundColor Gray
}
else {
    $processResults |
        Select-Object pid, parent_pid, name, role, age_minutes, start_time |
        Format-Table -AutoSize
}

Write-Host ''
Write-Host 'Container event summary:' -ForegroundColor Cyan
if (-not [string]::IsNullOrWhiteSpace($eventError)) {
    Write-Warning $eventError
}
elseif ($SkipEventWatch) {
    Write-Host 'Skipped event watch by request.' -ForegroundColor Gray
}
elseif ($interestingEvents.Count -eq 0) {
    Write-Host "No short-lived container activity observed in $ObserveSeconds seconds." -ForegroundColor Gray
}
else {
    Write-Host "Observed $($interestingEvents.Count) container lifecycle events." -ForegroundColor Green
    $interestingEvents |
        Group-Object -Property action |
        Sort-Object Name |
        ForEach-Object {
            Write-Host "  - $($_.Name): $($_.Count)" -ForegroundColor Gray
        }
    $topImages = @(
        $interestingEvents |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_.image) } |
            Group-Object -Property image |
            Sort-Object Count -Descending |
            Select-Object -First 5
    )
    if ($topImages.Count -gt 0) {
        Write-Host 'Top images:' -ForegroundColor Gray
        foreach ($item in $topImages) {
            Write-Host "  - $($item.Name) ($($item.Count))" -ForegroundColor Gray
        }
    }
}

Write-Host ''
Write-Host 'Likely cause:' -ForegroundColor Cyan
if ($gatewayConfigs.Count -gt 0 -and $interestingEvents.Count -gt 0) {
    Write-Host 'One or more AI clients are polling MCP tools in the background.' -ForegroundColor Green
    Write-Host 'Docker starts short-lived MCP containers for those checks, then stops them.' -ForegroundColor Green
}
elseif ($gatewayConfigs.Count -gt 0) {
    Write-Host 'Client configs are wired to Docker MCP gateway. Background polls can cause short-lived containers.' -ForegroundColor Yellow
}
else {
    Write-Host 'No Docker MCP gateway config was detected in the common client files.' -ForegroundColor Yellow
}

if ($encodingWarnings.Count -gt 0) {
    Write-Warning 'Encoding issues found in client config files. BOM/UTF-16 can trigger retries and repeated refresh loops.'
    Write-Host 'Run: .\normalize-mcp-config-encoding.ps1 -Vendor all' -ForegroundColor Gray
}

if ($parseErrors.Count -gt 0) {
    Write-Warning 'At least one JSON config failed to parse. That can cause repeated reconnect attempts.'
    foreach ($item in $parseErrors) {
        Write-Host "  - $($item.client): $($item.parse_error)" -ForegroundColor Gray
    }
}

if ($duplicateHostGroups.Count -gt 0) {
    Write-Warning 'Duplicate agent host process groups found. Old duplicate hosts may keep polling MCP in the background.'
    Write-Host 'Run: .\check-agent-host-processes.ps1' -ForegroundColor Gray
}

$resolvedReportPath = Ensure-ReportPath -PathHint $ReportPath
$report = [pscustomobject]@{
    generated_at_utc       = (Get-Date).ToUniversalTime().ToString('o')
    observe_seconds        = $ObserveSeconds
    skip_event_watch       = [bool]$SkipEventWatch
    docker_ready           = [bool]$dockerStatus.ready
    docker_note            = $dockerStatus.note
    gateway_config_count   = $gatewayConfigs.Count
    config_results         = $configResults
    process_count          = $processResults.Count
    duplicate_host_groups  = $duplicateHostGroups.Count
    process_results        = $processResults
    interesting_event_count = $interestingEvents.Count
    event_error            = $eventError
    event_results          = $interestingEvents
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Path $resolvedReportPath -Encoding utf8

Write-Host ''
Write-Host "Report saved to: $resolvedReportPath" -ForegroundColor Gray
