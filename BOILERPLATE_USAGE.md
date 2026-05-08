# Django Boilerplate Usage Guide

This guide explains how to use this Django boilerplate to create new projects.

## Quick Start

### Method 1: One-Command Installer (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash
```

The installer will:
1. Prompt for project name and description
2. Copy all boilerplate files to a new directory
3. Replace all placeholders with your project name
4. Generate secure secret keys
5. Initialize a Git repository
6. Optionally create a virtual environment
7. Optionally install dependencies and run migrations

### Method 2: Manual Setup

```bash
# Clone the boilerplate
git clone https://github.com/binileldhoroy/django-boilerplate.git my_new_project
cd my_new_project

# Manually replace placeholders
# Find and replace {{ project_name }} with your project name
# Find and replace {{ project_description }} with your description

# Create .env file
cp .env.example .env
# Edit .env and set SECRET_KEY and other variables

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run server
python manage.py runserver
```

## What's Included

### Core Structure

- **config/** - Project configuration (replaces traditional project folder)
  - `settings.py` - Environment-driven settings
  - `urls.py` - URL configuration
  - `wsgi.py` - WSGI configuration
  - `asgi.py` - ASGI configuration
  - `celery.py` - Celery configuration

- **apps/** - Django applications
  - `users/` - Custom user model and authentication
  - `web/` - Web interface and views

- **templates/** - HTML templates
- **static/** - Static files (CSS, JS, images)
- **media/** - User-uploaded files (created automatically)

### Features

✅ **Django 5.0+** - Latest stable version
✅ **Custom User Model** - Email-based authentication
✅ **Django REST Framework** - API development
✅ **JWT Authentication** - Token-based auth
✅ **Django Allauth** - Social authentication ready
✅ **Celery** - Asynchronous task processing
✅ **Redis** - Caching and message broker
✅ **PostgreSQL** - Production database
✅ **Docker Support** - Containerized deployment
✅ **Environment Variables** - Secure configuration
✅ **API Documentation** - Swagger/ReDoc
✅ **Health Checks** - Monitoring endpoints

### Configuration Files

- `.env.example` - Environment variables template
- `.gitignore` - Git ignore rules
- `Dockerfile` - Docker configuration
- `docker-compose.yml` - Multi-container setup
- `requirements.txt` - Python dependencies
- `Makefile` - Common commands
- `pytest.ini` - Testing configuration

## Customization Guide

### 1. Adding New Apps

```bash
# Create new app
python manage.py startapp myapp apps/myapp

# Add to INSTALLED_APPS in config/settings.py
PROJECT_APPS = [
    "apps.users.apps.UserConfig",
    "apps.web",
    "apps.myapp",  # Add your app
]
```

### 2. Configuring Database

Edit `.env`:
```bash
# Option 1: DATABASE_URL
DATABASE_URL='postgresql://user:password@host:port/dbname'

# Option 2: Individual settings
DJANGO_DATABASE_NAME=mydb
DJANGO_DATABASE_USER=myuser
DJANGO_DATABASE_PASSWORD=mypassword
DJANGO_DATABASE_HOST=localhost
DJANGO_DATABASE_PORT=5432
```

### 3. Setting Up Email

Edit `.env`:
```bash
# Development (console)
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend

# Production (SMTP)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-password
DEFAULT_FROM_EMAIL=noreply@yourdomain.com
```

### 4. Enabling Social Authentication

1. Add provider credentials to `.env`:
```bash
# Google OAuth
SOCIALACCOUNT_PROVIDERS_GOOGLE_CLIENT_ID=your-client-id
SOCIALACCOUNT_PROVIDERS_GOOGLE_SECRET=your-secret
```

2. Add provider to `config/settings.py`:
```python
THIRD_PARTY_APPS = [
    # ... existing apps
    "allauth.socialaccount.providers.google",
]

SOCIALACCOUNT_PROVIDERS = {
    "google": {
        "SCOPE": ["profile", "email"],
        "AUTH_PARAMS": {"access_type": "online"},
    }
}
```

### 5. Configuring AWS S3

Edit `.env`:
```bash
USE_S3_MEDIA=True
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_STORAGE_BUCKET_NAME=your-bucket
AWS_S3_REGION_NAME=us-east-1
```

### 6. Adding Celery Tasks

Create `apps/myapp/tasks.py`:
```python
from celery import shared_task

@shared_task
def my_task(param):
    # Your task logic
    return result
```

Use in views:
```python
from apps.myapp.tasks import my_task

# Async execution
my_task.delay(param)
```

## Development Workflow

### Daily Development

```bash
# Activate virtual environment
source venv/bin/activate

# Run development server
make run

# Or with Docker
make docker-up
```

### Database Changes

```bash
# Create migrations
make makemigrations

# Apply migrations
make migrate
```

### Running Tests

```bash
# Run all tests
make test

# Run specific app tests
python manage.py test apps.users
```

### Celery Tasks

```bash
# Terminal 1: Run Celery worker
make celery-worker

# Terminal 2: Run Celery beat (scheduled tasks)
make celery-beat
```

## Deployment

### Production Checklist

1. **Environment Variables**
   - Set `DEBUG=False`
   - Configure `ALLOWED_HOSTS`
   - Set strong `SECRET_KEY` and `SIMPLE_JWT_SIGNING_KEY`
   - Configure production database
   - Set `USE_HTTPS_IN_ABSOLUTE_URLS=True`

2. **Static Files**
   ```bash
   python manage.py collectstatic
   ```

3. **Database**
   ```bash
   python manage.py migrate
   ```

4. **Security**
   - Enable HTTPS
   - Configure CSRF_TRUSTED_ORIGINS
   - Set up firewall rules
   - Configure backup strategy

5. **Monitoring**
   - Set up Sentry (add SENTRY_DSN to .env)
   - Configure logging
   - Set up health check monitoring

### Docker Deployment

```bash
# Build and run
docker-compose -f docker-compose.prod.yml up --build -d

# Run migrations
docker-compose exec web python manage.py migrate

# Collect static files
docker-compose exec web python manage.py collectstatic --noinput

# Create superuser
docker-compose exec web python manage.py createsuperuser
```

## Troubleshooting

### Common Issues

**Issue: ModuleNotFoundError**
```bash
# Solution: Ensure virtual environment is activated
source venv/bin/activate
pip install -r requirements.txt
```

**Issue: Database connection error**
```bash
# Solution: Check PostgreSQL is running
sudo systemctl status postgresql
# Or with Docker
docker-compose ps
```

**Issue: Static files not loading**
```bash
# Solution: Collect static files
python manage.py collectstatic
```

**Issue: Celery tasks not running**
```bash
# Solution: Ensure Redis is running
redis-cli ping
# Should return: PONG
```

## Best Practices

1. **Never commit .env file** - Use .env.example as template
2. **Use environment variables** - Don't hardcode sensitive data
3. **Write tests** - Maintain good test coverage
4. **Use migrations** - Never modify database directly
5. **Follow Django conventions** - Keep code organized
6. **Document your code** - Write clear docstrings
7. **Use version control** - Commit regularly with clear messages
8. **Keep dependencies updated** - Regularly update requirements.txt

## Additional Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [Celery Documentation](https://docs.celeryproject.org/)
- [Docker Documentation](https://docs.docker.com/)

## Support

For issues or questions:
1. Check this documentation
2. Review Django documentation
3. Open an issue on GitHub
4. Contact the maintainers

---

Happy coding! 🚀
