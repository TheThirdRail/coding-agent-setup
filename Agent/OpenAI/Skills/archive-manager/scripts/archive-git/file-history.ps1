<#
.SYNOPSIS
    Get the commit history for a specific file.
.PARAMETER RepoPath
    Path to the git repository
.PARAMETER FilePath
    Relative path to the file within the repo
.PARAMETER Limit
    Maximum number of commits to show
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [int]$Limit = 10
)

$ErrorActionPreference = "Stop"

# Validate repo path
if (-not (Test-Path (Join-Path $RepoPath ".git"))) {
    Write-Host "Error: Not a git repository: $RepoPath" -ForegroundColor Red
    exit 1
}

Push-Location $RepoPath

try {
    Write-Host "File history: $FilePath" -ForegroundColor Cyan
    Write-Host ""

    $Results = git log -n $Limit --pretty=format:"%h|%ad|%an|%s" --date=short -- $FilePath 2>&1

    if (-not $Results -or $Results -match "^fatal:") {
        Write-Host "No history found for: $FilePath" -ForegroundColor Yellow
        Pop-Location
        exit 0
    }

    # Parse and display results
    $Results -split "`n" | ForEach-Object {
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
        elseif ($_) {
            Write-Host $_
        }
    }
}
finally {
    Pop-Location
}
