#!/bin/bash

# Django Boilerplate - One-Command Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo ""
echo "================================================"
echo "  Django Boilerplate - One-Command Installer"
echo "================================================"
echo ""

# Check prerequisites
print_info "Checking prerequisites..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed. Please install Python 3.12+ first."
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
REQUIRED_VERSION="3.12"
if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    print_warning "Python version $PYTHON_VERSION detected. Python 3.12+ is recommended."
fi

print_success "Prerequisites check passed!"

# Get project details
echo ""
print_info "Let's set up your Django project!"
echo ""

# Project name
while true; do
    read -p "Enter your project name (e.g., my_awesome_app): " PROJECT_NAME </dev/tty
    
    # Validate project name
    if [[ -z "$PROJECT_NAME" ]]; then
        print_error "Project name cannot be empty!"
        continue
    fi
    
    # Convert to lowercase and replace spaces/hyphens with underscores
    PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr '-' '_')
    
    # Check if valid Python identifier
    if ! [[ "$PROJECT_NAME" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        print_error "Invalid project name. Use only lowercase letters, numbers, and underscores. Must start with a letter or underscore."
        continue
    fi
    
    break
done

# Project description
read -p "Enter project description (optional, press Enter to skip): " PROJECT_DESCRIPTION </dev/tty
if [[ -z "$PROJECT_DESCRIPTION" ]]; then
    PROJECT_DESCRIPTION="A Django project built with Django Boilerplate"
fi

# Target directory
read -p "Enter target directory (default: ./$PROJECT_NAME): " TARGET_DIR </dev/tty
if [[ -z "$TARGET_DIR" ]]; then
    TARGET_DIR="./$PROJECT_NAME"
fi

# Check if directory exists
if [[ -d "$TARGET_DIR" ]]; then
    print_warning "Directory $TARGET_DIR already exists!"
    read -p "Do you want to remove it and continue? (yes/no): " REMOVE_DIR </dev/tty
    if [[ "$REMOVE_DIR" == "yes" ]]; then
        rm -rf "$TARGET_DIR"
        print_info "Removed existing directory"
    else
        print_error "Installation cancelled."
        exit 1
    fi
fi

# GitHub repository URL
REPO_URL="https://github.com/binileldhoroy/django-boilerplate.git"
TEMP_DIR=$(mktemp -d)

print_info "Downloading Django boilerplate..."

# Clone the repository to temp directory
if git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    print_success "Boilerplate downloaded successfully!"
else
    print_error "Failed to download boilerplate. Please check your internet connection."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy files (exclude .git, install.sh, and documentation that's not needed)
print_info "Setting up project structure..."

rsync -av --progress "$TEMP_DIR/" "$TARGET_DIR/" \
    --exclude '.git' \
    --exclude 'install.sh' \
    --exclude '__pycache__' \
    --exclude '*.pyc' \
    --exclude 'venv' \
    --exclude 'env' \
    --exclude '.env' \
    --exclude 'db.sqlite3' \
    --exclude 'media' \
    --exclude 'static_root' \
    > /dev/null 2>&1

# Clean up temp directory
rm -rf "$TEMP_DIR"

print_success "Project structure created!"

# Navigate to project directory
cd "$TARGET_DIR"

# Replace placeholders
print_info "Configuring project..."

# Generate secret keys
print_info "Generating secure secret keys..."
SECRET_KEY=$(python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
JWT_SIGNING_KEY=$(python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")

# Files to process
FILES_TO_PROCESS=(
    "config/settings.py"
    "config/urls.py"
    "config/wsgi.py"
    "config/asgi.py"
    "config/celery.py"
    "manage.py"
    ".env.example"
    "docker-compose.yml"
    "README.md"
    "templates/base.html"
    "templates/web/home.html"
    "static/css/style.css"
    "static/js/main.js"
)

# Replace placeholders in each file
for file in "${FILES_TO_PROCESS[@]}"; do
    if [[ -f "$file" ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/{{ project_name }}/$PROJECT_NAME/g" "$file"
            sed -i '' "s/{{ project_description }}/$PROJECT_DESCRIPTION/g" "$file"
        else
            # Linux
            sed -i "s/{{ project_name }}/$PROJECT_NAME/g" "$file"
            sed -i "s/{{ project_description }}/$PROJECT_DESCRIPTION/g" "$file"
        fi
    fi
done

# Create .env file from .env.example
print_info "Creating .env file..."
cp .env.example .env

# Replace secret keys in .env
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/your-secret-key-here-change-in-production/$SECRET_KEY/g" .env
    sed -i '' "s/your-jwt-signing-key-change-in-production/$JWT_SIGNING_KEY/g" .env
else
    sed -i "s/your-secret-key-here-change-in-production/$SECRET_KEY/g" .env
    sed -i "s/your-jwt-signing-key-change-in-production/$JWT_SIGNING_KEY/g" .env
fi

print_success "Configuration complete!"

# Initialize Git repository
print_info "Initializing Git repository..."
git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "Initial commit from Django Boilerplate" > /dev/null 2>&1
print_success "Git repository initialized!"

# Ask about virtual environment
echo ""
read -p "Do you want to create a virtual environment? (yes/no): " CREATE_VENV </dev/tty

if [[ "$CREATE_VENV" == "yes" ]]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created!"
    
    # Ask about installing dependencies
    read -p "Do you want to install dependencies? (yes/no): " INSTALL_DEPS </dev/tty
    
    if [[ "$INSTALL_DEPS" == "yes" ]]; then
        print_info "Installing dependencies... (this may take a few minutes)"
        
        # Activate virtual environment and install
        source venv/bin/activate
        pip install --upgrade pip > /dev/null 2>&1
        pip install -r requirements.txt
        
        print_success "Dependencies installed!"
        
        # Ask about running migrations
        read -p "Do you want to run database migrations? (yes/no): " RUN_MIGRATIONS </dev/tty
        
        if [[ "$RUN_MIGRATIONS" == "yes" ]]; then
            print_info "Running migrations..."
            python manage.py migrate
            print_success "Migrations completed!"
            
            # Ask about creating superuser
            read -p "Do you want to create a superuser? (yes/no): " CREATE_SUPERUSER </dev/tty
            
            if [[ "$CREATE_SUPERUSER" == "yes" ]]; then
                echo ""
                print_info "Creating superuser..."
                python manage.py createsuperuser
            fi
        fi
    fi
fi

# Final instructions
echo ""
echo "================================================"
print_success "🎉 Project setup complete!"
echo "================================================"
echo ""
print_info "Project location: $(pwd)"
echo ""
print_info "Next steps:"
echo ""
echo "  1. Navigate to your project:"
echo "     cd $TARGET_DIR"
echo ""

if [[ "$CREATE_VENV" == "yes" ]]; then
    echo "  2. Activate virtual environment:"
    echo "     source venv/bin/activate"
    echo ""
    echo "  3. Edit .env file with your configuration"
    echo ""
    echo "  4. Run the development server:"
    echo "     python manage.py runserver"
else
    echo "  2. Create and activate virtual environment:"
    echo "     python3 -m venv venv"
    echo "     source venv/bin/activate"
    echo ""
    echo "  3. Install dependencies:"
    echo "     pip install -r requirements.txt"
    echo ""
    echo "  4. Edit .env file with your configuration"
    echo ""
    echo "  5. Run migrations:"
    echo "     python manage.py migrate"
    echo ""
    echo "  6. Create superuser:"
    echo "     python manage.py createsuperuser"
    echo ""
    echo "  7. Run the development server:"
    echo "     python manage.py runserver"
fi

echo ""
print_info "Or use Docker:"
echo "  docker-compose up --build"
echo ""
print_info "Access your application:"
echo "  • Web: http://localhost:8000"
echo "  • Admin: http://localhost:8000/admin/"
echo "  • API Docs: http://localhost:8000/api/schema/swagger-ui/"
echo ""
print_success "Happy coding! 🚀"
echo ""
