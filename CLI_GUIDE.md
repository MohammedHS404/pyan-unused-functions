# CLI Usage Guide

Complete guide for using `pyan-unused-functions` from the command line.

## Installation

```bash
pip install pyan-unused-functions
```

This will automatically install the required dependency: `pyan3==1.1.1`

## Basic Commands

### Analyze Current Directory

```bash
pyan-unused-functions .
```

### Analyze Specific Directory

```bash
pyan-unused-functions /path/to/your/project
```

### Analyze Subdirectory

```bash
pyan-unused-functions ./src
```

## Output Explained

```
Analyzing Python code in: ./my_project
Analyzing 45 Python files...

=== Analysis Results ===
Total functions defined: 127      ← All public functions found
Total function calls found: 98    ← Unique function calls detected
Potentially unused functions: 12  ← Functions not found in calls

=== Potentially Unused Functions ===
  module_a.helper_function       ← Format: module.function
  module_b.MyClass.old_method    ← Format: module.Class.method
  utils.deprecated_function
  ...
```

## Advanced Usage

### Redirecting Output to File

```bash
# Save full output
pyan-unused-functions . > analysis.txt

# Save only unused functions
pyan-unused-functions . | grep "  " > unused.txt
```

### Integration with Other Commands

```bash
# Count unused functions
pyan-unused-functions . | grep -c "  "

# Search for specific pattern
pyan-unused-functions . | grep "deprecated"

# Check if any unused functions exist (for scripts)
if pyan-unused-functions . | grep -q "Potentially unused functions: 0"; then
    echo "Clean!"
else
    echo "Has unused functions"
fi
```

### PowerShell Examples

```powershell
# Analyze project
pyan-unused-functions .

# Save to file
pyan-unused-functions . | Out-File analysis.txt

# Count unused
(pyan-unused-functions . | Select-String "^  ").Count

# Filter results
pyan-unused-functions . | Select-String "deprecated"
```

### Batch Processing

**Bash:**
```bash
#!/bin/bash
# Analyze multiple projects
for dir in project1 project2 project3; do
    echo "Analyzing $dir..."
    pyan-unused-functions "./$dir"
    echo "---"
done
```

**PowerShell:**
```powershell
# Analyze multiple projects
$projects = @("project1", "project2", "project3")
foreach ($project in $projects) {
    Write-Host "Analyzing $project..." -ForegroundColor Cyan
    pyan-unused-functions ".\$project"
    Write-Host "---" -ForegroundColor Gray
}
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0    | Success - analysis completed (regardless of findings) |
| 1    | Error - invalid path, no Python files, or parsing error |

**Note**: The tool does NOT exit with error code when unused functions are found. Wrap with custom logic if you need that behavior.

## Filtering Results

### Skip Certain Files

The tool automatically skips:
- Virtual environments (`.venv`, `venv`)
- Cache directories (`__pycache__`, `.pytest_cache`)
- Version control (`.git`)
- Dependencies (`node_modules`)

To analyze only specific directories:
```bash
# Only analyze source code
pyan-unused-functions ./src

# Only analyze specific modules
pyan-unused-functions ./myapp/core
```

### Understanding False Positives

Functions may be flagged but are actually used in these cases:

1. **Dynamic calls**: `getattr(obj, 'function_name')()`
2. **Decorators**: Functions used as decorators
3. **Callbacks**: Framework/library callbacks
4. **Entry points**: CLI commands, setup.py entry points
5. **External imports**: Called from other projects
6. **String references**: `eval()`, `exec()`, `__import__()`

## Common Workflows

### Pre-Commit Check

```bash
#!/bin/bash
# Save as check-before-commit.sh
echo "Checking for unused functions..."
UNUSED=$(pyan-unused-functions . | grep "Potentially unused functions:" | grep -oE '[0-9]+')

if [ "$UNUSED" -gt 0 ]; then
    echo "⚠️  Warning: Found $UNUSED unused functions"
    read -p "Continue with commit? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi
```

### Generate Report

```bash
#!/bin/bash
# Save detailed report
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT="unused_functions_$TIMESTAMP.txt"

{
    echo "Unused Functions Report"
    echo "Generated: $(date)"
    echo "================================"
    echo
    pyan-unused-functions .
} > "$REPORT"

echo "Report saved to: $REPORT"
```

### Compare Over Time

```bash
#!/bin/bash
# Track changes in unused functions count
CURRENT=$(pyan-unused-functions . | grep "Potentially unused functions:" | grep -oE '[0-9]+')
PREVIOUS=$(cat .unused-count 2>/dev/null || echo 0)

echo "$CURRENT" > .unused-count

if [ "$CURRENT" -gt "$PREVIOUS" ]; then
    echo "⚠️  Unused functions increased: $PREVIOUS → $CURRENT"
elif [ "$CURRENT" -lt "$PREVIOUS" ]; then
    echo "✅ Unused functions decreased: $PREVIOUS → $CURRENT"
else
    echo "→ No change: $CURRENT unused functions"
fi
```

## Continuous Integration Examples

### GitLab CI

```yaml
# .gitlab-ci.yml
check-unused-functions:
  stage: test
  image: python:3.11
  script:
    - pip install pyan-unused-functions
    - pyan-unused-functions .
  allow_failure: true
```

### Jenkins

```groovy
// Jenkinsfile
stage('Check Unused Functions') {
    steps {
        sh 'pip install pyan-unused-functions'
        sh 'pyan-unused-functions .'
    }
}
```

### CircleCI

```yaml
# .circleci/config.yml
jobs:
  check-unused:
    docker:
      - image: python:3.11
    steps:
      - checkout
      - run: pip install pyan-unused-functions
      - run: pyan-unused-functions .
```

### Azure Pipelines

```yaml
# azure-pipelines.yml
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.11'

- script: |
    pip install pyan-unused-functions
    pyan-unused-functions .
  displayName: 'Check unused functions'
```

## Troubleshooting

### "No Python files found"
- Verify the path exists and contains `.py` files
- Check you're not in a directory that's automatically skipped

### "Syntax error in file"
- The tool will skip files with syntax errors
- Check the problematic file for Python syntax issues

### "Permission denied"
- Ensure you have read access to the directory
- Check file permissions

### No output / hangs
- Very large codebases may take time
- Check if there are extremely large Python files

## Performance Tips

- Analyze specific subdirectories rather than entire repos
- Skip test directories if not interested: `pyan-unused-functions ./src`
- For very large projects, consider analyzing modules separately

## Getting Help

```bash
# Show help
pyan-unused-functions --help  # (not implemented in v0.1.0)

# Version
python -c "import pyan_unused_functions; print(pyan_unused_functions.__version__)"
```

## Examples

See the [`examples/`](examples/) directory for:
- GitHub Actions workflows
- Git hooks
- CI/CD integrations
- Advanced automation scripts
