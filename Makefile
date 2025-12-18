.PHONY: help install migrate run test clean docker-up docker-down

help:
	@echo "Django Project Management Commands"
	@echo ""
	@echo "  make install       - Install dependencies"
	@echo "  make migrate       - Run database migrations"
	@echo "  make makemigrations - Create new migrations"
	@echo "  make run           - Run development server"
	@echo "  make superuser     - Create superuser"
	@echo "  make test          - Run tests"
	@echo "  make clean         - Clean Python cache files"
	@echo "  make docker-up     - Start Docker containers"
	@echo "  make docker-down   - Stop Docker containers"
	@echo "  make docker-build  - Build Docker containers"
	@echo "  make shell         - Open Django shell"
	@echo "  make collectstatic - Collect static files"

install:
	pip install --upgrade pip
	pip install -r requirements.txt

migrate:
	python manage.py migrate

makemigrations:
	python manage.py makemigrations

run:
	python manage.py runserver

superuser:
	python manage.py createsuperuser

test:
	python manage.py test

clean:
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	find . -type d -name '*.egg-info' -exec rm -rf {} +
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov

docker-up:
	docker-compose up

docker-down:
	docker-compose down

docker-build:
	docker-compose up --build

shell:
	python manage.py shell

collectstatic:
	python manage.py collectstatic --noinput

celery-worker:
	celery -A config worker -l info

celery-beat:
	celery -A config beat -l info
