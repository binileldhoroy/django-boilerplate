#!/bin/bash

# Django Project Setup Script
# This script creates a new Django project from the boilerplate

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

# Function to generate a random secret key
generate_secret_key() {
    python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
}

# Welcome message
echo ""
echo "================================================"
echo "  Django Project Setup Script"
echo "================================================"
echo ""

# Get project name
read -p "Enter your project name (e.g., my_awesome_project): " PROJECT_NAME

# Validate project name
if [[ -z "$PROJECT_NAME" ]]; then
    print_error "Project name cannot be empty!"
    exit 1
fi

# Convert to lowercase and replace spaces with underscores
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr '-' '_')

# Check if project name is valid Python identifier
if ! [[ "$PROJECT_NAME" =~ ^[a-z_][a-z0-9_]*$ ]]; then
    print_error "Invalid project name. Use only lowercase letters, numbers, and underscores. Must start with a letter or underscore."
    exit 1
fi

print_info "Project name: $PROJECT_NAME"

# Get project description
read -p "Enter project description (optional): " PROJECT_DESCRIPTION
if [[ -z "$PROJECT_DESCRIPTION" ]]; then
    PROJECT_DESCRIPTION="A Django project"
fi

# Get target directory
read -p "Enter target directory (default: ./$PROJECT_NAME): " TARGET_DIR
if [[ -z "$TARGET_DIR" ]]; then
    TARGET_DIR="./$PROJECT_NAME"
fi

# Check if target directory already exists
if [[ -d "$TARGET_DIR" ]]; then
    print_error "Directory $TARGET_DIR already exists!"
    read -p "Do you want to remove it and continue? (yes/no): " REMOVE_DIR
    if [[ "$REMOVE_DIR" == "yes" ]]; then
        rm -rf "$TARGET_DIR"
        print_warning "Removed existing directory"
    else
        print_error "Aborting..."
        exit 1
    fi
fi

# Get the directory where this script is located (boilerplate directory)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_info "Copying boilerplate to $TARGET_DIR..."

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy all files except the setup script itself
rsync -av --progress "$SCRIPT_DIR/" "$TARGET_DIR/" \
    --include 'README.md' \
    --exclude '*.md' \
    --exclude 'create_django_project.sh' \
    --exclude 'install.sh' \
    --exclude '.git' \
    --exclude '__pycache__' \
    --exclude '*.pyc' \
    --exclude 'venv' \
    --exclude 'env' \
    --exclude '.env' \
    --exclude 'db.sqlite3' \
    --exclude 'media' \
    --exclude 'static_root'

print_success "Files copied successfully"

# Replace placeholders in files
print_info "Replacing placeholders..."

# Generate secret keys
SECRET_KEY=$(generate_secret_key)
JWT_SIGNING_KEY=$(generate_secret_key)

# Rename config/ to the project name
if [[ -d "$TARGET_DIR/config" ]]; then
    mv "$TARGET_DIR/config" "$TARGET_DIR/$PROJECT_NAME"
fi

# Files to process
FILES_TO_PROCESS=(
    "$PROJECT_NAME/settings.py"
    "$PROJECT_NAME/urls.py"
    "$PROJECT_NAME/wsgi.py"
    "$PROJECT_NAME/asgi.py"
    "$PROJECT_NAME/celery.py"
    "manage.py"
    ".env.example"
    "docker-compose.yml"
    "README.md"
    "templates/base.html"
    "templates/web/home.html"
)

# Replace placeholders in each file
for file in "${FILES_TO_PROCESS[@]}"; do
    if [[ -f "$TARGET_DIR/$file" ]]; then
        print_info "Processing $file..."
        
        # Use sed to replace placeholders
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/{{ project_name }}/$PROJECT_NAME/g" "$TARGET_DIR/$file"
            sed -i '' "s/{{ project_description }}/$PROJECT_DESCRIPTION/g" "$TARGET_DIR/$file"
        else
            # Linux
            sed -i "s/{{ project_name }}/$PROJECT_NAME/g" "$TARGET_DIR/$file"
            sed -i "s/{{ project_description }}/$PROJECT_DESCRIPTION/g" "$TARGET_DIR/$file"
        fi
    fi
done

# Create .env file from .env.example
print_info "Creating .env file..."
cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"

# Replace secret keys in .env
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/your-secret-key-here-change-in-production/$SECRET_KEY/g" "$TARGET_DIR/.env"
    sed -i '' "s/your-jwt-signing-key-change-in-production/$JWT_SIGNING_KEY/g" "$TARGET_DIR/.env"
else
    sed -i "s/your-secret-key-here-change-in-production/$SECRET_KEY/g" "$TARGET_DIR/.env"
    sed -i "s/your-jwt-signing-key-change-in-production/$JWT_SIGNING_KEY/g" "$TARGET_DIR/.env"
fi

print_success "Placeholders replaced"

# Initialize Git repository
print_info "Initializing Git repository..."
cd "$TARGET_DIR"
git init
git add .
git commit -m "Initial commit from Django boilerplate"
print_success "Git repository initialized"

# Ask if user wants to create virtual environment
read -p "Do you want to create a virtual environment? (yes/no): " CREATE_VENV
if [[ "$CREATE_VENV" == "yes" ]]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created"
    
    # Ask if user wants to install dependencies
    read -p "Do you want to install dependencies? (yes/no): " INSTALL_DEPS
    if [[ "$INSTALL_DEPS" == "yes" ]]; then
        print_info "Installing dependencies..."
        source venv/bin/activate
        pip install --upgrade pip
        pip install -r requirements.txt
        print_success "Dependencies installed"
        
        # Ask if user wants to run migrations
        read -p "Do you want to run migrations? (yes/no): " RUN_MIGRATIONS
        if [[ "$RUN_MIGRATIONS" == "yes" ]]; then
            print_info "Running migrations..."
            python manage.py migrate
            print_success "Migrations completed"
            
            # Ask if user wants to create superuser
            read -p "Do you want to create a superuser? (yes/no): " CREATE_SUPERUSER
            if [[ "$CREATE_SUPERUSER" == "yes" ]]; then
                print_info "Creating superuser..."
                python manage.py createsuperuser
            fi
        fi
    fi
fi

# Final instructions
echo ""
echo "================================================"
print_success "Project setup complete!"
echo "================================================"
echo ""
print_info "Project location: $TARGET_DIR"
echo ""
print_info "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. source venv/bin/activate  (if you created a virtual environment)"
echo "  3. Edit .env file with your configuration"
echo "  4. python manage.py runserver"
echo ""
print_info "Or use Docker:"
echo "  1. cd $TARGET_DIR"
echo "  2. docker-compose up --build"
echo ""
print_info "Access your application at: http://localhost:8000"
print_info "Admin panel: http://localhost:8000/admin/"
print_info "API docs: http://localhost:8000/api/schema/swagger-ui/"
echo ""
print_success "Happy coding! 🚀"
echo ""
