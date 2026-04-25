# PowerShell script to set Docker MCP secrets from .env file
# Updated to support both Docker native catalog and custom catalog secret names

param(
    [string]$EnvFilePath = ".env"
)

if (-not (Test-Path $EnvFilePath)) {
    Write-Error "File not found: $EnvFilePath"
    exit 1
}

# Define mapping from .env variable name to MCP secret name(s)
# Some secrets need to be set for both Docker native and custom catalog
$Mappings = @{
    # ============================================
    # CORE - GitHub (Docker native + custom)
    # ============================================
    "GITHUB_PERSONAL_ACCESS_TOKEN" = @(
        "github.personal_access_token",  # Docker native (github-official)
        "github.token"                    # Custom catalog
    )

    # ============================================
    # SEARCH
    # ============================================
    "BRAVE_API_KEY"                = @("brave.api_key")  # Docker native
    "TAVILY_API_KEY"               = @("tavily.api_token")  # Docker native

    # ============================================
    # TASK MANAGEMENT
    # ============================================
    "LINEAR_API_KEY"               = @("linear.personal_access_token")  # Docker native (OAuth)
    "TODOIST_API_TOKEN"            = @("todoist.api_key")  # Custom catalog - new package uses API_KEY

    # ============================================
    # DATABASES - Docker native
    # ============================================
    "POSTGRES_URL"                 = @("postgres.url")  # Docker native (single connection string)
    "MONGODB_URI"                  = @("mongodb.connection_string")  # Docker native
    "NEON_API_KEY"                 = @("neon.api_key")  # Docker native

    # ============================================
    # DATABASES - Custom catalog (Supabase)
    # ============================================
    "SUPABASE_ACCESS_TOKEN"        = @("supabase.access_token")  # Updated: uses access token now

    # ============================================
    # INFRASTRUCTURE - Custom catalog
    # ============================================
    "CLOUDFLARE_API_TOKEN"         = @("cloudflare.api_token")
    "CLOUDFLARE_ACCOUNT_ID"        = @("cloudflare.account_id")

    # ============================================
    # SECURITY - Custom catalog
    # ============================================
    "SNYK_TOKEN"                   = @("snyk.api_key")  # Community package uses SNYK_API_KEY
    "GITGUARDIAN_API_KEY"          = @("gitguardian.api_key")

    # ============================================
    # RESEARCH - Mixed
    # ============================================
    "FIRECRAWL_API_KEY"            = @("firecrawl.api_key")  # Docker native
    "PERPLEXITY_API_KEY"           = @("perplexity-ask.api_key")  # Docker native

    # ============================================
    # KNOWLEDGE MANAGEMENT
    # ============================================
    "NOTION_API_KEY"               = @("notion.internal_integration_token")  # Docker native
    "MEM0_API_KEY"                 = @("mem0.key")  # Custom catalog
}

Write-Host "+--------------------------------------------+" -ForegroundColor Cyan
Write-Host "|   Docker MCP Secrets Configuration         |" -ForegroundColor Cyan
Write-Host "+--------------------------------------------+" -ForegroundColor Cyan
Write-Host ""
Write-Host "Reading secrets from $EnvFilePath..." -ForegroundColor Yellow

$SecretsSet = 0
$SecretsFailed = 0

# Read .env file line by line
Get-Content $EnvFilePath | ForEach-Object {
    $line = $_.Trim()

    # Skip comments and empty lines
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) {
        return
    }

    # Split key and value (handling possible '=' in value)
    $parts = $line.Split("=", 2)
    if ($parts.Count -lt 2) { return }

    $Key = $parts[0].Trim()
    $Value = $parts[1].Trim()

    # Check if this env var is in our mapping list
    if ($Mappings.ContainsKey($Key)) {
        $SecretNames = $Mappings[$Key]

        foreach ($SecretName in $SecretNames) {
            Write-Host "  Setting: $SecretName" -NoNewline

            # Pipe value to docker mcp secret set
            $Value | docker mcp secret set $SecretName 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host " [OK]" -ForegroundColor Green
                $SecretsSet++
            }
            else {
                Write-Host " [FAIL]" -ForegroundColor Red
                $SecretsFailed++
            }
        }
    }
}

Write-Host ""
Write-Host "--------------------------------------------" -ForegroundColor Cyan
$ResultColor = if ($SecretsFailed -eq 0) { "Green" } else { "Yellow" }
Write-Host "Results: $SecretsSet secrets set, $SecretsFailed failed" -ForegroundColor $ResultColor
Write-Host ""
Write-Host "Run 'docker mcp secret ls' to verify." -ForegroundColor Gray
