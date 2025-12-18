# Django Boilerplate

A production-ready Django boilerplate with modern best practices and **one-command installation**.

## 🚀 Quick Start

Install and set up a new Django project with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

That's it! The installer will guide you through the setup process.

**Note**: Replace `YOUR_USERNAME/YOUR_REPO` with your actual GitHub repository details. See [GITHUB_SETUP.md](GITHUB_SETUP.md) for instructions.

## Features

- **Django 5.0+** - Latest Django version
- **PostgreSQL** - Production-ready database
- **Redis** - Caching and Celery broker
- **Celery** - Asynchronous task processing
- **Django REST Framework** - API development
- **JWT Authentication** - Secure token-based auth
- **Django Allauth** - Complete authentication solution
- **Docker** - Containerized development and deployment
- **Environment-based configuration** - Secure settings management

## Quick Start

### Prerequisites

- Python 3.12+
- PostgreSQL 15+
- Redis 7+

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd {{ project_name }}
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

5. **Run migrations**
```bash
python manage.py migrate
```

6. **Create superuser**
```bash
python manage.py createsuperuser
```

7. **Run development server**
```bash
python manage.py runserver
```

Visit http://localhost:8000

## Docker Setup

### Using Docker Compose

1. **Build and start services**
```bash
docker-compose up --build
```

2. **Run migrations**
```bash
docker-compose exec web python manage.py migrate
```

3. **Create superuser**
```bash
docker-compose exec web python manage.py createsuperuser
```

Visit http://localhost:8000

## Project Structure

```
{{ project_name }}/
├── config/                 # Project configuration
│   ├── settings.py        # Django settings
│   ├── urls.py            # URL configuration
│   ├── wsgi.py            # WSGI configuration
│   ├── asgi.py            # ASGI configuration
│   └── celery.py          # Celery configuration
├── apps/                   # Django apps
│   ├── users/             # User management
│   └── web/               # Web interface
├── templates/             # HTML templates
├── static/                # Static files (CSS, JS, images)
├── media/                 # User-uploaded files
├── manage.py              # Django management script
├── requirements.txt       # Python dependencies
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Docker Compose configuration
└── .env.example           # Environment variables template
```

## Environment Variables

Key environment variables (see `.env.example` for full list):

- `SECRET_KEY` - Django secret key
- `DEBUG` - Debug mode (True/False)
- `DATABASE_URL` - Database connection string
- `REDIS_URL` - Redis connection string
- `ALLOWED_HOSTS` - Allowed hosts for Django

## API Documentation

API documentation is available at:
- Swagger UI: http://localhost:8000/api/schema/swagger-ui/
- ReDoc: http://localhost:8000/api/schema/redoc/

## Running Tests

```bash
python manage.py test
```

## Celery Tasks

Start Celery worker:
```bash
celery -A config worker -l info
```

Start Celery beat (for scheduled tasks):
```bash
celery -A config beat -l info
```

## Deployment

### Production Checklist

1. Set `DEBUG=False` in environment
2. Configure `ALLOWED_HOSTS`
3. Set strong `SECRET_KEY` and `SIMPLE_JWT_SIGNING_KEY`
4. Configure production database
5. Set up static file serving
6. Configure email backend
7. Enable HTTPS (`USE_HTTPS_IN_ABSOLUTE_URLS=True`)
8. Set up Sentry for error tracking
9. Configure backup strategy

### Using Gunicorn

```bash
gunicorn config.wsgi:application --bind 0.0.0.0:8000
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License
