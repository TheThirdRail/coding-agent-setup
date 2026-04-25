[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z][a-z0-9-]{0,62}[a-z0-9]$')]
    [ValidateLength(2, 64)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [ValidateSet('mine', 'anthropic', 'openai', 'google')]
    [string]$Vendor = 'google',

    [Parameter(Mandatory = $false)]
    [string]$ProjectRoot = ".",

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
if (-not (Test-Path -Path $SourcePath -PathType Container)) {
    Write-Error "Source path is not a directory: $SourcePath"
    exit 1
}

$SkillMdPath = Join-Path $SourcePath "SKILL.md"
if (-not (Test-Path $SkillMdPath)) {
    Write-Error "Source folder does not contain SKILL.md: $SourcePath"
    exit 1
}

$ProjectRoot = (Resolve-Path $ProjectRoot -ErrorAction Stop).Path

switch ($Vendor) {
    'mine' { $RelativeLocalPath = ".agent\skills" }
    'anthropic' { $RelativeLocalPath = ".claude\skills" }
    'openai' {
        if ($UseLegacyCodexPath) {
            $RelativeLocalPath = ".codex\skills"
        }
        else {
            $RelativeLocalPath = ".agents\skills"
        }
    }
    'google' { $RelativeLocalPath = ".agent\skills" }
}

$LocalPath = Join-Path $ProjectRoot $RelativeLocalPath
if (-not (Test-Path $LocalPath)) {
    if ($PSCmdlet.ShouldProcess($LocalPath, "Create destination directory")) {
        New-Item -ItemType Directory -Path $LocalPath -Force | Out-Null
    }
}

$DestPath = Join-Path $LocalPath $Name
if (Test-Path $DestPath) {
    if (-not $Force) {
        Write-Error "Destination already exists. Use -Force to overwrite: $DestPath"
        exit 1
    }

    if ($PSCmdlet.ShouldProcess($DestPath, "Remove existing destination")) {
        Remove-Item -Path $DestPath -Recurse -Force
    }
}

$ActionName = if ($Mode -eq 'Copy') { 'Copy' } else { 'Move' }

Write-Host "Installing workspace skill" -ForegroundColor Cyan
Write-Host "  Vendor: $Vendor" -ForegroundColor Gray
Write-Host "  ProjectRoot: $ProjectRoot" -ForegroundColor Gray
Write-Host "  Mode: $Mode" -ForegroundColor Gray
Write-Host "  Source: $SourcePath" -ForegroundColor Gray
Write-Host "  Destination: $DestPath" -ForegroundColor Gray

if ($PSCmdlet.ShouldProcess($DestPath, "$ActionName skill folder")) {
    if ($Mode -eq 'Copy') {
        Copy-Item -Path $SourcePath -Destination $DestPath -Recurse -Force
    }
    else {
        Move-Item -Path $SourcePath -Destination $DestPath -Force
    }

    Write-Host "Workspace install completed: $DestPath" -ForegroundColor Green
}
