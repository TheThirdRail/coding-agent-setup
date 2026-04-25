<#
.SYNOPSIS
    Initialize a new skill folder with template structure.

.DESCRIPTION
    Creates a new skill directory with SKILL.md template and example resource folders.
    Compatible with Antigravity, Claude Code, GitHub Copilot, and Cursor.

.PARAMETER Name
    The name of the skill (kebab-case, max 64 characters).

.PARAMETER Path
    The parent directory where the skill folder will be created.
    Defaults to current directory.

.EXAMPLE
    .\init_skill.ps1 -Name "pdf-editor" -Path ".agent/skills"
#>

# TODO_SCAN_ALLOW: This file intentionally contains TODO placeholders in generated templates.

param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z][a-z0-9-]{0,62}[a-z0-9]$')]
    [ValidateLength(2, 64)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [string]$Path = "."
)

$ErrorActionPreference = "Stop"

# Ensure parent path exists and resolve full path
if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

$ParentPath = (Resolve-Path $Path -ErrorAction Stop).Path
$SkillPath = Join-Path -Path $ParentPath -ChildPath $Name

# Check if already exists
if (Test-Path $SkillPath) {
    Write-Error "Skill folder already exists: $SkillPath"
    exit 1
}

Write-Host "Creating skill: $Name" -ForegroundColor Cyan
Write-Host "Location: $SkillPath" -ForegroundColor Gray

# Create directory structure
$Directories = @(
    $SkillPath,
    (Join-Path $SkillPath "scripts"),
    (Join-Path $SkillPath "references"),
    (Join-Path $SkillPath "assets")
)

foreach ($Dir in $Directories) {
    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    Write-Host "  Created: $Dir" -ForegroundColor DarkGray
}

# Create SKILL.md template
$SkillMdContent = @"
---
name: $Name
description: |
  TODO: Brief description of what the skill does.
  Include WHEN to use this skill (triggers).
  Keep under 200 words.
---

<skill name="$Name" version="1.0.0">
  <metadata>
    <keywords>TODO: keyword1, keyword2</keywords>
  </metadata>

  <goal>TODO: One sentence describing the skill's purpose.</goal>

  <core_principles>
    <principle name="TODO: Key Principle">
      <rule>TODO: Specific rule or guideline</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="TODO: Step Name">
      <instruction>TODO: What to do in this step</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>TODO: What to do</do>
    <dont>TODO: What to avoid</dont>
  </best_practices>

  <related_skills>
    <!-- <skill>related-skill-name</skill> -->
  </related_skills>
</skill>
"@

$SkillMdPath = Join-Path $SkillPath "SKILL.md"
Set-Content -Path $SkillMdPath -Value $SkillMdContent -Encoding UTF8
Write-Host "  Created: $SkillMdPath" -ForegroundColor DarkGray

# Create example script
$ExampleScriptContent = @"
#!/usr/bin/env python3
"""
Example script for $Name skill.
Delete this file if not needed.

Usage:
    python example.py <input>
"""

import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: python example.py <input>")
        sys.exit(1)

    input_arg = sys.argv[1]
    print(f"Processing: {input_arg}")
    # TODO: Implement functionality

if __name__ == "__main__":
    main()
"@

$ExampleScriptPath = Join-Path $SkillPath "scripts/example.py"
Set-Content -Path $ExampleScriptPath -Value $ExampleScriptContent -Encoding UTF8
Write-Host "  Created: $ExampleScriptPath" -ForegroundColor DarkGray

# Create example reference
$ExampleRefContent = @"
# Reference Documentation

This file contains reference material that the agent can load when needed.

## Table of Contents
- [Section 1](#section-1)
- [Section 2](#section-2)

## Section 1

TODO: Add reference content here.

## Section 2

TODO: Add more reference content here.

---
*Delete this file if not needed.*
"@

$ExampleRefPath = Join-Path $SkillPath "references/example.md"
Set-Content -Path $ExampleRefPath -Value $ExampleRefContent -Encoding UTF8
Write-Host "  Created: $ExampleRefPath" -ForegroundColor DarkGray

# Create example asset placeholder
$ExampleAssetContent = "Delete this file and add actual assets (images, templates, boilerplate code) as needed."
$ExampleAssetPath = Join-Path $SkillPath "assets/README.txt"
Set-Content -Path $ExampleAssetPath -Value $ExampleAssetContent -Encoding UTF8
Write-Host "  Created: $ExampleAssetPath" -ForegroundColor DarkGray

Write-Host "`nSkill initialized successfully!" -ForegroundColor Green
Write-Host @"

Next steps:
  1. Edit SKILL.md - Replace TODO placeholders
  2. Add resources - scripts/, references/, assets/
  3. Delete unused example files
  4. Package when ready: package_skill.ps1 -Path "$SkillPath"

"@ -ForegroundColor Yellow
