<#
.SYNOPSIS
    Scan codebase for hardcoded secrets and credentials.

.DESCRIPTION
    Searches for common secret patterns in code files.
    Checks if .env files are properly gitignored.
    Returns findings with file:line references.

.PARAMETER Path
    Directory to scan. Default: current directory.

.PARAMETER Extensions
    File extensions to scan. Default: common code files.

.PARAMETER Exclude
    Directories to exclude. Default: node_modules, .git, vendor, dist

.EXAMPLE
    .\scan_secrets.ps1
    # Scans current directory

.EXAMPLE
    .\scan_secrets.ps1 -Path "src" -Extensions "*.py","*.js"
#>

param(
    [string]$Path = ".",
    [string[]]$Extensions = @("*.js", "*.ts", "*.jsx", "*.tsx", "*.py", "*.rb", "*.go", "*.java", "*.cs", "*.php", "*.yaml", "*.yml", "*.json", "*.env*", "*.config"),
    [string[]]$Exclude = @("node_modules", ".git", "vendor", "dist", "build", "__pycache__", ".venv", "venv")
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== Secret Scanner ===" -ForegroundColor Cyan
Write-Host "Scanning: $Path" -ForegroundColor Gray
Write-Host ""

# Resolve path
$ScanPath = Resolve-Path $Path -ErrorAction Stop

# Secret patterns to search for
$Patterns = @(
    @{ Name = "API Key"; Pattern = '(?i)(api[_-]?key|apikey)\s*[:=]\s*["\x27]([a-zA-Z0-9_\-]{20,})["\x27]' },
    @{ Name = "AWS Access Key"; Pattern = 'AKIA[0-9A-Z]{16}' },
    @{ Name = "AWS Secret Key"; Pattern = '(?i)aws[_-]?secret[_-]?access[_-]?key\s*[:=]\s*["\x27]([a-zA-Z0-9/+=]{40})["\x27]' },
    @{ Name = "GitHub Token"; Pattern = '(?i)(gh[ps]_[a-zA-Z0-9]{36}|github[_-]?token\s*[:=]\s*["\x27][a-zA-Z0-9_\-]+["\x27])' },
    @{ Name = "Password"; Pattern = '(?i)(password|passwd|pwd)\s*[:=]\s*["\x27]([^"\x27]{4,})["\x27]' },
    @{ Name = "Secret"; Pattern = '(?i)(secret|private[_-]?key)\s*[:=]\s*["\x27]([^"\x27]{8,})["\x27]' },
    @{ Name = "Bearer Token"; Pattern = '(?i)bearer\s+[a-zA-Z0-9_\-\.]+' },
    @{ Name = "Database URL"; Pattern = '(?i)(postgres|mysql|mongodb|redis)://[^"\x27\s]+:[^"\x27\s]+@' },
    @{ Name = "Private Key"; Pattern = '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----' },
    @{ Name = "Slack Token"; Pattern = 'xox[baprs]-[0-9a-zA-Z]{10,}' },
    @{ Name = "Stripe Key"; Pattern = '(?i)(sk|pk)_(live|test)_[0-9a-zA-Z]{24,}' }
)

$findings = @()
$scannedFiles = 0

# Build exclude pattern
$ExcludePattern = ($Exclude | ForEach-Object { [regex]::Escape($_) }) -join "|"

# Get files to scan
$files = Get-ChildItem -Path $ScanPath -Recurse -Include $Extensions -File | Where-Object {
    $_.FullName -notmatch $ExcludePattern
}

$totalFiles = $files.Count
Write-Host "Scanning $totalFiles files..." -ForegroundColor Gray

foreach ($file in $files) {
    $scannedFiles++

    # Show progress every 50 files
    if ($scannedFiles % 50 -eq 0) {
        Write-Host "  Scanned $scannedFiles / $totalFiles files..." -ForegroundColor DarkGray
    }

    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }

        $lineNumber = 0
        $lines = $content -split "`n"

        foreach ($line in $lines) {
            $lineNumber++

            foreach ($pattern in $Patterns) {
                if ($line -match $pattern.Pattern) {
                    # Mask the actual secret
                    $maskedLine = $line -replace '(["\x27])([^"\x27]{4})[^"\x27]+([^"\x27]{4})(["\x27])', '$1$2****$3$4'

                    $findings += [PSCustomObject]@{
                        Type    = $pattern.Name
                        File    = $file.FullName.Replace($ScanPath, ".").Replace("\", "/")
                        Line    = $lineNumber
                        Content = $maskedLine.Trim().Substring(0, [Math]::Min(80, $maskedLine.Trim().Length))
                    }
                }
            }
        }
    }
    catch {
        # Skip files that can't be read
    }
}

Write-Host ""

# Check .gitignore for .env files
Write-Host "--- .gitignore Check ---" -ForegroundColor Yellow
$gitignorePath = Join-Path $ScanPath ".gitignore"
$envWarnings = @()

if (Test-Path $gitignorePath) {
    $gitignore = Get-Content $gitignorePath -Raw

    $envPatterns = @(".env", ".env.local", ".env.*.local", "*.env")
    foreach ($pattern in $envPatterns) {
        if ($gitignore -notmatch [regex]::Escape($pattern)) {
            $envWarnings += $pattern
        }
    }

    if ($envWarnings.Count -eq 0) {
        Write-Host "  [OK] .env files appear to be gitignored" -ForegroundColor Green
    }
    else {
        Write-Host "  [WARN] Missing from .gitignore: $($envWarnings -join ', ')" -ForegroundColor Yellow
    }
}
else {
    Write-Host "  [WARN] No .gitignore found!" -ForegroundColor Yellow
}

Write-Host ""

# Report findings
if ($findings.Count -eq 0) {
    Write-Host "--- Results ---" -ForegroundColor Green
    Write-Host "  [OK] No secrets detected in $scannedFiles files" -ForegroundColor Green
    Write-Host ""
    exit 0
}
else {
    Write-Host "--- Findings ($($findings.Count) potential secrets) ---" -ForegroundColor Red
    Write-Host ""

    $groupedFindings = $findings | Group-Object Type

    foreach ($group in $groupedFindings) {
        Write-Host "  [ALERT] $($group.Name) ($($group.Count) found)" -ForegroundColor Red
        foreach ($finding in $group.Group) {
            Write-Host "     $($finding.File):$($finding.Line)" -ForegroundColor Yellow
            Write-Host "       $($finding.Content)" -ForegroundColor Gray
        }
        Write-Host ""
    }

    Write-Host "--- Summary ---" -ForegroundColor Cyan
    Write-Host "  Files scanned: $scannedFiles" -ForegroundColor Gray
    Write-Host "  Secrets found: $($findings.Count)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Action: Review each finding and move secrets to environment variables." -ForegroundColor Yellow
    Write-Host ""

    exit 1
}
