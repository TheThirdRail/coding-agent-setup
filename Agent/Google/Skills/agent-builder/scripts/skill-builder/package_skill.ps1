<#
.SYNOPSIS
    Validate and package a skill for distribution.

.DESCRIPTION
    Performs strict validation on SKILL.md structure, references, metadata,
    and placeholders, then packages the skill as a .skill archive.

.PARAMETER Path
    Path to the skill folder to package.

.PARAMETER OutputDir
    Directory where the .skill file will be created.

.PARAMETER SkipValidation
    Skip validation checks.

.PARAMETER Strict
    Treat warnings as errors.
#>

# TODO_SCAN_ALLOW: This file intentionally references TODO placeholder patterns.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = ".",

    [Parameter(Mandatory = $false)]
    [switch]$SkipValidation,

    [Parameter(Mandatory = $false)]
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

function Add-ValidationError {
    param(
        [System.Collections.Generic.List[string]]$List,
        [string]$Message
    )
    $List.Add($Message) | Out-Null
}

function Add-ValidationWarning {
    param(
        [System.Collections.Generic.List[string]]$List,
        [string]$Message
    )
    $List.Add($Message) | Out-Null
}

function Parse-Frontmatter {
    param([string]$Content)

    $match = [regex]::Match($Content, '^---\s*\r?\n([\s\S]*?)\r?\n---', [System.Text.RegularExpressions.RegexOptions]::Multiline)
    if (-not $match.Success) {
        return $null
    }

    $front = $match.Groups[1].Value
    $keyMatches = [regex]::Matches($front, '(?m)^([A-Za-z0-9_-]+):')
    $keys = @($keyMatches | ForEach-Object { $_.Groups[1].Value })

    $name = $null
    $nameMatch = [regex]::Match($front, '(?m)^name:\s*([^\r\n]+)')
    if ($nameMatch.Success) {
        $name = $nameMatch.Groups[1].Value.Trim()
    }

    $description = $null
    $descBlockMatch = [regex]::Match($front, '(?ms)^description:\s*\|\s*\r?\n(?<body>(?:\s{2}.*(?:\r?\n|$))+)' )
    if ($descBlockMatch.Success) {
        $description = ($descBlockMatch.Groups['body'].Value -split "`r?`n" | ForEach-Object { $_ -replace '^\s{2}', '' } | Where-Object { $_ -ne '' }) -join " "
    }
    else {
        $descInlineMatch = [regex]::Match($front, '(?m)^description:\s*([^\r\n]+)')
        if ($descInlineMatch.Success) {
            $description = $descInlineMatch.Groups[1].Value.Trim()
        }
    }

    return @{
        Keys = $keys
        Name = $name
        Description = $description
    }
}

function Get-SkillXml {
    param([string]$Content)

    $match = [regex]::Match($Content, '(?s)(<skill\b[\s\S]*</skill>)')
    if ($match.Success) {
        return $match.Groups[1].Value
    }
    return $null
}

function ConvertTo-HashtableCompat {
    param($InputObject)

    if ($null -eq $InputObject) {
        return $null
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        $hash = @{}
        foreach ($key in $InputObject.Keys) {
            $hash[$key] = ConvertTo-HashtableCompat -InputObject $InputObject[$key]
        }
        return $hash
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and -not ($InputObject -is [string])) {
        $list = @()
        foreach ($item in $InputObject) {
            $list += ,(ConvertTo-HashtableCompat -InputObject $item)
        }
        return $list
    }

    if ($InputObject -is [psobject] -and $InputObject.PSObject.Properties.Count -gt 0) {
        $hash = @{}
        foreach ($prop in $InputObject.PSObject.Properties) {
            $hash[$prop.Name] = ConvertTo-HashtableCompat -InputObject $prop.Value
        }
        return $hash
    }

    return $InputObject
}

