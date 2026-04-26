[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$sourcePath = Join-Path $PSScriptRoot '..\GEMINI.md'
$sourcePath = (Resolve-Path $sourcePath -ErrorAction Stop).Path

$globalGeminiRoot = Join-Path $HOME '.gemini'
$destinationPath = Join-Path $globalGeminiRoot 'GEMINI.md'

Write-Host 'Installing Google Antigravity global instruction file' -ForegroundColor Cyan
Write-Host "  Source: $sourcePath" -ForegroundColor Gray
Write-Host "  Destination: $destinationPath" -ForegroundColor Gray

if ($DryRun) {
    Write-Host 'Dry run complete. No files were changed.' -ForegroundColor Yellow
    return
}

if (-not (Test-Path $globalGeminiRoot)) {
    if ($PSCmdlet.ShouldProcess($globalGeminiRoot, 'Create global Gemini config directory')) {
        New-Item -ItemType Directory -Path $globalGeminiRoot -Force | Out-Null
    }
}

if ($PSCmdlet.ShouldProcess($destinationPath, 'Copy GEMINI.md')) {
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    Write-Host "Install completed: $destinationPath" -ForegroundColor Green
}
