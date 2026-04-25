<#
.SYNOPSIS
    Scaffold test files from source files.

.DESCRIPTION
    Analyzes a source file and creates a corresponding test file with
    boilerplate structure based on functions/classes found.

.PARAMETER SourceFile
    Path to the source file to create tests for.

.PARAMETER OutputDir
    Directory for test files. Default: auto-detect (tests/, __tests__, or same dir)

.PARAMETER Framework
    Test framework to use. Default: auto-detect from package.json/requirements.txt

.EXAMPLE
    .\scaffold_tests.ps1 -SourceFile "src/utils.ts"
    # Creates tests/utils.test.ts with boilerplate

.EXAMPLE
    .\scaffold_tests.ps1 -SourceFile "app/services/user_service.py" -Framework "pytest"
#>

# TODO_SCAN_ALLOW: This script intentionally emits TODO placeholders for generated test scaffolds.

param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFile,
    [string]$OutputDir = "",
    [string]$Framework = ""
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== Test Scaffolder ===" -ForegroundColor Cyan

# Validate source file exists
if (-not (Test-Path $SourceFile)) {
    Write-Host "ERROR: Source file not found: $SourceFile" -ForegroundColor Red
    exit 1
}

$sourceInfo = Get-Item $SourceFile
$extension = $sourceInfo.Extension.ToLower()
$baseName = $sourceInfo.BaseName

Write-Host "Source: $SourceFile" -ForegroundColor Gray

# Detect language and framework
$language = switch ($extension) {
    ".ts" { "typescript" }
    ".tsx" { "typescript" }
    ".js" { "javascript" }
    ".jsx" { "javascript" }
    ".py" { "python" }
    ".go" { "go" }
    default { "unknown" }
}

if ($language -eq "unknown") {
    Write-Host "ERROR: Unsupported file type: $extension" -ForegroundColor Red
    exit 1
}

Write-Host "Language: $language" -ForegroundColor Gray

# Detect/set test framework
if (-not $Framework) {
    $Framework = switch ($language) {
        "typescript" { "jest" }
        "javascript" { "jest" }
        "python" { "pytest" }
        "go" { "testing" }
    }
}

Write-Host "Framework: $Framework" -ForegroundColor Gray

# Determine output directory
if (-not $OutputDir) {
    $parentDir = $sourceInfo.DirectoryName

    # Check common test directories
    $possibleDirs = @(
        (Join-Path $parentDir "__tests__"),
        (Join-Path $parentDir "tests"),
        (Join-Path (Split-Path $parentDir -Parent) "tests"),
        (Join-Path (Split-Path $parentDir -Parent) "__tests__")
    )

    foreach ($dir in $possibleDirs) {
        if (Test-Path $dir) {
            $OutputDir = $dir
            break
        }
    }

    # Default to same directory with test suffix
    if (-not $OutputDir) {
        $OutputDir = $parentDir
    }
}

# Create output directory if needed
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Determine test file name
$testFileName = switch ($language) {
    "typescript" { "$baseName.test.ts" }
    "javascript" { "$baseName.test.js" }
    "python" { "test_$baseName.py" }
    "go" { "${baseName}_test.go" }
}

$testFilePath = Join-Path $OutputDir $testFileName

Write-Host "Output: $testFilePath" -ForegroundColor Gray

# Extract functions/classes from source
$content = Get-Content $SourceFile -Raw
$functions = @()

switch ($language) {
    "typescript" {
        # Match function declarations and exports
        $regexMatches = [regex]::Matches($content, '(?:export\s+)?(?:async\s+)?function\s+(\w+)|(?:export\s+)?const\s+(\w+)\s*=\s*(?:async\s*)?\([^)]*\)\s*(?::\s*[^=]+)?\s*=>')
        foreach ($match in $regexMatches) {
            $name = if ($match.Groups[1].Value) { $match.Groups[1].Value } else { $match.Groups[2].Value }
            if ($name -and $name -notmatch '^_') {
                $functions += $name
            }
        }

        # Match class declarations
        $classMatches = [regex]::Matches($content, 'class\s+(\w+)')
        foreach ($match in $classMatches) {
            $functions += $match.Groups[1].Value
        }
    }
    "javascript" {
        $regexMatches = [regex]::Matches($content, '(?:export\s+)?(?:async\s+)?function\s+(\w+)|(?:export\s+)?const\s+(\w+)\s*=\s*(?:async\s*)?\([^)]*\)\s*=>')
        foreach ($match in $regexMatches) {
            $name = if ($match.Groups[1].Value) { $match.Groups[1].Value } else { $match.Groups[2].Value }
            if ($name -and $name -notmatch '^_') {
                $functions += $name
            }
        }
    }
    "python" {
        # Match function and class definitions
        $regexMatches = [regex]::Matches($content, '(?:async\s+)?def\s+(\w+)|class\s+(\w+)')
        foreach ($match in $regexMatches) {
            $name = if ($match.Groups[1].Value) { $match.Groups[1].Value } else { $match.Groups[2].Value }
            if ($name -and $name -notmatch '^_') {
                $functions += $name
            }
        }
    }
    "go" {
        $regexMatches = [regex]::Matches($content, 'func\s+(?:\([^)]+\)\s+)?(\w+)')
        foreach ($match in $regexMatches) {
            $name = $match.Groups[1].Value
            # Go exports start with uppercase
            if ($name -and $name -cmatch '^[A-Z]') {
                $functions += $name
            }
        }
    }
}