function ConvertFrom-JsonCompat {
    param([string]$JsonText)

    try {
        return ($JsonText | ConvertFrom-Json -AsHashtable -ErrorAction Stop)
    }
    catch {
        $obj = $JsonText | ConvertFrom-Json -ErrorAction Stop
        return ConvertTo-HashtableCompat -InputObject $obj
    }
}

function Validate-MetadataFile {
    param(
        [string]$MetadataPath,
        [string]$SchemaPath,
        [string]$SkillName,
        [System.Collections.Generic.List[string]]$Errors,
        [System.Collections.Generic.List[string]]$Warnings
    )

    if (-not (Test-Path $MetadataPath)) {
        Add-ValidationError $Errors "metadata.json not found"
        return
    }

    if (-not (Test-Path $SchemaPath)) {
        Add-ValidationError $Errors "metadata.schema.json not found at $SchemaPath"
        return
    }

    try {
        $metadata = ConvertFrom-JsonCompat -JsonText (Get-Content $MetadataPath -Raw)
    }
    catch {
        Add-ValidationError $Errors "metadata.json is not valid JSON"
        return
    }

    try {
        $schema = ConvertFrom-JsonCompat -JsonText (Get-Content $SchemaPath -Raw)
    }
    catch {
        Add-ValidationError $Errors "metadata.schema.json is not valid JSON"
        return
    }

    $required = @($schema.required)
    $allowed = @($schema.properties.Keys)

    foreach ($requiredKey in $required) {
        if (-not $metadata.ContainsKey($requiredKey)) {
            Add-ValidationError $Errors "metadata.json missing required field '$requiredKey'"
        }
    }

    foreach ($key in $metadata.Keys) {
        if ($allowed -notcontains $key) {
            Add-ValidationError $Errors "metadata.json contains unsupported field '$key'"
        }
    }

    if ($metadata.ContainsKey('name')) {
        if ($metadata.name -ne $SkillName) {
            Add-ValidationError $Errors "metadata.name '$($metadata.name)' must match folder '$SkillName'"
        }
        if ($metadata.name -notmatch '^[a-z][a-z0-9-]*$') {
            Add-ValidationError $Errors "metadata.name must be kebab-case"
        }
    }

    if ($metadata.ContainsKey('version')) {
        if ($metadata.version -notmatch '^\d+\.\d+\.\d+$') {
            Add-ValidationError $Errors "metadata.version must be semantic version (x.y.z)"
        }
    }

    if ($metadata.ContainsKey('description')) {
        if ([string]::IsNullOrWhiteSpace($metadata.description)) {
            Add-ValidationError $Errors "metadata.description must not be empty"
        }
        elseif ($metadata.description.Length -gt 200) {
            Add-ValidationError $Errors "metadata.description must be <= 200 characters"
        }
    }

    if ($metadata.ContainsKey('category')) {
        $validCategories = @('development', 'architecture', 'testing', 'documentation', 'security', 'devops', 'research', 'productivity')
        if ($validCategories -notcontains $metadata.category) {
            Add-ValidationError $Errors "metadata.category '$($metadata.category)' is invalid"
        }
    }

    if ($metadata.ContainsKey('keywords')) {
        if ($metadata.keywords.Count -gt 10) {
            Add-ValidationError $Errors "metadata.keywords must contain at most 10 items"
        }
    }

    if ($metadata.ContainsKey('related_workflows')) {
        foreach ($wf in $metadata.related_workflows) {
            if ($wf -notmatch '^/[a-z-]+$') {
                Add-ValidationError $Errors "metadata.related_workflows entry '$wf' must match ^/[a-z-]+$"
            }
        }
    }

    if ($metadata.ContainsKey('dateCreated')) {
        if ($metadata.dateCreated -notmatch '^\d{4}-\d{2}-\d{2}$') {
            Add-ValidationError $Errors "metadata.dateCreated must be YYYY-MM-DD"
        }
    }

    if ($metadata.ContainsKey('dateModified')) {
        if ($metadata.dateModified -notmatch '^\d{4}-\d{2}-\d{2}$') {
            Add-ValidationError $Errors "metadata.dateModified must be YYYY-MM-DD"
        }
    }
}

