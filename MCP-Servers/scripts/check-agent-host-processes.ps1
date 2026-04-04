[CmdletBinding()]
param(
    [ValidateRange(1, 1440)]
    [int]$StaleMinutes = 30,
    [switch]$IncludeCommandLine
)

$ErrorActionPreference = 'Stop'

function Get-ProcessRole {
    param(
        [string]$Name,
        [string]$CommandLine
    )

    if ($CommandLine -match '(?i)\bapp-server\b') {
        return 'app-server'
    }
    if ($CommandLine -match '(?i)\bgateway\b') {
        return 'gateway'
    }
    if ($CommandLine -match '(?i)\bmcp\b') {
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

function Get-CandidateProcesses {
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

        $results += [pscustomobject]@{
            pid             = $row.ProcessId
            parent_pid      = $row.ParentProcessId
            name            = $row.Name
            role            = $role
            signature       = "$($row.Name)|$role"
            start_time      = $startTime
            age_minutes     = $ageMinutes
            command_preview = $preview
        }
    }

    return $results | Sort-Object role, name, start_time
}

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Agent Host Process Check' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

$processes = Get-CandidateProcesses

if ($processes.Count -eq 0) {
    Write-Host 'No matching agent host processes found.' -ForegroundColor Gray
    return
}

$displayColumns = @('pid', 'parent_pid', 'name', 'role', 'age_minutes', 'start_time')
if ($IncludeCommandLine) {
    $displayColumns += 'command_preview'
}

Write-Host 'Detected processes:' -ForegroundColor Cyan
$processes |
    Select-Object $displayColumns |
    Format-Table -AutoSize

$hostRoles = @('app-server', 'gateway', 'mcp-related')
$duplicateGroups = @(
    $processes |
        Where-Object { $_.role -in $hostRoles } |
        Group-Object -Property signature |
        Where-Object { $_.Count -gt 1 }
)

$staleCandidates = @()
foreach ($group in $duplicateGroups) {
    $ordered = @($group.Group | Sort-Object start_time)
    if ($ordered.Count -lt 2) {
        continue
    }

    $newest = $ordered[$ordered.Count - 1]
    foreach ($candidate in $ordered) {
        if ($candidate.pid -eq $newest.pid) {
            continue
        }
        if ($null -ne $candidate.age_minutes -and $candidate.age_minutes -ge $StaleMinutes) {
            $staleCandidates += $candidate
        }
    }
}

Write-Host ''
Write-Host 'Duplicate host groups:' -ForegroundColor Cyan
if ($duplicateGroups.Count -eq 0) {
    Write-Host 'No duplicate process groups detected.' -ForegroundColor Green
}
else {
    foreach ($group in $duplicateGroups) {
        Write-Host "  - $($group.Name): $($group.Count) process(es)" -ForegroundColor Yellow
    }
}

Write-Host ''
Write-Host 'Stale candidates:' -ForegroundColor Cyan
if ($staleCandidates.Count -eq 0) {
    Write-Host "No stale duplicate hosts older than $StaleMinutes minute(s)." -ForegroundColor Green
}
else {
    Write-Warning "Found $($staleCandidates.Count) stale duplicate host process(es)."
    $staleCandidates |
        Sort-Object age_minutes -Descending |
        Select-Object pid, name, role, age_minutes, start_time |
        Format-Table -AutoSize

    Write-Host ''
    Write-Host 'Manual cleanup commands (run only if you confirm these are stale):' -ForegroundColor Gray
    foreach ($item in ($staleCandidates | Sort-Object pid -Unique)) {
        Write-Host "Stop-Process -Id $($item.pid)" -ForegroundColor Gray
    }
}
