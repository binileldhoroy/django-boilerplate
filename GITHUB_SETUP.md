# GitHub Repository Setup Guide

This guide will help you upload the Django boilerplate to GitHub and configure the one-command installation.

## Step 1: Create GitHub Repository

### Option A: Private Repository (Recommended for your use case)

1. Go to https://github.com/new
2. Fill in repository details:
   - **Repository name**: `django-boilerplate` (or your preferred name)
   - **Description**: "Production-ready Django boilerplate with one-command setup"
   - **Visibility**: ✅ **Private**
3. **DO NOT** initialize with README, .gitignore, or license (we already have these)
4. Click "Create repository"

### Option B: Public Repository

Same steps as above, but select **Public** visibility.

## Step 2: Update Repository URL

Before pushing, update the repository URL in the installation script:

1. Open `install.sh` in your editor
2. Find this line (around line 107):
   ```bash
   REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO.git"
   ```
3. Replace with your actual repository URL:
   ```bash
   REPO_URL="https://github.com/yourusername/django-boilerplate.git"
   ```
4. Save the file

## Step 3: Push to GitHub

```bash
# Navigate to the boilerplate directory
cd /home/binil/Desktop/django-boilerplate

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Django boilerplate with one-command installer"

# Add remote (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to GitHub
git push -u origin main
```

If you get an error about branch name, try:
```bash
git branch -M main
git push -u origin main
```

## Step 4: Configure for One-Command Installation

### For Private Repository

Since your repository is private, users will need authentication. Here are the options:

#### Option 1: Personal Access Token (Recommended)

1. **Create a Personal Access Token (PAT)**:
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a name: "Django Boilerplate Installer"
   - Select scopes: `repo` (Full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

2. **Update install.sh** to use token:
   ```bash
   # Replace line 107 with:
   REPO_URL="https://YOUR_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git"
   ```

3. **Security Note**: This embeds the token in the script. Only share this with trusted users.

#### Option 2: SSH Key Authentication

Users need to set up SSH keys with GitHub:

```bash
# User runs this command with SSH URL
git clone git@github.com:YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
./create_django_project.sh
```

#### Option 3: Make install.sh Public

1. Create a separate public repository for just the installer
2. Keep the main boilerplate private
3. The installer can prompt for credentials

### For Public Repository

If you make the repository public, the one-command installation works directly:

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

## Step 5: Update Documentation

Update all documentation files with your actual repository URL:

```bash
# Replace in all markdown files
find . -name "*.md" -type f -exec sed -i 's|YOUR_USERNAME/YOUR_REPO|yourusername/django-boilerplate|g' {} +

# Or manually update these files:
# - README.md
# - INSTALLATION.md
# - QUICKSTART.md
# - BOILERPLATE_USAGE.md
```

## Step 6: Test the Installation

Test the one-command installation:

```bash
# In a different directory
cd /tmp

# Test the installer
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash

# Or if private with token:
curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

## Step 7: Create GitHub Releases (Optional)

Create releases for version management:

```bash
# Tag a version
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

Then on GitHub:
1. Go to your repository
2. Click "Releases" → "Create a new release"
3. Select the tag you created
4. Add release notes
5. Publish release

## Recommended Repository Structure

Your GitHub repository should look like this:

```
django-boilerplate/
├── .github/
│   └── workflows/          # CI/CD (optional)
├── apps/
├── config/
├── static/
├── templates/
├── .dockerignore
├── .env.example
├── .gitignore
├── BOILERPLATE_SUMMARY.md
├── BOILERPLATE_USAGE.md
├── CHECKLIST.md
├── CONTRIBUTING.md
├── create_django_project.sh
├── docker-compose.yml
├── Dockerfile
├── GITHUB_SETUP.md         # This file
├── INSTALLATION.md
├── install.sh              # ⭐ One-command installer
├── LICENSE
├── Makefile
├── manage.py
├── pytest.ini
├── QUICKSTART.md
├── README.md
└── requirements.txt
```

## Usage Instructions for End Users

### For Private Repository

**Method 1: With Personal Access Token**
```bash
# You provide this command to users (with your token)
curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

**Method 2: Git Clone with Authentication**
```bash
# Users clone the repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
./create_django_project.sh
```

**Method 3: SSH (Users need SSH keys set up)**
```bash
git clone git@github.com:YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
./create_django_project.sh
```

### For Public Repository

```bash
# Simple one-command installation
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

## Security Best Practices

### For Private Repository

1. **Don't commit sensitive data**
   - Never commit actual `.env` files
   - Use `.env.example` as template
   - Add `.env` to `.gitignore` (already done)

2. **Token Management**
   - Use tokens with minimal required permissions
   - Rotate tokens regularly
   - Don't share tokens publicly
   - Consider using GitHub Apps for better security

3. **Access Control**
   - Only give repository access to trusted users
   - Use GitHub Teams for organization
   - Review access regularly

### For Public Repository

1. **No secrets in code**
   - All secrets in environment variables
   - Use `.env.example` without real values
   - Document required environment variables

2. **Security scanning**
   - Enable Dependabot alerts
   - Use GitHub security scanning
   - Keep dependencies updated

## Alternative: Create a Public Installer Repository

If you want to keep the boilerplate private but make installation easy:

1. **Create two repositories**:
   - `django-boilerplate` (Private) - Main boilerplate
   - `django-boilerplate-installer` (Public) - Just the installer

2. **Public installer repository contains**:
   - `install.sh` - Modified to prompt for credentials
   - `README.md` - Installation instructions
   - Documentation

3. **Modified install.sh**:
   ```bash
   # Prompt for GitHub credentials
   read -p "Enter your GitHub username: " GITHUB_USER
   read -sp "Enter your GitHub token: " GITHUB_TOKEN
   echo ""
   
   REPO_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/YOUR_USERNAME/django-boilerplate.git"
   ```

## Continuous Integration (Optional)

Add GitHub Actions for automated testing:

Create `.github/workflows/tests.yml`:
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      - run: pip install -r requirements.txt
      - run: python manage.py test
```

## Support and Maintenance

1. **Enable GitHub Issues** for bug reports and feature requests
2. **Create templates** for issues and pull requests
3. **Add CONTRIBUTING.md** (already included)
4. **Set up GitHub Discussions** for community support
5. **Add badges** to README.md (build status, version, etc.)

## Quick Reference Commands

```bash
# Clone your repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Update and push changes
git add .
git commit -m "Update description"
git push

# Create and push a tag
git tag -a v1.0.1 -m "Bug fixes"
git push origin v1.0.1

# View remote URL
git remote -v

# Change remote URL
git remote set-url origin https://github.com/NEW_USERNAME/NEW_REPO.git
```

## Troubleshooting

### Authentication Failed

```bash
# Use Personal Access Token instead of password
git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git
```

### Permission Denied (SSH)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
```

### Large Files Warning

```bash
# If you have large files, use Git LFS
git lfs install
git lfs track "*.psd"
git add .gitattributes
```

## Next Steps

1. ✅ Create GitHub repository
2. ✅ Update `install.sh` with your repository URL
3. ✅ Push to GitHub
4. ✅ Update all documentation with your repository URL
5. ✅ Test the installation
6. ✅ Share with your team/users
7. ✅ Set up CI/CD (optional)
8. ✅ Create releases (optional)

---

**Your Django boilerplate is now ready to share! 🎉**

Users can install it with a single command, and you have full control over the repository.
