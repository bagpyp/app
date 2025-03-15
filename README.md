
# Python Starter Project

This is a minimal Python project template designed to help you quickly bootstrap a new Python project. It includes a basic structure, dependency management with Poetry, and configuration loading via `python-dotenv`.

## Features

- **Dependency Management**: Uses [Poetry](https://python-poetry.org/) for managing dependencies and packaging.
- **Environment Configuration**: Uses [python-dotenv](https://github.com/theskumar/python-dotenv) for environment variable management.
- **Code Formatting**: Configured with [Black](https://black.readthedocs.io/) for consistent code style.
- **Extensible Project Structure**: Provides a foundation for scaling your project.

---

## Project Structure

```plaintext
app/
├── src/
│   ├── __init__.py     # Empty init file for package
│   ├── config.py       # Loads environment variables
│   ├── main.py         # Entry point for the app
├── .env                # Environment variable file
├── .env.test           # Environment variable file for tests
├── pyproject.toml      # Poetry configuration
├── README.md           # This file
```

---

## Requirements

- Python 3.13+
- [Poetry](https://python-poetry.org/docs/#installation)

---

## Getting Started

### Install Dependencies

```bash
poetry install
```

### Configure Environment Variables

Create a `.env` file in the root directory. Add your environment variables as needed. For example:

```plaintext
# .env
ENV=development
```

For testing, use a separate `.env.test` file:

```plaintext
# .env.test
ENV=test
```

### Run the App

Activate the Poetry shell and run the application:

```bash
poetry shell
python src/main.py
```

---

## Customizing

1. **Add Your Logic**: Modify `src/main.py` to include your application logic.
2. **Organize Code**: Expand the `src/` directory with additional modules and packages.
3. **Add Dependencies**: Use `poetry add <package>` to include additional dependencies.

---

## Development Tips

### Using Black for Formatting

This project includes Black for code formatting. Run the formatter with:

```bash
poetry run black src/
```

### Testing

Use the test-specific `.env.test` configuration when writing and running tests. Configure your testing framework (e.g., `pytest`) as needed.

---

## Author

Created by Bagpyp.  
[Email Me](mailto:robert@bagpyp.net)

---

## License

This project is open source. You can add a license if needed.
