[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9][a-z0-9._-]*\.automation\.md$')]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [ValidateSet('openai', 'anthropic', 'google')]
    [string]$Vendor = 'openai',

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

$ErrorActionPreference = 'Stop'

if (-not $SourcePath) {
    $SourcePath = Join-Path (Get-Location) $Name
}

$SourcePath = (Resolve-Path $SourcePath -ErrorAction Stop).Path
if (-not (Test-Path -Path $SourcePath -PathType Leaf)) {
    Write-Error "Source automation file not found: $SourcePath"
    exit 1
}

switch ($Vendor) {
    'openai' {
        if ($UseLegacyCodexPath) {
            $GlobalPath = Join-Path $HOME '.codex\automations'
        }
        else {
            $GlobalPath = Join-Path $HOME '.agents\automations'
        }
    }
    'anthropic' { $GlobalPath = Join-Path $HOME '.claude\automations' }
    'google' { $GlobalPath = Join-Path $HOME '.gemini\automations' }
}

if (-not (Test-Path $GlobalPath)) {
    if ($PSCmdlet.ShouldProcess($GlobalPath, 'Create destination directory')) {
        New-Item -ItemType Directory -Path $GlobalPath -Force | Out-Null
    }
}

$DestPath = Join-Path $GlobalPath $Name
if (Test-Path $DestPath) {
    if (-not $Force) {
        Write-Error "Destination already exists. Use -Force to overwrite: $DestPath"
        exit 1
    }

    if ($PSCmdlet.ShouldProcess($DestPath, 'Remove existing destination file')) {
        Remove-Item -Path $DestPath -Force
    }
}

$ActionName = if ($Mode -eq 'Copy') { 'Copy' } else { 'Move' }

Write-Host 'Installing global automation' -ForegroundColor Cyan
Write-Host "  Vendor: $Vendor" -ForegroundColor Gray
Write-Host "  Mode: $Mode" -ForegroundColor Gray
Write-Host "  Source: $SourcePath" -ForegroundColor Gray
Write-Host "  Destination: $DestPath" -ForegroundColor Gray

if ($PSCmdlet.ShouldProcess($DestPath, "$ActionName automation file")) {
    if ($Mode -eq 'Copy') {
        Copy-Item -Path $SourcePath -Destination $DestPath -Force
    }
    else {
        Move-Item -Path $SourcePath -Destination $DestPath -Force
    }

    Write-Host "Global install completed: $DestPath" -ForegroundColor Green
}
