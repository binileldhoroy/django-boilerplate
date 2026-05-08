# Quick Start Guide

Get your Django project up and running in 5 minutes!

## Prerequisites

- Python 3.12+
- PostgreSQL (or use SQLite for development)
- Redis (optional, for Celery)

## Option 1: One-Command Install (Recommended) ⚡

```bash
curl -fsSL https://raw.githubusercontent.com/binileldhoroy/django-boilerplate/main/install.sh | bash

# Follow the prompts:
# - Enter project name: my_awesome_app
# - Enter description: My awesome Django application
# - Target directory: ./my_awesome_app
# - Create virtual environment? yes
# - Install dependencies? yes
# - Run migrations? yes
# - Create superuser? yes

# Done! Your project is ready
cd my_awesome_app
source venv/bin/activate
python manage.py runserver
```

Visit: http://localhost:8000

## Option 2: Manual Setup 🛠️

```bash
# 1. Clone the boilerplate
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project

# 2. Find and replace placeholders
# Replace {{ project_name }} with your project name
# Replace {{ project_description }} with your description

# 3. Set up environment
cp .env.example .env
# Edit .env and set:
# - SECRET_KEY (generate with: python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
# - DATABASE_URL or database settings
# - Other settings as needed

# 4. Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 5. Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# 6. Run migrations
python manage.py migrate

# 7. Create superuser
python manage.py createsuperuser

# 8. Run server
python manage.py runserver
```

Visit: http://localhost:8000

## Option 3: Docker Setup 🐳

```bash
# 1. Clone the boilerplate
git clone https://github.com/binileldhoroy/django-boilerplate.git my_project
cd my_project

# 2. Update docker-compose.yml
# Replace {{ project_name }} with your project name

# 3. Create .env file
cp .env.example .env
# Edit as needed

# 4. Build and run
docker-compose up --build

# 5. In another terminal, run migrations
docker-compose exec web python manage.py migrate

# 6. Create superuser
docker-compose exec web python manage.py createsuperuser
```

Visit: http://localhost:8000

## What You Get

After setup, you'll have:

- ✅ Working Django 5.0+ application
- ✅ Custom user model with email authentication
- ✅ Admin panel at `/admin/`
- ✅ API documentation at `/api/schema/swagger-ui/`
- ✅ REST API with JWT authentication
- ✅ Celery for async tasks (if Redis is running)
- ✅ Health check endpoint
- ✅ Basic web interface

## Common Commands

```bash
# Activate virtual environment
source venv/bin/activate

# Run development server
python manage.py runserver
# or
make run

# Create migrations
python manage.py makemigrations
# or
make makemigrations

# Apply migrations
python manage.py migrate
# or
make migrate

# Create superuser
python manage.py createsuperuser
# or
make superuser

# Run tests
python manage.py test
# or
make test

# Start Celery worker
celery -A config worker -l info
# or
make celery-worker

# Collect static files
python manage.py collectstatic
# or
make collectstatic
```

## Project Structure

```
my_project/
├── config/              # Settings and configuration
├── apps/
│   ├── users/          # User management
│   └── web/            # Web interface
├── templates/          # HTML templates
├── static/             # CSS, JS, images
├── manage.py           # Django management
├── requirements.txt    # Dependencies
└── .env               # Environment variables
```

## Next Steps

1. **Explore the admin panel**
   - Go to http://localhost:8000/admin/
   - Login with your superuser credentials

2. **Check API documentation**
   - Go to http://localhost:8000/api/schema/swagger-ui/
   - Explore available endpoints

3. **Create your first app**
   ```bash
   python manage.py startapp myapp apps/myapp
   ```
   - Add to `INSTALLED_APPS` in `config/settings.py`

4. **Customize the home page**
   - Edit `templates/web/home.html`
   - Edit `static/css/style.css`

5. **Add your business logic**
   - Create models in your app
   - Create views and URLs
   - Create templates

## Troubleshooting

### Database connection error
```bash
# Make sure PostgreSQL is running
sudo systemctl status postgresql

# Or use SQLite for development (edit .env):
# Comment out DATABASE_URL
# Django will use SQLite by default
```

### Port already in use
```bash
# Use a different port
python manage.py runserver 8001
```

### Module not found
```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt
```

### Static files not loading
```bash
# Collect static files
python manage.py collectstatic
```

## Getting Help

- 📖 Read `README.md` for detailed documentation
- 📚 Check `BOILERPLATE_USAGE.md` for usage guide
- 🔍 Review `PROJECT_STRUCTURE.md` for overview
- 🐛 Check Django documentation: https://docs.djangoproject.com/

## Tips

💡 **Development**
- Keep `DEBUG=True` in development
- Use `python manage.py runserver` for auto-reload
- Use Django Debug Toolbar (set `ENABLE_DEBUG_TOOLBAR=True`)

💡 **Production**
- Set `DEBUG=False`
- Use strong `SECRET_KEY` and `SIMPLE_JWT_SIGNING_KEY`
- Configure `ALLOWED_HOSTS`
- Use Gunicorn or uWSGI
- Set up HTTPS
- Configure Sentry for error tracking

💡 **Database**
- Use PostgreSQL in production
- SQLite is fine for development
- Always backup your database
- Run migrations before deploying

💡 **Security**
- Never commit `.env` file
- Use environment variables for secrets
- Keep dependencies updated
- Enable HTTPS in production
- Configure CORS properly

---

**Happy coding! 🚀**

Need help? Check the other documentation files or open an issue.
