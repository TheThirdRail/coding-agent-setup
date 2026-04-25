<#
.SYNOPSIS
    Generate conventional commit messages from staged changes.

.DESCRIPTION
    Analyzes git staged changes and generates a conventional commit message.
    Can optionally execute the commit with the generated message.

.PARAMETER Execute
    If specified, runs git commit with the generated message.

.PARAMETER Body
    Optional commit body for detailed explanation.

.EXAMPLE
    .\generate_commit.ps1
    # Analyzes staged changes and outputs suggested commit message

.EXAMPLE
    .\generate_commit.ps1 -Execute
    # Generates and executes the commit
#>

param(
    [switch]$Execute,
    [string]$Body = ""
)

$ErrorActionPreference = "Stop"

# Check for staged changes
$staged = git diff --staged --stat 2>$null
if (-not $staged) {
    Write-Host "No staged changes found. Stage files with 'git add' first." -ForegroundColor Yellow
    exit 1
}

Write-Host "`nAnalyzing staged changes..." -ForegroundColor Cyan
Write-Host $staged -ForegroundColor Gray

# Get detailed diff for analysis
$diff = git diff --staged --name-status

# Categorize changes
$files = @{
    Added    = @()
    Modified = @()
    Deleted  = @()
    Renamed  = @()
}

$diff -split "`n" | ForEach-Object {
    if ($_ -match "^([AMDR])\t(.+)$") {
        $status = $Matches[1]
        $file = $Matches[2]
        switch ($status) {
            "A" { $files.Added += $file }
            "M" { $files.Modified += $file }
            "D" { $files.Deleted += $file }
            "R" { $files.Renamed += $file }
        }
    }
}

# Detect primary area (scope)
$allFiles = $files.Added + $files.Modified + $files.Deleted + $files.Renamed
$scope = ""

# Common scope patterns
$scopePatterns = @{
    "src/components" = "ui"
    "src/api"        = "api"
    "src/hooks"      = "hooks"
    "src/utils"      = "utils"
    "src/services"   = "services"
    "tests"          = "tests"
    "docs"           = "docs"
    ".github"        = "ci"
    "scripts"        = "scripts"
    "config"         = "config"
}

foreach ($file in $allFiles) {
    foreach ($pattern in $scopePatterns.Keys) {
        if ($file -like "*$pattern*") {
            $scope = $scopePatterns[$pattern]
            break
        }
    }
    if ($scope) { break }
}

# If no scope detected, use first directory
if (-not $scope -and $allFiles.Count -gt 0) {
    $firstFile = $allFiles[0]
    if ($firstFile -match "^([^/\\]+)[/\\]") {
        $scope = $Matches[1].ToLower()
    }
}

# Determine commit type
$type = "chore"  # default

# Check file extensions and paths
$hasTests = $allFiles | Where-Object { $_ -match "\.test\.|\.spec\.|tests[/\\]" }
$hasDocs = $allFiles | Where-Object { $_ -match "\.md$|docs[/\\]" }
$hasConfig = $allFiles | Where-Object { $_ -match "\.config\.|\.json$|\.yaml$|\.yml$" }
$hasSrc = $allFiles | Where-Object { $_ -match "^src[/\\]|\.tsx?$|\.jsx?$|\.py$" }
$hasCI = $allFiles | Where-Object { $_ -match "\.github[/\\]|\.gitlab|Jenkinsfile|azure-pipelines" }

if ($files.Added.Count -gt 0 -and $files.Modified.Count -eq 0 -and $files.Deleted.Count -eq 0) {
    # Primarily adding new files
    if ($hasTests) {
        $type = "test"
    }
    elseif ($hasDocs) {
        $type = "docs"
    }
    elseif ($hasSrc) {
        $type = "feat"
    }
}
elseif ($files.Deleted.Count -gt 0 -and $files.Added.Count -eq 0) {
    $type = "refactor"
}
elseif ($hasDocs -and -not $hasSrc) {
    $type = "docs"
}
elseif ($hasTests -and -not $hasSrc) {
    $type = "test"
}
elseif ($hasCI) {
    $type = "ci"
}
elseif ($hasConfig -and -not $hasSrc) {
    $type = "build"
}
elseif ($hasSrc) {
    # Default to feat for source changes, but this is a guess
    $type = "feat"
}

# Generate description
$description = ""
$fileCount = $allFiles.Count

if ($fileCount -eq 1) {
    $filename = Split-Path $allFiles[0] -Leaf
    if ($files.Added.Count -eq 1) {
        $description = "add $filename"
    }
    elseif ($files.Deleted.Count -eq 1) {
        $description = "remove $filename"
    }
    else {
        $description = "update $filename"
    }
}
else {
    if ($files.Added.Count -gt 0 -and $files.Modified.Count -eq 0) {
        $description = "add $($files.Added.Count) new files"
    }
    elseif ($files.Deleted.Count -gt 0 -and $files.Added.Count -eq 0 -and $files.Modified.Count -eq 0) {
        $description = "remove $($files.Deleted.Count) files"
    }
    else {
        $description = "update $fileCount files"
    }
}

# Build commit message
if ($scope) {
    $commitMsg = "$type($scope): $description"
}
else {
    $commitMsg = "${type}: $description"
}

# Output results
Write-Host "`n--- Suggested Commit Message ---" -ForegroundColor Green
Write-Host $commitMsg -ForegroundColor White

if ($Body) {
    Write-Host "`n$Body" -ForegroundColor Gray
}

Write-Host "`n--- Change Summary ---" -ForegroundColor Cyan
Write-Host "  Type: $type" -ForegroundColor Gray
Write-Host "  Scope: $(if ($scope) { $scope } else { '(none)' })" -ForegroundColor Gray
Write-Host "  Added: $($files.Added.Count), Modified: $($files.Modified.Count), Deleted: $($files.Deleted.Count)" -ForegroundColor Gray

# Execute if requested
if ($Execute) {
    Write-Host "`nExecuting commit..." -ForegroundColor Yellow
    if ($Body) {
        git commit -m $commitMsg -m $Body
    }
    else {
        git commit -m $commitMsg
    }
    Write-Host "Commit created successfully!" -ForegroundColor Green
}
else {
    Write-Host "`nTo commit with this message, run:" -ForegroundColor Yellow
    Write-Host "  git commit -m `"$commitMsg`"" -ForegroundColor White
    Write-Host "`nOr re-run with -Execute flag:" -ForegroundColor Yellow
    Write-Host "  .\generate_commit.ps1 -Execute" -ForegroundColor White
}
