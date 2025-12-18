# Deployment Guide - GitHub & One-Command Installation

## 📋 Overview

This guide provides step-by-step instructions to:
1. Upload the Django boilerplate to GitHub (private repository)
2. Configure one-command installation
3. Share with users

## 🎯 Your Use Case

You want to:
- ✅ Keep the boilerplate in a **private GitHub repository**
- ✅ Provide a **single command** for users to download and set up projects
- ✅ Users run one command → project is created on their local machine

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `django-boilerplate`
3. Visibility: **Private** ✅
4. Click "Create repository"

### Step 2: Update install.sh

Open `install.sh` and update line 107:

```bash
# Change this:
REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO.git"

# To your actual repository:
REPO_URL="https://github.com/yourusername/django-boilerplate.git"
```

### Step 3: Push to GitHub

```bash
cd /home/binil/Desktop/django-boilerplate

# Initialize git
git init
git add .
git commit -m "Initial commit: Django boilerplate"

# Add remote (replace with your URL)
git remote add origin https://github.com/yourusername/django-boilerplate.git

# Push
git branch -M main
git push -u origin main
```

### Step 4: Create Personal Access Token

Since your repository is private, create a token:

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Name: "Django Boilerplate Installer"
4. Select scope: `repo` (Full control of private repositories)
5. Click "Generate token"
6. **Copy the token** (starts with `ghp_...`)

### Step 5: Share with Users

Provide this command to your users:

```bash
curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/yourusername/django-boilerplate/main/install.sh | bash
```

Replace:
- `YOUR_TOKEN` with the token you created
- `yourusername` with your GitHub username

## 📝 Example

If your GitHub username is `binil` and your token is `ghp_abc123xyz`:

```bash
curl -sSL https://ghp_abc123xyz@raw.githubusercontent.com/binil/django-boilerplate/main/install.sh | bash
```

## 🔒 Security Considerations

### Option 1: Embed Token in Command (Simple)

**Pros:**
- ✅ One command for users
- ✅ No additional setup needed

**Cons:**
- ⚠️ Token is visible in the command
- ⚠️ Anyone with the command can access your repository

**Best for:** Small teams, trusted users

### Option 2: Users Provide Their Own Credentials

Update `install.sh` to prompt for credentials:

```bash
# Add after line 90 in install.sh:
echo ""
print_info "This repository is private. Please provide your GitHub credentials."
read -p "GitHub username: " GITHUB_USER
read -sp "GitHub token: " GITHUB_TOKEN
echo ""

REPO_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/yourusername/django-boilerplate.git"
```

Then users run:
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/django-boilerplate/main/install.sh | bash
```

**Pros:**
- ✅ More secure
- ✅ Each user uses their own credentials

**Cons:**
- ⚠️ Users need GitHub access
- ⚠️ More setup for users

**Best for:** Larger teams, organization-wide use

### Option 3: Git Clone Method

Users clone the repository directly:

```bash
# User clones with their credentials
git clone https://github.com/yourusername/django-boilerplate.git my_project
cd my_project
./create_django_project.sh
```

**Pros:**
- ✅ Standard Git workflow
- ✅ Users manage their own authentication

**Cons:**
- ⚠️ Not a single command
- ⚠️ Users need Git knowledge

**Best for:** Developer teams

## 📦 Complete Workflow Example

### For Repository Owner (You)

```bash
# 1. Navigate to boilerplate
cd /home/binil/Desktop/django-boilerplate

# 2. Update install.sh with your repository URL
nano install.sh  # Update line 107

# 3. Initialize and push to GitHub
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/django-boilerplate.git
git push -u origin main

# 4. Create Personal Access Token on GitHub
# (Follow Step 4 above)

# 5. Share command with users
echo "curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/yourusername/django-boilerplate/main/install.sh | bash"
```

### For End Users

```bash
# User receives this command from you
curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/yourusername/django-boilerplate/main/install.sh | bash

# Installer prompts:
# Enter your project name: my_blog
# Enter project description: A personal blog
# Enter target directory: ./my_blog
# Create virtual environment? yes
# Install dependencies? yes
# Run migrations? yes
# Create superuser? yes

# Done! Project is ready
cd my_blog
source venv/bin/activate
python manage.py runserver
```

## 🔄 Updating the Boilerplate

When you make changes:

```bash
cd /home/binil/Desktop/django-boilerplate

# Make your changes
# ... edit files ...

# Commit and push
git add .
git commit -m "Update: description of changes"
git push

# Users will automatically get the latest version
```

## 📊 Comparison of Methods

| Method | Security | Ease of Use | Best For |
|--------|----------|-------------|----------|
| **Embedded Token** | ⚠️ Medium | ✅ Very Easy | Small teams |
| **User Credentials** | ✅ High | ⚠️ Medium | Large teams |
| **Git Clone** | ✅ High | ⚠️ Medium | Developers |

## 🎯 Recommended Approach

For your use case (private repo, single command), I recommend:

### Approach A: For Small Team (2-10 people)

Use embedded token method:

```bash
# Share this with your team
curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/yourusername/django-boilerplate/main/install.sh | bash
```

**Setup time:** 5 minutes  
**User experience:** Excellent (one command)  
**Security:** Good (token has limited scope)

### Approach B: For Larger Team (10+ people)

Modify `install.sh` to prompt for credentials:

1. Update `install.sh` (see Option 2 above)
2. Give team members repository access
3. Share the command (without token)

**Setup time:** 10 minutes  
**User experience:** Good (one command + credentials)  
**Security:** Excellent (each user uses own credentials)

## 🛠️ Troubleshooting

### "Failed to download boilerplate"

**Solution 1:** Check token has `repo` scope  
**Solution 2:** Verify repository URL is correct  
**Solution 3:** Test token:
```bash
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
```

### "Permission denied"

**Solution:** User needs access to the repository  
Add them as collaborator: Repository Settings → Collaborators → Add people

### "Token expired"

**Solution:** Generate new token and update the command

## 📚 Additional Resources

- [GITHUB_SETUP.md](GITHUB_SETUP.md) - Detailed GitHub setup
- [INSTALLATION.md](INSTALLATION.md) - All installation methods
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [BOILERPLATE_USAGE.md](BOILERPLATE_USAGE.md) - Usage documentation

## ✅ Checklist

Before sharing with users:

- [ ] Repository created on GitHub (private)
- [ ] `install.sh` updated with your repository URL
- [ ] Code pushed to GitHub
- [ ] Personal Access Token created
- [ ] Token tested with curl command
- [ ] Installation command prepared
- [ ] Documentation updated with your repository details
- [ ] Tested installation on clean machine

## 🎉 You're Ready!

Your Django boilerplate is now:
- ✅ Hosted on GitHub (private)
- ✅ Installable with one command
- ✅ Ready to share with your team

Share this command with your users:

```bash
curl -sSL https://YOUR_TOKEN@raw.githubusercontent.com/YOUR_USERNAME/django-boilerplate/main/install.sh | bash
```

---

**Need help?** Check [GITHUB_SETUP.md](GITHUB_SETUP.md) for detailed instructions.
