# Deployment Guide - GitHub & One-Command Installation

## Overview

This guide explains how the one-command installer works and how to share it.

The repository is hosted at: `https://github.com/binileldhoroy/django-boilerplate`

## One-Command Installation

Anyone can install a new Django project with:

```bash
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```

The installer will:
1. Check prerequisites (Git, Python 3.12+)
2. Prompt for project name and description
3. Clone the boilerplate and copy files to the target directory
4. Replace all placeholders automatically
5. Generate secure secret keys
6. Create `.env` file
7. Initialize a Git repository
8. Optionally create virtual environment, install dependencies, run migrations, create superuser

## How It Works

```
User runs curl command
        ↓
install.sh downloads and executes
        ↓
Prompts user for project details (reads from /dev/tty)
        ↓
Clones https://github.com/binileldhoroy/django-boilerplate.git
        ↓
Copies files to target directory
        ↓
Replaces {{ project_name }} placeholders
        ↓
Generates SECRET_KEY and JWT_SIGNING_KEY
        ↓
Project is ready
```

## Updating the Boilerplate

When you make changes to the boilerplate:

```bash
cd ~/Documents/django-boilerplate

# Make your changes
# ... edit files ...

# Commit and push
git add .
git commit -m "Update: description of changes"
git push

# Users will automatically get the latest version next time they run the installer
```

## For Private Repository

If you switch the repository to private, users will need authentication.

### Option 1: Personal Access Token embedded in command

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a token with `repo` scope
3. Share this command with your users:

```bash
curl -fsSL https://YOUR_TOKEN@raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```

### Option 2: Users provide their own credentials

Update `install.sh` to prompt for credentials before cloning:

```bash
print_info "This repository is private. Please provide your GitHub credentials."
read -p "GitHub username: " GITHUB_USER </dev/tty
read -sp "GitHub token: " GITHUB_TOKEN </dev/tty
echo ""

REPO_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/binileldhoroy/django-boilerplate.git"
```

### Option 3: Git Clone Method

Users clone the repository directly:

```bash
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project
bash install.sh
```

## Troubleshooting

### "Failed to download boilerplate"

- Check internet connection
- Verify the repository is public (or token has `repo` scope if private)
- Test access: `curl -I https://github.com/binileldhoroy/django-boilerplate`

### "Permission denied"

For private repos, add the user as a collaborator: Repository Settings → Collaborators → Add people

### "Token expired"

Generate a new Personal Access Token and update the command.

## Comparison of Methods

| Method | Security | Ease of Use | Best For |
|--------|----------|-------------|----------|
| **Public repo (current)** | ✅ High | ✅ Very Easy | Open source / teams |
| **Embedded Token** | ⚠️ Medium | ✅ Very Easy | Small private teams |
| **User Credentials** | ✅ High | ⚠️ Medium | Large private teams |
| **Git Clone** | ✅ High | ⚠️ Medium | Developer teams |

## Additional Resources

- [GITHUB_SETUP.md](GITHUB_SETUP.md) - GitHub repository setup
- [INSTALLATION.md](INSTALLATION.md) - All installation methods
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [BOILERPLATE_USAGE.md](BOILERPLATE_USAGE.md) - Usage documentation

---

**Share this command with your users:**

```bash
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```
