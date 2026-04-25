<#
.SYNOPSIS
    Get recent git activity in a repository.
.PARAMETER RepoPath
    Path to the git repository
.PARAMETER Days
    Number of days to look back
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [int]$Days = 7
)

$ErrorActionPreference = "Stop"

# Validate repo path
if (-not (Test-Path (Join-Path $RepoPath ".git"))) {
    Write-Host "Error: Not a git repository: $RepoPath" -ForegroundColor Red
    exit 1
}

Push-Location $RepoPath

try {
    $Since = (Get-Date).AddDays(-$Days).ToString("yyyy-MM-dd")

    Write-Host "Recent activity (last $Days days):" -ForegroundColor Cyan
    Write-Host ""

    # Get commit summary
    $Commits = git log --since="$Since" --pretty=format:"%h|%ad|%an|%s" --date=short 2>&1

    if (-not $Commits -or $Commits -match "^fatal:") {
        Write-Host "No commits in the last $Days days." -ForegroundColor Yellow
        Pop-Location
        exit 0
    }

    $CommitCount = ($Commits -split "`n").Count
    Write-Host "Total commits: $CommitCount" -ForegroundColor Green
    Write-Host ""

    # Show commits
    $Commits -split "`n" | Select-Object -First 20 | ForEach-Object {
        if ($_ -match "^([^|]+)\|([^|]+)\|([^|]+)\|(.+)$") {
            $Hash = $Matches[1]
            $Date = $Matches[2]
            $Author = $Matches[3]
            $Message = $Matches[4]

            Write-Host "[$Hash] " -NoNewline -ForegroundColor Yellow
            Write-Host "$Date " -NoNewline -ForegroundColor Gray
            Write-Host "($Author) " -NoNewline -ForegroundColor Cyan
            Write-Host $Message
        }
    }

    if ($CommitCount -gt 20) {
        Write-Host ""
        Write-Host "... and $($CommitCount - 20) more commits" -ForegroundColor Gray
    }
}
finally {
    Pop-Location
}
