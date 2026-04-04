[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
param(
    [ValidateSet('openai', 'anthropic', 'google', 'all')]
    [string]$Vendor = 'all',
    [switch]$NoBackup
)

$ErrorActionPreference = 'Stop'

function Test-Utf8Bom {
    param([byte[]]$Bytes)
    return (
        $Bytes.Length -ge 3 -and
        $Bytes[0] -eq 0xEF -and
        $Bytes[1] -eq 0xBB -and
        $Bytes[2] -eq 0xBF
    )
}

function Get-FileEncodingHint {
    param([byte[]]$Bytes)

    if ($Bytes.Length -ge 4) {
        if ($Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE -and $Bytes[2] -eq 0x00 -and $Bytes[3] -eq 0x00) {
            return 'utf32-le'
        }
        if ($Bytes[0] -eq 0x00 -and $Bytes[1] -eq 0x00 -and $Bytes[2] -eq 0xFE -and $Bytes[3] -eq 0xFF) {
            return 'utf32-be'
        }
    }
    if ($Bytes.Length -ge 3 -and (Test-Utf8Bom -Bytes $Bytes)) {
        return 'utf8-bom'
    }
    if ($Bytes.Length -ge 2) {
        if ($Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) {
            return 'utf16-le'
        }
        if ($Bytes[0] -eq 0xFE -and $Bytes[1] -eq 0xFF) {
            return 'utf16-be'
        }
    }
    return 'utf8-or-ascii'
}

function Get-TargetConfigs {
    param(
        [ValidateSet('openai', 'anthropic', 'google', 'all')]
        [string]$Selection
    )

    $homePath = [Environment]::GetFolderPath('UserProfile')
    $targets = @()

    if ($Selection -in @('openai', 'all')) {
        $targets += [pscustomobject]@{
            vendor = 'openai'
            client = 'OpenAI Codex'
            kind   = 'toml'
            path   = (Join-Path $homePath '.codex\config.toml')
        }
    }
    if ($Selection -in @('anthropic', 'all')) {
        $targets += [pscustomobject]@{
            vendor = 'anthropic'
            client = 'Anthropic Claude'
            kind   = 'json'
            path   = (Join-Path $homePath '.claude.json')
        }
    }
    if ($Selection -in @('google', 'all')) {
        $targets += [pscustomobject]@{
            vendor = 'google'
            client = 'Google Antigravity'
            kind   = 'json'
            path   = (Join-Path $homePath '.gemini\antigravity\mcp_config.json')
        }
    }

    return $targets
}

function Normalize-TargetConfig {
    param(
        [pscustomobject]$Target,
        [bool]$CreateBackup
    )

    if (-not (Test-Path $Target.path)) {
        return [pscustomobject]@{
            client  = $Target.client
            path    = $Target.path
            status  = 'missing'
            before  = 'missing'
            after   = 'missing'
            backup  = ''
            note    = 'File does not exist.'
        }
    }

    $bytesBefore = [System.IO.File]::ReadAllBytes($Target.path)
    $beforeEncoding = Get-FileEncodingHint -Bytes $bytesBefore
    $rewriteEncodings = @('utf8-bom', 'utf16-le', 'utf16-be', 'utf32-le', 'utf32-be')

    if ($beforeEncoding -notin $rewriteEncodings) {
        return [pscustomobject]@{
            client  = $Target.client
            path    = $Target.path
            status  = 'already-normalized'
            before  = $beforeEncoding
            after   = $beforeEncoding
            backup  = ''
            note    = 'No rewrite needed.'
        }
    }

    $content = [System.IO.File]::ReadAllText($Target.path)
    $jsonValidationError = ''
    if ($Target.kind -eq 'json') {
        try {
            $content | ConvertFrom-Json -Depth 30 | Out-Null
        }
        catch {
            $jsonValidationError = $_.Exception.Message
        }
    }

    $backupPath = ''
    $status = 'whatif'
    $note = 'No changes applied.'

    if ($PSCmdlet.ShouldProcess($Target.path, 'Rewrite as UTF-8 without BOM')) {
        if ($CreateBackup) {
            $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
            $backupPath = "$($Target.path).bak-$stamp"
            Copy-Item -Path $Target.path -Destination $backupPath -Force
        }

        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($Target.path, $content, $utf8NoBom)
        $status = 'normalized'
        $note = 'Rewritten as UTF-8 without BOM.'
    }

    $bytesAfter = [System.IO.File]::ReadAllBytes($Target.path)
    $afterEncoding = Get-FileEncodingHint -Bytes $bytesAfter
    if (-not [string]::IsNullOrWhiteSpace($jsonValidationError)) {
        $note = "JSON parse warning (pre-existing content issue): $jsonValidationError"
    }

    return [pscustomobject]@{
        client  = $Target.client
        path    = $Target.path
        status  = $status
        before  = $beforeEncoding
        after   = $afterEncoding
        backup  = $backupPath
        note    = $note
    }
}

$targets = Get-TargetConfigs -Selection $Vendor
$createBackup = -not $NoBackup

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Normalize MCP Config Encoding' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

$results = @()
foreach ($target in $targets) {
    $results += Normalize-TargetConfig -Target $target -CreateBackup $createBackup
}

$results |
    Select-Object client, status, before, after, backup |
    Format-Table -AutoSize

Write-Host ''
$normalizedCount = @($results | Where-Object { $_.status -eq 'normalized' }).Count
$missingCount = @($results | Where-Object { $_.status -eq 'missing' }).Count
$warningCount = @($results | Where-Object { $_.note -like 'JSON parse warning*' }).Count

Write-Host "Normalized: $normalizedCount" -ForegroundColor Green
Write-Host "Missing: $missingCount" -ForegroundColor Yellow
if ($warningCount -gt 0) {
    Write-Warning "$warningCount JSON file(s) had parse warnings unrelated to encoding."
}

if ($createBackup -and $normalizedCount -gt 0) {
    Write-Host 'Backup files were created next to each rewritten config.' -ForegroundColor Gray
}