$SkillPath = (Resolve-Path $Path -ErrorAction Stop).Path
$SkillName = Split-Path $SkillPath -Leaf
$SkillMdPath = Join-Path $SkillPath "SKILL.md"
$SkillsRoot = Split-Path $SkillPath -Parent
$RepoRoot = Split-Path $SkillsRoot -Parent
$SchemaPath = Join-Path $SkillsRoot "metadata.schema.json"
$MetadataPath = Join-Path $SkillPath "metadata.json"
$WorkflowsPath = Join-Path $RepoRoot "Workflows"

Write-Host "Packaging skill: $SkillName" -ForegroundColor Cyan
Write-Host "Source: $SkillPath" -ForegroundColor Gray

$Errors = [System.Collections.Generic.List[string]]::new()
$Warnings = [System.Collections.Generic.List[string]]::new()

if (-not $SkipValidation) {
    Write-Host "`nValidating..." -ForegroundColor Yellow

    if (-not (Test-Path $SkillMdPath)) {
        Add-ValidationError $Errors "SKILL.md not found at: $SkillMdPath"
    }
    else {
        $Content = Get-Content $SkillMdPath -Raw

        # Frontmatter validation
        $frontmatter = Parse-Frontmatter -Content $Content
        if (-not $frontmatter) {
            Add-ValidationError $Errors "SKILL.md missing YAML frontmatter"
        }
        else {
            $keys = @($frontmatter.Keys | Sort-Object -Unique)
            $expectedKeys = @('description', 'name')
            if (($keys -join ',') -ne ($expectedKeys -join ',')) {
                Add-ValidationError $Errors "Frontmatter must contain only 'name' and 'description' fields"
            }

            if (-not $frontmatter.Name) {
                Add-ValidationError $Errors "Frontmatter missing 'name' value"
            }
            elseif ($frontmatter.Name -ne $SkillName) {
                Add-ValidationError $Errors "Frontmatter name '$($frontmatter.Name)' must match folder '$SkillName'"
            }

            if (-not $frontmatter.Description) {
                Add-ValidationError $Errors "Frontmatter missing 'description' value"
            }
            else {
                if ($frontmatter.Description -notmatch '(?i)use when') {
                    Add-ValidationWarning $Warnings "Description should include an explicit 'Use when ...' trigger clause"
                }
                if ($frontmatter.Description -match '(?i)\bTODO:\s*\S') {
                    Add-ValidationError $Errors "Description contains TODO placeholder"
                }
                if ($frontmatter.Description.Length -gt 300) {
                    Add-ValidationWarning $Warnings "Description is long ($($frontmatter.Description.Length) chars). Keep concise for discovery"
                }
            }
        }

        # XML validation
        $skillXml = Get-SkillXml -Content $Content
        if (-not $skillXml) {
            Add-ValidationError $Errors "SKILL.md body must contain a <skill ...> XML root"
        }
        else {
            try {
                [xml]$xml = "<root>$skillXml</root>"
                $skillNode = $xml.root.skill

                if (-not $skillNode) {
                    Add-ValidationError $Errors "Missing <skill> root node"
                }
                else {
                    # Root attributes
                    $xmlName = $skillNode.GetAttribute("name")
                    $xmlVersion = $skillNode.GetAttribute("version")
                    if ($xmlName -ne $SkillName) {
                        Add-ValidationError $Errors "XML skill name '$xmlName' must match folder '$SkillName'"
                    }
                    if ($xmlVersion -notmatch '^\d+\.\d+\.\d+$') {
                        Add-ValidationError $Errors "XML skill version must be semantic version (x.y.z)"
                    }

                    # Required sections
                    $requiredSections = @('metadata', 'goal', 'core_principles', 'workflow', 'best_practices')
                    foreach ($section in $requiredSections) {
                        if (-not $skillNode.SelectSingleNode($section)) {
                            Add-ValidationError $Errors "Missing required XML section <$section>"
                        }
                    }

                    # Trigger placement rule
                    if ($skillNode.SelectSingleNode('when_to_use')) {
                        Add-ValidationError $Errors "<when_to_use> is forbidden in body. Put triggers in frontmatter description"
                    }

                    # Workflow step sequence check
                    $stepNodes = $skillNode.SelectNodes('./workflow/step[@number]')
                    if ($stepNodes.Count -eq 0) {
                        Add-ValidationError $Errors "<workflow> must contain at least one numbered <step>"
                    }
                    else {
                        $numbers = @()
                        foreach ($step in $stepNodes) {
                            $raw = $step.GetAttribute('number')
                            if ($raw -notmatch '^\d+$') {
                                Add-ValidationError $Errors "Workflow step number '$raw' must be numeric"
                                continue
                            }
                            $numbers += [int]$raw
                        }

                        if ($numbers.Count -gt 0) {
                            $dupes = $numbers | Group-Object | Where-Object { $_.Count -gt 1 }
                            foreach ($dup in $dupes) {
                                Add-ValidationError $Errors "Duplicate workflow step number '$($dup.Name)'"
                            }

                            $distinct = $numbers | Sort-Object -Unique
                            $min = ($distinct | Measure-Object -Minimum).Minimum
                            $max = ($distinct | Measure-Object -Maximum).Maximum
                            if ($min -ne 1) {
                                Add-ValidationError $Errors "Workflow step numbering must start at '1'"
                            }
                            $expected = @($min..$max)
                            $missing = @($expected | Where-Object { $distinct -notcontains $_ })
                            foreach ($miss in $missing) {
                                Add-ValidationError $Errors "Missing workflow step number '$miss'"
                            }
                        }
                    }
                }
            }
            catch {
                Add-ValidationError $Errors "Invalid XML in SKILL.md: $($_.Exception.Message)"
            }

            # Cross-skill reference checks (parsed XML nodes only)
            $skillFolders = Get-ChildItem $SkillsRoot -Directory | Where-Object {
                Test-Path (Join-Path $_.FullName 'SKILL.md')
            } | Select-Object -ExpandProperty Name

            $relatedSkillNodes = $skillNode.SelectNodes('.//related_skills/skill | .//integration_points/skill')
            foreach ($relatedSkillNode in $relatedSkillNodes) {
                $ref = $null
                if ($relatedSkillNode.Attributes['ref']) {
                    $ref = $relatedSkillNode.Attributes['ref'].Value.Trim()
                }
                elseif (-not [string]::IsNullOrWhiteSpace($relatedSkillNode.InnerText)) {
                    $ref = $relatedSkillNode.InnerText.Trim()
                }

                if ($ref -and ($skillFolders -notcontains $ref)) {
                    Add-ValidationError $Errors "Related skill reference '$ref' does not exist"
                }
            }

            # Workflow reference checks (parsed XML nodes only)
            if (Test-Path $WorkflowsPath) {
                $workflowRefNodes = $skillNode.SelectNodes('.//related_workflows/workflow | .//integration_points/workflow')
                foreach ($workflowRefNode in $workflowRefNodes) {
                    $ref = $null
                    if ($workflowRefNode.Attributes['ref']) {
                        $ref = $workflowRefNode.Attributes['ref'].Value.Trim()
                    }
                    elseif (-not [string]::IsNullOrWhiteSpace($workflowRefNode.InnerText)) {
                        $ref = $workflowRefNode.InnerText.Trim()
                    }

                    if ($ref -and ($ref -match '^/[a-z-]+$')) {
                        $workflowFile = Join-Path $WorkflowsPath ($ref.TrimStart('/') + '.md')
                        if (-not (Test-Path $workflowFile)) {
                            Add-ValidationError $Errors "Workflow reference '$ref' does not exist at $workflowFile"
                        }
                    }
                }
            }
        }

        # General file size guideline
        $lineCount = ($Content -split "`r?`n").Count
        if ($lineCount -gt 500) {
            Add-ValidationWarning $Warnings "SKILL.md is $lineCount lines (recommended <= 500)"
        }
    }

    # metadata.json validation
    Validate-MetadataFile -MetadataPath $MetadataPath -SchemaPath $SchemaPath -SkillName $SkillName -Errors $Errors -Warnings $Warnings

    # Forbidden docs for skills
    $forbiddenFiles = @('README.md', 'CHANGELOG.md', 'INSTALLATION_GUIDE.md', 'QUICK_REFERENCE.md', 'CONTRIBUTING.md')
    foreach ($forbidden in $forbiddenFiles) {
        if (Test-Path (Join-Path $SkillPath $forbidden)) {
            Add-ValidationWarning $Warnings "Found forbidden auxiliary file '$forbidden'"
        }
    }

    # TODO placeholder scan
    $textExtensions = @('.md', '.txt', '.ps1', '.py', '.cjs', '.js', '.yaml', '.yml', '.json')
    $todoPattern = '(?i)\bTODO:\s*\S'
    $todoFiles = Get-ChildItem -Path $SkillPath -Recurse -File | Where-Object {
        $textExtensions -contains $_.Extension.ToLowerInvariant()
    }

    foreach ($todoFile in $todoFiles) {
        $fileContent = $null
        try {
            $fileContent = Get-Content $todoFile.FullName -Raw
        }
        catch {
            continue
        }

        if ($fileContent -match 'TODO_SCAN_ALLOW') {
            continue
        }

        if ($fileContent -match $todoPattern) {
            $relativePath = $todoFile.FullName.Substring($SkillPath.Length).TrimStart([char[]]@('\', '/'))
            if ([string]::IsNullOrWhiteSpace($relativePath)) {
                $relativePath = $todoFile.Name
            }
            Add-ValidationError $Errors "Found TODO placeholder in $relativePath"
        }
    }

    if ($Strict -and $Warnings.Count -gt 0) {
        foreach ($warn in $Warnings) {
            Add-ValidationError $Errors "[Strict] $warn"
        }
        $Warnings.Clear()
    }

    Write-Host ""
    foreach ($warn in $Warnings) {
        Write-Host "  [WARN] $warn" -ForegroundColor Yellow
    }
    foreach ($err in $Errors) {
        Write-Host "  [ERROR] $err" -ForegroundColor Red
    }

    if ($Errors.Count -gt 0) {
        Write-Host "`nValidation failed with $($Errors.Count) error(s)." -ForegroundColor Red
        exit 1
    }

    if ($Warnings.Count -eq 0) {
        Write-Host "  All checks passed!" -ForegroundColor Green
    }
}

Write-Host "`nPackaging..." -ForegroundColor Yellow

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$ResolvedOutputDir = (Resolve-Path $OutputDir).Path
$OutputPath = Join-Path $ResolvedOutputDir "$SkillName.skill"
$ZipPath = Join-Path $ResolvedOutputDir "$SkillName.zip"

if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Force
}
if (Test-Path $ZipPath) {
    Remove-Item $ZipPath -Force
}

try {
    Compress-Archive -Path "$SkillPath\*" -DestinationPath $ZipPath -Force
    Rename-Item -Path $ZipPath -NewName "$SkillName.skill" -Force

    $fileInfo = Get-Item $OutputPath
    $sizeKb = [math]::Round($fileInfo.Length / 1KB, 2)

    Write-Host "`nPackage created successfully!" -ForegroundColor Green
    Write-Host "  Output: $OutputPath" -ForegroundColor Gray
    Write-Host "  Size: $sizeKb KB" -ForegroundColor Gray

    if ($Warnings.Count -gt 0) {
        Write-Host "`n  Note: Package created with $($Warnings.Count) warning(s)." -ForegroundColor Yellow
    }
}
catch {
    Write-Error "Failed to create package: $_"
    exit 1
}
