# Publishing Guide

This guide will help you publish `pyan-unused-functions` to PyPI.

## Prerequisites

1. Create accounts:
   - [PyPI](https://pypi.org/account/register/) (production)
   - [TestPyPI](https://test.pypi.org/account/register/) (testing)

2. Install required tools:
```bash
pip install build twine
```

3. Note: This package requires `pyan3==1.1.1` which will be automatically installed when users install your package.

## Configuration

### Update Package Information

Before publishing, update the following files with your information:

1. **`pyproject.toml`** and **`setup.py`**:
   - Replace `"Your Name"` with your name
   - Replace `"your.email@example.com"` with your email
   - Update the GitHub URLs with your username/repository

2. **`pyan_unused_functions/__init__.py`**:
   - Update `__author__` with your name

3. **`LICENSE`**:
   - Replace `Your Name` with your name

4. **`README.md`**:
   - Update author section at the bottom

## Building the Package

1. Clean previous builds:
```bash
Remove-Item -Recurse -Force dist, build, *.egg-info -ErrorAction SilentlyContinue
```

2. Build the package:
```bash
python -m build
```

This creates:
- `dist/pyan_unused_functions-0.1.0-py3-none-any.whl` (wheel distribution)
- `dist/pyan-unused-functions-0.1.0.tar.gz` (source distribution)

## Testing Locally

Install locally to test:
```bash
pip install -e .
```

Test the CLI:
```bash
pyan-unused-functions .
```

## Publishing to TestPyPI (Recommended First)

1. Upload to TestPyPI:
```bash
python -m twine upload --repository testpypi dist/*
```

2. Enter your TestPyPI credentials when prompted

3. Test installation from TestPyPI:
```bash
pip install --index-url https://test.pypi.org/simple/ pyan-unused-functions
```

## Publishing to PyPI (Production)

⚠️ **Warning**: You can't re-upload the same version. Make sure everything is correct!

1. Upload to PyPI:
```bash
python -m twine upload dist/*
```

2. Enter your PyPI credentials when prompted

3. Your package is now live at: `https://pypi.org/project/pyan-unused-functions/`

## Install Your Published Package

Anyone can now install it:
```bash
pip install pyan-unused-functions
```

## Using API Tokens (Recommended)

For security, use API tokens instead of passwords:

1. Generate token on PyPI/TestPyPI:
   - Go to Account Settings → API tokens
   - Create a token for this project

2. Create `~/.pypirc`:
```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-your-api-token-here

[testpypi]
username = __token__
password = pypi-your-test-api-token-here
```

3. Now you can upload without entering credentials:
```bash
python -m twine upload --repository testpypi dist/*
python -m twine upload dist/*
```

## Version Bumping

When releasing a new version:

1. Update version in:
   - `pyproject.toml`
   - `setup.py`
   - `pyan_unused_functions/__init__.py`

2. Update `README.md` changelog

3. Commit changes:
```bash
git add .
git commit -m "Bump version to X.Y.Z"
git tag vX.Y.Z
git push origin main --tags
```

4. Rebuild and republish:
```bash
Remove-Item -Recurse -Force dist, build, *.egg-info -ErrorAction SilentlyContinue
python -m build
python -m twine upload dist/*
```

## Common Issues

### "File already exists"
- You can't re-upload the same version
- Bump the version number and rebuild

### "Invalid credentials"
- Use API tokens instead of passwords
- Check your `~/.pypirc` configuration

### "Package name already taken"
- Choose a different package name
- Update `name` in `pyproject.toml` and `setup.py`

## Automation with GitHub Actions

Consider setting up GitHub Actions for automatic publishing on release. Create `.github/workflows/publish.yml`:

```yaml
name: Publish to PyPI

on:
  release:
    types: [created]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.x'
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build twine
    - name: Build package
      run: python -m build
    - name: Publish to PyPI
      env:
        TWINE_USERNAME: __token__
        TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
      run: twine upload dist/*
```

Add your PyPI API token as a GitHub secret named `PYPI_API_TOKEN`.

## Resources

- [Python Packaging Guide](https://packaging.python.org/)
- [PyPI Help](https://pypi.org/help/)
- [Twine Documentation](https://twine.readthedocs.io/)
