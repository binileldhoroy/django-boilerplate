# Installation Guide

## One-Command Installation (Recommended) 🚀

Install and set up a new Django project with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```


### What This Does

The installation script will:
1. ✅ Check prerequisites (Git, Python 3.12+)
2. ✅ Download the latest boilerplate
3. ✅ Prompt for project name and description
4. ✅ Replace all placeholders automatically
5. ✅ Generate secure secret keys
6. ✅ Create .env file with your settings
7. ✅ Initialize Git repository
8. ✅ Optionally create virtual environment
9. ✅ Optionally install dependencies
10. ✅ Optionally run migrations
11. ✅ Optionally create superuser

### Example Usage

```bash
# Run the installer
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash

# Follow the prompts:
# Enter your project name: my_blog
# Enter project description: A personal blog application
# Enter target directory: ./my_blog
# Do you want to create a virtual environment? yes
# Do you want to install dependencies? yes
# Do you want to run database migrations? yes
# Do you want to create a superuser? yes

# Done! Your project is ready
cd my_blog
source venv/bin/activate
python manage.py runserver
```

## Alternative Installation Methods

### Method 1: Using Git Clone

```bash
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project
bash install.sh
```

### Method 2: Download ZIP

1. Download the repository as ZIP from GitHub
2. Extract to your desired location
3. Navigate to the directory and run:
   ```bash
   cd django-boilerplate
   bash install.sh
   ```

### Method 3: Manual Setup

```bash
# Clone the repository
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project

# Remove git history
rm -rf .git

# Create .env file
cp .env.example .env

# Generate secret keys and update .env
python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
# Copy the output and update SECRET_KEY in .env

# Replace placeholders manually
# Find and replace {{ project_name }} with your project name
# Find and replace {{ project_description }} with your description

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run server
python manage.py runserver
```

## Prerequisites

### Required
- **Python 3.12+** - [Download](https://www.python.org/downloads/)
- **Git** - [Download](https://git-scm.com/downloads)

### Optional (for full features)
- **PostgreSQL 15+** - [Download](https://www.postgresql.org/download/)
- **Redis 7+** - [Download](https://redis.io/download)
- **Docker** - [Download](https://www.docker.com/get-started)

## Installation on Different Operating Systems

### Ubuntu/Debian

```bash
# Install prerequisites
sudo apt update
sudo apt install python3.12 python3.12-venv python3-pip git postgresql redis-server

# Run the installer
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```

### macOS

```bash
# Install prerequisites (using Homebrew)
brew install python@3.12 git postgresql redis

# Run the installer
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```

### Windows

```powershell
# Install prerequisites:
# 1. Download and install Python 3.12+ from python.org
# 2. Download and install Git from git-scm.com
# 3. Download and install PostgreSQL from postgresql.org

# Clone the repository
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project

# Create virtual environment
python -m venv venv
venv\Scripts\activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run server
python manage.py runserver
```

## Docker Installation

### Quick Start with Docker

```bash
# Clone the repository
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project

# Update docker-compose.yml (replace {{ project_name }})
sed -i 's/{{ project_name }}/my_project/g' docker-compose.yml

# Create .env file
cp .env.example .env

# Build and run
docker-compose up --build

# In another terminal, run migrations
docker-compose exec web python manage.py migrate

# Create superuser
docker-compose exec web python manage.py createsuperuser
```

Visit: http://localhost:8000

## Verification

After installation, verify everything is working:

```bash
# Activate virtual environment (if not already activated)
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Check Django version
python manage.py --version

# Run checks
python manage.py check

# Run tests
python manage.py test

# Access the application
python manage.py runserver
```

Then visit:
- **Home**: http://localhost:8000
- **Admin**: http://localhost:8000/admin/
- **API Docs**: http://localhost:8000/api/schema/swagger-ui/

## Troubleshooting

### "Command not found: curl"

**Ubuntu/Debian:**
```bash
sudo apt install curl
```

**macOS:**
```bash
brew install curl
```

### "Python version too old"

Install Python 3.12+:
```bash
# Ubuntu/Debian
sudo apt install python3.12

# macOS
brew install python@3.12
```

### "Permission denied" when running install.sh

Make the script executable:
```bash
chmod +x install.sh
./install.sh
```

### "Failed to download boilerplate"

1. Check your internet connection
2. Verify the repository URL is correct
3. If private repo, use git clone with authentication:
   ```bash
   git clone https://github.com/binileldhoroy/django-boilerplate.git
   cd django-boilerplate
   bash install.sh
   ```

### Database connection errors

**Using PostgreSQL:**
```bash
# Make sure PostgreSQL is running
sudo systemctl status postgresql  # Linux
brew services list  # macOS

# Create database
createdb my_project_db
```

**Using SQLite (development):**
Edit `.env` and comment out `DATABASE_URL`. Django will use SQLite by default.

### Port 8000 already in use

```bash
# Use a different port
python manage.py runserver 8001
```

### Module not found errors

```bash
# Ensure virtual environment is activated
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt
```

## Post-Installation

### Configure Your Project

1. **Edit .env file**
   ```bash
   nano .env  # or use your preferred editor
   ```
   Update database credentials, email settings, etc.

2. **Configure Database**
   - For PostgreSQL: Update `DATABASE_URL` in `.env`
   - For SQLite: Comment out `DATABASE_URL` (default)

3. **Set up Email**
   - Update `EMAIL_BACKEND` and related settings in `.env`

4. **Configure Static Files**
   ```bash
   python manage.py collectstatic
   ```

### Development Workflow

```bash
# Start development server
python manage.py runserver

# Create new app
python manage.py startapp myapp apps/myapp

# Make migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run tests
python manage.py test
```

### Using Make Commands

```bash
make install       # Install dependencies
make migrate       # Run migrations
make run           # Run development server
make test          # Run tests
make clean         # Clean Python cache
make docker-up     # Start Docker containers
```

## Getting Help

- 📖 Read the [README.md](README.md)
- 🚀 Check [QUICKSTART.md](QUICKSTART.md)
- 📚 Review [BOILERPLATE_USAGE.md](BOILERPLATE_USAGE.md)
- 🐛 Report issues on GitHub
- 💬 Check Django documentation: https://docs.djangoproject.com/

## Next Steps

After successful installation:

1. ✅ Explore the admin panel
2. ✅ Check API documentation
3. ✅ Create your first app
4. ✅ Customize templates and styles
5. ✅ Add your business logic
6. ✅ Deploy to production

---

**Happy coding! 🚀**
