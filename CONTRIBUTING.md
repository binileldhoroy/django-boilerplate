# Contributing to Django Boilerplate

Thank you for considering contributing to this project!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone <your-fork-url>`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Run tests: `make test`
6. Commit your changes: `git commit -am 'Add some feature'`
7. Push to the branch: `git push origin feature/your-feature-name`
8. Submit a pull request

## Development Setup

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
make install

# Run migrations
make migrate

# Run development server
make run
```

## Code Style

- Follow PEP 8 guidelines
- Use meaningful variable and function names
- Write docstrings for functions and classes
- Keep functions small and focused

## Testing

- Write tests for new features
- Ensure all tests pass before submitting PR
- Aim for high test coverage

```bash
make test
```

## Commit Messages

- Use clear and descriptive commit messages
- Start with a verb in present tense (Add, Fix, Update, etc.)
- Keep the first line under 50 characters
- Add detailed description if needed

Example:
```
Add user profile endpoint

- Create UserProfile model
- Add serializer and viewset
- Update URL configuration
- Add tests for profile endpoints
```

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update documentation if you're changing functionality
3. The PR will be merged once you have approval from maintainers

## Questions?

Feel free to open an issue for any questions or concerns.
