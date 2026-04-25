[CmdletBinding()]
param(
    [ValidateRange(1, 1440)]
    [int]$StaleMinutes = 30,
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
    return ''
}

function Get-CandidateProcesses {
    $rows = Get-CimInstance Win32_Process | Where-Object {
        $_.CommandLine -match '(?i)\bmcp\b.*\bgateway\b|\bgateway\b.*\bmcp\b' -or
        $_.Name -match '(?i)^docker-mcp(?:\.exe)?$'
    }

    $results = @()
    foreach ($row in $rows) {
        $role = Get-ProcessRole -Name $row.Name -CommandLine ([string]$row.CommandLine)
        if ([string]::IsNullOrWhiteSpace($role)) {
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

$processes = Get-CandidateProcesses
if ($processes.Count -eq 0) {
    Write-Host 'No MCP gateway runtime processes found.' -ForegroundColor Green
    exit 0
}

$stale = Get-StaleDuplicates -Processes $processes -ThresholdMinutes $StaleMinutes
if ($stale.Count -eq 0) {
    Write-Host "No stale duplicate MCP runtime processes older than $StaleMinutes minute(s)." -ForegroundColor Green
    exit 0
}

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
