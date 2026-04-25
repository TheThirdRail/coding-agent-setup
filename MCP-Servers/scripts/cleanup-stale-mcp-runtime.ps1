[CmdletBinding()]
param(
    [ValidateRange(1, 1440)]
    [int]$StaleMinutes = 30,
    [switch]$IncludeGatewayProxy,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

function Get-ProcessRole {
    param(
        [string]$Name,
        [string]$CommandLine
    )

    if ($CommandLine -match '(?i)\bmcp\b' -and $CommandLine -match '(?i)\bgateway\b') {
        return 'docker-mcp-gateway'
    }
    if ($Name -match '(?i)^docker-mcp(?:\.exe)?$') {
        return 'docker-mcp-gateway'
    }
    if ($Name -match '(?i)^gateway\.proxy\..+\.exe$') {
        return 'gateway-proxy'
    }
    return ''
}

function Get-CandidateProcesses {
    $rows = Get-CimInstance Win32_Process | Where-Object {
        $_.CommandLine -match '(?i)\bmcp\b.*\bgateway\b|\bgateway\b.*\bmcp\b' -or
        $_.Name -match '(?i)^docker-mcp(?:\.exe)?$|^gateway\.proxy\..+\.exe$'
    }

    $results = @()
    foreach ($row in $rows) {
        $role = Get-ProcessRole -Name $row.Name -CommandLine ([string]$row.CommandLine)
        if ([string]::IsNullOrWhiteSpace($role)) {
            continue
        }

        if (-not $IncludeGatewayProxy -and $role -eq 'gateway-proxy') {
            continue
        }

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

        $results += [pscustomobject]@{
            pid         = $row.ProcessId
            parent_pid  = $row.ParentProcessId
            name        = $row.Name
            role        = $role
            signature   = "$($row.Name)|$role"
            start_time  = $startTime
            age_minutes = $ageMinutes
            command     = [string]$row.CommandLine
        }
    }

    return @($results | Sort-Object role, name, start_time)
}

function Get-StaleDuplicates {
    param(
        [object[]]$Processes,
        [int]$ThresholdMinutes
    )

    $groups = @(
        $Processes |
            Group-Object -Property signature |
            Where-Object { $_.Count -gt 1 }
    )

    $stale = @()
    foreach ($group in $groups) {
        $ordered = @($group.Group | Sort-Object start_time)
        if ($ordered.Count -lt 2) {
            continue
        }

        $newest = $ordered[$ordered.Count - 1]
        foreach ($candidate in $ordered) {
            if ($candidate.pid -eq $newest.pid) {
                continue
            }
            if ($null -ne $candidate.age_minutes -and $candidate.age_minutes -ge $ThresholdMinutes) {
                $stale += $candidate
            }
        }
    }

    return @($stale | Sort-Object age_minutes -Descending)
}

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Cleanup Stale MCP Runtime Processes' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

$processes = Get-CandidateProcesses
if ($processes.Count -eq 0) {
    Write-Host 'No MCP gateway-related processes found.' -ForegroundColor Green
    return
}

$stale = Get-StaleDuplicates -Processes $processes -ThresholdMinutes $StaleMinutes

Write-Host 'Detected MCP gateway-related processes:' -ForegroundColor Cyan
$processes |
    Select-Object pid, parent_pid, name, role, age_minutes, start_time |
    Format-Table -AutoSize

Write-Host ''
if ($stale.Count -eq 0) {
    Write-Host "No stale duplicate gateway processes older than $StaleMinutes minute(s)." -ForegroundColor Green
    return
}

Write-Host "Stale duplicate processes to remove: $($stale.Count)" -ForegroundColor Yellow
$stale |
    Select-Object pid, name, role, age_minutes, start_time |
    Format-Table -AutoSize

Write-Host ''
foreach ($item in $stale) {
    if ($WhatIf) {
        Write-Host "[WHATIF] Stop-Process -Id $($item.pid)" -ForegroundColor Gray
        continue
    }

    try {
        Stop-Process -Id $item.pid -Force -ErrorAction Stop
        Write-Host "Stopped PID $($item.pid) ($($item.name))" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to stop PID $($item.pid): $($_.Exception.Message)"
    }
}
