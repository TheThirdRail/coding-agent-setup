<#
.SYNOPSIS
    Search git commit history by message or code changes.
.PARAMETER RepoPath
    Path to the git repository
.PARAMETER Query
    Search term
.PARAMETER Mode
    'message' (search commit messages) or 'diff' (search code changes)
.PARAMETER Limit
    Maximum number of results
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [Parameter(Mandatory = $true)]
    [string]$Query,

    [ValidateSet("message", "diff")]
    [string]$Mode = "message",

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
    Write-Host "Searching git history for: '$Query' (mode: $Mode)" -ForegroundColor Cyan
    Write-Host ""

    if ($Mode -eq "message") {
        # Search commit messages
        $Results = git log --grep="$Query" -n $Limit --pretty=format:"%h|%ad|%an|%s" --date=short 2>&1
    }
    else {
        # Search for code changes (pickaxe search)
        $Results = git log -S "$Query" -n $Limit --pretty=format:"%h|%ad|%an|%s" --date=short 2>&1
    }

    if (-not $Results -or $Results -match "^fatal:") {
        Write-Host "No results found." -ForegroundColor Yellow
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
