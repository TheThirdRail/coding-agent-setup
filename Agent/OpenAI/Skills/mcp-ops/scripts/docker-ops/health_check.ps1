<#
.SYNOPSIS
    Health check for Docker MCP containers.

.DESCRIPTION
    Runs diagnostic checks on all MCP-related Docker containers.
    Reports status, logs from unhealthy containers, and resource usage.

.PARAMETER ContainerFilter
    Filter pattern for container names. Default: "mcp"

.PARAMETER LogLines
    Number of log lines to show for unhealthy containers. Default: 20

.EXAMPLE
    .\health_check.ps1
    # Checks all MCP containers

.EXAMPLE
    .\health_check.ps1 -ContainerFilter "github" -LogLines 50
    # Checks containers matching "github", shows 50 log lines
#>

param(
    [string]$ContainerFilter = "mcp",
    [int]$LogLines = 20
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== Docker MCP Health Check ===" -ForegroundColor Cyan
Write-Host "Filter: *$ContainerFilter*" -ForegroundColor Gray
Write-Host ""

# Check Docker is running
try {
    docker info 2>&1 | Out-Null
}
catch {
    Write-Host "ERROR: Docker is not running or not accessible." -ForegroundColor Red
    exit 1
}

# Get all containers matching filter
$containers = docker ps -a --filter "name=$ContainerFilter" --format "{{.ID}}|{{.Names}}|{{.Status}}|{{.State}}" 2>$null

if (-not $containers) {
    Write-Host "No containers found matching filter: $ContainerFilter" -ForegroundColor Yellow
    exit 0
}

# Parse and display container status
$healthy = @()
$unhealthy = @()
$stopped = @()

Write-Host "--- Container Status ---" -ForegroundColor Yellow
Write-Host ""

$containers -split "`n" | ForEach-Object {
    if ($_ -match "^(.+)\|(.+)\|(.+)\|(.+)$") {
        $null = $Matches[1]  # Container ID (not used)
        $name = $Matches[2]
        $status = $Matches[3]
        $state = $Matches[4]

        $icon = switch ($state) {
            "running" { "[RUNNING]" }
            "exited" { "[STOPPED]" }
            "restarting" { "[RESTARTING]" }
            default { "[UNKNOWN]" }
        }

        # Check for health status in status string
        if ($status -match "unhealthy") {
            $icon = "[UNHEALTHY]"
            $unhealthy += $name
        }
        elseif ($status -match "healthy") {
            $icon = "[HEALTHY]"
            $healthy += $name
        }
        elseif ($state -eq "exited") {
            $stopped += $name
        }
        else {
            $healthy += $name
        }

        Write-Host "  $icon $name" -ForegroundColor White -NoNewline
        Write-Host " - $status" -ForegroundColor Gray
    }
}

Write-Host ""

# Show logs for unhealthy/stopped containers
if ($unhealthy.Count -gt 0) {
    Write-Host "--- Unhealthy Container Logs ---" -ForegroundColor Red
    foreach ($name in $unhealthy) {
        Write-Host "`n[$name] Last $LogLines lines:" -ForegroundColor Yellow
        docker logs $name --tail $LogLines 2>&1 | ForEach-Object {
            if ($_ -match "error|fail|exception" ) {
                Write-Host "  $_" -ForegroundColor Red
            }
            else {
                Write-Host "  $_" -ForegroundColor Gray
            }
        }
    }
    Write-Host ""
}

if ($stopped.Count -gt 0) {
    Write-Host "--- Stopped Container Logs ---" -ForegroundColor Yellow
    foreach ($name in $stopped) {
        Write-Host "`n[$name] Last $LogLines lines:" -ForegroundColor Yellow
        docker logs $name --tail $LogLines 2>&1 | ForEach-Object {
            if ($_ -match "error|fail|exception") {
                Write-Host "  $_" -ForegroundColor Red
            }
            else {
                Write-Host "  $_" -ForegroundColor Gray
            }
        }
    }
    Write-Host ""
}

# Resource usage for running containers
$running = docker ps --filter "name=$ContainerFilter" --format "{{.Names}}" 2>$null
if ($running) {
    Write-Host "--- Resource Usage ---" -ForegroundColor Yellow
    docker stats --no-stream --filter "name=$ContainerFilter" --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    Write-Host ""
}

# Summary
Write-Host "--- Summary ---" -ForegroundColor Cyan
Write-Host "  Healthy:   $($healthy.Count)" -ForegroundColor Green
Write-Host "  Unhealthy: $($unhealthy.Count)" -ForegroundColor $(if ($unhealthy.Count -gt 0) { "Red" } else { "Gray" })
Write-Host "  Stopped:   $($stopped.Count)" -ForegroundColor $(if ($stopped.Count -gt 0) { "Yellow" } else { "Gray" })
Write-Host ""

# Exit code based on health
if ($unhealthy.Count -gt 0) {
    Write-Host "Action required: $($unhealthy.Count) unhealthy container(s)" -ForegroundColor Red
    exit 1
}
elseif ($stopped.Count -gt 0) {
    Write-Host "Note: $($stopped.Count) container(s) are stopped" -ForegroundColor Yellow
    exit 0
}
else {
    Write-Host "All containers healthy!" -ForegroundColor Green
    exit 0
}
