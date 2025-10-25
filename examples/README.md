# Usage Examples

This directory contains practical examples for using `pyan-unused-functions` in various scenarios.

## 📁 Files

### GitHub Actions Workflows

1. **`github-actions-strict.yml`**
   - Fails the build if any unused functions are found
   - Automatically comments on PRs with results
   - Best for: Enforcing strict code quality standards

2. **`github-actions-scheduled.yml`**
   - Runs weekly automated checks
   - Creates/updates GitHub issues for tracking
   - Uploads reports as artifacts
   - Best for: Regular maintenance and monitoring

3. **`github-actions-multi-project.yml`**
   - Analyzes multiple directories separately
   - Uses matrix strategy for parallel execution
   - Best for: Monorepos or multi-project repositories

### Git Hooks

4. **`pre-commit-hook.sh`**
   - Bash script to run before each commit
   - Warns about unused functions
   - Can be configured to block commits
   - Best for: Local development workflow

## 🚀 Quick Start

### Using GitHub Actions

1. Choose a workflow example that fits your needs
2. Copy it to `.github/workflows/` in your repository
3. Customize the configuration (branches, paths, etc.)
4. Push to trigger the workflow

### Using Pre-commit Hook

```bash
# Copy the hook to your git hooks directory
cp examples/pre-commit-hook.sh .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit

# Test it
git commit -m "test"
```

For Windows (PowerShell):
```powershell
# Copy the hook
Copy-Item examples\pre-commit-hook.sh .git\hooks\pre-commit

# Git Bash will handle execution on Windows
```

## 🎯 Use Case Scenarios

### Scenario 1: Basic CI Check
**Goal**: Get notified about unused functions, but don't block merges

**Solution**: Use the default workflow in `.github/workflows/check-unused-functions.yml`

### Scenario 2: Strict Code Quality
**Goal**: Prevent merging any code with unused functions

**Solution**: Use `github-actions-strict.yml` with branch protection rules

### Scenario 3: Technical Debt Tracking
**Goal**: Monitor unused functions over time and create cleanup tasks

**Solution**: Use `github-actions-scheduled.yml` for weekly reports

### Scenario 4: Monorepo
**Goal**: Analyze different parts of the codebase separately

**Solution**: Use `github-actions-multi-project.yml` with your directory structure

### Scenario 5: Local Development
**Goal**: Catch unused functions before committing

**Solution**: Use `pre-commit-hook.sh` for local validation

## ⚙️ Customization Tips

### Modify Workflow Triggers

```yaml
# Run on specific branches
on:
  push:
    branches: [ main, staging, production ]

# Run on schedule
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday midnight

# Run manually
on:
  workflow_dispatch:
```

### Exclude Specific Directories

Since the tool already skips common directories (`.venv`, `__pycache__`, etc.), you can analyze specific subdirectories:

```yaml
- name: Analyze only source code
  run: pyan-unused-functions ./src
```

### Multiple Python Versions

```yaml
strategy:
  matrix:
    python-version: ['3.8', '3.9', '3.10', '3.11', '3.12']
steps:
  - uses: actions/setup-python@v4
    with:
      python-version: ${{ matrix.python-version }}
```

### Save Results as Artifacts

```yaml
- name: Save analysis results
  run: pyan-unused-functions . > results.txt

- name: Upload results
  uses: actions/upload-artifact@v3
  with:
    name: unused-functions-report
    path: results.txt
    retention-days: 30
```

## 🔗 Integration with Other Tools

### Combine with Coverage Reports

```yaml
- name: Run tests with coverage
  run: pytest --cov

- name: Check unused functions
  run: pyan-unused-functions .

- name: Generate combined report
  run: |
    echo "## Code Quality Report" > report.md
    echo "### Coverage" >> report.md
    coverage report >> report.md
    echo "### Unused Functions" >> report.md
    pyan-unused-functions . >> report.md
```

### Use with pre-commit Framework

Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: check-unused-functions
        name: Check for unused functions
        entry: pyan-unused-functions
        args: ['.']
        language: system
        pass_filenames: false
```

### Integrate with Slack/Teams

```yaml
- name: Notify on Slack
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "⚠️ Unused functions detected in ${{ github.repository }}"
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

## 📊 Best Practices

1. **Start with warnings**: Don't block builds immediately; gather data first
2. **Regular scans**: Use scheduled workflows to track trends
3. **Team awareness**: Comment on PRs to educate the team
4. **Gradual enforcement**: Move from warnings to errors over time
5. **Document exceptions**: Keep a list of intentionally unused functions (if any)
6. **Review before removing**: Always manually verify before deleting code

## 🆘 Troubleshooting

### Workflow not running?
- Check branch names in `on:` triggers
- Verify workflow file is in `.github/workflows/`
- Check repository Actions settings are enabled

### Too many false positives?
- Review the "Limitations" section in README.md
- Functions used dynamically may be flagged
- Framework callbacks might be flagged

### Want to exclude specific functions?
- Current version doesn't support exclusion lists
- Consider analyzing specific directories only
- Filter output using grep/custom scripts

## 📝 Contributing Examples

Have a useful workflow or integration? Contribute it!

1. Fork the repository
2. Add your example to this directory
3. Update this README with description
4. Submit a pull request

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Pre-commit Framework](https://pre-commit.com/)
- [Python Packaging Guide](https://packaging.python.org/)
