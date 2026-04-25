[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9][a-z0-9._-]*\.md$')]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [ValidateSet('anthropic', 'openai', 'google')]
    [string]$Vendor = 'google',

    [Parameter(Mandatory = $false)]
    [string]$SourcePath,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Copy', 'Move')]
    [string]$Mode = 'Copy',

    [Parameter(Mandatory = $false)]
    [switch]$UseLegacyCodexPath,

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if (-not $SourcePath) {
    $SourcePath = Join-Path (Get-Location) $Name
}

$SourcePath = (Resolve-Path $SourcePath -ErrorAction Stop).Path
if (-not (Test-Path -Path $SourcePath -PathType Leaf)) {
    Write-Error "Source workflow file not found: $SourcePath"
    exit 1
}

switch ($Vendor) {
    'anthropic' { $GlobalPath = Join-Path $HOME ".claude\workflows" }
    'openai' {
        if ($UseLegacyCodexPath) {
            $GlobalPath = Join-Path $HOME ".codex\workflows"
        }
        else {
            $GlobalPath = Join-Path $HOME ".agents\workflows"
        }
    }
    'google' { $GlobalPath = Join-Path $HOME ".gemini\antigravity\global_workflows" }
}

if (-not (Test-Path $GlobalPath)) {
    if ($PSCmdlet.ShouldProcess($GlobalPath, "Create destination directory")) {
        New-Item -ItemType Directory -Path $GlobalPath -Force | Out-Null
    }
}

$DestPath = Join-Path $GlobalPath $Name
if (Test-Path $DestPath) {
    if (-not $Force) {
        Write-Error "Destination already exists. Use -Force to overwrite: $DestPath"
        exit 1
    }

    if ($PSCmdlet.ShouldProcess($DestPath, "Remove existing destination file")) {
        Remove-Item -Path $DestPath -Force
    }
}

$ActionName = if ($Mode -eq 'Copy') { 'Copy' } else { 'Move' }

Write-Host "Installing global workflow" -ForegroundColor Cyan
Write-Host "  Vendor: $Vendor" -ForegroundColor Gray
Write-Host "  Mode: $Mode" -ForegroundColor Gray
Write-Host "  Source: $SourcePath" -ForegroundColor Gray
Write-Host "  Destination: $DestPath" -ForegroundColor Gray

if ($PSCmdlet.ShouldProcess($DestPath, "$ActionName workflow file")) {
    if ($Mode -eq 'Copy') {
        Copy-Item -Path $SourcePath -Destination $DestPath -Force
    }
    else {
        Move-Item -Path $SourcePath -Destination $DestPath -Force
    }

    Write-Host "Global install completed: $DestPath" -ForegroundColor Green
}