Write-Host "Found $($functions.Count) testable items: $($functions -join ', ')" -ForegroundColor Gray

# Generate test content
$testContent = switch ($Framework) {
    "jest" {
        $relativePath = [System.IO.Path]::GetRelativePath($OutputDir, $sourceInfo.FullName).Replace('\', '/')
        $relativePath = $relativePath -replace '\.tsx?$', ''

        $imports = "import { $($functions -join ', ') } from './$relativePath';"

        $tests = $functions | ForEach-Object {
            @"

describe('$_', () => {
  describe('when called with valid input', () => {
    it('should return expected result', () => {
      // Arrange
      const input = undefined; // TODO: add test input

      // Act
      const result = $_(input);

      // Assert
      expect(result).toBeDefined();
    });
  });

  describe('edge cases', () => {
    it('should handle empty input', () => {
      // TODO: implement
    });

    it('should handle null/undefined', () => {
      // TODO: implement
    });
  });

  describe('error handling', () => {
    it('should throw on invalid input', () => {
      // TODO: implement
    });
  });
});
"@
        }

        "$imports`n$($tests -join "`n")"
    }

    "pytest" {
        $relativePath = $sourceInfo.DirectoryName -replace '.*[/\\]', ''
        $moduleName = "$relativePath.$baseName" -replace '^\.', ''

        $imports = "import pytest`nfrom $moduleName import $($functions -join ', ')"

        $tests = $functions | ForEach-Object {
            @"


class Test${_}:
    """Tests for ${_} function/class."""

    def test_happy_path(self):
        """Test normal operation."""
        # Arrange
        input_data = None  # TODO: add test input

        # Act
        result = $_(input_data)

        # Assert
        assert result is not None

    def test_edge_case_empty(self):
        """Test with empty input."""
        # TODO: implement
        pass

    def test_edge_case_none(self):
        """Test with None input."""
        # TODO: implement
        pass

    def test_error_invalid_input(self):
        """Test error handling for invalid input."""
        with pytest.raises(Exception):  # TODO: specify exception type
            $_(invalid_input)
"@
        }

        "$imports`n$($tests -join "`n")"
    }

    "testing" {
        $packageLine = ($content -split "`n" | Where-Object { $_ -match '^package\s+\w+' } | Select-Object -First 1)

        $tests = $functions | ForEach-Object {
            @"


func Test$_(t *testing.T) {
	tests := []struct {
		name    string
		input   interface{} // TODO: define input type
		want    interface{} // TODO: define output type
		wantErr bool
	}{
		{
			name:    "happy path",
			input:   nil, // TODO: add test input
			want:    nil, // TODO: add expected output
			wantErr: false,
		},
		{
			name:    "edge case - empty",
			input:   nil,
			want:    nil,
			wantErr: false,
		},
		{
			name:    "error case",
			input:   nil,
			want:    nil,
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := $_(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("$_() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("$_() = %v, want %v", got, tt.want)
			}
		})
	}
}
"@
        }

        "$packageLine`n`nimport `"testing`"`n$($tests -join "`n")"
    }
}

# Check if file already exists
if (Test-Path $testFilePath) {
    Write-Host "`nWARNING: Test file already exists: $testFilePath" -ForegroundColor Yellow
    $overwrite = Read-Host "Overwrite? (y/N)"
    if ($overwrite -ne 'y') {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
    }
}

# Write test file
$testContent | Out-File -FilePath $testFilePath -Encoding utf8

Write-Host "`n[OK] Created test file: $testFilePath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Fill in TODO placeholders with actual test data" -ForegroundColor Gray
Write-Host "  2. Run tests: " -NoNewline -ForegroundColor Gray

switch ($Framework) {
    "jest" { Write-Host "npm test -- $testFileName" -ForegroundColor White }
    "pytest" { Write-Host "pytest $testFilePath -v" -ForegroundColor White }
    "testing" { Write-Host "go test -v ./$((Split-Path $testFilePath -Parent) -replace '\\', '/')/" -ForegroundColor White }
}

Write-Host ""
