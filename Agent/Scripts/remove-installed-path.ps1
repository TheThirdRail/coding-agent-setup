[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [string]$Label,

    [switch]$ChildrenOnly,
    [string[]]$ExcludeNames = @(),
    [switch]$Purge,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

function New-BackupPath {
    param([string]$TargetPath)

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    return "$TargetPath.bak-$timestamp"
}

Write-Host "=== Remove $Label ===" -ForegroundColor Cyan
Write-Host "  Target: $Path" -ForegroundColor Gray

if (-not (Test-Path -LiteralPath $Path)) {
    Write-Host '  Nothing to remove.' -ForegroundColor Yellow
    return
}

if ($ChildrenOnly) {
    $items = Get-ChildItem -LiteralPath $Path -Force
    if ($ExcludeNames.Count -gt 0) {
        $items = $items | Where-Object { $ExcludeNames -notcontains $_.Name }
    }

    if (-not $items -or $items.Count -eq 0) {
        Write-Host '  Nothing to remove after exclusions.' -ForegroundColor Yellow
        return
    }

    if ($ExcludeNames.Count -gt 0) {
        Write-Host "  Preserving: $($ExcludeNames -join ', ')" -ForegroundColor Gray
    }

    if ($Purge) {
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would delete $($items.Count) child item(s)." -ForegroundColor Yellow
            return
        }

        if ($PSCmdlet.ShouldProcess($Path, "Delete $($items.Count) child item(s)")) {
            foreach ($item in $items) {
                Remove-Item -LiteralPath $item.FullName -Recurse -Force
            }
            Write-Host "  Deleted $($items.Count) child item(s)." -ForegroundColor Green
        }
        return
    }

    $backupPath = New-BackupPath -TargetPath $Path
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would move $($items.Count) child item(s) to backup: $backupPath" -ForegroundColor Yellow
        return
    }

    if ($PSCmdlet.ShouldProcess($Path, "Move $($items.Count) child item(s) to $backupPath")) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        foreach ($item in $items) {
            Move-Item -LiteralPath $item.FullName -Destination $backupPath
        }
        Write-Host "  Backed up and removed $($items.Count) child item(s): $backupPath" -ForegroundColor Green
    }
    return
}

if ($Purge) {
    if ($DryRun) {
        Write-Host '  [DRY RUN] Would delete target.' -ForegroundColor Yellow
        return
    }

    if ($PSCmdlet.ShouldProcess($Path, 'Delete target')) {
        Remove-Item -LiteralPath $Path -Recurse -Force
        Write-Host "  Deleted: $Path" -ForegroundColor Green
    }
    return
}

$backupPath = New-BackupPath -TargetPath $Path
if ($DryRun) {
    Write-Host "  [DRY RUN] Would move target to backup: $backupPath" -ForegroundColor Yellow
    return
}

if ($PSCmdlet.ShouldProcess($Path, "Move target to $backupPath")) {
    Move-Item -LiteralPath $Path -Destination $backupPath
    Write-Host "  Backed up and removed: $backupPath" -ForegroundColor Green
}
