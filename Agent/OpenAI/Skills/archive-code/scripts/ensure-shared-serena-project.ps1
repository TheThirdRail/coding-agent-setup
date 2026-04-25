[CmdletBinding()]
param(
    [string]$ProjectPath = ".",
    [ValidateRange(1, 65535)]
    [int]$Port = 9121,
    [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')]
    [string]$LogLevel = 'INFO',
    [switch]$ForceRestart
)

$ErrorActionPreference = 'Stop'

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

function Get-StatePaths {
    $root = Join-Path $env:USERPROFILE '.serena'
    $logDir = Join-Path $root 'logs'
    $statePath = Join-Path $root 'shared-http-state.json'

    if (-not (Test-Path $root)) {
        New-Item -ItemType Directory -Path $root -Force | Out-Null
    }
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    return @{
        Root      = $root
        LogDir    = $logDir
        StatePath = $statePath
    }
}

function Read-State {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return $null
    }

    try {
        return Get-Content -Path $Path -Raw | ConvertFrom-Json
    }
    catch {
        return $null
    }
}

function Write-State {
    param(
        [string]$Path,
        [hashtable]$State
    )

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $json = $State | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($Path, $json, $utf8NoBom)
}

function Get-RunningProcess {
    param([int]$ProcessId)

    if ($ProcessId -le 0) {
        return $null
    }

    return Get-CimInstance Win32_Process -Filter "ProcessId = $ProcessId" -ErrorAction SilentlyContinue
}

function Stop-ProcessSafe {
    param([int]$ProcessId)

    if ($ProcessId -le 0) {
        return
    }

    $process = Get-RunningProcess -ProcessId $ProcessId
    if ($null -ne $process) {
        Stop-Process -Id $ProcessId -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}

function Get-SerenaProcessesForPort {
    param([int]$Port)

    $portPattern = [regex]::Escape("--port $Port")
    return @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
        $commandLine = [string]$_.CommandLine
        $commandLine -match '\bstart-mcp-server\b' -and
        $commandLine -match '--transport streamable-http' -and
        $commandLine -match '--context ide' -and
        $commandLine -match $portPattern
    })
}

function Stop-SerenaProcessesForPort {
    param([int]$Port)

    $processes = Get-SerenaProcessesForPort -Port $Port | Sort-Object ProcessId -Descending
    foreach ($process in $processes) {
        Stop-ProcessSafe -ProcessId ([int]$process.ProcessId)
    }
}

function Get-PortProcess {
    param([int]$Port)

    $connection = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($null -eq $connection) {
        return $null
    }

    return Get-RunningProcess -ProcessId $connection.OwningProcess
}

function Test-ProjectMatch {
    param(
        [object]$State,
        [string]$ProjectPath,
        [int]$Port
    )

    if ($null -eq $State) {
        return $false
    }

    return (
        $State.project_path -eq $ProjectPath -and
        [int]$State.port -eq $Port -and
        $State.context -eq 'ide'
    )
}

function Start-SharedSerena {
    param(
        [string]$ProjectPath,
        [int]$Port,
        [string]$LogLevel,
        [string]$LogDir
    )

    $env:UV_CACHE_DIR = Join-Path $env:USERPROFILE '.cache\uv'
    if (-not (Test-Path $env:UV_CACHE_DIR)) {
        New-Item -ItemType Directory -Path $env:UV_CACHE_DIR -Force | Out-Null
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $stdoutPath = Join-Path $LogDir "serena-http-$Port-$timestamp.out.log"
    $stderrPath = Join-Path $LogDir "serena-http-$Port-$timestamp.err.log"
    $argumentList = @(
        '--from',
        'git+https://github.com/oraios/serena',
        'serena',
        'start-mcp-server',
        '--transport',
        'streamable-http',
        '--host',
        '127.0.0.1',
        '--port',
        "$Port",
        '--project',
        $ProjectPath,
        '--context',
        'ide',
        '--log-level',
        $LogLevel,
        '--open-web-dashboard',
        'false'
    )

    $process = Start-Process `
        -FilePath 'uvx' `
        -ArgumentList $argumentList `
        -WorkingDirectory $ProjectPath `
        -WindowStyle Hidden `
        -RedirectStandardOutput $stdoutPath `
        -RedirectStandardError $stderrPath `
        -PassThru

    return @{
        pid         = $process.Id
        stdout_path = $stdoutPath
        stderr_path = $stderrPath
    }
}

$resolvedProjectPath = Get-ResolvedProjectPath -Path $ProjectPath
$paths = Get-StatePaths
$state = Read-State -Path $paths.StatePath
$managedProcess = $null

if ($null -ne $state) {
    $managedProcess = Get-RunningProcess -ProcessId ([int]$state.pid)
}

if (-not $ForceRestart -and $null -ne $managedProcess -and (Test-ProjectMatch -State $state -ProjectPath $resolvedProjectPath -Port $Port)) {
    Write-Host 'Shared Serena already matches this project.' -ForegroundColor Green
    Write-Host "Project: $resolvedProjectPath" -ForegroundColor Gray
    Write-Host "URL:     http://127.0.0.1:$Port/mcp" -ForegroundColor Gray
    exit 0
}

if ($null -ne $managedProcess) {
    Write-Host "Stopping shared Serena PID $($managedProcess.ProcessId) to switch projects..." -ForegroundColor Yellow
    Stop-ProcessSafe -ProcessId ([int]$managedProcess.ProcessId)
}

$serenaProcesses = Get-SerenaProcessesForPort -Port $Port
if ($serenaProcesses.Count -gt 0) {
    Write-Host "Stopping existing Serena process set on port $Port..." -ForegroundColor Yellow
    Stop-SerenaProcessesForPort -Port $Port
}

$portProcess = Get-PortProcess -Port $Port
if ($null -ne $portProcess) {
    $commandLine = [string]$portProcess.CommandLine
    if ($commandLine -match 'serena' -or $commandLine -match 'start-mcp-server') {
        Write-Host "Stopping existing Serena listener on port $Port (PID $($portProcess.ProcessId))..." -ForegroundColor Yellow
        Stop-ProcessSafe -ProcessId ([int]$portProcess.ProcessId)
    }
    else {
        throw "Port $Port is already in use by PID $($portProcess.ProcessId). Refusing to replace a non-Serena process."
    }
}

Write-Host 'Starting shared Serena HTTP server for the current project...' -ForegroundColor Cyan
$started = Start-SharedSerena -ProjectPath $resolvedProjectPath -Port $Port -LogLevel $LogLevel -LogDir $paths.LogDir

Write-State -Path $paths.StatePath -State @{
    pid          = $started.pid
    port         = $Port
    project_path = $resolvedProjectPath
    context      = 'ide'
    url          = "http://127.0.0.1:$Port/mcp"
    stdout_path  = $started.stdout_path
    stderr_path  = $started.stderr_path
    started_at   = (Get-Date).ToString('o')
}

Write-Host "Shared Serena is now aligned to: $resolvedProjectPath" -ForegroundColor Green
Write-Host "URL: http://127.0.0.1:$Port/mcp" -ForegroundColor Gray
